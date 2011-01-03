Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387Ab1ACRGf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 12:06:35 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:49509
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751198Ab1ACRGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 12:06:33 -0500
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2cK1432N98dNzz1202hzz8275bhz32i637h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LEGI6H-01-MSO-02
X-M-MSG: 
Date: Mon, 3 Jan 2011 18:06:17 +0100
From: Robert Richter <robert.richter@amd.com>
To: "graalfs@linux.vnet.ibm.com" <graalfs@linux.vnet.ibm.com>
CC: "mingo@elte.hu" <mingo@elte.hu>,
        "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "borntraeger@de.ibm.com" <borntraeger@de.ibm.com>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>,
        Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>,
        Maran Pakkirisamy <maranp@linux.vnet.ibm.com>
Subject: Re: [patch 1/4] This patch adds support for hardware based
 sampling on System z processors (models z10 and up)
Message-ID: <20110103170617.GR4739@erda.amd.com>
References: <20101220130541.446049933@linux.vnet.ibm.com>
 <20101220130629.517553112@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20101220130629.517553112@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.12.10 08:05:42, graalfs@linux.vnet.ibm.com wrote:
> From: graalfs@linux.vnet.ibm.com

This should include the real name like in your Signed-off-by tag.

You can fix this by reconfiguring git and recommitting your patches
(git rebase -i ..., git commit --amend --reset-author).

> 
> The CPU Measurement Facility CPUMF is described in the z/Architecture Principles of Operation.
> 
> The patch introduces
>  - a new configuration option OPROFILE_HWSAMPLING_MODE
>  - a new kernel module hwsampler that controls all hardware sampling related operations as
>   - checking if hardware sampling feature is available
>     - ie: on System z models z10 and up, in LPAR mode only, and authorised during LPAR activation
>   - allocating memory for the hardware sampling feature
>   - starting/stopping hardware sampling
> The hwsampler module will also depend on CONFIG_OPROFILE and CONFIG_64BIT.
> 
> All functions required to start and stop hardware sampling have to be
> invoked by the oprofile kernel module as provided by the other patches of this patch set.
> 
> In case hardware based sampling cannot be setup standard timer based sampling is used by OProfile.
> 
> Signed-off-by: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
> Signed-off-by: Maran Pakkirisamy <maranp@linux.vnet.ibm.com>
> Signed-off-by: Heinz Graalfs <graalfs@linux.vnet.ibm.com>
> ---
>  arch/s390/Kconfig                       |   22
>  arch/s390/include/asm/hwsampler.h       |  130 +++
>  arch/s390/oprofile/Makefile             |    6
>  drivers/s390/hwsampler/hwsampler-main.c | 1155 ++++++++++++++++++++++++++++++++
>  drivers/s390/hwsampler/smpctl.c         |  170 ++++

Is there a reason for splitting the code into two files? If we would
merge hwsampler-main.c and smpctl.c we could make a lot functions
static which simplifies the interface. We could also drop the
hwsampler/ directory and put all in drivers/s390/hwsampler.c.

Another thing is, wouldn't all of this better be part of cpu
initialization code? This is not really a driver, it only registers a
cpu notifier. Do you need to build this as module?  I leave this
decision to the s390 maintainers.

>  5 files changed, 1483 insertions(+)
> 
> Index: linux-2.6/arch/s390/include/asm/hwsampler.h
> ===================================================================
> --- /dev/null
> +++ linux-2.6/arch/s390/include/asm/hwsampler.h

This file should only contain definitions for the public interface.
All structs should be private, defined in something like

 drivers/s390/hwsampler.h

or so. All of them are only used in hwsampler-main.c or smpctl.c.

To avoid namespace collisions, add a prefix like hws_ to all symbols.

