Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127Ab1ACTCS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 14:02:18 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:52823 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427Ab1ACTCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 14:02:16 -0500
X-SpamScore: -14
X-BigFish: VPS-14(zzbb2cK1432N98dNzz1202hzz8275bhz32i637h668h)
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 13,
X-WSS-ID: 0LEGNJE-02-C08-02
X-M-MSG: 
Date: Mon, 3 Jan 2011 20:02:03 +0100
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
Subject: Re: [patch 2/4] This patch enhances OProfile to support System zs
 hardware sampling feature
Message-ID: <20110103190203.GS4739@erda.amd.com>
References: <20101220130541.446049933@linux.vnet.ibm.com>
 <20101220130629.671800849@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20101220130629.671800849@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.12.10 08:05:43, graalfs@linux.vnet.ibm.com wrote:
> From: graalfs@linux.vnet.ibm.com
> 
> OProfile is enhanced to export all files for controlling System z's hardware sampling,
> and to invoke hwsampler exported functions to initialize and use System z's hardware sampling.
> 
> The patch invokes hwsampler_setup() during oprofile init and exports following
> hwsampler files under oprofilefs if hwsampler's setup succeeded:
> 
> A new directory for hardware sampling based files
> 
>  /dev/oprofile/hwsampling/
> 
> The userland daemon must explicitly write to the following files
> to disable (or enable) hardware based sampling
> 
>  /dev/oprofile/hwsampling/hwsampler
> 
> to modify the actual sampling rate
> 
>  /dev/oprofile/hwsampling/hw_interval
> 
> to modify the amount of sampling memory (measured in 4K pages)
> 
>  /dev/oprofile/hwsampling/hw_sdbt_blocks
> 
> The following files are read only and show
> the possible minimum sampling rate
> 
>  /dev/oprofile/hwsampling/hw_min_interval
> 
> the possible maximum sampling rate
> 
>  /dev/oprofile/hwsampling/hw_max_interval
> 
> The patch splits the oprofile_timer_[init/exit] function so that it can be also called
> through user context (oprofilefs) to avoid kernel oops.
> 
> Signed-off-by: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
> Signed-off-by: Maran Pakkirisamy <maranp@linux.vnet.ibm.com>
> Signed-off-by: Heinz Graalfs <graalfs@linux.vnet.ibm.com>
> ---
>  arch/s390/oprofile/Makefile          |    1
>  arch/s390/oprofile/hwsampler_files.c |  120 +++++++++++++++++++++++++++++++++++

I would rather see a file hwsampler.c here that contains all oprofile
hwsampler code in it and also sets up a struct oprofile_operations*
ops.

Doing so, most of global functions and variables below can be made
static.

>  arch/s390/oprofile/init.c            |   35 ++++++++++

We should find a better solution than changing all those files only
for a single architecture:

>  drivers/oprofile/oprof.c             |   37 ++++++++++
>  drivers/oprofile/oprof.h             |    2
>  drivers/oprofile/timer_int.c         |   16 +++-
>  include/linux/oprofile.h             |   15 ++++

I want to see most of this in arch/s390.

>  7 files changed, 223 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6/arch/s390/oprofile/Makefile
> ===================================================================
> --- linux-2.6.orig/arch/s390/oprofile/Makefile
> +++ linux-2.6/arch/s390/oprofile/Makefile
> @@ -8,6 +8,7 @@ DRIVER_OBJS = $(addprefix ../../../drive
>                 timer_int.o )
> 
>  oprofile-y                             := $(DRIVER_OBJS) init.o backtrace.o
> +oprofile-y                             += $(if $(CONFIG_HWSAMPLER), hwsampler_files.o,)
> 
>  HW_SAMPLER_DRIVER_OBJS = $(addprefix ../../../drivers/s390/hwsampler/, \
>                 hwsampler-main.o smpctl.o )
> Index: linux-2.6/arch/s390/oprofile/hwsampler_files.c
> ===================================================================
> --- /dev/null
> +++ linux-2.6/arch/s390/oprofile/hwsampler_files.c
> @@ -0,0 +1,120 @@
> +/**
> + * arch/s390/oprofile/hwsampler_files.c
> + *
> + * Copyright IBM Corp. 2010
> + * Author: Mahesh Salgaonkar (mahesh@linux.vnet.ibm.com)
> + */
> +#include <linux/oprofile.h>
> +#include <linux/errno.h>
> +#include <linux/fs.h>
> +
> +#include <asm/hwsampler.h>
> +
> +#define DEFAULT_INTERVAL       4096
> +
> +#define DEFAULT_SDBT_BLOCKS    1
> +#define DEFAULT_SDB_BLOCKS     511
> +
> +static unsigned long oprofile_hw_interval = DEFAULT_INTERVAL;
> +unsigned long oprofile_min_interval;
> +unsigned long oprofile_max_interval;

