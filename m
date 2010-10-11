Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851Ab0JKSH0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 14:07:26 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:47618 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755701Ab0JKSHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 14:07:24 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: akataria@vmware.com
Cc: kexec@lists.infradead.org, Vivek Goyal <vgoyal@redhat.com>,
        Haren Myneni <hbabu@us.ibm.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Dan Hecht <dhecht@vmware.com>
References: <1286570087.8769.27.camel@ank32.eng.vmware.com>
	<1286816964.1372.2.camel@ank32.eng.vmware.com>
Date: Mon, 11 Oct 2010 11:07:13 -0700
In-Reply-To: <1286816964.1372.2.camel@ank32.eng.vmware.com> (Alok Kataria's
	message of "Mon, 11 Oct 2010 10:09:24 -0700")
Message-ID: <m1lj64ppri.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;akataria@vmware.com
X-Spam-Relay-Country: 
Subject: Re: [RFC PATCH] Bug during kexec...not all cpus are stopped
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alok Kataria <akataria@vmware.com> writes:

> Copying a few more maintainers on the thread...
> On Fri, 2010-10-08 at 13:34 -0700, Alok Kataria wrote:
>> Before starting the new kernel kexec calls machine_shutdown to stop all
>> the cpus, which internally calls native_smp_send_stop. AFAIU, kexec
>> expects that all the cpus are now halted after that call returns.
>> Now, looking at the code for native_smp_send_stop, it assumes that all
>> the processors have processed the REBOOT ipi in 1 second after the IPI
>> was sent.
>> native_smp_send_stop()
>> ---------------------------------------------------------
>> 	apic->send_IPI_allbutself(REBOOT_VECTOR);
>> 
>>         /* Don't wait longer than a second */
>>         wait = USEC_PER_SEC;
>>         while (num_online_cpus() > 1 && wait--)
>>         	udelay(1);
>> ---------------------------------------------------------
>> 
>> It just returns after that 1 second irrespective of whether all cpus
>> were halted or not. This brings up a issue in the kexec case, since we
>> can have the BSP starting the new kernel and AP's still processing the
>> REBOOT IPI simultaneously.
>> 
>> Many distribution kernels use kexec to load the newly installed kernel
>> during the installation phase, in virtualized environment with the host
>> heavily overcommitted, we have seen some instances when vcpu fails to
>> process the IPI in the allotted 1 sec and as a result the AP's end up
>> accessing uninitialized state (the BSP has already gone ahead with
>> setting up the new state) and causing GPF's.
>> 
>> IMO, kexec expects machine_shutdown to return only after all cpus are
>> stopped.
>> 
>> The patch below should fix the issue, comments ??
>> 
>> --
>> machine_shutdown now takes a parameter "wait", if it is true, it waits
>> until all the cpus are halted. All the callers except kexec still
>> fallback to the earlier version of the shutdown call, where it just
>> waited for max 1 sec before returning.

The approach seems reasonable.  However on every path except for the
panic path I would wait for all of the cpus to stop, as that is what
those code paths are expecting.  Until last year smp_send_stop always
waited until all of the cpus stopped.  So I think changing
machine_shutdown should not need to happen.

This patch cannot be used as is because it changes the parameters to
smp_send_stop() and there are more than just x86 implementations out
there.

Let me propose a slightly different tactic.  We need to separate
the panic path from the normal path to avoid confusion.  At the
generic level smp_send_stop is exclusively used for the panic
path.  So we should keep that, and rename the x86 non-panic path
function something else.

Can you rename the x86 smp_send_stop function say stop_all_other_cpus().

At which point we could implement smp_send_stop as:
stop_all_other_cpus(0);

And everywhere else would call stop_all_other_cpus(1) waiting for
the cpus to actually stop.

I really think we want to wait for the cpus to stop in all cases except
for panic/kdump where we expect things to be broken and we are doing
our best to make things work anyway.

Eric

