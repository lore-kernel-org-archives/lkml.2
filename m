Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933717Ab1CXSvI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 14:51:08 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50362 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933125Ab1CXSvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 14:51:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=HTlwrqBYWSKkrQ3obIb/Kk6u1ZGlDx6qwhNyYl776LdvayjngOgun2LZyJiawUVSGV
         fW+34JQ/7Zo0PLOqJBJl83YKN7DiTSaLLfyA3f+vtA6BVG5wEJtexzqLLkvfgYKV1jvh
         TcK9tnFZWHc7N4nJFDvziiTB8lfk78n1Uf42s=
MIME-Version: 1.0
In-Reply-To: <1300980071-24645-3-git-send-email-jamie@jamieiles.com>
References: <1300980071-24645-1-git-send-email-jamie@jamieiles.com> <1300980071-24645-3-git-send-email-jamie@jamieiles.com>
From: Mike Frysinger <vapier@gentoo.org>
Date: Thu, 24 Mar 2011 14:50:35 -0400
X-Google-Sender-Auth: IrE6fsaabTnLXQFIejcZ5vri4Tc
Message-ID: <AANLkTikaO3_WgFjF04+kfQ_vxxpHhCmC1mpHJvjo7ZtS@mail.gmail.com>
Subject: Re: [RFC PATCHv2 2/4] drivers/otp: add support for Picoxcell PC3X3 OTP
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 11:21, Jamie Iles wrote:
> --- a/drivers/otp/Kconfig
> +++ b/drivers/otp/Kconfig
> @@ -8,3 +8,14 @@ menuconfig OTP
>          Say y here to support OTP memory found in some embedded devices.
>          This memory can commonly be used to store boot code, cryptographic
>          keys and other persistent data.
> +
> +if OTP
> +
> +config OTP_PC3X3
> +       tristate "Enable support for Picochip PC3X3 OTP"
> +       depends on OTP && ARCH_PICOXCELL

since every driver is going to need "depend OTP", the "if OTP" is
redundant then right ?

> +       help
> +         Say y or m here to allow support for the OTP found in PC3X3 devices.
> +         If you say m then the module will be called otp_pc3x3.

"y" -> "y"
"m" -> "M"

