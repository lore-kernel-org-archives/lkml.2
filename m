Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab1LUPcw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 10:32:52 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:64243 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164Ab1LUPcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 10:32:50 -0500
MIME-Version: 1.0
In-Reply-To: <201112211602.26845.trenn@suse.de>
References: <1324338394-4670-1-git-send-email-andi@firstfloor.org>
 <1324338394-4670-9-git-send-email-andi@firstfloor.org> <201112211602.26845.trenn@suse.de>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 21 Dec 2011 16:32:28 +0100
Message-ID: <CAPXgP12xDOjaEoRDdjYSSoLFCmpUOCZjoLFuyZHdnEMVsKGa0w@mail.gmail.com>
Subject: Re: [PATCH 9/8] CPU: Introduce ARCH_HAS_CPU_AUTOPROBE and X86 parts
To: Thomas Renninger <trenn@suse.de>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        hpa@zytor.com, Andi Kleen <ak@linux.intel.com>, axboe@kernel.dk,
        herbert@gondor.hengli.com.au, ying.huang@intel.com, lenb@kernel.org,
        Greg Kroah-Hartmann <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pBLFWuNt013829

2011/12/21 Thomas Renninger <trenn@suse.de>:

Cool. That sounds good. Nice work. Thanks.

Adding Greg, so he's in the loop.

Greg, Andi's upcoming CPU modaliases are temporarily hooked into the
'cpuid' class devices to make them work with userspace, which isn't
possible with the weird sysdev stuff.

We don't want to depend on the 'cpuid' class, but hook into the real
'cpu' subsystem. This switches them over after we have the
sysdev-cpu-conversion stuff merged.

Thanks,
Kay

