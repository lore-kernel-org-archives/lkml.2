Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050Ab2CGNno (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 08:43:44 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:40184 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757941Ab2CGNnn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 08:43:43 -0500
MIME-Version: 1.0
In-Reply-To: <CAKA=qzaHqwZ8eqpLNFjxnO2fX-tgAOjmpvxgBFjv6dJeQaOW1w@mail.gmail.com>
References: <CAKA=qzaHqwZ8eqpLNFjxnO2fX-tgAOjmpvxgBFjv6dJeQaOW1w@mail.gmail.com>
Date: Wed, 7 Mar 2012 07:43:42 -0600
Message-ID: <CAKA=qzZQ0YkWXpi4gKYe5yFrR9EF3+G1Wq=kWybreLXx7D30oQ@mail.gmail.com>
Subject: Re: multi-second application stall in open()
From: Josh Hunt <joshhunt00@gmail.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, tj@kernel.org, vgoyal@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 6, 2012 at 3:56 PM, Josh Hunt <joshhunt00@gmail.com> wrote:
> I am trying to diagnose a stall in an application when making a call
> to open() with O_TRUNC. The issue was originally seen on 2.6.38 and
> I've since reproduced on 2.6.35. I believe the last kernel that I did
> not see the stall was 2.6.32. The system is under low to moderate cpu
> and memory load when the issue occurs. The filesystem is ext2, but I
> mounted it as ext4 and still saw the issue.
>
> To me it appears the O_TRUNC needs to truncate pages in the page
> cache, but maybe those are already out for writeback? This causes the
> open() to wait until that operation completes at which time it is then
> able to proceed. If that's true then it looks like the writeback is
> sitting on the queue forever waiting (tens of seconds) to be
> dispatched to the device.
>
> Here's some more info/data I collected:
> (Unfortunately the data here and attached are from separate runs so
> the #s will not match up file to file.)
>
> Snippet of an strace when it is hanging:
> 1329323286.589182 close(37)             = 0 <0.000010>
> 1329323286.589212 clock_gettime(0x5 /* CLOCK_??? */, {1329323286,
> 587579583}) = 0 <0.000007>
> 1329323286.589241 open("/usr/local/etc/abcd/known/test808",
> O_WRONLY|O_CREAT|O_TRUNC, 0644)                = 37 <76.841586>
> 1329323363.441841 fchmod(37, 0644)      = 0 <0.000012>
> 1329323363.441882 fcntl64(37, F_GETFL)  = 0x1 (flags O_WRONLY) <0.000011>
> 1329323363.441915 fcntl64(37, F_SETFL, O_WRONLY|O_NONBLOCK) = 0 <0.000010>
>
> To debug this more I enabled the hang check timer to dump stack when
> anything hung for longer than 10s. There I see the the hanging
> application appearing to be stuck in sync_page(). See attached dmesg
> for traces.
>
> I've also captured "iostat -xm 1" while the application was running
> and have attached a snippet of that when the problem is occurring. I
> see 100% utilization for many seconds and then eventually the
> operations complete, but the await time is extremely high. To me there
> doesn't look like much IO going on which could be starving out any
> requests.
>
> I have not been able to perform a full bisection to better understand
> what may be causing this, but do see this on 2.6.38, a little less
> frequently but still occurs on 2.6.35, and no longer see the issue on
> 2.6.32. If I switch slice_idle to 0 or change to the deadline
> scheduler the issue appears to go away in both 2.6.35 and 38.
>
> I've also attached the "blkparse -t" output a few seconds before and
> after the issue occurs, and the avg file from the output of "btt -i
> ... -o bp.log"
>
> Please let me know if any other data would be helpful.
> I would appreciate any help in better understanding this issue and
> what may be causing it.
>
> --
> Josh

[adding to cc list]

-- 
Josh