> +
> +endif
> diff --git a/drivers/otp/Makefile b/drivers/otp/Makefile
> index 84fd03e..c710ec4 100644
> --- a/drivers/otp/Makefile
> +++ b/drivers/otp/Makefile
> @@ -1 +1,2 @@
>  obj-$(CONFIG_OTP)      += otp.o
> +obj-$(CONFIG_OTP_PC3X3)        += otp_pc3x3.o
> diff --git a/drivers/otp/otp_pc3x3.c b/drivers/otp/otp_pc3x3.c
> new file mode 100644
> index 0000000..855d664
> --- /dev/null
> +++ b/drivers/otp/otp_pc3x3.c
> @@ -0,0 +1,1079 @@
> +/*
> + * Copyright 2010-2011 Picochip LTD, Jamie Iles
> + * http://www.picochip.com
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version
> + * 2 of the License, or (at your option) any later version.
> + *
> + * This driver implements a picoxcellotp backend for reading and writing the
> + * OTP memory in Picochip PC3X3 devices. This OTP can be used for executing
> + * secure boot code or for the secure storage of keys and any other user data.
> + */
> +#define pr_fmt(fmt) "pc3x3otp: " fmt
> +
> +#include <linux/bitops.h>
> +#include <linux/clk.h>
> +#include <linux/delay.h>
> +#include <linux/err.h>
> +#include <linux/io.h>
> +#include <linux/module.h>
> +#include <linux/otp.h>
> +#include <linux/platform_device.h>
> +
> +/*
> + * To test the user interface and most of the driver logic, we have a test
> + * mode whereby rather than writing to OTP we have a RAM buffer that simulates
> + * the OTP. This means that we can test everything apart from:
> + *
> + *     - The OTP state machines and commands.
> + *     - Failure to program bits.
> + */
> +static int test_mode;
> +module_param(test_mode, bool, S_IRUSR);
> +MODULE_PARM_DESC(test_mode,
> +                "Run in test mode (use a memory buffer rather than OTP");
> +
> +/*
> + * This is the maximum number of times to try and soak a failed bit. We get
> + * this from the Sidense documentation. After 16 attempts it is very unlikely
> + * that anything will change.
> + */
> +#define MAX_PROGRAM_RETRIES            16
> +
> +#define OTP_MACRO_CMD_REG_OFFSET       0x00
> +#define OTP_MACRO_STATUS_REG_OFFSET    0x04
> +#define OTP_MACRO_CONFIG_REG_OFFSET    0x08
> +#define OTP_MACRO_ADDR_REG_OFFSET      0x0C
> +#define OTP_MACRO_D_LO_REG_OFFSET      0x10
> +#define OTP_MACRO_D_HI_REG_OFFSET      0x14
> +#define OTP_MACRO_Q_LO_REG_OFFSET      0x20
> +#define OTP_MACRO_Q_HI_REG_OFFSET      0x24
> +#define OTP_MACRO_Q_MR_REG_OFFSET      0x28
> +#define OTP_MACRO_Q_MRAB_REG_OFFSET    0x2C
> +#define OTP_MACRO_Q_SR_LO_REG_OFFSET   0x30
> +#define OTP_MACRO_Q_SR_HI_REG_OFFSET   0x34
> +#define OTP_MACRO_Q_RR_LO_REG_OFFSET   0x38
> +#define OTP_MACRO_Q_RR_HI_REG_OFFSET   0x3C
> +#define OTP_MACRO_TIME_RD_REG_OFFSET   0x40
> +#define OTP_MACRO_TIME_WR_REG_OFFSET   0x44
> +#define OTP_MACRO_TIME_PGM_REG_OFFSET  0x48
> +#define OTP_MACRO_TIME_PCH_REG_OFFSET  0x4C
> +#define OTP_MACRO_TIME_CMP_REG_OFFSET  0x50
> +#define OTP_MACRO_TIME_RST_REG_OFFSET  0x54
> +#define OTP_MACRO_TIME_PWR_REG_OFFSET  0x58
> +#define OTP_MACRO_DIRECT_IO_REG_OFFSET 0x5C
> +
> +/*
> + * The OTP addresses of the special register. This is in the boot
> + * sector and we use words 0 and 2 of sector 0 in redundant format.
> + */
> +#define SR_ADDRESS_0       ((1 << 11) | 0x0)
> +#define SR_ADDRESS_2       ((1 << 11) | 0x2)
> +
> +enum otp_command {
> +       OTP_COMMAND_IDLE,
> +       OTP_COMMAND_WRITE,
> +       OTP_COMMAND_PROGRAM,
> +       OTP_COMMAND_READ,
> +       OTP_COMMAND_WRITE_MR,
> +       OTP_COMMAND_PRECHARGE,
> +       OTP_COMMAND_COMPARE,
> +       OTP_COMMAND_RESET,
> +       OTP_COMMAND_RESET_M,
> +       OTP_COMMAND_POWER_DOWN,
> +       OTP_COMMAND_AUX_UPDATE_A,
> +       OTP_COMMAND_AUX_UPDATE_B,
> +       OTP_COMMAND_WRITE_PROGRAM,
> +       OTP_COMMAND_WRITE_MRA,
> +       OTP_COMMAND_WRITE_MRB,
> +       OTP_COMMAND_RESET_MR,
> +};
> +
> +/* The control and status registers follow the AXI OTP map. */
> +#define OTP_CTRL_BASE                  0x4000
> +
> +/*
> + * The number of words in the OTP device. The device is 16K bytes and the word
> + * size is 64 bits.
> + */
> +#define OTP_NUM_WORDS      (SZ_16K / OTP_WORD_SIZE)
> +
> +/*
> + * The OTP device representation. We can have a static structure as there is
> + * only ever one OTP device in a system.
> + *
> + * @iomem: the io memory for the device that should be accessed with the I/O
> + *     accessors.
> + * @mem: the 16KB of OTP memory that can be accessed like normal memory. When
> + *     we probe, we force the __iomem away so we can read it directly.
> + * @test_mode_sr0, test_mode_sr2 the values of the special register when we're
> + *     in test mode.
> + */
> +struct pc3x3_otp {
> +       struct otp_device   *dev;
> +       void __iomem        *iomem;
> +       void                *mem;
> +       struct clk          *clk;
> +       u64                 test_mode_sr0, test_mode_sr2;
> +       unsigned long       registered_regions;
> +};
> +
> +static inline void otp_write_reg(struct pc3x3_otp *otp, unsigned reg_num,
> +                                u32 value)
> +{
> +       writel(value, otp->iomem + OTP_CTRL_BASE + reg_num);
> +}
> +
> +static inline u32 otp_read_reg(struct pc3x3_otp *otp, unsigned reg_num)
> +{
> +       return readl(otp->iomem + OTP_CTRL_BASE + reg_num);
> +}
> +
> +static inline u32 otp_read_sr(struct pc3x3_otp *otp)
> +{
> +       if (test_mode)
> +               return otp->test_mode_sr0 | otp->test_mode_sr2;
> +
> +       return otp_read_reg(otp, OTP_MACRO_Q_SR_LO_REG_OFFSET);
> +}
> +
> +/*
> + * Get the region format. The region format encoding and number of regions are
> + * encoded in the bottom 32 bis of the special register:
> + *
> + *  20: enable redundancy replacement.
> + *  [2:0]: AXI address mask - determines the number of address bits to use for
> + *  selecting the region to read from.
> + *  [m:n]: the format for region X where n := (X * 2) + 4 and m := n + 1.
> + */
> +static enum otp_redundancy_fmt
> +__pc3x3_otp_region_get_fmt(struct pc3x3_otp *otp,
> +                          const struct otp_region *region)
> +{
> +       unsigned shift = (region->region_nr * 2) + 4;
> +
> +       return (otp_read_sr(otp) >> shift) & 0x3;
> +}
> +
> +static enum otp_redundancy_fmt
> +pc3x3_otp_region_get_fmt(struct otp_region *region)
> +{
> +       struct pc3x3_otp *otp = dev_get_drvdata(region->dev.parent);
> +
> +       return __pc3x3_otp_region_get_fmt(otp, region);
> +}
> +
> +/*
> + * Find out how many regions the OTP is partitioned into. This can be 1, 2, 4
> + * or 8.
> + */
> +static inline int otp_num_regions(struct pc3x3_otp *otp)
> +{
> +#define SR_AXI_ADDRESS_MASK    0x7
> +       u32 addr_mask;
> +       int nr_regions;
> +
> +       addr_mask = otp_read_sr(otp) & SR_AXI_ADDRESS_MASK;
> +
> +       if (0 == addr_mask)
> +               nr_regions = 1;
> +       else if (4 == addr_mask)
> +               nr_regions = 2;
> +       else if (6 == addr_mask)
> +               nr_regions = 4;
> +       else if (7 == addr_mask)
> +               nr_regions = 8;
> +       else
> +               nr_regions = 0;
> +
> +       if (WARN_ON(0 == nr_regions))
> +               return -EINVAL;
> +
> +       return nr_regions;
> +}