This could be static.

> +
> +static unsigned long oprofile_sdbt_blocks = DEFAULT_SDBT_BLOCKS;
> +static unsigned long oprofile_sdb_blocks = DEFAULT_SDB_BLOCKS;
> +
> +static unsigned long oprofile_hwsampler;
> +
> +static int oprofile_hwsampler_start(void)
> +{
> +       int retval;
> +
> +       printk(KERN_INFO "oprofile_hwsampler_start\n");

This looks like a debug msg.

> +
> +       retval = hwsampler_allocate(oprofile_sdbt_blocks, oprofile_sdb_blocks);
> +       if (retval)
> +               return retval;
> +
> +       retval = hwsampler_start_all(oprofile_hw_interval);
> +
> +       return retval;
> +}
> +
> +static void oprofile_hwsampler_stop(void)
> +{
> +       printk(KERN_INFO "oprofile_hwsampler_stop\n");

Same here.

> +
> +       hwsampler_stop_all();
> +       hwsampler_deallocate();
> +       return;
> +}
> +
> +int oprofile_arch_set_hwsampler(struct oprofile_operations *ops)
> +{
> +       printk(KERN_INFO "oprofile: using hardware sampling\n");
> +       ops->start = oprofile_hwsampler_start;
> +       ops->stop = oprofile_hwsampler_stop;
> +       ops->cpu_type = "timer";

Wouldn't it be better to have a different cpu_type string here, I
don't think the oprofilefs interface is exactly the same as for timer
mode. How the daemon distinguishs between both modes?

> +
> +       return 0;
> +}
> +
> +static ssize_t hwsampler_read(struct file *file, char __user *buf,
> +               size_t count, loff_t *offset)
> +{
> +       return oprofilefs_ulong_to_user(oprofile_hwsampler, buf, count, offset);
> +}
> +
> +static ssize_t hwsampler_write(struct file *file, char const __user *buf,
> +               size_t count, loff_t *offset)
> +{
> +       unsigned long val;
> +       int retval;
> +
> +       if (*offset)
> +               return -EINVAL;
> +
> +       retval = oprofilefs_ulong_from_user(&val, buf, count);
> +       if (retval)
> +               return retval;
> +
> +       if (oprofile_hwsampler == val)
> +               return -EINVAL;
> +
> +       retval = oprofile_set_hwsampler(val);
> +
> +       if (retval)
> +               return retval;
> +
> +       oprofile_hwsampler = val;
> +       return count;
> +}
> +
> +static const struct file_operations hwsampler_fops = {
> +       .read           = hwsampler_read,
> +       .write          = hwsampler_write,
> +};
> +
> +int oprofile_create_hwsampling_files(struct super_block *sb,
> +                                               struct dentry *root)

This can be made static too.

