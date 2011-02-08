Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933Ab1BHT2a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 14:28:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30187 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923Ab1BHT23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 14:28:29 -0500
Date: Tue, 8 Feb 2011 14:27:56 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Jarod Wilson <jwilson@redhat.com>
Subject: Re: Query about kdump_msg hook into crash_kexec()
Message-ID: <20110208192756.GB29081@redhat.com>
References: <20110131225939.GH11974@redhat.com>
 <20110203094715.939C.A69D9226@jp.fujitsu.com>
 <20110203020528.GA21603@redhat.com>
 <5C4C569E8A4B9B42A84A977CF070A35B2C147F4346@USINDEVS01.corp.hds.com>
 <m14o8klt3w.fsf@fess.ebiederm.org>
 <5C4C569E8A4B9B42A84A977CF070A35B2C147F43B7@USINDEVS01.corp.hds.com>
 <20110208164656.GA29081@redhat.com>
 <m1ei7i8m5o.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1ei7i8m5o.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 08, 2011 at 09:35:15AM -0800, Eric W. Biederman wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
> 
> > On Thu, Feb 03, 2011 at 05:08:01PM -0500, Seiji Aguchi wrote:
> >> Hi Eric,
> >> 
> >> Thank you for your prompt reply.
> >> 
> >> I would like to consider "Needs in enterprise area" and "Implementation of kmsg_dump()" separately.
> >> 
> >> (1) Needs in enterprise area
> >>   In case of kdump failure, we would like to store kernel buffer to NVRAM/flush memory
> >>   for detecting root cause of kernel crash.
> >> 
> >> (2) Implementation of kmsg_dump 
> >>   You suggest to review/test cording of kmsg_dump() more.
> >> 
> >> What do you think about (1)?
> >> Is it acceptable for you?
> >
> > Ok, I am just trying to think loud about this problem and see if something
> > fruitful comes out which paves the way forward.
> >
> > - So ideally we would like kdump_msg() to be called after crash_kexec() so
> >   that any unaudited (third party modules), unreliable calls do not 
> >   compromise the realiability of kdump operation.
> >
> >   But hitachi folks seems to be wanting to save atleast kernel buffers
> >   somwhere in the NVRAM etc because they think that kdump can be
> >   unreliable and we might not capture any information after the crash. So
> >   they kind of want two mechanisms in place. One is light weight which
> >   tries to save kernel buffers in NVRAM and then one heavy weight one
> >   which tries to save the entire/filtered kernel core.
> >
> >   Personally I am not too excited about the idea but I guess I can live
> >   with it. We can try to audit atleast in kernel module and for external
> >   modules we don't have much control and live with the fact that if
> >   modules screw up, we don't capture the dump.
> >
> >  Those who don't want this behavior can do three things.
> >
> > 	- Disable kdump_msg() at compile time.
> > 	- Do not load any module which registers for kdump_msg()
> > 	- Implement a /proc tunable which allows controlling this
> > 	  behavior.
> >
> > - Ok, having said why do we want it, comes the question of how to  
> >   do it so that it works reasonably well.
> >
> >   - There seems to be on common requirement of kmsg_dump() and kdump()
> >     and that is stop other cpus reliably (use nmi if possible). Can
> >     we try to share this code between kmsg_dump and crash_kexec(). So
> >     something like as follows.
> >
> > 	- panic happens
> > 	- Do all the activities related to printing panic string and
> > 	  stack dump.
> > 	- Stop other cpus.
> > 		- This can be probably be done with the equivalent of
> > 		  machine_crash_shutdown() function. In fact this function
> > 		  can probably be broken down in two parts. First part
> > 	  	  does shutdown_prepare() where all other cpus are shot
> > 		  down and second part can do the actual disabling of
> > 		  LAPIC/IOAPIC and saving cpu registers etc.
> >
> > 		if (mutex_trylock(some_shutdown_mutex)) {
> > 			/* setp regs, fix vmcoreinfo etc */
> > 			crash_kexec_prepare();
> > 			machine_shutdown_prepare();
> > 			kdump_msg();	
> > 			crash_kexec_execute()
> > 			/* Also call panic_notifier_list here ? */
> > 		}
> >
> > crash_kexec_prepare () {
> > 		crash_setup_regs(&fixed_regs, regs);
> > 		crash_save_vmcoreinfo();
> > }
> >
> > crash_kexec_execute() {
> > 			/* Shutdown lapic/ioapic, save this cpu register etc */
> > 			machine_shutdown();
> > 			machine_kexec()
> > }
> >
> > So basically we break down machine_shutdown() function in two parts
> > and start sharing common part between kdump_msg(), crash_kexec and
> > possibly panic_notifiers. 
> >
> > If kdump is not configured, then after executing kdump_msg() and panic
> > notifiers, we should either be sitting in tight loop with interrupt
> > enabled for somebody to press Ctrl-boot or reboot system upon lapse
> > of panic_timeout().
> >
> > Eric, does it make sense to you?
> 
> kexec on panic doesn't strictly require that we stop other cpus.

Yes but it is desirable.

- We don't want cpus to be scribbling on old memory and possibly on
  new kernel's memory also in case of corrupted pointer and crash
  the freshly booted kernel (New kerenl's memory is mapped in old
  kernel)

- We don't want other cpus to complete panic() and jump to BIOS or
  lead to some kind of triple fault and reset the system etc.

So that would suggest to be robust, stopping other cpus is required.

On a side note, kdump_msg() hook is present in emergency_reboot() too.
So if these paths are not properly designed, then system might not
even reboot automatically even if panic_timeout() has been specified.

> 
> What makes sense to me at this point is for someone on the kmsg_dump
> side to make a strong case that the code actually works in a crash dump
> scenario.  We have lots of experience over the years that says a design
> like kmsg_dump is attractive but turns out to be a unreliable piece of
> junk that fails just when you need it.  Because developers only test
> the case when the kernel is happy and because people share code with
> the regular path drivers, and that code assumes things are happy.
> 
> I forget exactly why but last I looked.
> local_irq_disable()
> kmsg_dump()
> local_irq_enalbe()

I agree that kdump_msg() code should be able to work with interrupts
disabled, atleast. 

There seem to be two pieces to it. One is generic call which calls
all the dumpers and then respective dumpers.

Looking at generic dumping call, I can't think why does it need interrupts
to be enabled. There is one spin_lock() and then rcu_read_lock(). That's
it.

Regarding mtdoops, it is hard to tell. There is lot of code. But the good
thing is that they have introduced a separate write path for panic context.
That way atleast one can do special casing in panic path to avoid
taking locks and not be dependent on interrupts.

ramoops seems to be simple. It seems to be just memcpy() except
do_gettimeofday(). I noticed that in the past you raised concern about usage
of do_gettimeofday(), but I am not sure what is the concern here (silly
question i guess).

So to me, ramoops seems to be simple memcpy (atleast in principle) and
mtdoops has a dedicated path for handling panic context. So atleast
it is fixable for possible issues. Generic code seems harmless to me
at this point of time.
 
> 
> Was a recipe for disaster, and you have be at least that good to even
> have a chance of working in a crash dump scenario.
> 
> In part I am puzzled why the kmsg dump doesn't just use the printk
> interface.  Strangely enough printk works in the event of a crash and
> has been shown to be reliable over the years.

Are you suggesting implementing these things as console driver and
register with printk as console? Sounds interesting. I think one of
the issues they probably will find that they don't want to log everything.
They want to do selective logging. Not sure how would they get this
info.

In some cases like emergency_restart(), there are no printk() and they
just consider it one of the events to dump the kernel buffer contents.

Thanks
Vivek
