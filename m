Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab1DADTJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 23:19:09 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:60903 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754774Ab1DADSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 23:18:52 -0400
Subject: Re: Commit 7eaceaccab5f40 causing boot hang.
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Rob Landley <rlandley@parallels.com>,
        Pete Clements <clem@clem.clem-digital.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
In-Reply-To: <4D9460F8.7080606@fusionio.com>
References: <201103291551.p2TFpDqZ001692@clem.clem-digital.net>
	 <4D92C874.7040104@parallels.com> <4D931634.5030807@fusionio.com>
	 <4D933584.5050005@parallels.com> <4D94432D.5080601@fusionio.com>
	 <4D944544.9040705@parallels.com> <4D945247.4080404@fusionio.com>
	 <4D945976.8000401@fusionio.com> <4D945BAD.10309@parallels.com>
	 <4D9460F8.7080606@fusionio.com>
Content-Type: text/plain
Date: Thu, 31 Mar 2011 20:11:31 -0700
Message-Id: <1301627491.2319.61.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-31 at 13:09 +0200, Jens Axboe wrote:
> On 2011-03-31 12:47, Rob Landley wrote:
> > On 03/31/2011 05:37 AM, Jens Axboe wrote:
> >> On 2011-03-31 12:07, Jens Axboe wrote:
> >>> On 2011-03-31 11:11, Rob Landley wrote:
> >>>> On 03/31/2011 04:02 AM, Jens Axboe wrote:
> >>>>> On 2011-03-30 15:52, Rob Landley wrote:
> >>>>>> On 03/30/2011 06:38 AM, Jens Axboe wrote:
> >>>>>>> On 2011-03-30 08:06, Rob Landley wrote:
> >>>>>>>> On 03/29/2011 10:51 AM, Pete Clements wrote:
> >>>>>>>>> Quoting Jens Axboe

<SNIP>

> >>>>>>>>> I have had a similiar problem (reported earlier) unable to boot.
> >>>>>>>>> With git15-18 hung with IDE drives (hda), git19-21 moved the hang down to
> >>>>>>>>> the IDE CDROM (hdc). Applied the above patch and now booted into git21 without
> >>>>>>>>> any hang and all appears ok.
> >>>>>>>>
> >>>>>>>> It may have made it better for me, it's hard to tell.
> >>>>>>>>
> >>>>>>>> I did a fresh pull, re-applied the patch, and tried again with
> >>>>>>>> init=/bin/sh and it booted to the shell prompt... which then hung when I
> >>>>>>>> did "ls -l /".
> >>>>>>>>
> >>>>>>>> If I let it boot normally, init announces itself, gives a spurious
> >>>>>>>> warning about a fstab field (which it's been doing for a while, my fault
> >>>>>>>> but harmless), then hangs.
> >>>>>>>>
> >>>>>>>>> This is i386, UP.
> >>>>>>>>
> >>>>>>>> I'm doing x86-64 SMP.
> >>>>>>>
> >>>>>>> I think we have the same issue the other location. How about this, then:
> >>>>>>>
> >>>>>>> diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
> >>>>>>> index 0e406d73..4978ec3 100644
> >>>>>>> --- a/drivers/ide/ide-io.c
> >>>>>>> +++ b/drivers/ide/ide-io.c
> >>>>>>> @@ -549,12 +549,11 @@ plug_device:
> >>>>>>>  	spin_unlock_irq(&hwif->lock);
> >>>>>>>  	ide_unlock_host(host);
> >>>>>>>  plug_device_2:
> >>>>>>> +	blk_delay_queue(q, queue_run_ms);
> >>>>>>>  	spin_lock_irq(q->queue_lock);
> >>>>>>>  
> >>>>>>> -	if (rq) {
> >>>>>>> +	if (rq)
> >>>>>>>  		blk_requeue_request(q, rq);
> >>>>>>> -		blk_delay_queue(q, queue_run_ms);
> >>>>>>> -	}
> >>>>>>>  }
> >>>>>>>  
> >>>>>>>  void ide_requeue_and_plug(ide_drive_t *drive, struct request *rq)
> >>>>>>> @@ -570,8 +569,7 @@ void ide_requeue_and_plug(ide_drive_t *drive, struct request *rq)
> >>>>>>>  	spin_unlock_irqrestore(q->queue_lock, flags);
> >>>>>>>  
> >>>>>>>  	/* Use 3ms as that was the old plug delay */
> >>>>>>> -	if (rq)
> >>>>>>> -		blk_delay_queue(q, 3);
> >>>>>>> +	blk_delay_queue(q, 3);
> >>>>>>>  }
> >>>>>>>  
> >>>>>>>  static int drive_is_ready(ide_drive_t *drive)
> >>>>>>>
> >>>>>>
> >>>>>> Did a fresh pull and applied that patch.  (It conflicts with your
> >>>>>> previous one, but looks like it includes it.)
> >>>>>>
> >>>>>> Now it hangs after the "EXT3-fs: barriers not enabled" line, doesn't
> >>>>>> make it to init.
> >>>>>
> >>>>> I have tried hard to reproduce this, but even stock 2.6.39-rc1 works
> >>>>> fine for me here. Setup a KVM image with a debian 6 install, then
> >>>>> converted it to IDE and booting it with a custom kernel like you are.
> >>>>> Works fine, boots and I can do disk activity tests and it all works.
> >>>>>
> >>>>> Can you send me your .config?
> >>>>
> >>>> It was attached to the first message in this series, here it is again.
> >>>>
> >>>> I update it via "make oldconfig" and hold down return.
> >>>>
> >>>> I boot it via:
> >>>>
> >>>> qemu-system-x86_64 -m 1024 -kernel arch/x86/boot/bzImage \
> >>>>   -hda ~/sid.ext3 -append "root=/dev/hda rw"
> >>>
> >>> Much better, I see the hang now! Now to try and diagnose...
> >>
> >> It seems to hard hang, looks very odd:
> > 
> > I should have mentioned that: when it hangs, you can't page back up in
> > the console display anymore.
> 
> Data point - only seems to happen on UP. If you add -smp X to kvm, then
> it boots and works just fine. It smells oddly like some sort of irq
> event.
> 

Hi Jens and Co,

I ran into this same problem yesterday with .39-rc1 in my HW target mode
QEMU/KVM development environment.  I applied the above patch, which
still hangs during boot with the following usage QEMU-KVM usage:

qemu-system-x86_64 -m 2048 -smp 4 -device pci-assign,host=02:00.0
-device pci-assign,host=06:00.0 /root/lenny64guest0-orig.img -serial
file:serial-36.log

However, after adding the '-cdrom ~/linux-distro.iso' parameter to the
above w/ your patch I am now about to boot without issue into .39-rc1
guest and everything appears fine for root=/dev/hda1.

So AFAICT it seems to be related to ide_cd_mod.ko with an empty drive..

--nab

