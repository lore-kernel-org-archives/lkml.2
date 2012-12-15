Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019Ab2LOJqt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 04:46:49 -0500
Received: from mx1.fusionio.com ([66.114.96.30]:47497 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751037Ab2LOJqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 04:46:43 -0500
X-ASG-Debug-ID: 1355564797-03d6a50cb5de9650001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <50CC46F8.3070600@fusionio.com>
Date: Sat, 15 Dec 2012 10:46:32 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Kent Overstreet <koverstreet@google.com>
CC: Jack Wang <jack.wang.usish@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "zab@redhat.com" <zab@redhat.com>, "bcrl@kvack.org" <bcrl@kvack.org>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 00/26] AIO performance improvements/cleanups, v2
References: <1354568322-29029-1-git-send-email-koverstreet@google.com> <20121213211808.GJ25017@kernel.dk> <CA+res+SKXjXTgrxPaj+kuekd-CZMp4POkSpsdJ7Csfg0HsD=bA@mail.gmail.com> <50CAD6D9.5070703@fusionio.com> <20121215092526.GA10411@moria.home.lan>
X-ASG-Orig-Subj: Re: [PATCH 00/26] AIO performance improvements/cleanups, v2
In-Reply-To: <20121215092526.GA10411@moria.home.lan>
X-Enigmail-Version: 1.4.6
Content-Type: multipart/mixed;
	boundary="------------020404040707090806000102"
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1355564797
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -1.80
X-Barracuda-Spam-Status: No, SCORE=-1.80 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=BSF_SC0_SA085, CN_BODY_332
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.117068
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.12 CN_BODY_332            BODY: CN_BODY_332
	0.10 BSF_SC0_SA085          Custom Rule SA085
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------020404040707090806000102
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

On 2012-12-15 10:25, Kent Overstreet wrote:
> On Fri, Dec 14, 2012 at 08:35:53AM +0100, Jens Axboe wrote:
>> On 2012-12-14 03:26, Jack Wang wrote:
>>> 2012/12/14 Jens Axboe <jaxboe@fusionio.com>:
>>>> On Mon, Dec 03 2012, Kent Overstreet wrote:
>>>>> Last posting: http://thread.gmane.org/gmane.linux.kernel.aio.general/3169
>>>>>
>>>>> Changes since the last posting should all be noted in the individual
>>>>> patch descriptions.
>>>>>
>>>>>  * Zach pointed out the aio_read_evt() patch was calling functions that
>>>>>    could sleep in TASK_INTERRUPTIBLE state, that patch is rewritten.
>>>>>  * Ben pointed out some synchronize_rcu() usage was problematic,
>>>>>    converted it to call_rcu()
>>>>>  * The flush_dcache_page() patch is new
>>>>>  * Changed the "use cancellation list lazily" patch so as to remove
>>>>>    ki_flags from struct kiocb.
>>>>
>>>> Kent, I ran a few tests, and the below patches still don't seem as fast
>>>> as the approach I took. To keep it fair, I used your aio branch and
>>>> applied by dio speedups too. As a sanity check, I ran with your branch
>>>> alone as well. The quick results below - kaio is kent-aio, just your
>>>> branch. kaio-dio is with the direct IO speedups too. jaio is my branch,
>>>> which already has the dio changes too.
>>>>
>>>> Devices         Branch          IOPS
>>>> 1               kaio            ~915K
>>>> 1               kaio-dio        ~930K
>>>> 1               jaio           ~1220K
>>>> 6               kaio           ~3050K
>>>> 6               kaio-dio       ~3080K
>>>> 6               jaio            3500K
>>>>
>>>> The box runs out of CPU driving power, which is why it doesn't scale
>>>> linearly, otherwise I know that jaio at least does. It's basically
>>>> completion limited for the 6 device test at the moment.
>>>>
>>>> I'll run some profiling tomorrow morning and get you some better
>>>> results. Just thought I'd share these at least.
>>>>
>>>> --
>>>> Jens Axboe
>>>>
>>>
>>> A really good performance, woo.
>>>
>>> I think the device tested is really fast PCIe SSD builded by fusionio
>>> with fusionio in house block driver?
>>
>> It is pci-e flash storage, but it is not fusion-io.
>>
>>> any compare number with current mainline?
>>
>> Sure, I should have included that. Here's the table again, this time
>> with mainline as well.
>>
>> Devices         Branch          IOPS
>> 1               mainline        ~870K
>> 1               kaio            ~915K
>> 1               kaio-dio        ~930K
>> 1               jaio           ~1220K
>> 6               kaio           ~3050K
>> 6               kaio-dio       ~3080K
>> 6               jaio           ~3500K
>> 6               mainline       ~2850K
> 
> Cool, thanks for the numbers!
> 
> I suspect the difference is due to contention on the ringbuffer,
> completion side. You didn't enable my batched completion stuff, did you?

