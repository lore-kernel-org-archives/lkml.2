Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118Ab1BHQr2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 11:47:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38481 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754790Ab1BHQr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 11:47:27 -0500
Date: Tue, 8 Feb 2011 11:46:56 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Jarod Wilson <jwilson@redhat.com>
Subject: Re: Query about kdump_msg hook into crash_kexec()
Message-ID: <20110208164656.GA29081@redhat.com>
References: <20110131225939.GH11974@redhat.com>
 <20110203094715.939C.A69D9226@jp.fujitsu.com>
 <20110203020528.GA21603@redhat.com>
 <5C4C569E8A4B9B42A84A977CF070A35B2C147F4346@USINDEVS01.corp.hds.com>
 <m14o8klt3w.fsf@fess.ebiederm.org>
 <5C4C569E8A4B9B42A84A977CF070A35B2C147F43B7@USINDEVS01.corp.hds.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5C4C569E8A4B9B42A84A977CF070A35B2C147F43B7@USINDEVS01.corp.hds.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 03, 2011 at 05:08:01PM -0500, Seiji Aguchi wrote:
> Hi Eric,
> 
> Thank you for your prompt reply.
> 
> I would like to consider "Needs in enterprise area" and "Implementation of kmsg_dump()" separately.
> 
> (1) Needs in enterprise area
>   In case of kdump failure, we would like to store kernel buffer to NVRAM/flush memory
>   for detecting root cause of kernel crash.
> 
> (2) Implementation of kmsg_dump 
>   You suggest to review/test cording of kmsg_dump() more.
> 
> What do you think about (1)?
> Is it acceptable for you?

Ok, I am just trying to think loud about this problem and see if something
fruitful comes out which paves the way forward.

- So ideally we would like kdump_msg() to be called after crash_kexec() so
  that any unaudited (third party modules), unreliable calls do not 
  compromise the realiability of kdump operation.

  But hitachi folks seems to be wanting to save atleast kernel buffers
  somwhere in the NVRAM etc because they think that kdump can be
  unreliable and we might not capture any information after the crash. So
  they kind of want two mechanisms in place. One is light weight which
  tries to save kernel buffers in NVRAM and then one heavy weight one
  which tries to save the entire/filtered kernel core.

  Personally I am not too excited about the idea but I guess I can live
  with it. We can try to audit atleast in kernel module and for external
  modules we don't have much control and live with the fact that if
  modules screw up, we don't capture the dump.

 Those who don't want this behavior can do three things.

	- Disable kdump_msg() at compile time.
	- Do not load any module which registers for kdump_msg()
	- Implement a /proc tunable which allows controlling this
	  behavior.

- Ok, having said why do we want it, comes the question of how to  
  do it so that it works reasonably well.

  - There seems to be on common requirement of kmsg_dump() and kdump()
    and that is stop other cpus reliably (use nmi if possible). Can
    we try to share this code between kmsg_dump and crash_kexec(). So
    something like as follows.

	- panic happens
	- Do all the activities related to printing panic string and
	  stack dump.
	- Stop other cpus.
		- This can be probably be done with the equivalent of
		  machine_crash_shutdown() function. In fact this function
		  can probably be broken down in two parts. First part
	  	  does shutdown_prepare() where all other cpus are shot
		  down and second part can do the actual disabling of
		  LAPIC/IOAPIC and saving cpu registers etc.

		if (mutex_trylock(some_shutdown_mutex)) {
			/* setp regs, fix vmcoreinfo etc */
			crash_kexec_prepare();
			machine_shutdown_prepare();
			kdump_msg();	
			crash_kexec_execute()
			/* Also call panic_notifier_list here ? */
		}

crash_kexec_prepare () {
		crash_setup_regs(&fixed_regs, regs);
		crash_save_vmcoreinfo();
}

crash_kexec_execute() {
			/* Shutdown lapic/ioapic, save this cpu register etc */
			machine_shutdown();
			machine_kexec()
}

So basically we break down machine_shutdown() function in two parts
and start sharing common part between kdump_msg(), crash_kexec and
possibly panic_notifiers. 

If kdump is not configured, then after executing kdump_msg() and panic
notifiers, we should either be sitting in tight loop with interrupt
enabled for somebody to press Ctrl-boot or reboot system upon lapse
of panic_timeout().

Eric, does it make sense to you?

Thanks
Vivek

    

> 
> Seiji
> 
> >-----Original Message-----
> >From: Eric W. Biederman [mailto:ebiederm@xmission.com]
> >Sent: Thursday, February 03, 2011 4:13 PM
> >To: Seiji Aguchi
> >Cc: Vivek Goyal; KOSAKI Motohiro; linux kernel mailing list; Jarod Wilson
> >Subject: Re: Query about kdump_msg hook into crash_kexec()
> >
> >Seiji Aguchi <seiji.aguchi@hds.com> writes:
> >
> >> Hi,
> >>
> >>>PS: FWIW, Hitach folks have usage idea for their enterprise purpose, but
> >>>    unfortunately I don't know its detail. I hope anyone tell us it.
> >>
> >> I explain the usage of kmsg_dump(KMSG_DUMP_KEXEC) in enterprise area.
> >>
> >> [Background]
> >> In our support service experience, we always need to detect root cause
> >> of OS panic.
> >> So, customers in enterprise area never forgive us if kdump fails and
> >> we can't detect the root cause of panic due to lack of materials for
> >> investigation.
> >>
> >>>- Why do you need a notification from inside crash_kexec(). IOW, what
> >>>  is the usage of KMSG_DUMP_KEXEC.
> >>
> >>
> >> The usage of kdump(KMSG_DUMP_KEXEC) in enterprise area is getting
> >> useful information for investigating kernel crash in case kdump
> >> kernel doesn't boot.
> >>
> >> Kdump kernel may not start booting because there is a sha256 checksum
> >> verified over the kdump kernel before it starts booting.
> >> This means kdump kernel may fail even if there is no bug in kdump and
> >> we can't get any information for detecting root cause of kernel crash
> >
> >Sure it is theoretically possible that the sha256 checksum gets
> >corrupted (I have never seen it happen or heard reports of it
> >happening).  It is a feature that if someone has corrupted your code the
> >code doesn't try and run anyway and corrupt anything else.
> >
> >That you are arguing against have such a feature in the code you use to
> >write to persistent storage is scary.
> >
> >> As I mentioned in [Background], We must avoid lack of materials for
> >> investigation.
> >> So, kdump(KMSG_DUMP_KEXEC) is very important feature in enterprise
> >> area.
> >
> >That sounds wonderful, but it doesn't jive with the
> >code. kmsg_dump(KMSG_DUMP_KEXEC) when I read through it was simply not
> >written to be robust when most of the kernel is suspect.  Making it in
> >appropriate for use on the crash_kexec path.  I do not believe kmsg_dump
> >has seen any testing in kernel failure scenarios.
> >
> >There is this huge assumption that kmsg_dump is more reliable than
> >crash_kexec, from my review of the code kmsg_dump is simply not safe in
> >the context of a broken kernel.  The kmsg_dump code last I looked code
> >won't work if called with interrupts disabled.
> >
> >Furthermore kmsg_dump(KMSG_DUMP_KEXEC) is only useful for debugging
> >crash_kexec.  Which has it backwards as it is kmsg_dump that needs the
> >debugging.
> >
> >You just argued that it is better to corrupt the target of your
> >kmsg_dump in the event of a kernel failure instead of to fail silently.
> >
> >I don't want that unreliable code that wants to corrupt my jffs
> >partition anywhere near my machines.
> >
> >Eric
