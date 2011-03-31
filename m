Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933897Ab1CaKhz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 06:37:55 -0400
Received: from mx2.fusionio.com ([64.244.102.31]:44026 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757253Ab1CaKhu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 06:37:50 -0400
X-ASG-Debug-ID: 1301567864-01de284cf8e5150001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D945976.8000401@fusionio.com>
Date: Thu, 31 Mar 2011 12:37:42 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Rob Landley <rlandley@parallels.com>
CC: Pete Clements <clem@clem.clem-digital.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: Commit 7eaceaccab5f40 causing boot hang.
References: <201103291551.p2TFpDqZ001692@clem.clem-digital.net> <4D92C874.7040104@parallels.com> <4D931634.5030807@fusionio.com> <4D933584.5050005@parallels.com> <4D94432D.5080601@fusionio.com> <4D944544.9040705@parallels.com> <4D945247.4080404@fusionio.com>
X-ASG-Orig-Subj: Re: Commit 7eaceaccab5f40 causing boot hang.
In-Reply-To: <4D945247.4080404@fusionio.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1301567864
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.50
X-Barracuda-Spam-Status: No, SCORE=0.50 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=BSF_RULE7568M
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.59494
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.50 BSF_RULE7568M          Custom Rule 7568M
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-31 12:07, Jens Axboe wrote:
> On 2011-03-31 11:11, Rob Landley wrote:
>> On 03/31/2011 04:02 AM, Jens Axboe wrote:
>>> On 2011-03-30 15:52, Rob Landley wrote:
>>>> On 03/30/2011 06:38 AM, Jens Axboe wrote:
>>>>> On 2011-03-30 08:06, Rob Landley wrote:
>>>>>> On 03/29/2011 10:51 AM, Pete Clements wrote:
>>>>>>> Quoting Jens Axboe
>>>>>>>   > 
>>>>>>>   > On 2011-03-29 16:13, Rob Landley wrote:
>>>>>>>   > > On 03/29/2011 08:59 AM, Jens Axboe wrote:
>>>>>>>   > >> On 2011-03-29 10:52, Rob Landley wrote:
>>>>>>>   > >>> I'm booting all this under kvm or qemu, by the way:
>>>>>>>   > >>>
>>>>>>>   > >>> qemu-system-x86_64 -m 1024 -kernel arch/x86/boot/bzImage \
>>>>>>>   > >>>   -hda ~/sid.ext3 -append "root=/dev/hda rw"
>>>>>>>   > >>>
>>>>>>>   > >>> Sometimes with init=/bin/bash in that last quoted bit.  The root
>>>>>>>   > >>> filesystem's debian sid but that's probably not relevant because it
>>>>>>>   > >>> worked fine with .38.
>>>>>>>   > >>
>>>>>>>   > >> Does this help?
>>>>>>>   > >>
>>>>>>>   > >> diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
>>>>>>>   > >> index 0e406d73..ca27d30 100644
>>>>>>>   > >> --- a/drivers/ide/ide-io.c
>>>>>>>   > >> +++ b/drivers/ide/ide-io.c
>>>>>>>   > >> @@ -570,8 +570,7 @@ void ide_requeue_and_plug(ide_drive_t *drive, struct request *rq)
>>>>>>>   > >>  	spin_unlock_irqrestore(q->queue_lock, flags);
>>>>>>>   > >>  
>>>>>>>   > >>  	/* Use 3ms as that was the old plug delay */
>>>>>>>   > >> -	if (rq)
>>>>>>>   > >> -		blk_delay_queue(q, 3);
>>>>>>>   > >> +	blk_delay_queue(q, 3);
>>>>>>>   > >>  }
>>>>>>>   > >>  
>>>>>>>   > >>  static int drive_is_ready(ide_drive_t *drive)
>>>>>>>   > >>
>>>>>>>   > > 
>>>>>>>   > > Nope, still hung the same way.
>>>>>>>   > 
>>>>>>>   > Funky. I'll try and reproduce this tonight.
>>>>>>>   > 
>>>>>>>   > -- 
>>>>>>>   > Jens Axboe
>>>>>>>   > 
>>>>>>>
>>>>>>> I have had a similiar problem (reported earlier) unable to boot.
>>>>>>> With git15-18 hung with IDE drives (hda), git19-21 moved the hang down to
>>>>>>> the IDE CDROM (hdc). Applied the above patch and now booted into git21 without
>>>>>>> any hang and all appears ok.
>>>>>>
>>>>>> It may have made it better for me, it's hard to tell.
>>>>>>
>>>>>> I did a fresh pull, re-applied the patch, and tried again with
>>>>>> init=/bin/sh and it booted to the shell prompt... which then hung when I
>>>>>> did "ls -l /".
>>>>>>
>>>>>> If I let it boot normally, init announces itself, gives a spurious
>>>>>> warning about a fstab field (which it's been doing for a while, my fault
>>>>>> but harmless), then hangs.
>>>>>>
>>>>>>> This is i386, UP.
>>>>>>
>>>>>> I'm doing x86-64 SMP.
>>>>>
>>>>> I think we have the same issue the other location. How about this, then:
>>>>>
>>>>> diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
>>>>> index 0e406d73..4978ec3 100644
>>>>> --- a/drivers/ide/ide-io.c
>>>>> +++ b/drivers/ide/ide-io.c
>>>>> @@ -549,12 +549,11 @@ plug_device:
>>>>>  	spin_unlock_irq(&hwif->lock);
>>>>>  	ide_unlock_host(host);
>>>>>  plug_device_2:
>>>>> +	blk_delay_queue(q, queue_run_ms);
>>>>>  	spin_lock_irq(q->queue_lock);
>>>>>  
>>>>> -	if (rq) {
>>>>> +	if (rq)
>>>>>  		blk_requeue_request(q, rq);
>>>>> -		blk_delay_queue(q, queue_run_ms);
>>>>> -	}
>>>>>  }
>>>>>  
>>>>>  void ide_requeue_and_plug(ide_drive_t *drive, struct request *rq)
>>>>> @@ -570,8 +569,7 @@ void ide_requeue_and_plug(ide_drive_t *drive, struct request *rq)
>>>>>  	spin_unlock_irqrestore(q->queue_lock, flags);
>>>>>  
>>>>>  	/* Use 3ms as that was the old plug delay */
>>>>> -	if (rq)
>>>>> -		blk_delay_queue(q, 3);
>>>>> +	blk_delay_queue(q, 3);
>>>>>  }
>>>>>  
>>>>>  static int drive_is_ready(ide_drive_t *drive)
>>>>>
>>>>
>>>> Did a fresh pull and applied that patch.  (It conflicts with your
>>>> previous one, but looks like it includes it.)
>>>>
>>>> Now it hangs after the "EXT3-fs: barriers not enabled" line, doesn't
>>>> make it to init.
>>>
>>> I have tried hard to reproduce this, but even stock 2.6.39-rc1 works
>>> fine for me here. Setup a KVM image with a debian 6 install, then
>>> converted it to IDE and booting it with a custom kernel like you are.
>>> Works fine, boots and I can do disk activity tests and it all works.
>>>
>>> Can you send me your .config?
>>
>> It was attached to the first message in this series, here it is again.
>>
>> I update it via "make oldconfig" and hold down return.
>>
>> I boot it via:
>>
>> qemu-system-x86_64 -m 1024 -kernel arch/x86/boot/bzImage \
>>   -hda ~/sid.ext3 -append "root=/dev/hda rw"
> 
> Much better, I see the hang now! Now to try and diagnose...