>> Signed-off-by: Alok N Kataria <akataria@vmware.com>
>> 
>> Index: linux-2.6/arch/x86/include/asm/reboot.h
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/include/asm/reboot.h	2010-03-26 16:57:18.000000000 -0700
>> +++ linux-2.6/arch/x86/include/asm/reboot.h	2010-10-07 16:41:58.000000000 -0700
>> @@ -9,7 +9,7 @@ struct machine_ops {
>>  	void (*restart)(char *cmd);
>>  	void (*halt)(void);
>>  	void (*power_off)(void);
>> -	void (*shutdown)(void);
>> +	void (*shutdown)(int wait);
>>  	void (*crash_shutdown)(struct pt_regs *);
>>  	void (*emergency_restart)(void);
>>  };
>> @@ -17,7 +17,7 @@ struct machine_ops {
>>  extern struct machine_ops machine_ops;
>>  
>>  void native_machine_crash_shutdown(struct pt_regs *regs);
>> -void native_machine_shutdown(void);
>> +void native_machine_shutdown(int wait);
>>  void machine_real_restart(const unsigned char *code, int length);
>>  
>>  typedef void (*nmi_shootdown_cb)(int, struct die_args*);
>> Index: linux-2.6/arch/x86/include/asm/smp.h
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/include/asm/smp.h	2010-08-03 12:43:47.000000000 -0700
>> +++ linux-2.6/arch/x86/include/asm/smp.h	2010-10-07 16:37:41.000000000 -0700
>> @@ -50,7 +50,7 @@ struct smp_ops {
>>  	void (*smp_prepare_cpus)(unsigned max_cpus);
>>  	void (*smp_cpus_done)(unsigned max_cpus);
>>  
>> -	void (*smp_send_stop)(void);
>> +	void (*smp_send_stop)(int wait);
>>  	void (*smp_send_reschedule)(int cpu);
>>  
>>  	int (*cpu_up)(unsigned cpu);
>> @@ -71,9 +71,9 @@ extern void set_cpu_sibling_map(int cpu)
>>  #endif
>>  extern struct smp_ops smp_ops;
>>  
>> -static inline void smp_send_stop(void)
>> +static inline void smp_send_stop(int wait)
>>  {
>> -	smp_ops.smp_send_stop();
>> +	smp_ops.smp_send_stop(wait);
>>  }
>>  
>>  static inline void smp_prepare_boot_cpu(void)
>> Index: linux-2.6/arch/x86/kernel/kvmclock.c
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/kernel/kvmclock.c	2010-08-03 12:43:47.000000000 -0700
>> +++ linux-2.6/arch/x86/kernel/kvmclock.c	2010-10-07 16:43:28.000000000 -0700
>> @@ -174,10 +174,10 @@ static void kvm_crash_shutdown(struct pt
>>  }
>>  #endif
>>  
>> -static void kvm_shutdown(void)
>> +static void kvm_shutdown(int wait)
>>  {
>>  	native_write_msr(msr_kvm_system_time, 0, 0);
>> -	native_machine_shutdown();
>> +	native_machine_shutdown(wait);
>>  }
>>  
>>  void __init kvmclock_init(void)
>> Index: linux-2.6/arch/x86/kernel/reboot.c
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/kernel/reboot.c	2010-08-03 12:43:47.000000000 -0700
>> +++ linux-2.6/arch/x86/kernel/reboot.c	2010-10-07 16:45:24.000000000 -0700
>> @@ -616,7 +616,7 @@ static void native_machine_emergency_res
>>  	}
>>  }
>>  
>> -void native_machine_shutdown(void)
>> +void native_machine_shutdown(int wait)
>>  {
>>  	/* Stop the cpus and apics */
>>  #ifdef CONFIG_SMP
>> @@ -641,7 +641,7 @@ void native_machine_shutdown(void)
>>  	/* O.K Now that I'm on the appropriate processor,
>>  	 * stop all of the others.
>>  	 */
>> -	smp_send_stop();
>> +	smp_send_stop(wait);
>>  #endif
>>  
>>  	lapic_shutdown();
>> @@ -670,14 +670,14 @@ static void native_machine_restart(char 
>>  	printk("machine restart\n");
>>  
>>  	if (!reboot_force)
>> -		machine_shutdown();
>> +		machine_shutdown(0);
>>  	__machine_emergency_restart(0);
>>  }
>>  
>>  static void native_machine_halt(void)
>>  {
>>  	/* stop other cpus and apics */
>> -	machine_shutdown();
>> +	machine_shutdown(0);
>>  
>>  	tboot_shutdown(TB_SHUTDOWN_HALT);
>>  
>> @@ -689,7 +689,7 @@ static void native_machine_power_off(voi
>>  {
>>  	if (pm_power_off) {
>>  		if (!reboot_force)
>> -			machine_shutdown();
>> +			machine_shutdown(0);
>>  		pm_power_off();
>>  	}
>>  	/* a fallback in case there is no PM info available */
>> @@ -712,9 +712,9 @@ void machine_power_off(void)
>>  	machine_ops.power_off();
>>  }
>>  
>> -void machine_shutdown(void)
>> +void machine_shutdown(int wait)
>>  {
>> -	machine_ops.shutdown();
>> +	machine_ops.shutdown(wait);
>>  }
>>  
>>  void machine_emergency_restart(void)
>> Index: linux-2.6/arch/x86/kernel/smp.c
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/kernel/smp.c	2010-10-07 16:30:34.000000000 -0700
>> +++ linux-2.6/arch/x86/kernel/smp.c	2010-10-07 16:34:16.000000000 -0700
>> @@ -159,10 +159,10 @@ asmlinkage void smp_reboot_interrupt(voi
>>  	irq_exit();
>>  }
>>  
>> -static void native_smp_send_stop(void)
>> +static void native_smp_send_stop(int wait)
>>  {
>>  	unsigned long flags;
>> -	unsigned long wait;
>> +	unsigned long timeout;
>>  
>>  	if (reboot_force)
>>  		return;
>> @@ -179,9 +179,9 @@ static void native_smp_send_stop(void)
>>  	if (num_online_cpus() > 1) {
>>  		apic->send_IPI_allbutself(REBOOT_VECTOR);
>>  
>> -		/* Don't wait longer than a second */
>> -		wait = USEC_PER_SEC;
>> -		while (num_online_cpus() > 1 && wait--)
>> +		/* Don't wait longer than a second if this not a synchronous call */
>> +		timeout = USEC_PER_SEC;
>> +		while (num_online_cpus() > 1 && (wait || timeout--))
>>  			udelay(1);
>>  	}
>>  
>> Index: linux-2.6/arch/x86/xen/enlighten.c
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/xen/enlighten.c	2010-08-30 16:20:50.000000000 -0700
>> +++ linux-2.6/arch/x86/xen/enlighten.c	2010-10-07 16:49:00.000000000 -0700
>> @@ -1018,7 +1018,7 @@ static void xen_reboot(int reason)
>>  	struct sched_shutdown r = { .reason = reason };
>>  
>>  #ifdef CONFIG_SMP
>> -	smp_send_stop();
>> +	smp_send_stop(0);
>>  #endif
>>  
>>  	if (HYPERVISOR_sched_op(SCHEDOP_shutdown, &r))
>> Index: linux-2.6/arch/x86/xen/smp.c
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/xen/smp.c	2010-08-30 16:20:50.000000000 -0700
>> +++ linux-2.6/arch/x86/xen/smp.c	2010-10-07 16:46:27.000000000 -0700
>> @@ -400,7 +400,7 @@ static void stop_self(void *v)
>>  	BUG();
>>  }
>>  
>> -static void xen_smp_send_stop(void)
>> +static void xen_smp_send_stop(int wait)
>>  {
>>  	smp_call_function(stop_self, NULL, 0);
>>  }
>> Index: linux-2.6/drivers/s390/char/sclp_quiesce.c
>> ===================================================================
>> --- linux-2.6.orig/drivers/s390/char/sclp_quiesce.c	2010-08-03 12:45:04.000000000 -0700
>> +++ linux-2.6/drivers/s390/char/sclp_quiesce.c	2010-10-07 16:49:12.000000000 -0700
>> @@ -29,7 +29,7 @@ static void do_machine_quiesce(void)
>>  {
>>  	psw_t quiesce_psw;
>>  
>> -	smp_send_stop();
>> +	smp_send_stop(0);
>>  	quiesce_psw.mask = PSW_BASE_BITS | PSW_MASK_WAIT;
>>  	quiesce_psw.addr = 0xfff;
>>  	__load_psw(quiesce_psw);
>> Index: linux-2.6/include/linux/reboot.h
>> ===================================================================
>> --- linux-2.6.orig/include/linux/reboot.h	2010-08-03 12:46:08.000000000 -0700
>> +++ linux-2.6/include/linux/reboot.h	2010-10-07 16:44:21.000000000 -0700
>> @@ -51,7 +51,7 @@ extern void machine_restart(char *cmd);
>>  extern void machine_halt(void);
>>  extern void machine_power_off(void);
>>  
>> -extern void machine_shutdown(void);
>> +extern void machine_shutdown(int wait);
>>  struct pt_regs;
>>  extern void machine_crash_shutdown(struct pt_regs *);
>>  
>> Index: linux-2.6/include/linux/smp.h
>> ===================================================================
>> --- linux-2.6.orig/include/linux/smp.h	2010-08-03 12:46:08.000000000 -0700
>> +++ linux-2.6/include/linux/smp.h	2010-10-07 16:49:41.000000000 -0700
>> @@ -43,7 +43,7 @@ int smp_call_function_single(int cpuid, 
>>  /*
>>   * stops all CPUs but the current one:
>>   */
>> -extern void smp_send_stop(void);
>> +extern void smp_send_stop(int wait);
>>  
>>  /*
>>   * sends a 'reschedule' event to another CPU:
>> @@ -116,7 +116,7 @@ extern unsigned int setup_max_cpus;
>>  
>>  #else /* !SMP */
>>  
>> -static inline void smp_send_stop(void) { }
>> +static inline void smp_send_stop(int wait) { }
>>  
>>  /*
>>   *	These macros fold the SMP functionality into a single CPU system
>> Index: linux-2.6/kernel/kexec.c
>> ===================================================================
>> --- linux-2.6.orig/kernel/kexec.c	2010-10-07 14:33:57.000000000 -0700
>> +++ linux-2.6/kernel/kexec.c	2010-10-07 16:45:38.000000000 -0700
>> @@ -1538,7 +1538,7 @@ int kernel_kexec(void)
>>  	{
>>  		kernel_restart_prepare(NULL);
>>  		printk(KERN_EMERG "Starting new kernel\n");
>> -		machine_shutdown();
>> +		machine_shutdown(1);
>>  	}
>>  
>>  	machine_kexec(kexec_image);
>> Index: linux-2.6/kernel/panic.c
>> ===================================================================
>> --- linux-2.6.orig/kernel/panic.c	2010-08-30 16:22:03.000000000 -0700
>> +++ linux-2.6/kernel/panic.c	2010-10-07 16:50:05.000000000 -0700
>> @@ -94,7 +94,7 @@ NORET_TYPE void panic(const char * fmt, 
>>  	 * unfortunately means it may not be hardened to work in a panic
>>  	 * situation.
>>  	 */
>> -	smp_send_stop();
>> +	smp_send_stop(0);
>>  
>>  	atomic_notifier_call_chain(&panic_notifier_list, 0, buf);
>>  
>> 