> @@ -0,0 +1,130 @@
> +/*
> + * CPUMF HW sampler structures and prototypes
> + *
> + *    Copyright IBM Corp. 2010
> + *    Author(s): Heinz Graalfs <graalfs@de.ibm.com>
> + */
> +
> +#ifndef HWSAMPLER_H_
> +#define HWSAMPLER_H_
> +
> +#include <linux/workqueue.h>
> +
> +struct qsi_info_block          /* QUERY SAMPLING information block  */
> +{ /* Bit(s) */
> +       unsigned int b0_13:14;      /* 0-13: zeros                       */
> +       unsigned int as:1;          /* 14: sampling authorisation control*/
> +       unsigned int b15_21:7;      /* 15-21: zeros                      */
> +       unsigned int es:1;          /* 22: sampling enable control       */
> +       unsigned int b23_29:7;      /* 23-29: zeros                      */
> +       unsigned int cs:1;          /* 30: sampling activation control   */
> +       unsigned int:1;             /* 31: reserved                      */
> +       unsigned int bsdes:16;      /* 4-5: size of sampling entry       */
> +       unsigned int:16;            /* 6-7: reserved                     */
> +       unsigned long min_sampl_rate; /* 8-15: minimum sampling interval */
> +       unsigned long max_sampl_rate; /* 16-23: maximum sampling interval*/
> +       unsigned long tear;         /* 24-31: TEAR contents              */
> +       unsigned long dear;         /* 32-39: DEAR contents              */
> +       unsigned int rsvrd0;        /* 40-43: reserved                   */
> +       unsigned int cpu_speed;     /* 44-47: CPU speed                  */
> +       unsigned long long rsvrd1;  /* 48-55: reserved                   */
> +       unsigned long long rsvrd2;  /* 56-63: reserved                   */
> +};
> +
> +struct ssctl_request_block     /* SET SAMPLING CONTROLS req block   */
> +{ /* bytes 0 - 7  Bit(s) */
> +       unsigned int s:1;           /* 0: maximum buffer indicator       */
> +       unsigned int h:1;           /* 1: part. level reserved for VM use*/
> +       unsigned long b2_53:52;     /* 2-53: zeros                       */
> +       unsigned int es:1;          /* 54: sampling enable control       */
> +       unsigned int b55_61:7;      /* 55-61: - zeros                    */
> +       unsigned int cs:1;          /* 62: sampling activation control   */
> +       unsigned int b63:1;         /* 63: zero                          */
> +       unsigned long interval;     /* 8-15: sampling interval           */
> +       unsigned long tear;         /* 16-23: TEAR contents              */
> +       unsigned long dear;         /* 24-31: DEAR contents              */
> +       /* 32-63:                                                        */
> +       unsigned long rsvrd1;       /* reserved                          */
> +       unsigned long rsvrd2;       /* reserved                          */
> +       unsigned long rsvrd3;       /* reserved                          */
> +       unsigned long rsvrd4;       /* reserved                          */
> +};
> +
> +typedef void oprf_add_sample_func(unsigned long pc,
> +       struct pt_regs * const regs,
> +       unsigned long event, int is_kernel,
> +       struct task_struct *task);

Don't use typedefs.

> +
> +struct cpu_buffer {
> +       unsigned long first_sdbt;       /* @ of 1st SDB-Table for this CP*/
> +       unsigned long worker_entry;
> +       unsigned long sample_overflow;  /* taken from SDB ...            */
> +       struct qsi_info_block qsi;
> +       struct ssctl_request_block ssctl;
> +       struct work_struct worker;
> +       oprf_add_sample_func *add_sample_f;
> +       atomic_t ext_params;
> +       unsigned long req_alert;
> +       unsigned long loss_of_sample_data;
> +       unsigned long invalid_entry_address;
> +       unsigned long incorrect_sdbt_entry;
> +       unsigned long sample_auth_change_alert;
> +       unsigned int finish:1;
> +       unsigned int oom:1;
> +       unsigned int stop_mode:1;
> +};
> +
> +struct data_entry {
> +       unsigned int def:16;        /* 0-15  Data Entry Format           */
> +       unsigned int R:4;           /* 16-19 reserved                    */
> +       unsigned int U:4;           /* 20-23 Number of unique instruct.  */
> +       unsigned int z:2;           /* zeros                             */
> +       unsigned int T:1;           /* 26 PSW DAT mode                   */
> +       unsigned int W:1;           /* 27 PSW wait state                 */
> +       unsigned int P:1;           /* 28 PSW Problem state              */
> +       unsigned int AS:2;          /* 29-30 PSW address-space control   */
> +       unsigned int I:1;           /* 31 entry valid or invalid         */
> +       unsigned int:16;
> +       unsigned int prim_asn:16;   /* primary ASN                       */
> +       unsigned long long ia;      /* Instruction Address               */
> +       unsigned long long lpp;     /* Logical-Partition Program Param.  */
> +       unsigned long long vpp;     /* Virtual-Machine Program Param.    */
> +};
> +
> +struct trailer_entry {
> +       unsigned int f:1;           /* 0 - Block Full Indicator          */
> +       unsigned int a:1;           /* 1 - Alert request control         */
> +       unsigned long:62;           /* 2 - 63: Reserved                  */
> +       unsigned long overflow;     /* 64 - sample Overflow count        */
> +       unsigned long timestamp;    /* 16 - time-stamp                   */
> +       unsigned long timestamp1;   /*                                   */
> +       unsigned long reserved1;    /* 32 -Reserved                      */
> +       unsigned long reserved2;    /*                                   */
> +       unsigned long progusage1;   /* 48 - reserved for programming use */
> +       unsigned long progusage2;   /*                                   */
> +};
> +
> +int hwsampler_setup(void);
> +int hwsampler_shutdown(void);
> +int hwsampler_allocate(unsigned long sdbt, unsigned long sdb);
> +int hwsampler_deallocate(void);
> +long hwsampler_query_min_interval(void);
> +long hwsampler_query_max_interval(void);
> +int hwsampler_start_all(unsigned long interval);
> +int hwsampler_stop_all(void);
> +int hwsampler_deactivate(unsigned int cpu);
> +int hwsampler_activate(unsigned int cpu);
> +unsigned long hwsampler_get_sample_overflow_count(unsigned int cpu);
> +

