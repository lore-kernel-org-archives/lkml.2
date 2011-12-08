Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814Ab1LHJgL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 04:36:11 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:13949 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713Ab1LHJgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 04:36:01 -0500
Date: Thu, 8 Dec 2011 10:35:40 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, kay.sievers@vrfy.org, trenn@suse.de,
        Andi Kleen <ak@linux.intel.com>, davej@redhat.com, axboe@kernel.dk,
        hpa@zytor.com, herbert@gondor.hengli.com.au, ying.huang@intel.com,
        lenb@kernel.org
Subject: Re: [PATCH 01/10] Add driver auto probing for x86 features
Message-ID: <20111208103540.4778b896@endymion.delvare>
In-Reply-To: <1323304882-27953-2-git-send-email-andi@firstfloor.org>
References: <1323304882-27953-1-git-send-email-andi@firstfloor.org>
	<1323304882-27953-2-git-send-email-andi@firstfloor.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On Wed,  7 Dec 2011 16:41:14 -0800, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Old patchkit, resurrect due to popular demand.

Oh yes!

> There's a growing number of drivers that support a specific x86 feature
> or CPU.  Currently loading these drivers currently on a generic
> distribution requires various driver specific hacks and it often
> doesn't work.
> 
> This patch adds auto probing for drivers based on the x86 cpuid
> information, in particular based on vendor/family/model number
> and also based on CPUID feature bits.
> 
> For example a common issue is not loading the SSE 4.2 accelerated
> CRC module: this can significantly lower the performance of BTRFS
> which relies on fast CRC.
> 
> Another issue is loading the right CPUFREQ driver for the current CPU.
> Currently distributions often try all all possible driver until
> one sticks, which is not really a good way to do this.
> 
> It works with existing udev without any changes. The code
> exports the x86 information as a generic string in sysfs
> that can be matched by udev's pattern matching.
> 
> This scheme does not support numeric ranges, so if you want to
> handle e.g. ranges of model numbers they have to be encoded
> in ASCII or simply all models or families listed. Fixing
> that would require changing udev.
> 
> Another issue is that udev will happily load all drivers that match,
> there is currently no nice way to stop a specific driver from
> being loaded if it's not needed (e.g. if you don't need fast CRC)
> But there are not that many cpu specific drivers around and they're
> all not that bloated, so this isn't a particularly serious issue.
> 
> Originally this patch added the modalias to the normal cpu
> sysdevs. However sysdevs don't have all the infrastructure
> needed for udev, so it couldn't really autoload drivers.
> This patch instead adds the CPU modaliases to the cpuid devices,
> which are real devices with full support for udev. This implies
> that the cpuid driver has to be loaded to use this.
> 
> This patch just adds infrastructure, some driver conversions
> in followups.
> 
> Thanks to Kay for helping with some sysfs magic.
> (...)

Partial review:

> diff --git a/arch/x86/kernel/cpu/match.c b/arch/x86/kernel/cpu/match.c
> new file mode 100644
> index 0000000..2c23457
> --- /dev/null
> +++ b/arch/x86/kernel/cpu/match.c
> @@ -0,0 +1,48 @@
> +#include <asm/cpu_device_id.h>
> +#include <asm/processor.h>
> +#include <linux/cpu.h>
> +#include <linux/module.h>
> +
> +/**
> + * x86_match_cpu - match current CPU again an array of x86_cpu_ids

The code is actually matching the boot cpu, which isn't necessarily the
current CPU. I think it would be better to let the caller pass a
specific cpu as a parameter. At least the hwmon drivers would benefit
from that. Then you can add an helper function x86_match_boot_cpu()
calling x86_match_cpu() on &boot_cpu_data if you want.

> + * @match: Pointer to array of x86_cpu_ids. Last entry terminated with
> + *         X86_MODEL_END.

I see no such X86_MODEL_END, your loop below is instead treating entries
with all fields set to 0 as the terminating entry (which seems
reasonable.)

> + *
> + * Return the entry if the current CPU matches the entries in the
> + * passed x86_cpu_id match table. Otherwise NULL.  The match table
> + * contains vendor (X86_VENDOR_*), family, model and feature bits or
> + * respective wildcard entries.
> + *
> + * A typical table entry would be to match a specific CPU
> + * { X86_VENDOR_INTEL, 6, 0x12 }
> + * or to match a specific CPU feature
> + * { X86_FEATURE_MATCH(X86_FEATURE_FOOBAR) }
> + *
> + * Felds can be wildcarded with %X86_VENDOR_ANY, %X86_FAMILY_ANY,

Spelling: Fields.

> + * %X86_MODEL_ANY, %X86_FEATURE_ANY.
> + *
> + * Arrays used to match for this should also be declared using 
> + * MODULE_DEVICE_TABLE(x86_cpu, ...)
> + *
> + * This always matches against the boot cpu, assuming models and features are 
> + * consistent over all CPUs.

Not necessarily a good assumption, as stated above.

> + */
> +struct x86_cpu_id *x86_match_cpu(struct x86_cpu_id *match)

