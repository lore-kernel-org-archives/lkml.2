Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937Ab2HBRxy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 13:53:54 -0400
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:30174 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658Ab2HBRxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 13:53:53 -0400
Message-ID: <1343929732.3010.614.camel@misato.fc.hp.com>
Subject: Re: [PATCH 1/2] x86: abort secondary CPU bring-up gracefully if
 do_boot_cpu timed out on cpu_callin_mask
From: Toshi Kani <toshi.kani@hp.com>
To: Igor Mammedov <imammedo@redhat.com>
Cc: linux-kernel@vger.kernel.org, prarit@redhat.com, oleg@redhat.com,
        rob@landley.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, luto@mit.edu,
        suresh b siddha <suresh.b.siddha@intel.com>, avi@redhat.com,
        a p zijlstra <a.p.zijlstra@chello.nl>, johnstul@us.ibm.com,
        a17711@motorola.com, shuahkhan@gmail.com
Date: Thu, 02 Aug 2012 11:48:52 -0600
In-Reply-To: <501A49A4.90107@redhat.com>
References: <501A49A4.90107@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-02 at 11:34 +0200, Igor Mammedov wrote:
> Hi Toshi,
> 
> I'm sorry for delayed response, I was on vacation. Thanks for looking at 
> the patch, my comments are below.

Hi Igor,

Welcome back!

> PS:
> I'm not happy with introducing one more sync point and bitmat. Well, 
> it's necessary to somehow notify being on-lined CPU that master CPU will 
> wait for it, but perhaps it could be done even earlier than in this 
> patch and less stuff should be backed-out.
> 
> Currently master CPU spins on cpu_callin_mask till secondary CPU sets it
> in smp_callin(). Then master CPU leaves do_boot_cpu() and does nothing 
> in native_cpu_up() first waiting for secondary CPU in 
> check_tsc_sync_source() or if that is skipped then immediately spinning 
> on 'while (!cpu_online(cpu))'.
> Master CPU will do nothing and will not call any CPU notifiers until 
> secondary CPU reports that it is ONLINE by setting bit in 
> cpu_online_mask at the end of start_secondary().
> 
> So questions to experts are:
> 
>   1. what is purpose of cpu_callin_mask
> 
>   2. why master CPU spins on cpu_callin_mask but not on cpu_initialized_mask
> 
> In current state of code, it looks like cpu_callin_mask is not necessary 
> and we could remove it completely and spin on cpu_initialized_mask in 
> do_boot_cpu() instead. Then when master CPU
> sees secondary CPU in cpu_initialized_mask it could set cpu_callout_mask 
> to ack its intention not to cancel and wait until
> secondary CPU is booted.

I agree and I'd like to know the answers as well.  This way, the master
does not have to deal with secondary's back-back out procedure.

> PS2:
> I wish x86 maintainers were more responsive to the topic and in 
> discussion we could find a way to fix problem. With their expertise, 
> It's surely easier to spot potential issues and see correct approach for 
> the fix.
> 

(snip)

> > > +
> > > +die:
> > > +#ifdef CONFIG_HOTPLUG_CPU
> > > +	numa_remove_cpu(cpuid);
> >
> > smp_callin() calls numa_add_cpu(), so it makes sense to perform this
> > back-out from here.  However, do_boot_cpu() also calls this function
> > in
> > its error path.  I think we should change do_boot_cpu() to perform its
> > back-out to the master CPU's initialization code only.  This would keep
> > their responsibility clear and avoid any race condition.
> Reason to keep numa_remove_cpu() in do_boot_cpu() is for the case where
> being onlined CPU is permanently stuck on boot. In this case 
> numa_remove_cpu() would not be called from smp_callin().
> Anyway race is still there:
>   master CPU: numa_remove_cpu()
>    ... window with incorrect numa state
>   secondary CPU: numa_add_cpu()
>   secondary CPU: numa_remove_cpu()

Right.  Another example is that the master can call numa_remove_cpu()
after a secondary called numa_add_cpu().  If the secondary's next
procedure relies on numa_add_cpu() be done, it causes a problem.

Anyway, I like your idea of the master to wait for cpu_initialized_mask.
This should eliminate the need of the master to perform secondary's
back-out procedure.

> > Also, it would be helpful to have a comment like /* was set by
> > smp_store_cpu_info() */ to state this responsibility clearly.
> I'll fix it in next version.
> 
> >
> > > +	remove_siblinginfo(cpuid);
> > > +	clear_local_APIC();
> > > +	/* was set by cpu_init() */
> > > +	cpumask_clear_cpu(cpuid, cpu_initialized_mask);
> >
> > This is also called by do_boot_cpu().  Same comment as above.
> >
> > > +	cpumask_clear_cpu(cpuid, cpu_callin_mask);
> > > +	play_dead();
> > > +#endif
> > > +	panic("%s: Failed to online CPU%d!\n", __func__, cpuid);
> >
> > Why does it panic in case of !CONFIG_HOTPLUG_CPU?  Is this because user
> > cannot online this CPU later on, so it might be better off rebooting
> > with a panic?  Can I also assume that user can try to on-line this
> > failed CPU if CONFIG_HOTPLUG_CPU is set?  Some comment would be helpful
> > to clarify this behavior.
> User isn't able to online/offline CPUs if kernel is built without 
> CONFIG_HOTPLUG_CPU.
> Define is here to cover failed on boot CPU for non hotplug capable 
> kernel. A bunch of code to stop CPU is just not built for non hotplug
> kernel so what else to do except of panicking?

Another option is to simply boot-up the system with a reduced number of
CPUs for all cases.  This way has advantage when:

 - If resume/suspend works without CONFIG_HOTPLUG_CPU, it avoids
crashing the system at resume.
 - User can boot-up and uses the system with a reduced number of CPUs
even if the error persists after a reboot.


Thanks,
-Toshi 