the "if" style is backwards from most of the kernel ... plus, this
would probably look cleaner as a switch() statement

is this sort of a big func to be forcing inline isnt it ?

> +static void otp_charge_pump_enable(struct pc3x3_otp *otp, int enable)
> +{
> +#define OTP_MRA_CHARGE_PUMP_ENABLE_MASK            (1 << 12)
> +#define OTP_MRA_CHARGE_PUMP_MONITOR_MASK    (1 << 15)
> +#define OTP_MRA_READ_REFERENCE_LEVEL9_MASK  (1 << 9)
> +#define OTP_MRA_READ_REFERENCE_LEVEL5_MASK  (1 << 5)
> +#define OTP_STATUS_VPP_APPLIED             (1 << 4)
> +       u32 mra = enable ?
> +               (OTP_MRA_CHARGE_PUMP_ENABLE_MASK |
> +                OTP_MRA_CHARGE_PUMP_MONITOR_MASK |
> +                OTP_MRA_READ_REFERENCE_LEVEL9_MASK |
> +                OTP_MRA_READ_REFERENCE_LEVEL5_MASK) : 0;
> +
> +       otp_write_MRA(otp, mra);
> +
> +       /* Now wait for VPP to reach the correct level. */
> +       if (enable && !test_mode) {
> +               while (!(otp_read_reg(otp, OTP_MACRO_STATUS_REG_OFFSET) &
> +                        OTP_STATUS_VPP_APPLIED))
> +                       cpu_relax();
> +       }
> +
> +       udelay(1);
> +}