match can be a const pointer. This would allow drivers to declare their
cpu tables as const too.

> +{
> +	struct x86_cpu_id *m;
> +	struct cpuinfo_x86 *c = &boot_cpu_data;
> +
> +	for (m = match; m->vendor | m->family | m->model | m->feature; m++) {
> +		if (m->vendor != X86_VENDOR_ANY && c->x86_vendor != m->vendor)
> +			continue;
> +		if (m->family != X86_FAMILY_ANY && c->x86 != m->family)
> +			continue;
> +		if (m->model != X86_MODEL_ANY && c->x86_model != m->model)
> +			continue;
> +		if (m->feature != X86_FEATURE_ANY && !cpu_has(c, m->feature))
> +			continue;
> +		return m;
> +	}
> +	return NULL;
> +}
> +EXPORT_SYMBOL(x86_match_cpu);
> diff --git a/arch/x86/kernel/cpuid.c b/arch/x86/kernel/cpuid.c
> index 212a6a4..6bb24d3 100644
> --- a/arch/x86/kernel/cpuid.c
> +++ b/arch/x86/kernel/cpuid.c
> @@ -40,6 +40,7 @@
>  #include <linux/notifier.h>
>  #include <linux/uaccess.h>
>  #include <linux/gfp.h>
> +#include <linux/slab.h>
>  
>  #include <asm/processor.h>
>  #include <asm/msr.h>
> @@ -138,13 +139,56 @@ static const struct file_operations cpuid_fops = {
>  	.open = cpuid_open,
>  };
>  
> +static ssize_t print_cpu_modalias(struct device *dev,
> +				  struct device_attribute *attr,
> +				  char *bufptr)
> +{
> +	int size = PAGE_SIZE;
> +	int i, n;
> +	char *buf = bufptr;
> +
> +	n = snprintf(buf, size, "x86cpu:vendor:%04x:family:%04x:model:%04x:feature:",
> +		boot_cpu_data.x86_vendor,
> +		boot_cpu_data.x86,
> +		boot_cpu_data.x86_model);
> +	size -= n;
> +	buf += n;
> +	size -= 2;

You might as well initialize size to PAGE_SIZE - 2 directly.

> +	for (i = 0; i < NCAPINTS*32; i++) {
> +		if (boot_cpu_has(i)) {
> +			n = snprintf(buf, size, ",%04x", i);
> +			if (n < 0) {
> +				WARN(1, "x86 features overflow page\n");
> +				break;
> +			}
> +			size -= n;
> +			buf += n;
> +		}
> +	}
> +	*buf++ = ',';
> +	*buf++ = '\n';
> +	return buf - bufptr;
> +}
> +
> +static DEVICE_ATTR(modalias, 0444, print_cpu_modalias, NULL);
> +
>  static __cpuinit int cpuid_device_create(int cpu)
>  {
>  	struct device *dev;
> +	int err;
>  
>  	dev = device_create(cpuid_class, NULL, MKDEV(CPUID_MAJOR, cpu), NULL,
>  			    "cpu%d", cpu);
> -	return IS_ERR(dev) ? PTR_ERR(dev) : 0;
> +	if (IS_ERR(dev))
> +		return PTR_ERR(dev);
> +
> +	err = device_create_file(dev, &dev_attr_modalias);
> +	if (err) {
> +		/* keep device around on error. attribute is optional. */
> +		return err;
> +	}
> +
> +	return 0;
>  }
>  
>  static void cpuid_device_destroy(int cpu)
> @@ -182,6 +226,17 @@ static char *cpuid_devnode(struct device *dev, mode_t *mode)
>  	return kasprintf(GFP_KERNEL, "cpu/%u/cpuid", MINOR(dev->devt));
>  }
>  
> +static int cpuid_dev_uevent(struct device *dev, struct kobj_uevent_env *env)
> +{
> +	char *buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
> +	if (buf) {
> +		print_cpu_modalias(NULL, NULL, buf);
> +		add_uevent_var(env, "MODALIAS=%s", buf);
> +		kfree(buf);
> +	}
> +	return 0;
> +}
> +
>  static int __init cpuid_init(void)
>  {
>  	int i, err = 0;
> @@ -200,6 +255,7 @@ static int __init cpuid_init(void)
>  		goto out_chrdev;
>  	}
>  	cpuid_class->devnode = cpuid_devnode;
> +	cpuid_class->dev_uevent = cpuid_dev_uevent;
>  	for_each_online_cpu(i) {
>  		err = cpuid_device_create(i);
>  		if (err != 0)
> diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
> index 468819c..8971fec 100644
> --- a/include/linux/mod_devicetable.h
> +++ b/include/linux/mod_devicetable.h
> @@ -542,4 +542,24 @@ struct isapnp_device_id {
>  	kernel_ulong_t driver_data;	/* data private to the driver */
>  };
>  
> +/*
> + * Match x86 CPUs for CPU specific drivers.
> + * See documentation of "x86_match_cpu" for details.
> + */
> +
> +struct x86_cpu_id {
> +	__u16 vendor;
> +	__u16 family;
> +	__u16 model;
> + 	__u16 feature;	/* bit index */
> +	kernel_ulong_t driver_data;
> +};
> +
> +#define X86_FEATURE_MATCH(x) { X86_VENDOR_ANY, X86_FAMILY_ANY, X86_MODEL_ANY, x }
> +
> +#define X86_VENDOR_ANY 0xffff
> +#define X86_FAMILY_ANY 0
> +#define X86_MODEL_ANY  0

Are you sure family 0 or model 0 are never used, by any vendor? I
wouldn't take the risk. What's wrong with 0xffff?

> +#define X86_FEATURE_ANY 0	/* Same as FPU, you can't test for that */

Might be better to set X86_FEATURE_ANY to either 10 (unused feature
bit) or 0xffff then.

> +
>  #endif /* LINUX_MOD_DEVICETABLE_H */
> diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
> index f936d1f..e5dd089 100644
> --- a/scripts/mod/file2alias.c
> +++ b/scripts/mod/file2alias.c
> @@ -880,6 +880,29 @@ static int do_isapnp_entry(const char *filename,
>  	return 1;
>  }
>  
> +/* LOOKS like x86cpu:vendor:VVVV:family:FFFF:model:MMMM:feature:*,FEAT,*
> + * All fields are numbers. It would be nicer to use strings for vendor
> + * and feature, but getting those out of the build system here is too
> + * complicated.
> + */
> +
> +static int do_x86cpu_entry(const char *filename, struct x86_cpu_id *id, 
> +			   char *alias)
> +{
> +	id->feature = TO_NATIVE(id->feature);
> +	id->family = TO_NATIVE(id->family);
> +	id->model = TO_NATIVE(id->model);
> +	id->vendor = TO_NATIVE(id->vendor);
> +
> +	strcpy(alias, "x86cpu:");
> +	ADD(alias, "vendor:",  id->vendor != X86_VENDOR_ANY, id->vendor);
> +	ADD(alias, ":family:", id->family != X86_FAMILY_ANY, id->family);
> +	ADD(alias, ":model:",  id->model  != X86_MODEL_ANY,  id->model);
> +	ADD(alias, ":feature:*,", id->feature != X86_FEATURE_ANY, id->feature);
> +	strcat(alias, ",*");
> +	return 1;
> +}
> +
>  /* Ignore any prefix, eg. some architectures prepend _ */
>  static inline int sym_is(const char *symbol, const char *name)
>  {
> @@ -1047,6 +1070,10 @@ void handle_moddevtable(struct module *mod, struct elf_info *info,
>  		do_table(symval, sym->st_size,
>  			sizeof(struct isapnp_device_id), "isa",
>  			do_isapnp_entry, mod);
> +	else if (sym_is(symname, "__mod_x86cpu_device_table"))
> +		do_table(symval, sym->st_size,
> +			 sizeof(struct x86_cpu_id), "x86cpu",
> +			 do_x86cpu_entry, mod);
>  	free(zeros);
>  }
>  


-- 
Jean Delvare