No, haven't tried the batching yet.

> I suspect the numbers would look quite a bit different with that,
> based on my own profiling. If the driver for the device you're testing
> on is open source, I'd be happy to do the conversion (it's a 5 minute
> job).

Knock yourself out - I already took a quick look at it, and conversion
should be pretty simple. It's the mtip32xx driver, it's in the kernel. I
would suggest getting rid of the ->async_callback() (since it's always
bio_endio()) since that'll make it cleaner.

> Also, I don't think our approaches really conflict - it's been awhile

Completely agree. I split my patches up a bit yesterday, and then I took
a look at your series. There's a bit of overlap between the two, but
really most of it would be useful together. You can see the (bit more)
split series here:

http://git.kernel.dk/?p=linux-block.git;a=shortlog;h=refs/heads/aio-dio

> since I looked at your patch but you're getting rid of the aio
> ringbuffer and using a linked list instead, right? My batched completion
> stuff should still benefit that case.

Yes, I make the ring interface optional. Basically you tell aio to use
the ring or not at io_queue_init() time. If you don't care about the
ring, we can use a lockless list for the completions.

You completely remove the cancel, I just make it optional for the gadget
case. I'm fine with either of them, though I did not look at your usb
change in detail. If it's clean, I suspect we should just kill cancel
completion as you did.

> Though - hrm, I'd have expected getting rid of the cancellation linked
> list to make a bigger difference and both our patchsets do that.

The machine in question runs out of oomph, which is hampering the
results. I should have it beefed up next week. It's running E5-2630
right now, will move to E5-2690. I think that should make the results
clearer.

> What device are you testing on, and what's your fio script? I may just
> have to buy some hardware so I can test this myself.

Pretty basic script, it's attached. Probably could eek more out of the
system, but it's been fine for just basic apples-to-apples comparison.
I'm using 6x p320h for this test case.

-- 
Jens Axboe


--------------020404040707090806000102
Content-Type: text/plain; charset="UTF-8"; name="rssdc-rand-read.fio"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="rssdc-rand-read.fio"

[global]
bs=4k
direct=1
ioengine=libaio
iodepth=42
numjobs=5
rwmixread=100
rw=randrw
iodepth_batch=8
iodepth_batch_submit=4
iodepth_batch_complete=4
random_generator=lfsr
group_reporting=1

[rssda]
cpus_allowed=0,2,4,6,8,10
filename=/dev/rssda

[rssdb]
cpus_allowed=0,2,4,6,8,10
filename=/dev/rssdb

[rssdc]
cpus_allowed=1,3,5,7,9,11
filename=/dev/rssdc

[rssdd]
cpus_allowed=1,3,5,7,9,11
filename=/dev/rssdd

[rssde]
cpus_allowed=1,3,5,7,9,11
filename=/dev/rssde

[rssdf]
cpus_allowed=1,3,5,7,9,11
filename=/dev/rssdf

--------------020404040707090806000102--
