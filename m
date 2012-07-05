Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757247Ab2GEUYz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 16:24:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37072 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754145Ab2GEUYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 16:24:54 -0400
Date: Thu, 5 Jul 2012 16:24:43 -0400
From: Don Zickus <dzickus@redhat.com>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "mikew@google.com" <mikew@google.com>,
        "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: Re: [RFC][PATCH 2/2] write callback: Check if existing entry is
 erasable
Message-ID: <20120705202443.GQ5637@redhat.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D401AAED@USINDEM103.corp.hds.com>
 <20120705133201.GG5637@redhat.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D401C288@USINDEM103.corp.hds.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D401C288@USINDEM103.corp.hds.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2012 at 08:05:06PM +0000, Seiji Aguchi wrote:
> Don,
> 
> Thank you for giving me your comments.
> Let me explain what I'm thinking now.
> 
> > I would rather see no records overwritten and just make sure there is enough space for a dozen or so records to buffer multiple
> > panics before userspace can run.
> > 
> > Implementing policy like this in the kernel seems like it would be a constant battle between everyone's view point of what is
> > important and not important.
> > 
> > I would rather take the viewpoint, if it is important to log it in a space limited NVRAM, then it is important enough not to overwrite
> > until userspace explicitly asks it to be deleted.  Otherwise why log it, if it is not important?
> > 
> 
> If the simple policy above is workable, it is easy. 
> But we have to discuss whether it is useful in each specific use case.
>        When I posted a patch introducing kernel parameter ,efi_pstore_overwrite,
>        I thought same thing above. But I changed my mind while considering  Tony's comment....
> 
> When an user can read kmsg via /dev/pstore and erase old entries,  we don't need to care.
> (Hopefully, some user space apps will be developed near future.)
> 
> Problem here is at very final stage and early stage which an user can't see /dev/pstore.
> 
> 1) At very final stage  (system is panicking/rebooting.)
> 
> 1-1) Kernel panics while system is rebooting(or oopsing)
> 
> When kernel panics while system is rebooting, panic message should be logged rather than skipping it.
> 
> Even though reboot message is overwritten by panic one, we will probably save both final part of 
> reboot message and panic message as follows.
> 
> Example of kmsg in NVRAM
> 	<snip>
> 	Panic#1							 <- header supplied by pstore
> 	<6>kvm: exiting hardware virtualization
> 	<5>sd 0:0:0:0: [sda] Synchronizing SCSI cache
> 	 <0>Restarting system.						<- reboot message
> 	<0>BUG: soft lockup - CPU#0 stuck for 22s! [swapper/0:0]
> 	<0> Kernel panic - not syncing: softlockup: hung tasks		<- panic message
> 	<0>Pid: 0, comm: swapper/0 Not tainted 3.3.8 #4 Call Trace:
>   	<0><IRQ>  [<ffffffff8136bdd5>] panic+0xb8/0x1c4
>   	<0>[<ffffffff81071f37>] watchdog_timer_fn+0x139/0x15d
>   	<0>[<ffffffff81071dfe>] ? __touch_watchdog+0x1f/0x1f
> 	<snip>
> 
> 1-2) Double panic 
> In this case, 1s panic message should not be overwritten to detect root cause of system failure.
> 
> 1-3) ) Kernel reboots while system is panicking
> Never happens because kmsg_dump in panic case is serialized via smp_send_stop()
> 
> 2)  At very early stage  (system is booting up.)
> 2-1)Previous event is panic, and then panic happens again at boot time.
> Previous panic should not be overwritten.
> 
> 2-2)Previous event is reboot, and then panic happens at boot time
> This depends on situation.
> Some customer would like to have previous reboot message.
> Others may want to get latter panic message.
> 
> So, in my current patch, I just decided a policy which error message is prioritized higher than normal message.

I understand the above scenario and was the one of was thinking of when I
replied.  My counter argument is if the NVRAM isn't big enough to hold
more than two panics, then the logs are too big.

This stuff should be designed to easily accomodate multiple logs (like
say 6 or so), then the above situation doesn't matter.

I just feel this is adding complexity to something that shouldn't need it.

Cheers,
Don