> +{
> +       struct dentry *hw_dir;
> +
> +       /* reinitialize default values */
> +       oprofile_hwsampler = 1;
> +
> +       hw_dir = oprofilefs_mkdir(sb, root, "hwsampling");
> +       if (!hw_dir)
> +               return -EINVAL;
> +
> +       oprofilefs_create_file(sb, hw_dir, "hwsampler", &hwsampler_fops);
> +       oprofilefs_create_ulong(sb, hw_dir, "hw_interval",
> +                               &oprofile_hw_interval);
> +       oprofilefs_create_ro_ulong(sb, hw_dir, "hw_min_interval",
> +                               &oprofile_min_interval);
> +       oprofilefs_create_ro_ulong(sb, hw_dir, "hw_max_interval",
> +                               &oprofile_max_interval);
> +       oprofilefs_create_ulong(sb, hw_dir, "hw_sdbt_blocks",
> +                               &oprofile_sdbt_blocks);
> +
> +       return 0;
> +}
> Index: linux-2.6/drivers/oprofile/oprof.c
> ===================================================================
> --- linux-2.6.orig/drivers/oprofile/oprof.c
> +++ linux-2.6/drivers/oprofile/oprof.c
> @@ -239,10 +239,43 @@ int oprofile_set_ulong(unsigned long *ad
>         return err;
>  }
> 
> +#ifdef CONFIG_OPROFILE_HWSAMPLING_MODE
> +int oprofile_set_hwsampler(unsigned long val)
> +{
> +       int err = 0;
> +
> +       mutex_lock(&start_mutex);
> +
> +       if (oprofile_started) {
> +               err = -EBUSY;
> +               goto out;
> +       }
> +
> +       switch (val) {
> +       case 1:
> +               /* Switch to hardware sampling. */
> +               __oprofile_timer_exit();
> +               err = oprofile_arch_set_hwsampler(&oprofile_ops);
> +               break;
> +       case 0:
> +               printk(KERN_INFO "oprofile: using timer interrupt.\n");
> +               err = __oprofile_timer_init(&oprofile_ops);
> +               break;

Is there a use case for switching the mode at runtime? There are
kernel parameters to force timer mode while booting or loading the
module. I don't like exporting all these timer and hwsampler
functions. We could avoid this by making hwsampler architectural code
and leaving the timer code as it is.

> +       default:
> +               err = -EINVAL;
> +       }
> +
> +out:
> +       mutex_unlock(&start_mutex);
> +       return err;
> +}
> +#endif /* CONFIG_OPROFILE_HWSAMPLING_MODE */
> +
>  static int __init oprofile_init(void)
>  {
>         int err;
> 
> +       memset(&oprofile_ops, 0, sizeof(oprofile_ops));

The struct is already initialized to 0.

>         err = oprofile_arch_init(&oprofile_ops);
>         if (err < 0 || timer) {
>                 printk(KERN_INFO "oprofile: using timer interrupt.\n");
> @@ -250,6 +283,10 @@ static int __init oprofile_init(void)
>                 if (err)
>                         return err;
>         }
> +#ifdef CONFIG_OPROFILE_HWSAMPLING_MODE
> +       else if (err == 0)
> +               oprofile_arch_set_hwsampler(&oprofile_ops);

I would like to see this in oprofile_arch_init().

> +#endif
>         return oprofilefs_register();
>  }
> 
> Index: linux-2.6/drivers/oprofile/oprof.h
> ===================================================================
> --- linux-2.6.orig/drivers/oprofile/oprof.h
> +++ linux-2.6/drivers/oprofile/oprof.h
> @@ -35,7 +35,9 @@ struct dentry;
> 
>  void oprofile_create_files(struct super_block *sb, struct dentry *root);
>  int oprofile_timer_init(struct oprofile_operations *ops);
> +int __oprofile_timer_init(struct oprofile_operations *ops);
>  void oprofile_timer_exit(void);
> +void __oprofile_timer_exit(void);

See my comments above, I don't want to export this.