> CPU: Introduce ARCH_HAS_CPU_AUTOPROBE and X86 parts
>
> This patch is based on Andi Kleen's work:
> Implement autoprobing/loading of modules serving CPU
> specific features (x86cpu autoloading).
>
> And Kay Siever's work to get rid of sysdev cpu structures
> and making use of struct device instead.
>
> Signed-off-by: Thomas Renninger <trenn@suse.de>
> CC: ak@linux.intel.com
> CC: kay.sievers@vrfy.org
> CC: hpa@zytor.com
> CC: davej@redhat.com
> CC: kay.sievers@vrfy.org
> CC: axboe@kernel.dk
> CC: hpa@zytor.com
> CC: herbert@gondor.apana.org.au
> CC: ying.huang@intel.com
> CC: lenb@kernel.org
>
> ---
>  arch/x86/Kconfig            |    3 ++
>  arch/x86/kernel/cpu/match.c |   43 ++++++++++++++++++++++++++++++++
>  arch/x86/kernel/cpuid.c     |   58 --------------------------------------------
>  drivers/base/cpu.c          |   11 ++++++++
>  include/linux/cpu.h         |    7 +++++
>  5 files changed, 65 insertions(+), 57 deletions(-)
>
> Index: linux-3.2-rc6-master/arch/x86/kernel/cpuid.c
> ===================================================================
> --- linux-3.2-rc6-master.orig/arch/x86/kernel/cpuid.c
> +++ linux-3.2-rc6-master/arch/x86/kernel/cpuid.c
> @@ -40,7 +40,6 @@
>  #include <linux/notifier.h>
>  #include <linux/uaccess.h>
>  #include <linux/gfp.h>
> -#include <linux/slab.h>
>
>  #include <asm/processor.h>
>  #include <asm/msr.h>
> @@ -139,56 +138,13 @@ static const struct file_operations cpui
>        .open = cpuid_open,
>  };
>
> -static ssize_t print_cpu_modalias(struct device *dev,
> -                                 struct device_attribute *attr,
> -                                 char *bufptr)
> -{
> -       int size = PAGE_SIZE;
> -       int i, n;
> -       char *buf = bufptr;
> -
> -       n = snprintf(buf, size, "x86cpu:vendor:%04x:family:%04x:model:%04x:feature:",
> -               boot_cpu_data.x86_vendor,
> -               boot_cpu_data.x86,
> -               boot_cpu_data.x86_model);
> -       size -= n;
> -       buf += n;
> -       size -= 2;
> -       for (i = 0; i < NCAPINTS*32; i++) {
> -               if (boot_cpu_has(i)) {
> -                       n = snprintf(buf, size, ",%04x", i);
> -                       if (n < 0) {
> -                               WARN(1, "x86 features overflow page\n");
> -                               break;
> -                       }
> -                       size -= n;
> -                       buf += n;
> -               }
> -       }
> -       *buf++ = ',';
> -       *buf++ = '\n';
> -       return buf - bufptr;
> -}
> -
> -static DEVICE_ATTR(modalias, 0444, print_cpu_modalias, NULL);
> -
>  static __cpuinit int cpuid_device_create(int cpu)
>  {
>        struct device *dev;
> -       int err;
>
>        dev = device_create(cpuid_class, NULL, MKDEV(CPUID_MAJOR, cpu), NULL,
>                            "cpu%d", cpu);
> -       if (IS_ERR(dev))
> -               return PTR_ERR(dev);
> -
> -       err = device_create_file(dev, &dev_attr_modalias);
> -       if (err) {
> -               /* keep device around on error. attribute is optional. */
> -               err = 0;
> -       }
> -
> -       return 0;
> +       return IS_ERR(dev) ? PTR_ERR(dev) : 0;
>  }
>
>  static void cpuid_device_destroy(int cpu)
> @@ -226,17 +182,6 @@ static char *cpuid_devnode(struct device
>        return kasprintf(GFP_KERNEL, "cpu/%u/cpuid", MINOR(dev->devt));
>  }
>
> -static int cpuid_dev_uevent(struct device *dev, struct kobj_uevent_env *env)
> -{
> -       char *buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
> -       if (buf) {
> -               print_cpu_modalias(NULL, NULL, buf);
> -               add_uevent_var(env, "MODALIAS=%s", buf);
> -               kfree(buf);
> -       }
> -       return 0;
> -}
> -
>  static int __init cpuid_init(void)
>  {
>        int i, err = 0;
> @@ -255,7 +200,6 @@ static int __init cpuid_init(void)
>                goto out_chrdev;
>        }
>        cpuid_class->devnode = cpuid_devnode;
> -       cpuid_class->dev_uevent = cpuid_dev_uevent;
>        for_each_online_cpu(i) {
>                err = cpuid_device_create(i);CPU: Introduce ARCH_HAS_CPU_AUTOPROBE and X86 parts
>                if (err != 0)
> Index: linux-3.2-rc6-master/arch/x86/Kconfig
> ===================================================================
> --- linux-3.2-rc6-master.orig/arch/x86/Kconfig
> +++ linux-3.2-rc6-master/arch/x86/Kconfig
> @@ -185,6 +185,9 @@ config ARCH_HAS_DEFAULT_IDLE
>  config ARCH_HAS_CACHE_LINE_SIZE
>        def_bool y
>
> +config ARCH_HAS_CPU_AUTOPROBE
> +       def_bool y
> +
>  config HAVE_SETUP_PER_CPU_AREA
>        def_bool y
>
> Index: linux-3.2-rc6-master/drivers/base/cpu.c
> ===================================================================
> --- linux-3.2-rc6-master.orig/drivers/base/cpu.c
> +++ linux-3.2-rc6-master/drivers/base/cpu.c
> @@ -10,6 +10,7 @@
>  #include <linux/device.h>
>  #include <linux/node.h>
>  #include <linux/gfp.h>
> +#include <linux/slab.h>
>
>  #include "base.h"
>
> @@ -221,6 +222,9 @@ int __cpuinit register_cpu(struct cpu *c
>        cpu->node_id = cpu_to_node(num);
>        cpu->dev.id = num;
>        cpu->dev.bus = &cpu_subsys;
> +#ifdef CONFIG_ARCH_HAS_CPU_AUTOPROBE
> +       cpu->dev.bus->uevent = arch_cpu_uevent;
> +#endif
>        error = device_register(&cpu->dev);
>        if (!error && cpu->hotpluggable)
>                register_cpu_control(cpu);
> @@ -245,6 +249,10 @@ struct device *get_cpu_device(unsigned c
>  }
>  EXPORT_SYMBOL_GPL(get_cpu_device);
>
> +#ifdef CONFIG_ARCH_HAS_CPU_AUTOPROBE
> +static DEVICE_ATTR(modalias, 0444, arch_print_cpu_modalias, NULL);
> +#endif
> +
>  static struct attribute *cpu_root_attrs[] = {
>  #ifdef CONFIG_ARCH_CPU_PROBE_RELEASE
>        &dev_attr_probe.attr,
> @@ -255,6 +263,9 @@ static struct attribute *cpu_root_attrs[
>        &cpu_attrs[2].attr.attr,
>        &dev_attr_kernel_max.attr,
>        &dev_attr_offline.attr,
> +#ifdef CONFIG_ARCH_HAS_CPU_AUTOPROBE
> +       &dev_attr_modalias.attr,
> +#endif
>        NULL
>  };
>
> Index: linux-3.2-rc6-master/arch/x86/kernel/cpu/match.c
> ===================================================================
> --- linux-3.2-rc6-master.orig/arch/x86/kernel/cpu/match.c
> +++ linux-3.2-rc6-master/arch/x86/kernel/cpu/match.c
> @@ -2,6 +2,7 @@
>  #include <asm/processor.h>
>  #include <linux/cpu.h>
>  #include <linux/module.h>
> +#include <linux/slab.h>
>
>  /**
>  * x86_match_cpu - match current CPU again an array of x86_cpu_ids
> @@ -46,3 +47,45 @@ const struct x86_cpu_id *x86_match_cpu(c
>        return NULL;
>  }
>  EXPORT_SYMBOL(x86_match_cpu);
> +
> +ssize_t arch_print_cpu_modalias(struct device *dev,
> +                               struct device_attribute *attr,
> +                               char *bufptr)
> +{
> +       int size = PAGE_SIZE;
> +       int i, n;
> +       char *buf = bufptr;
> +
> +       n = snprintf(buf, size, "x86cpu:vendor:%04x:family:%04x:model:%04x:feature:",
> +               boot_cpu_data.x86_vendor,
> +               boot_cpu_data.x86,
> +               boot_cpu_data.x86_model);
> +       size -= n;
> +       buf += n;
> +       size -= 2;
> +       for (i = 0; i < NCAPINTS*32; i++) {
> +               if (boot_cpu_has(i)) {
> +                       n = snprintf(buf, size, ",%04x", i);
> +                       if (n < 0) {
> +                               WARN(1, "x86 features overflow page\n");
> +                               break;
> +                       }
> +                       size -= n;
> +                       buf += n;
> +               }
> +       }
> +       *buf++ = ',';
> +       *buf++ = '\n';
> +       return buf - bufptr;
> +}
> +
> +int arch_cpu_uevent(struct device *dev, struct kobj_uevent_env *env)
> +{
> +       char *buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
> +       if (buf) {
> +               arch_print_cpu_modalias(NULL, NULL, buf);
> +               add_uevent_var(env, "MODALIAS=%s", buf);
> +               kfree(buf);
> +       }
> +       return 0;
> +}
> Index: linux-3.2-rc6-master/include/linux/cpu.h
> ===================================================================
> --- linux-3.2-rc6-master.orig/include/linux/cpu.h
> +++ linux-3.2-rc6-master/include/linux/cpu.h
> @@ -43,6 +43,13 @@ extern ssize_t arch_cpu_release(const ch
>  #endif
>  struct notifier_block;
>
> +#ifdef CONFIG_ARCH_HAS_CPU_AUTOPROBE
> +extern int arch_cpu_uevent(struct device *dev, struct kobj_uevent_env *env);
> +extern ssize_t arch_print_cpu_modalias(struct device *dev,
> +                                      struct device_attribute *attr,
> +                                      char *bufptr);
> +#endif
> +
>  /*
>  * CPU notifier priorities.
>  */
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