All the following functions should have a prefix (e.g. hws_):

> +int smp_ctl_qsi(int);
> +int smp_ctl_ssctl_deactivate(int);
> +int smp_ctl_ssctl_stop(int);
> +int smp_ctl_ssctl_enable_activate(int, unsigned long);
> +
> +int qsi(void *);
> +
> +void execute_qsi(void *);
> +void execute_ssctl(void *);

Many functions above are for internal use only, these should be
removed from this interface and made static.

> +
> +#endif /*HWSAMPLER_H_*/
> +
> Index: linux-2.6/drivers/s390/hwsampler/hwsampler-main.c
> ===================================================================
> --- /dev/null
> +++ linux-2.6/drivers/s390/hwsampler/hwsampler-main.c

> +static int __cpuinit hws_cpu_callback(struct notifier_block *nfb,
> +       unsigned long action, void *hcpu)
> +{
> +       /* We do not have sampler space available for all possible CPUs.
> +          All CPUs should be online when hw sampling is activated. */
> +       return NOTIFY_BAD;

Is this to prevent bringing cpus on-/offline?

> +}

[...]

> +static int __init hwsampler_init(void)
> +{
> +       hws_state = HWS_INIT;
> +       register_cpu_notifier(&hws_cpu_notifier);
> +       return 0;
> +}
> +
> +static void __exit hwsampler_exit(void)
> +{
> +       unregister_cpu_notifier(&hws_cpu_notifier);
> +}
> +
> +module_init(hwsampler_init);
> +module_exit(hwsampler_exit);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Heinz Graalfs <graalfs@de.ibm.com>");
> +MODULE_DESCRIPTION("IBM CPUMF Customer Mode Sampling Kernel Module");

[...]

> Index: linux-2.6/arch/s390/Kconfig
> ===================================================================
> --- linux-2.6.orig/arch/s390/Kconfig
> +++ linux-2.6/arch/s390/Kconfig
> @@ -127,6 +127,7 @@ config S390
>         select ARCH_INLINE_WRITE_UNLOCK_BH
>         select ARCH_INLINE_WRITE_UNLOCK_IRQ
>         select ARCH_INLINE_WRITE_UNLOCK_IRQRESTORE
> +       select HAVE_HWSAMPLER
> 
>  config SCHED_OMIT_FRAME_POINTER
>         bool
> @@ -618,6 +619,27 @@ config SECCOMP
> 
>           If unsure, say Y.
> 
> +config HWSAMPLER
> +       tristate "Exploit CPUMF hardware sampling with OProfile"
> +       depends on OPROFILE
> +       depends on HAVE_HWSAMPLER
> +       depends on 64BIT
> +       select OPROFILE_HWSAMPLING_MODE
> +       help
> +         Hardware (HW) sampling is a feature provided by z processor.
> +         The sampling process is implemented in hardware and millicode
> +         and thus does not affect the operating system being observed,
> +         apart from the required buffer memory that Linux kernel must
> +         provide.
> +
> +         If unsure, say N.
> +
> +config HAVE_HWSAMPLER
> +       bool
> +
> +config OPROFILE_HWSAMPLING_MODE
> +       bool
> +
>  endmenu
> 
>  menu "Power Management"
> Index: linux-2.6/arch/s390/oprofile/Makefile
> ===================================================================
> --- linux-2.6.orig/arch/s390/oprofile/Makefile
> +++ linux-2.6/arch/s390/oprofile/Makefile
> @@ -1,3 +1,4 @@
> +obj-$(CONFIG_HWSAMPLER)        += hwsampler.o
>  obj-$(CONFIG_OPROFILE) += oprofile.o
> 
>  DRIVER_OBJS = $(addprefix ../../../drivers/oprofile/, \
> @@ -7,3 +8,8 @@ DRIVER_OBJS = $(addprefix ../../../drive
>                 timer_int.o )
> 
>  oprofile-y                             := $(DRIVER_OBJS) init.o backtrace.o
> +
> +HW_SAMPLER_DRIVER_OBJS = $(addprefix ../../../drivers/s390/hwsampler/, \
> +               hwsampler-main.o smpctl.o )
> +
> +hwsampler-y                            := $(HW_SAMPLER_DRIVER_OBJS)

Have you tried building this as a module. Not really sure, but I think it should be

 hwsampler-$(CONFIG_HWSAMPLER) := ...

See also my statement above about putting this to cpu init code
instead of having a driver for it.

-Robert

> 
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