> 
>  int oprofile_set_ulong(unsigned long *addr, unsigned long val);
>  int oprofile_set_timeout(unsigned long time);
> Index: linux-2.6/drivers/oprofile/timer_int.c
> ===================================================================
> --- linux-2.6.orig/drivers/oprofile/timer_int.c
> +++ linux-2.6/drivers/oprofile/timer_int.c
> @@ -97,14 +97,13 @@ static struct notifier_block __refdata o
>         .notifier_call = oprofile_cpu_notify,
>  };
> 
> -int __init oprofile_timer_init(struct oprofile_operations *ops)
> +int  __oprofile_timer_init(struct oprofile_operations *ops)
>  {
>         int rc;
> 
>         rc = register_hotcpu_notifier(&oprofile_cpu_notifier);
>         if (rc)
>                 return rc;
> -       ops->create_files = NULL;
>         ops->setup = NULL;
>         ops->shutdown = NULL;
>         ops->start = oprofile_hrtimer_start;
> @@ -113,7 +112,18 @@ int __init oprofile_timer_init(struct op
>         return 0;
>  }
> 
> -void __exit oprofile_timer_exit(void)
> +int __init oprofile_timer_init(struct oprofile_operations *ops)
> +{
> +       return __oprofile_timer_init(ops);
> +}
> +
> +void __oprofile_timer_exit(void)
>  {
>         unregister_hotcpu_notifier(&oprofile_cpu_notifier);
>  }
> +
> +void __exit oprofile_timer_exit(void)
> +{
> +       __oprofile_timer_exit();
> +}
> +
> Index: linux-2.6/include/linux/oprofile.h
> ===================================================================
> --- linux-2.6.orig/include/linux/oprofile.h
> +++ linux-2.6/include/linux/oprofile.h
> @@ -89,6 +89,21 @@ int oprofile_arch_init(struct oprofile_o
>   */
>  void oprofile_arch_exit(void);
> 
> +#ifdef CONFIG_OPROFILE_HWSAMPLING_MODE
> +/**
> + * setup hardware sampler for oprofiling.
> + */
> +
> +int oprofile_set_hwsampler(unsigned long);
> +
> +/**
> + * hardware sampler module initialization for the s390 arch
> + */
> +
> +int oprofile_arch_set_hwsampler(struct oprofile_operations *ops);

This is not generic code, there is no other architecture that may
reuse this. We should move this to arch/s390.

> +
> +#endif /* CONFIG_OPROFILE_HWSAMPLING_MODE */
> +
>  /**
>   * Add a sample. This may be called from any context.
>   */
> Index: linux-2.6/arch/s390/oprofile/init.c
> ===================================================================
> --- linux-2.6.orig/arch/s390/oprofile/init.c
> +++ linux-2.6/arch/s390/oprofile/init.c
> @@ -11,16 +11,51 @@
>  #include <linux/oprofile.h>
>  #include <linux/init.h>
>  #include <linux/errno.h>
> +#include <linux/fs.h>
> 
> +#ifdef CONFIG_OPROFILE_HWSAMPLING_MODE
> +#include <asm/hwsampler.h>
> +
> +extern int oprofile_create_hwsampling_files(struct super_block *sb,
> +                                                       struct dentry *root);
> +
> +extern unsigned long oprofile_min_interval;
> +extern unsigned long oprofile_max_interval;

This becomes static if we move it to arch/s390/oprofile/hwsampler.c
(see below).

> +#endif /* CONFIG_OPROFILE_HWSAMPLING_MODE */
> 
>  extern void s390_backtrace(struct pt_regs * const regs, unsigned int depth);
> 
>  int __init oprofile_arch_init(struct oprofile_operations* ops)
>  {
>         ops->backtrace = s390_backtrace;
> +
> +#ifdef CONFIG_OPROFILE_HWSAMPLING_MODE
> +       if (hwsampler_setup())
> +               return -ENODEV;
> +
> +       /*
> +        * create hwsampler files only if hwsampler_setup() succeeds.
> +        */
> +       ops->create_files = oprofile_create_hwsampling_files;
> +       oprofile_min_interval = hwsampler_query_min_interval();
> +       if (oprofile_min_interval < 0) {
> +               oprofile_min_interval = 0;
> +               return -ENODEV;
> +       }
> +       oprofile_max_interval = hwsampler_query_max_interval();
> +       if (oprofile_max_interval < 0) {
> +               oprofile_max_interval = 0;
> +               return -ENODEV;
> +       }
> +       return 0;
> +#endif /* CONFIG_OPROFILE_HWSAMPLING_MODE */

Move all the code for CONFIG_OPROFILE_HWSAMPLING_MODE in this file to 

 arch/s390/oprofile/hwsampler.c

and only export an oprofile_hwsampler_init() function. This can be an
empty function stub for the !CONFIG_OPROFILE_HWSAMPLING_MODE case.

> +
>         return -ENODEV;
>  }
> 
>  void oprofile_arch_exit(void)
>  {
> +#ifdef CONFIG_OPROFILE_HWSAMPLING_MODE
> +       hwsampler_shutdown();
> +#endif /* CONFIG_OPROFILE_HWSAMPLING_MODE */

Same here...

-Robert

>  }
> 
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