It seems to hard hang, looks very odd:

[   84.056007] BUG: soft lockup - CPU#0 stuck for 67s! [kworker/0:2:743]
[   84.056008] Modules linked in:
[   84.056008] irq event stamp: 334859658
[   84.056008] hardirqs last  enabled at (334859657): [<ffffffff815c40c7>] _raw_spin_unlock_irq+0x2b/0x30
[   84.056008] hardirqs last disabled at (334859658): [<ffffffff815c42e7>] save_args+0x67/0x70
[   84.056008] softirqs last  enabled at (334855538): [<ffffffff81044819>] __do_softirq+0x1a3/0x1c2
[   84.056008] softirqs last disabled at (334855525): [<ffffffff815cb9cc>] call_softirq+0x1c/0x30
[   84.056008] CPU 0 
[   84.056008] Modules linked in:
[   84.056008] 
[   84.056008] Pid: 743, comm: kworker/0:2 Not tainted 2.6.39-rc1+ #12 Bochs Bochs
[   84.056008] RIP: 0010:[<ffffffff815c40c9>]  [<ffffffff815c40c9>] _raw_spin_unlock_irq+0x2d/0x30
[   84.056008] RSP: 0018:ffff88003d343d98  EFLAGS: 00000202
[   84.056008] RAX: 0000000013f58d89 RBX: 0000000000000006 RCX: ffff88003d2c5998
[   84.056008] RDX: 0000000000000006 RSI: ffff88003d343da0 RDI: ffff88003db19508
[   84.056008] RBP: ffff88003d343da0 R08: ffff88003fc15c00 R09: 0000000000000001
[   84.056008] R10: ffffffff81e0d040 R11: ffff88003d343d60 R12: ffffffff815cb18e
[   84.056008] R13: 0000000000000001 R14: ffff88003d2c5998 R15: ffffffff81069aec
[   84.056008] FS:  0000000000000000(0000) GS:ffff88003fc00000(0000) knlGS:0000000000000000
[   84.056008] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   84.056008] CR2: 000000000060d828 CR3: 000000003d3f8000 CR4: 00000000000006f0
[   84.056008] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   84.056008] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   84.056008] Process kworker/0:2 (pid: 743, threadinfo ffff88003d342000, task ffff88003db18f60)
[   84.056008] Stack:
[   84.056008]  ffff88003d2c5870 ffff88003d343dc0 ffffffff812171d3 ffff88003fc15c00
[   84.056008]  ffff88003d31e6c0 ffff88003d343e50 ffffffff81053e99 ffffffff81053e0b
[   84.056008]  ffff88003d342010 ffff88003db18f60 0000000000000046 ffff88003fc15c05
[   84.056008] Call Trace:
[   84.056008]  [<ffffffff812171d3>] blk_delay_work+0x32/0x36
[   84.056008]  [<ffffffff81053e99>] process_one_work+0x230/0x397
[   84.056008]  [<ffffffff81053e0b>] ? process_one_work+0x1a2/0x397
[   84.056008]  [<ffffffff8105612a>] worker_thread+0x136/0x255
[   84.056008]  [<ffffffff81055ff4>] ? manage_workers+0x190/0x190
[   84.056008]  [<ffffffff8105974a>] kthread+0x7d/0x85
[   84.056008]  [<ffffffff815cb8d4>] kernel_thread_helper+0x4/0x10
[   84.056008]  [<ffffffff815c4440>] ? retint_restore_args+0xe/0xe
[   84.056008]  [<ffffffff810596cd>] ? __init_kthread_worker+0x56/0x56
[   84.056008]  [<ffffffff815cb8d0>] ? gs_change+0xb/0xb
[   84.056008] Code: 01 00 00 00 48 89 e5 53 48 89 fb 48 83 c7 18 48 83 ec 08 48 8b 55 08 e8 11 7b aa ff 48 89 df e8 03 05 c7 ff e8 f3 5e aa ff fb 5e <5b> c9 c3 55 48 89 e5 41 54 49 89 fc 48 8b 55 08 48 83 c7 18 53 


-- 
Jens Axboe

