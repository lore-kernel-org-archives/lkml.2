Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab0JTTHS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 15:07:18 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:51884 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228Ab0JTTHP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 15:07:15 -0400
MIME-Version: 1.0
In-Reply-To: <20101011041312.GF23588@angua.secretlab.ca>
References: <20101010020626.102437f5@debxo> <20101011041312.GF23588@angua.secretlab.ca>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 20 Oct 2010 12:56:21 -0600
X-Google-Sender-Auth: AgGbzj-QtuhGaKtndXVPn96kqSY
Message-ID: <AANLkTikg-HOM3EVQiPvuDahLuUWvhg_VeBBXLtJu6Tzo@mail.gmail.com>
Subject: Re: [PATCH 5/5] x86: OLPC: add OLPC device-tree support
To: Andres Salomon <dilinger@queued.net>
Cc: devicetree-discuss@lists.ozlabs.org, David Miller <davem@davemloft.net>,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 10, 2010 at 10:13 PM, Grant Likely
<grant.likely@secretlab.ca> wrote:
> On Sun, Oct 10, 2010 at 02:06:26AM -0700, Andres Salomon wrote:
>>
>> Make use of PROC_DEVICETREE to export the tree, and sparc's PROMTREE code to
>> call into OLPC's Open Firmware to build the tree.
>>
>> Signed-off-by: Andres Salomon <dilinger@queued.net>
>
> Holding off on this one until I hear from the x86 maintainers [cc'd].

Oops, and it appears that patch breaks the build on other
architectures when CONFIG_OF is enabled and CONFIG_PROMTREE is not due
to how of_pdt_init_devicetree is defined.

g.

>
> g.
>
>> ---
>>  arch/x86/Kconfig                |    2 +
>>  arch/x86/include/asm/olpc_ofw.h |    4 +
>>  arch/x86/include/asm/prom.h     |    1 +
>>  arch/x86/kernel/Makefile        |    1 +
>>  arch/x86/kernel/olpc_ofw.c      |    8 ++
>>  arch/x86/kernel/olpc_prom.c     |  152 +++++++++++++++++++++++++++++++++++++++
>>  drivers/of/pdt.c                |    2 +
>>  fs/proc/proc_devtree.c          |    4 +
>>  include/linux/of_pdt.h          |    1 +
>>  9 files changed, 175 insertions(+), 0 deletions(-)
>>  create mode 100644 arch/x86/include/asm/prom.h
>>  create mode 100644 arch/x86/kernel/olpc_prom.c
>>
>> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>> index cea0cd9..7d4ef72 100644
>> --- a/arch/x86/Kconfig
>> +++ b/arch/x86/Kconfig
>> @@ -2069,6 +2069,8 @@ config OLPC_OPENFIRMWARE
>>       bool "Support for OLPC's Open Firmware"
>>       depends on !X86_64 && !X86_PAE
>>       default y if OLPC
>> +     select OF
>> +     select OF_PROMTREE
>>       help
>>         This option adds support for the implementation of Open Firmware
>>         that is used on the OLPC XO-1 Children's Machine.
>> diff --git a/arch/x86/include/asm/olpc_ofw.h b/arch/x86/include/asm/olpc_ofw.h
>> index 08fde47..13075df 100644
>> --- a/arch/x86/include/asm/olpc_ofw.h
>> +++ b/arch/x86/include/asm/olpc_ofw.h
>> @@ -28,4 +28,8 @@ static inline void setup_olpc_ofw_pgd(void) { }
>>
>>  #endif /* !CONFIG_OLPC_OPENFIRMWARE */
>>
>> +#ifdef CONFIG_PROC_DEVICETREE
>> +extern void olpc_prom_build_devicetree(void);
>> +#endif /* CONFIG_PROC_DEVICETREE */
>> +
>>  #endif /* _ASM_X86_OLPC_OFW_H */
>> diff --git a/arch/x86/include/asm/prom.h b/arch/x86/include/asm/prom.h
>> new file mode 100644
>> index 0000000..b4ec95f
>> --- /dev/null
>> +++ b/arch/x86/include/asm/prom.h
>> @@ -0,0 +1 @@
>> +/* dummy prom.h; here to make linux/of.h's #includes happy */
>> diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
>> index fedf32a..ced0c9a 100644
>> --- a/arch/x86/kernel/Makefile
>> +++ b/arch/x86/kernel/Makefile
>> @@ -107,6 +107,7 @@ scx200-y                  += scx200_32.o
>>
>>  obj-$(CONFIG_OLPC)           += olpc.o
>>  obj-$(CONFIG_OLPC_OPENFIRMWARE)      += olpc_ofw.o
>> +obj-$(CONFIG_PROC_DEVICETREE)        += olpc_prom.o
>>  obj-$(CONFIG_X86_MRST)               += mrst.o
>>
>>  microcode-y                          := microcode_core.o
>> diff --git a/arch/x86/kernel/olpc_ofw.c b/arch/x86/kernel/olpc_ofw.c
>> index 3218aa7..6c4d243 100644
>> --- a/arch/x86/kernel/olpc_ofw.c
>> +++ b/arch/x86/kernel/olpc_ofw.c
>> @@ -1,5 +1,7 @@
>>  #include <linux/kernel.h>
>>  #include <linux/module.h>
>> +#include <linux/of.h>
>> +#include <linux/of_pdt.h>
>>  #include <linux/init.h>
>>  #include <asm/page.h>
>>  #include <asm/setup.h>
>> @@ -38,6 +40,12 @@ void __init setup_olpc_ofw_pgd(void)
>>       /* implicit optimization barrier here due to uninline function return */
>>
>>       early_iounmap(base, sizeof(olpc_ofw_pgd) * PTRS_PER_PGD);
>> +
>> +#ifdef CONFIG_PROC_DEVICETREE
>> +     /* OFW set up succesfully; use it for the device tree */
>> +     of_pdt_init_devicetree = olpc_prom_build_devicetree;
>> +#endif
>> +
>>  }
>>
>>  int __olpc_ofw(const char *name, int nr_args, const void **args, int nr_res,
>> diff --git a/arch/x86/kernel/olpc_prom.c b/arch/x86/kernel/olpc_prom.c
>> new file mode 100644
>> index 0000000..e2ecaf2
>> --- /dev/null
>> +++ b/arch/x86/kernel/olpc_prom.c
>> @@ -0,0 +1,152 @@
>> +/*
>> + * olpc_prom.c: OLPC-specific OFW device tree support code.
>> + *
>> + * Paul Mackerras    August 1996.
>> + * Copyright (C) 1996-2005 Paul Mackerras.
>> + *
>> + *  Adapted for 64bit PowerPC by Dave Engebretsen and Peter Bergner.
>> + *    {engebret|bergner}@us.ibm.com
>> + *
>> + *  Adapted for sparc by David S. Miller davem@davemloft.net
>> + *  Adapted for x86/OLPC by Andres Salomon <dilinger@queued.net>
>> + *
>> + *      This program is free software; you can redistribute it and/or
>> + *      modify it under the terms of the GNU General Public License
>> + *      as published by the Free Software Foundation; either version
>> + *      2 of the License, or (at your option) any later version.
>> + */
>> +
>> +#include <linux/kernel.h>
>> +#include <linux/module.h>
>> +#include <linux/errno.h>
>> +#include <linux/slab.h>
>> +#include <linux/of.h>
>> +#include <linux/of_pdt.h>
>> +#include <asm/olpc_ofw.h>
>> +
>> +static phandle __init olpc_prom_getsibling(phandle node)
>> +{
>> +     const void *args[] = { (void *)node };
>> +     void *res[] = { &node };
>> +
>> +     if (node == -1)
>> +             return 0;
>> +
>> +     if (olpc_ofw("peer", args, res) || node == -1)
>> +             return 0;
>> +
>> +     return node;
>> +}
>> +
>> +static phandle __init olpc_prom_getchild(phandle node)
>> +{
>> +     const void *args[] = { (void *)node };
>> +     void *res[] = { &node };
>> +
>> +     if (node == -1)
>> +             return 0;
>> +
>> +     if (olpc_ofw("child", args, res) || node == -1) {
>> +             pr_err("PROM: %s: fetching child failed!\n", __func__);
>> +             return 0;
>> +     }
>> +
>> +     return node;
>> +}
>> +
>> +static int __init olpc_prom_getproplen(phandle node, const char *prop)
>> +{
>> +     const void *args[] = { (void *)node, prop };
>> +     int len;
>> +     void *res[] = { &len };
>> +
>> +     if (node == -1)
>> +             return -1;
>> +
>> +     if (olpc_ofw("getproplen", args, res)) {
>> +             pr_err("PROM: %s: getproplen failed!\n", __func__);
>> +             return -1;
>> +     }
>> +
>> +     return len;
>> +}
>> +
>> +static int __init olpc_prom_getproperty(phandle node, const char *prop,
>> +             char *buf, int bufsize)
>> +{
>> +     int plen;
>> +
>> +     plen = olpc_prom_getproplen(node, prop);
>> +     if (plen > bufsize || plen < 1)
>> +             return -1;
>> +     else {
>> +             const void *args[] = { (void *)node, prop, buf, (void *)plen };
>> +             void *res[] = { &plen };
>> +
>> +             if (olpc_ofw("getprop", args, res)) {
>> +                     pr_err("PROM: %s: getprop failed!\n", __func__);
>> +                     return -1;
>> +             }
>> +     }
>> +
>> +     return plen;
>> +}
>> +
>> +static int __init olpc_prom_nextprop(phandle node, char *prev, char *buf)
>> +{
>> +     const void *args[] = { (void *)node, prev, buf };
>> +     int success;
>> +     void *res[] = { &success };
>> +
>> +     buf[0] = '\0';
>> +
>> +     if (node == -1)
>> +             return -1;
>> +
>> +     if (olpc_ofw("nextprop", args, res) || success != 1)
>> +             return -1;
>> +
>> +     return 0;
>> +}
>> +
>> +static int __init olpc_prom_pkg2path(phandle node, char *buf,
>> +             const int buflen, int *len)
>> +{
>> +     const void *args[] = { (void *)node, buf, (void *)buflen };
>> +     void *res[] = { len };
>> +
>> +     if (node == -1)
>> +             return -1;
>> +
>> +     if (olpc_ofw("package-to-path", args, res) || *len < 1)
>> +             return -1;
>> +
>> +     return 0;
>> +}
>> +
>> +void * __init prom_early_alloc(unsigned long size)
>> +{
>> +     /* this is called late enough that we can alloc normally */
>> +     return kzalloc(size, GFP_KERNEL);
>> +}
>> +
>> +static struct of_pdt_ops prom_olpc_ops __initdata = {
>> +     .nextprop = olpc_prom_nextprop,
>> +     .getproplen = olpc_prom_getproplen,
>> +     .getproperty = olpc_prom_getproperty,
>> +     .getchild = olpc_prom_getchild,
>> +     .getsibling = olpc_prom_getsibling,
>> +     .pkg2path = olpc_prom_pkg2path,
>> +};
>> +
>> +void __init olpc_prom_build_devicetree(void)
>> +{
>> +     phandle root;
>> +
>> +     root = olpc_prom_getsibling(0);
>> +     if (root < 0) {
>> +             pr_err("PROM: unable to get root node from OFW!\n");
>> +             return;
>> +     }
>> +     of_pdt_build_devicetree(root, &prom_olpc_ops);
>> +}
>> diff --git a/drivers/of/pdt.c b/drivers/of/pdt.c
>> index 28295d0..07e3daa 100644
>> --- a/drivers/of/pdt.c
>> +++ b/drivers/of/pdt.c
>> @@ -29,6 +29,8 @@ static struct of_pdt_ops *of_pdt_prom_ops __initdata;
>>  void __initdata (*of_pdt_build_more)(struct device_node *dp,
>>               struct device_node ***nextp);
>>
>> +void __initdata (*of_pdt_init_devicetree)(void);
>> +
>>  #if defined(CONFIG_SPARC)
>>  unsigned int of_pdt_unique_id __initdata;
>>
>> diff --git a/fs/proc/proc_devtree.c b/fs/proc/proc_devtree.c
>> index d9396a4..9779039 100644
>> --- a/fs/proc/proc_devtree.c
>> +++ b/fs/proc/proc_devtree.c
>> @@ -11,6 +11,7 @@
>>  #include <linux/stat.h>
>>  #include <linux/string.h>
>>  #include <linux/of.h>
>> +#include <linux/of_pdt.h>
>>  #include <linux/module.h>
>>  #include <linux/slab.h>
>>  #include <asm/prom.h>
>> @@ -228,6 +229,9 @@ void __init proc_device_tree_init(void)
>>  {
>>       struct device_node *root;
>>
>> +     if (of_pdt_init_devicetree)
>> +             of_pdt_init_devicetree();
>> +
>>       proc_device_tree = proc_mkdir("device-tree", NULL);
>>       if (proc_device_tree == NULL)
>>               return;
>> diff --git a/include/linux/of_pdt.h b/include/linux/of_pdt.h
>> index c65a18a..5b29aef 100644
>> --- a/include/linux/of_pdt.h
>> +++ b/include/linux/of_pdt.h
>> @@ -38,6 +38,7 @@ extern void *prom_early_alloc(unsigned long size);
>>
>>  /* for building the device tree */
>>  extern void of_pdt_build_devicetree(phandle root_node, struct of_pdt_ops *ops);
>> +extern void (*of_pdt_init_devicetree)(void);
>>
>>  extern void (*of_pdt_build_more)(struct device_node *dp,
>>               struct device_node ***nextp);
>> --
>> 1.5.6.5
>>
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
