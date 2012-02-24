Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757536Ab2BXPqb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 10:46:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25320 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755577Ab2BXPqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 10:46:30 -0500
Date: Fri, 24 Feb 2012 10:46:13 -0500
From: Don Zickus <dzickus@redhat.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: properly _init-annotate NMI selftest code
Message-ID: <20120224154613.GF26998@redhat.com>
References: <4F478C010200007800074A3D@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F478C010200007800074A3D@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 24, 2012 at 12:09:21PM +0000, Jan Beulich wrote:
> After all, this code is being run once at boot only (if configured in
> at all).
> 
> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> Cc: Don Zickus <dzickus@redhat.com>

Heh. Yes, nice catch.

Ingo, I can respin this with my sign-off or just give my ACK.

Cheers,
Don

> 
> ---
>  arch/x86/kernel/nmi_selftest.c |   37 +++++++++++++++++++------------------
>  1 file changed, 19 insertions(+), 18 deletions(-)
> 
> --- 3.3-rc4/arch/x86/kernel/nmi_selftest.c
> +++ 3.3-rc4-x86-nmi-selftest-init/arch/x86/kernel/nmi_selftest.c
> @@ -12,6 +12,7 @@
>  #include <linux/smp.h>
>  #include <linux/cpumask.h>
>  #include <linux/delay.h>
> +#include <linux/init.h>
>  
>  #include <asm/apic.h>
>  #include <asm/nmi.h>
> @@ -20,35 +21,35 @@
>  #define FAILURE		1
>  #define TIMEOUT		2
>  
> -static int nmi_fail;
> +static int __initdata nmi_fail;
>  
>  /* check to see if NMI IPIs work on this machine */
> -static DECLARE_BITMAP(nmi_ipi_mask, NR_CPUS) __read_mostly;
> +static DECLARE_BITMAP(nmi_ipi_mask, NR_CPUS) __initdata;
>  
> -static int testcase_total;
> -static int testcase_successes;
> -static int expected_testcase_failures;
> -static int unexpected_testcase_failures;
> -static int unexpected_testcase_unknowns;
> +static int __initdata testcase_total;
> +static int __initdata testcase_successes;
> +static int __initdata expected_testcase_failures;
> +static int __initdata unexpected_testcase_failures;
> +static int __initdata unexpected_testcase_unknowns;
>  
> -static int nmi_unk_cb(unsigned int val, struct pt_regs *regs)
> +static int __init nmi_unk_cb(unsigned int val, struct pt_regs *regs)
>  {
>  	unexpected_testcase_unknowns++;
>  	return NMI_HANDLED;
>  }
>  
> -static void init_nmi_testsuite(void)
> +static void __init init_nmi_testsuite(void)
>  {
>  	/* trap all the unknown NMIs we may generate */
>  	register_nmi_handler(NMI_UNKNOWN, nmi_unk_cb, 0, "nmi_selftest_unk");
>  }
>  
> -static void cleanup_nmi_testsuite(void)
> +static void __init cleanup_nmi_testsuite(void)
>  {
>  	unregister_nmi_handler(NMI_UNKNOWN, "nmi_selftest_unk");
>  }
>  
> -static int test_nmi_ipi_callback(unsigned int val, struct pt_regs *regs)
> +static int __init test_nmi_ipi_callback(unsigned int val, struct pt_regs *regs)
>  {
>          int cpu = raw_smp_processor_id();
>  
> @@ -58,7 +59,7 @@ static int test_nmi_ipi_callback(unsigne
>          return NMI_DONE;
>  }
>  
> -static void test_nmi_ipi(struct cpumask *mask)
> +static void __init test_nmi_ipi(struct cpumask *mask)
>  {
>  	unsigned long timeout;
>  
> @@ -86,7 +87,7 @@ static void test_nmi_ipi(struct cpumask 
>  	return;
>  }
>  
> -static void remote_ipi(void)
> +static void __init remote_ipi(void)
>  {
>  	cpumask_copy(to_cpumask(nmi_ipi_mask), cpu_online_mask);
>  	cpumask_clear_cpu(smp_processor_id(), to_cpumask(nmi_ipi_mask));
> @@ -94,19 +95,19 @@ static void remote_ipi(void)
>  		test_nmi_ipi(to_cpumask(nmi_ipi_mask));
>  }
>  
> -static void local_ipi(void)
> +static void __init local_ipi(void)
>  {
>  	cpumask_clear(to_cpumask(nmi_ipi_mask));
>  	cpumask_set_cpu(smp_processor_id(), to_cpumask(nmi_ipi_mask));
>  	test_nmi_ipi(to_cpumask(nmi_ipi_mask));
>  }
>  
> -static void reset_nmi(void)
> +static void __init reset_nmi(void)
>  {
>  	nmi_fail = 0;
>  }
>  
> -static void dotest(void (*testcase_fn)(void), int expected)
> +static void __init dotest(void (*testcase_fn)(void), int expected)
>  {
>  	testcase_fn();
>  	/*
> @@ -131,12 +132,12 @@ static void dotest(void (*testcase_fn)(v
>  	reset_nmi();
>  }
>  
> -static inline void print_testname(const char *testname)
> +static inline void __init print_testname(const char *testname)
>  {
>  	printk("%12s:", testname);
>  }
>  
> -void nmi_selftest(void)
> +void __init nmi_selftest(void)
>  {
>  	init_nmi_testsuite();
>  
> 
> 
> 