is that udelay() really necessary ?  could it be refined to a smaller ndelay() ?

> + * any read-modify-write that is neccessary. For example if address 0 contains

"neccessary" -> "necessary"

> +static int otp_raw_write_word(struct pc3x3_otp *otp,
> +                             unsigned addr, u64 val)
> +{
> +       /* The status of the last command. 1 == success. */
> +#define OTP_STATUS_LCS                     (1 << 1)
> +
> +#define OTP_MR_SELF_TIMING                 (1 << 2)
> +#define OTP_MR_PROGRAMMABLE_DELAY          (1 << 5)
> +#define OTP_MR_PROGRAMMABLE_DELAY_CONTROL   (1 << 8)
> +
> +#define OTP_MRB_VREF_ADJUST_0              (1 << 0)
> +#define OTP_MRB_VREF_ADJUST_1              (1 << 1)
> +#define OTP_MRB_VREF_ADJUST_3              (1 << 3)
> +#define OTP_MRB_READ_TIMER_DELAY_CONTROL    (1 << 12)

this driver sure likes to inline defines ... usually these are kept
all together at the top, or in a sep file like drivers/otp/otp_pc3x3.h

> +       /* Enable the charge pump to begin programming. */
> +       otp_charge_pump_enable(otp, 1);
> +       otp_write_MRB(otp, OTP_MRB_VREF_ADJUST_3 |
> +                       OTP_MRB_READ_TIMER_DELAY_CONTROL);
> +       otp_write_MR(otp, OTP_MR_SELF_TIMING | OTP_MR_PROGRAMMABLE_DELAY |
> +                       OTP_MR_PROGRAMMABLE_DELAY_CONTROL);
> +       otp_raw_program_word(otp, addr, v);
> +       udelay(1);

i thought you had a helper func to do this ?

> +static int pc3x3_otp_region_read_word(struct otp_region *region,
> +                                     unsigned long addr, u64 *word)
> +{
> +       switch (fmt) {
> +       case OTP_REDUNDANCY_FMT_SINGLE_ENDED:
> +       case OTP_REDUNDANCY_FMT_REDUNDANT:
> +       case OTP_REDUNDANCY_FMT_DIFFERENTIAL:
> +       case OTP_REDUNDANCY_FMT_DIFFERENTIAL_REDUNDANT:
> +       default:
> +               err = -EINVAL;
> +       }
> +
> +       *word = result;

should that write happen even when there's an error ?

> +static ssize_t pc3x3_otp_region_get_size(struct otp_region *region)
> +{
> +       size_t region_sz;
> +       return region_sz;
> +}

return type is ssize_t, but you're returning a size_t ...

> +static int pc3x3_otp_get_nr_regions(struct otp_device *dev)
> +{
> +       struct pc3x3_otp *otp = dev_get_drvdata(&dev->dev);
> +       unsigned long sr = otp_read_sr(otp);
> +       u32 addr_mask = sr & SR_AXI_ADDRESS_MASK;
> +
> +       if (0 == addr_mask)
> +               return 1;
> +       else if (4 == addr_mask)
> +               return 2;
> +       else if (6 == addr_mask)
> +               return 4;
> +       else if (7 == addr_mask)
> +               return 8;
> +
> +       return -EINVAL;
> +}

use a switch() statement instead ?

> +static int __devinit otp_probe(struct platform_device *pdev)

namespace this ?  so call it "pc3x3_otp_probe" ...

> +       if (!devm_request_mem_region(&pdev->dev, mem->start,
> +                                    resource_size(mem), "otp")) {
> +               dev_err(&pdev->dev, "unable to request i/o memory\n");
> +               return -EBUSY;
> +       }
> +
> +       pc3x3_dev = devm_kzalloc(&pdev->dev, sizeof(*pc3x3_dev), GFP_KERNEL);
> +       if (!pc3x3_dev)
> +               return -ENOMEM;

i'm not familiar with "devm_request_mem_region", but does it not need
to be unrequested ?

also, should you be using the driver's name "pc3x3" rather than "otp"
when requesting things ?

> +       if (test_mode) {
> +               u64 *p = devm_kzalloc(&pdev->dev, SZ_16K + SZ_1K, GFP_KERNEL);
> ...
> +       } else {
> +               pc3x3_dev->iomem = devm_ioremap(&pdev->dev, mem->start,
> +                                               resource_size(mem));
> ...
> +out_unregister:
> +       otp_device_unregister(otp);
> +out_clk_disable:
> +       clk_disable(pc3x3_dev->clk);
> +       clk_put(pc3x3_dev->clk);
> +out:
> +       return err;

hmm, but you dont iounmap or free any of the memory from earlier when
you error out ...

> +static int __devexit otp_remove(struct platform_device *pdev)
> +{
> +       struct pc3x3_otp *otp = platform_get_drvdata(pdev);
> +
> +       otp_device_unregister(otp->dev);
> +       clk_disable(otp->clk);
> +       clk_put(otp->clk);
> +
> +       return 0;
> +}

seems like you forgot to release iomem here

> +#ifdef CONFIG_PM
> +static int otp_suspend(struct device *dev)
> +{
> +       struct platform_device *pdev = to_platform_device(dev);
> +       struct pc3x3_otp *otp = platform_get_drvdata(pdev);
> +
> +       otp_write_reg(otp, OTP_MACRO_CMD_REG_OFFSET, OTP_COMMAND_POWER_DOWN);
> +       clk_disable(otp->clk);
> +
> +       return 0;
> +}
> +
> +static int otp_resume(struct device *dev)
> +{
> +       struct platform_device *pdev = to_platform_device(dev);
> +       struct pc3x3_otp *otp = platform_get_drvdata(pdev);
> +
> +       clk_enable(otp->clk);
> +       otp_write_reg(otp, OTP_MACRO_CMD_REG_OFFSET, OTP_COMMAND_IDLE);
> +
> +       return 0;
> +}
> +#else /* CONFIG_PM */
> +#define otp_suspend    NULL
> +#define otp_resume     NULL
> +#endif /* CONFIG_PM */
> +
> +static const struct dev_pm_ops otp_pm_ops = {
> +       .suspend        = otp_suspend,
> +       .resume         = otp_resume,
> +};

usually people put the dev_pm_ops struct behind CONFIG_PM too and then do:
#ifdef CONFIG_PM
...
#define DEV_PM_OPS &otp_pm_ops
#else
#define DEV_PM_OPS NULL
#endif

> +static struct platform_driver otp_driver = {
> +       .remove         = __devexit_p(otp_remove),
> +       .driver         = {
> +               .name   = "picoxcell-otp-pc3x3",
> +               .pm     = &otp_pm_ops,
> +       },
> +};
>
> +static int __init pc3x3_otp_init(void)
> +{
> +       return platform_driver_probe(&otp_driver, otp_probe);
> +}

why call probe yourself ?  why not platform_driver_register() ?
-mike
