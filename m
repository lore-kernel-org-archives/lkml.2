Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258Ab0JKVRg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 17:17:36 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:33302 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756134Ab0JKVRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 17:17:34 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: akataria@vmware.com
Cc: "kexec\@lists.infradead.org" <kexec@lists.infradead.org>,
        Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Daniel Hecht <dhecht@vmware.com>,
        jeremy@xensource.com
References: <1286570087.8769.27.camel@ank32.eng.vmware.com>
	<1286816964.1372.2.camel@ank32.eng.vmware.com>
	<m1lj64ppri.fsf@fess.ebiederm.org>
	<1286826083.1372.15.camel@ank32.eng.vmware.com>
Date: Mon, 11 Oct 2010 14:17:25 -0700
In-Reply-To: <1286826083.1372.15.camel@ank32.eng.vmware.com> (Alok Kataria's
	message of "Mon, 11 Oct 2010 12:41:23 -0700")
Message-ID: <m1k4lo77kq.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;akataria@vmware.com
X-Spam-Relay-Country: 
Subject: Re: [RFC PATCH] Bug during kexec...not all cpus are stopped
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alok Kataria <akataria@vmware.com> writes:

> Hi Eric,
>
> Thanks for taking a look.
>
> On Mon, 2010-10-11 at 11:07 -0700, Eric W. Biederman wrote:
>> Alok Kataria <akataria@vmware.com> writes:
>> 
>> > Copying a few more maintainers on the thread...
>> > On Fri, 2010-10-08 at 13:34 -0700, Alok Kataria wrote:
>> >> Before starting the new kernel kexec calls machine_shutdown to stop all
>> >> the cpus, which internally calls native_smp_send_stop. AFAIU, kexec
>> >> expects that all the cpus are now halted after that call returns.
>> >> Now, looking at the code for native_smp_send_stop, it assumes that all
>> >> the processors have processed the REBOOT ipi in 1 second after the IPI
>> >> was sent.
>> >> native_smp_send_stop()
>> >> ---------------------------------------------------------
>> >>      apic->send_IPI_allbutself(REBOOT_VECTOR);
>> >>
>> >>         /* Don't wait longer than a second */
>> >>         wait = USEC_PER_SEC;
>> >>         while (num_online_cpus() > 1 && wait--)
>> >>              udelay(1);
>> >> ---------------------------------------------------------
>> >>
>> >> It just returns after that 1 second irrespective of whether all cpus
>> >> were halted or not. This brings up a issue in the kexec case, since we
>> >> can have the BSP starting the new kernel and AP's still processing the
>> >> REBOOT IPI simultaneously.
>> >>
>> >> Many distribution kernels use kexec to load the newly installed kernel
>> >> during the installation phase, in virtualized environment with the host
>> >> heavily overcommitted, we have seen some instances when vcpu fails to
>> >> process the IPI in the allotted 1 sec and as a result the AP's end up
>> >> accessing uninitialized state (the BSP has already gone ahead with
>> >> setting up the new state) and causing GPF's.
>> >>
>> >> IMO, kexec expects machine_shutdown to return only after all cpus are
>> >> stopped.
>> >>
>> >> The patch below should fix the issue, comments ??
>> >>
>> >> --
>> >> machine_shutdown now takes a parameter "wait", if it is true, it waits
>> >> until all the cpus are halted. All the callers except kexec still
>> >> fallback to the earlier version of the shutdown call, where it just
>> >> waited for max 1 sec before returning.
>> 
>> The approach seems reasonable.  However on every path except for the
>> panic path I would wait for all of the cpus to stop, as that is what
>> those code paths are expecting.  Until last year smp_send_stop always
>> waited until all of the cpus stopped.  So I think changing
>> machine_shutdown should not need to happen.
>> 
>> This patch cannot be used as is because it changes the parameters to
>> smp_send_stop() and there are more than just x86 implementations out
>> there.
>> 
>> Let me propose a slightly different tactic.  We need to separate
>> the panic path from the normal path to avoid confusion.  At the
>> generic level smp_send_stop is exclusively used for the panic
>> path.  So we should keep that, and rename the x86 non-panic path
>> function something else.
>> 
>> Can you rename the x86 smp_send_stop function say stop_all_other_cpus().
>> 
>> At which point we could implement smp_send_stop as:
>> stop_all_other_cpus(0);
>> 
>> And everywhere else would call stop_all_other_cpus(1) waiting for
>> the cpus to actually stop.
>
> Done, I have added a stop_other_cpus function which calls
> smp_ops.stop_other_cpus(1)
>
>> 
>> I really think we want to wait for the cpus to stop in all cases except
>> for panic/kdump where we expect things to be broken and we are doing
>> our best to make things work anyway.
> Now it does, except in the panic case.
>
> Jeremy, I have modified the xen_reboot bits too so that it now waits
> until all cpus are actually stopped, please take a look.
>
> --
>
> x86 smp_ops now has a new op, stop_other_cpus which takes a parameter "wait"
> this allows the caller to specify if it wants to stop untill all the cpus
> have processed the stop IPI. This is required specifically for the kexec case
> where we should wait for all the cpus to be stopped before starting the new
> kernel.
> We now wait for the cpus to stop in all cases except for panic/kdump where
> we expect things to be broken and we are doing our best to make things
> work anyway.

