Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933903Ab1CaKrZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 06:47:25 -0400
Received: from mx2.parallels.com ([64.131.90.16]:41815 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752133Ab1CaKrX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 06:47:23 -0400
Message-ID: <4D945BAD.10309@parallels.com>
Date: Thu, 31 Mar 2011 05:47:09 -0500
From: Rob Landley <rlandley@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jens Axboe <jaxboe@fusionio.com>
CC: Pete Clements <clem@clem.clem-digital.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: Commit 7eaceaccab5f40 causing boot hang.
References: <201103291551.p2TFpDqZ001692@clem.clem-digital.net> <4D92C874.7040104@parallels.com> <4D931634.5030807@fusionio.com> <4D933584.5050005@parallels.com> <4D94432D.5080601@fusionio.com> <4D944544.9040705@parallels.com> <4D945247.4080404@fusionio.com> <4D945976.8000401@fusionio.com>
In-Reply-To: <4D945976.8000401@fusionio.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2011 05:37 AM, Jens Axboe wrote:
> On 2011-03-31 12:07, Jens Axboe wrote:
>> On 2011-03-31 11:11, Rob Landley wrote:
>>> On 03/31/2011 04:02 AM, Jens Axboe wrote:
>>>> On 2011-03-30 15:52, Rob Landley wrote:
>>>>> On 03/30/2011 06:38 AM, Jens Axboe wrote:
>>>>>> On 2011-03-30 08:06, Rob Landley wrote:
>>>>>>> On 03/29/2011 10:51 AM, Pete Clements wrote:
>>>>>>>> Quoting Jens Axboe
>>>>>>>>   > 
>>>>>>>>   > On 2011-03-29 16:13, Rob Landley wrote:
>>>>>>>>   > > On 03/29/2011 08:59 AM, Jens Axboe wrote:
>>>>>>>>   > >> On 2011-03-29 10:52, Rob Landley wrote:
>>>>>>>>   > >>> I'm booting all this under kvm or qemu, by the way:
>>>>>>>>   > >>>
>>>>>>>>   > >>> qemu-system-x86_64 -m 1024 -kernel arch/x86/boot/bzImage \
>>>>>>>>   > >>>   -hda ~/sid.ext3 -append "root=/dev/hda rw"
>>>>>>>>   > >>>
>>>>>>>>   > >>> Sometimes with init=/bin/bash in that last quoted bit.  The root
>>>>>>>>   > >>> filesystem's debian sid but that's probably not relevant because it
>>>>>>>>   > >>> worked fine with .38.
>>>>>>>>   > >>
>>>>>>>>   > >> Does this help?
>>>>>>>>   > >>
>>>>>>>>   > >> diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
>>>>>>>>   > >> index 0e406d73..ca27d30 100644
>>>>>>>>   > >> --- a/drivers/ide/ide-io.c
>>>>>>>>   > >> +++ b/drivers/ide/ide-io.c
>>>>>>>>   > >> @@ -570,8 +570,7 @@ void ide_requeue_and_plug(ide_drive_t *drive, struct request *rq)
>>>>>>>>   > >>  	spin_unlock_irqrestore(q->queue_lock, flags);
>>>>>>>>   > >>  
>>>>>>>>   > >>  	/* Use 3ms as that was the old plug delay */
>>>>>>>>   > >> -	if (rq)
>>>>>>>>   > >> -		blk_delay_queue(q, 3);
>>>>>>>>   > >> +	blk_delay_queue(q, 3);
>>>>>>>>   > >>  }
>>>>>>>>   > >>  
>>>>>>>>   > >>  static int drive_is_ready(ide_drive_t *drive)
>>>>>>>>   > >>
>>>>>>>>   > > 
>>>>>>>>   > > Nope, still hung the same way.
>>>>>>>>   > 
>>>>>>>>   > Funky. I'll try and reproduce this tonight.
>>>>>>>>   > 
>>>>>>>>   > -- 
>>>>>>>>   > Jens Axboe
>>>>>>>>   > 
>>>>>>>>
>>>>>>>> I have had a similiar problem (reported earlier) unable to boot.
>>>>>>>> With git15-18 hung with IDE drives (hda), git19-21 moved the hang down to
>>>>>>>> the IDE CDROM (hdc). Applied the above patch and now booted into git21 without
>>>>>>>> any hang and all appears ok.
>>>>>>>
>>>>>>> It may have made it better for me, it's hard to tell.
>>>>>>>
>>>>>>> I did a fresh pull, re-applied the patch, and tried again with
>>>>>>> init=/bin/sh and it booted to the shell prompt... which then hung when I
>>>>>>> did "ls -l /".
>>>>>>>
>>>>>>> If I let it boot normally, init announces itself, gives a spurious
>>>>>>> warning about a fstab field (which it's been doing for a while, my fault
>>>>>>> but harmless), then hangs.
>>>>>>>
>>>>>>>> This is i386, UP.
>>>>>>>
>>>>>>> I'm doing x86-64 SMP.
>>>>>>
>>>>>> I think we have the same issue the other location. How about this, then:
>>>>>>
>>>>>> diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
>>>>>> index 0e406d73..4978ec3 100644
>>>>>> --- a/drivers/ide/ide-io.c
>>>>>> +++ b/drivers/ide/ide-io.c
>>>>>> @@ -549,12 +549,11 @@ plug_device:
>>>>>>  	spin_unlock_irq(&hwif->lock);
>>>>>>  	ide_unlock_host(host);
>>>>>>  plug_device_2:
>>>>>> +	blk_delay_queue(q, queue_run_ms);
>>>>>>  	spin_lock_irq(q->queue_lock);
>>>>>>  
>>>>>> -	if (rq) {
>>>>>> +	if (rq)
>>>>>>  		blk_requeue_request(q, rq);
>>>>>> -		blk_delay_queue(q, queue_run_ms);
>>>>>> -	}
>>>>>>  }
>>>>>>  
>>>>>>  void ide_requeue_and_plug(ide_drive_t *drive, struct request *rq)
>>>>>> @@ -570,8 +569,7 @@ void ide_requeue_and_plug(ide_drive_t *drive, struct request *rq)
>>>>>>  	spin_unlock_irqrestore(q->queue_lock, flags);
>>>>>>  
>>>>>>  	/* Use 3ms as that was the old plug delay */
>>>>>> -	if (rq)
>>>>>> -		blk_delay_queue(q, 3);
>>>>>> +	blk_delay_queue(q, 3);
>>>>>>  }
>>>>>>  
>>>>>>  static int drive_is_ready(ide_drive_t *drive)
>>>>>>
>>>>>
>>>>> Did a fresh pull and applied that patch.  (It conflicts with your
>>>>> previous one, but looks like it includes it.)
>>>>>
>>>>> Now it hangs after the "EXT3-fs: barriers not enabled" line, doesn't
>>>>> make it to init.
>>>>
>>>> I have tried hard to reproduce this, but even stock 2.6.39-rc1 works
>>>> fine for me here. Setup a KVM image with a debian 6 install, then
>>>> converted it to IDE and booting it with a custom kernel like you are.
>>>> Works fine, boots and I can do disk activity tests and it all works.
>>>>
>>>> Can you send me your .config?
>>>
>>> It was attached to the first message in this series, here it is again.
>>>
>>> I update it via "make oldconfig" and hold down return.
>>>
>>> I boot it via:
>>>
>>> qemu-system-x86_64 -m 1024 -kernel arch/x86/boot/bzImage \
>>>   -hda ~/sid.ext3 -append "root=/dev/hda rw"
>>
>> Much better, I see the hang now! Now to try and diagnose...
> 
> It seems to hard hang, looks very odd:

I should have mentioned that: when it hangs, you can't page back up in
the console display anymore.

Rob
