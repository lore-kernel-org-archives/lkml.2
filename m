Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760031Ab2CGTrp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 14:47:45 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52274 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760005Ab2CGTr1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 14:47:27 -0500
MIME-Version: 1.0
In-Reply-To: <20120307162851.GC13430@redhat.com>
References: <CAKA=qzaHqwZ8eqpLNFjxnO2fX-tgAOjmpvxgBFjv6dJeQaOW1w@mail.gmail.com>
	<CAKA=qzZQ0YkWXpi4gKYe5yFrR9EF3+G1Wq=kWybreLXx7D30oQ@mail.gmail.com>
	<20120307162851.GC13430@redhat.com>
Date: Wed, 7 Mar 2012 13:47:25 -0600
Message-ID: <CAKA=qzb0T62xFsDpiQ0nsnE--HQ2bXFKN2EWr4knjR_+bOshUA@mail.gmail.com>
Subject: Re: multi-second application stall in open()
From: Josh Hunt <joshhunt00@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, tj@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 7, 2012 at 10:28 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Wed, Mar 07, 2012 at 07:43:42AM -0600, Josh Hunt wrote:
>> On Tue, Mar 6, 2012 at 3:56 PM, Josh Hunt <joshhunt00@gmail.com> wrote:
>> > I am trying to diagnose a stall in an application when making a call
>> > to open() with O_TRUNC. The issue was originally seen on 2.6.38 and
>> > I've since reproduced on 2.6.35. I believe the last kernel that I did
>> > not see the stall was 2.6.32. The system is under low to moderate cpu
>> > and memory load when the issue occurs. The filesystem is ext2, but I
>> > mounted it as ext4 and still saw the issue.
>> >
>> > To me it appears the O_TRUNC needs to truncate pages in the page
>> > cache, but maybe those are already out for writeback? This causes the
>> > open() to wait until that operation completes at which time it is then
>> > able to proceed. If that's true then it looks like the writeback is
>> > sitting on the queue forever waiting (tens of seconds) to be
>> > dispatched to the device.
>> >
>> > Here's some more info/data I collected:
>> > (Unfortunately the data here and attached are from separate runs so
>> > the #s will not match up file to file.)
>> >
>> > Snippet of an strace when it is hanging:
>> > 1329323286.589182 close(37)             = 0 <0.000010>
>> > 1329323286.589212 clock_gettime(0x5 /* CLOCK_??? */, {1329323286,
>> > 587579583}) = 0 <0.000007>
>> > 1329323286.589241 open("/usr/local/etc/abcd/known/test808",
>> > O_WRONLY|O_CREAT|O_TRUNC, 0644)                = 37 <76.841586>
>> > 1329323363.441841 fchmod(37, 0644)      = 0 <0.000012>
>> > 1329323363.441882 fcntl64(37, F_GETFL)  = 0x1 (flags O_WRONLY) <0.000011>
>> > 1329323363.441915 fcntl64(37, F_SETFL, O_WRONLY|O_NONBLOCK) = 0 <0.000010>
>> >
>> > To debug this more I enabled the hang check timer to dump stack when
>> > anything hung for longer than 10s. There I see the the hanging
>> > application appearing to be stuck in sync_page(). See attached dmesg
>> > for traces.
>> >
>> > I've also captured "iostat -xm 1" while the application was running
>> > and have attached a snippet of that when the problem is occurring. I
>> > see 100% utilization for many seconds and then eventually the
>> > operations complete, but the await time is extremely high. To me there
>> > doesn't look like much IO going on which could be starving out any
>> > requests.
>> >
>> > I have not been able to perform a full bisection to better understand
>> > what may be causing this, but do see this on 2.6.38, a little less
>> > frequently but still occurs on 2.6.35, and no longer see the issue on
>> > 2.6.32. If I switch slice_idle to 0 or change to the deadline
>> > scheduler the issue appears to go away in both 2.6.35 and 38.
>
> Is it happening on latest kernel (3.3-rc6) ?
>
> Can you change the IO scheduler to deadline on sda and see if the issue
> still happens. (echo deadline > /sys/block/sda/queue/scheduler).
>
> blktrace of cfq look odd. I see that some IO (async writes) are being
> submitted but CFQ did not dispatch it for a long time.  Even some unplugs
> came in still nothing happened. Also no completions are happening during
> that window. Not sure why CFQ refuses to dispatch queued writes.
>
> Request added by flusher.
>
>  8,0    1    36926  5028.546000122  2846  A   W 20147012 + 8 <- (8,3)
> 3375152
>  8,0    1    36927  5028.546001798  2846  Q   W 20147012 + 8 [flush-8:0]
>  8,0    1    36928  5028.546009900  2846  G   W 20147012 + 8 [flush-8:0]
>  8,0    1    36929  5028.546014649  2846  I   W 20147012 + 8 (    4749)
> [flush-8:0]
>
> And this request is dispatched after 22 seconds.
>
>  8,0    1    37056  5050.117337221   162  D   W 20147012 + 16 (21571322572) [sync_supers]
>
>
> And it completes fairly fast.
>
>  8,0    0    36522  5050.117686149  9657  C   W 20147012 + 16 (  348928)
> [0]
>
> So not sure why CFQ will hold that request for so long when other IO is
> not happening.
>
> Please try latest kernels and see if deadline has the same issue. If not,
> then we know somehow CFQ is related. If it still happens on latest
> kernels, can you try capturing blktrace again when you are experiencing
> the delays.
>
> Thanks
> Vivek

Vivek thanks for the response. I did try deadline and do not see the
issue using that. I also do not see the problem when slice_idle is set
to 0. Unfortunately I cannot run the testcase on 3.3-rc right now. I
also wanted to point out that there seems to be very little IO going
on (at least from what I can tell.) Please double check me with the
iostat output I sent in the previous mail. I am wondering if it's
possible that there's not enough requests here to keep things running
smoothly? If that's a possibility?

Thanks
Josh