One little nit.


> Signed-off-by: Alok N Kataria <akataria@vmware.com>
> Cc: Eric W. Biederman <ebiederm@xmission.com>
> Cc: Jeremy Fitzhardinge <jeremy@xensource.com>
>
> Index: linux-2.6/arch/x86/include/asm/smp.h
> ===================================================================
> --- linux-2.6.orig/arch/x86/include/asm/smp.h	2010-10-11 11:56:40.000000000 -0700
> +++ linux-2.6/arch/x86/include/asm/smp.h	2010-10-11 12:00:22.000000000 -0700
> @@ -50,7 +50,7 @@ struct smp_ops {
>  	void (*smp_prepare_cpus)(unsigned max_cpus);
>  	void (*smp_cpus_done)(unsigned max_cpus);
>  
> -	void (*smp_send_stop)(void);
> +	void (*stop_other_cpus)(int wait);
>  	void (*smp_send_reschedule)(int cpu);
>  
>  	int (*cpu_up)(unsigned cpu);
> @@ -73,7 +73,12 @@ extern struct smp_ops smp_ops;
>  
>  static inline void smp_send_stop(void)
>  {
> -	smp_ops.smp_send_stop();
> +	smp_ops.stop_other_cpus(0);
> +}
> +
> +static inline void stop_other_cpus(void)
> +{
> +	smp_ops.stop_other_cpus(1);
>  }
>  
>  static inline void smp_prepare_boot_cpu(void)
> Index: linux-2.6/arch/x86/kernel/reboot.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/reboot.c	2010-10-11 11:56:40.000000000 -0700
> +++ linux-2.6/arch/x86/kernel/reboot.c	2010-10-11 12:05:02.000000000 -0700
> @@ -641,7 +641,7 @@ void native_machine_shutdown(void)
>  	/* O.K Now that I'm on the appropriate processor,
>  	 * stop all of the others.
>  	 */
> -	smp_send_stop();
> +	stop_other_cpus();
>  #endif
>  
>  	lapic_shutdown();
> Index: linux-2.6/arch/x86/kernel/smp.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/smp.c	2010-10-11 11:56:40.000000000 -0700
> +++ linux-2.6/arch/x86/kernel/smp.c	2010-10-11 12:16:42.000000000 -0700
> @@ -159,10 +159,10 @@ asmlinkage void smp_reboot_interrupt(voi
>  	irq_exit();
>  }
>  
> -static void native_smp_send_stop(void)
> +static void native_stop_other_cpus(int wait)
>  {
>  	unsigned long flags;
> -	unsigned long wait;
> +	unsigned long timeout;
>  
>  	if (reboot_force)
>  		return;
> @@ -179,9 +179,12 @@ static void native_smp_send_stop(void)
>  	if (num_online_cpus() > 1) {
>  		apic->send_IPI_allbutself(REBOOT_VECTOR);
>  
> -		/* Don't wait longer than a second */
> -		wait = USEC_PER_SEC;
> -		while (num_online_cpus() > 1 && wait--)
> +		/*
> +		 * Don't wait longer than a second if the caller
> +		 * didn't ask us to wait.
> +		 */
> +		timeout = USEC_PER_SEC;
> +		while (num_online_cpus() > 1 && (wait || timeout--))
>  			udelay(1);
>  	}
>  
> @@ -227,7 +230,7 @@ struct smp_ops smp_ops = {
>  	.smp_prepare_cpus	= native_smp_prepare_cpus,
>  	.smp_cpus_done		= native_smp_cpus_done,
>  
> -	.smp_send_stop		= native_smp_send_stop,
> +	.stop_other_cpus	= native_stop_other_cpus,
>  	.smp_send_reschedule	= native_smp_send_reschedule,
>  
>  	.cpu_up			= native_cpu_up,
> Index: linux-2.6/arch/x86/xen/enlighten.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/xen/enlighten.c	2010-10-11 11:56:40.000000000 -0700
> +++ linux-2.6/arch/x86/xen/enlighten.c	2010-10-11 11:58:53.000000000 -0700
> @@ -1018,7 +1018,7 @@ static void xen_reboot(int reason)
>  	struct sched_shutdown r = { .reason = reason };
>  
>  #ifdef CONFIG_SMP
> -	smp_send_stop();
> +	stop_other_cpus();
>  #endif
>  
>  	if (HYPERVISOR_sched_op(SCHEDOP_shutdown, &r))
> Index: linux-2.6/arch/x86/xen/smp.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/xen/smp.c	2010-10-11 11:56:40.000000000 -0700
> +++ linux-2.6/arch/x86/xen/smp.c	2010-10-11 11:58:53.000000000 -0700
> @@ -400,9 +400,9 @@ static void stop_self(void *v)
>  	BUG();
>  }
>  
> -static void xen_smp_send_stop(void)
> +static void xen_stop_other_cpus(int wait)
>  {
> -	smp_call_function(stop_self, NULL, 0);
> +	smp_call_function(stop_self, NULL, wait);
>  }
>  
>  static void xen_smp_send_reschedule(int cpu)
> @@ -470,7 +470,7 @@ static const struct smp_ops xen_smp_ops 
>  	.cpu_disable = xen_cpu_disable,
>  	.play_dead = xen_play_dead,
>  
> -	.smp_send_stop = xen_smp_send_stop,
> +	.stop_other_cpus = xen_stop_other_cpus,
>  	.smp_send_reschedule = xen_smp_send_reschedule,
>  
>  	.send_call_func_ipi = xen_smp_send_call_function_ipi,
> Index: linux-2.6/include/linux/smp.h
> ===================================================================
> --- linux-2.6.orig/include/linux/smp.h	2010-10-11 11:56:40.000000000 -0700
> +++ linux-2.6/include/linux/smp.h	2010-10-11 12:07:19.000000000 -0700
> @@ -116,7 +116,8 @@ extern unsigned int setup_max_cpus;
>  
>  #else /* !SMP */
>  
> -static inline void smp_send_stop(void) { }
> +static inline void smp_send_stop() { }
> +static inline void stop_other_cpus() { }

You shouldn't change smp.h.

For the moment stop_other_cpus() is x86 specific so we shouldn't
impose it in other architectures. 

Also note removing the explicit void is a bad idea in C because that is
equivalent to saying: smp_send_stop(...) { }  Which allows any set
of parameters you can think of.

Eric

