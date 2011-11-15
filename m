Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932330Ab1KOUyX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 15:54:23 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:56544 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932245Ab1KOUyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 15:54:22 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Wan ZongShun <mcuos.com@gmail.com>
Subject: Re: [PATCH V2] ARM: NUC900: Add PCI driver support for NUC960
Date: Tue, 15 Nov 2011 20:54:07 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>
References: <4EBE98FC.6070903@gmail.com> <4EC0BF9B.2050300@gmail.com>
In-Reply-To: <4EC0BF9B.2050300@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="gb2312"
Content-Transfer-Encoding: 7bit
Message-Id: <201111152054.07443.arnd@arndb.de>
X-Provags-ID: V02:K0:I5AC0QURzvEydgBS9UHF5mgs0gOCumE5kpUdkH2F1i1
 HR95t44YZ9GAZYzQwb6+AqbrY3/Ee1sdwLH6zh5I/P0GeOLmFK
 IRqFPI9sRO16tSYy/h4N6eG4WlFp1x0v0YpYqYphKbPV0vJn1n
 NK9cFj/Wo2d8rK5iaqVA3pskmbR6uTRl+JV+PPMymk4Bemlb+n
 qrKGcDXqayOfCp+blLEDwmCQJ4TEV4Jxor3f1VyW+4PY1dLYJR
 x112dWXAMdfPU7O5heegWmUpNAXQFSyWhtk1TPbzw1iq1mvht9
 FggbNkUBgPENCyyqpVR0RXWnkxYKELZSSrdXY20nx6yZ8seTbo
 Jzj4BdwksGVAZoLLm+zo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 November 2011, Wan ZongShun wrote:

> diff --git a/arch/arm/mach-w90x900/include/mach/regs-pci.h
> b/arch/arm/mach-w90x900/include/mach/regs-pci.h
> new file mode 100644
> index 0000000..d1975eb
> --- /dev/null
> +++ b/arch/arm/mach-w90x900/include/mach/regs-pci.h
> @@ -0,0 +1,37 @@

> +#define PCI_BA    W90X900_VA_PCI /* PCI Control */
> +/* PCI Control Registers */
> +#define REG_PCICTR		(PCI_BA + 0x000)
> +#define REG_PCISTR		(PCI_BA + 0x004)
> +#define REG_PCILATIMER		(PCI_BA + 0x008)
> +#define REG_PCIINTEN		(PCI_BA + 0x010)
> +#define REG_PCIINT		(PCI_BA + 0x014)
> +#define REG_CFGADDR		(PCI_BA + 0x020)
> +#define REG_CFGDATA		(PCI_BA + 0x024)
> +#define REG_PCIARB		(PCI_BA + 0x04C)
> +#define REG_PCIBIST		(PCI_BA + 0x050)

These should not be used outside of your pci.c file, so just move the
definitions there.

> +#define NUC900_PCI_IO_BASE	0xE0000000
> +#define NUC900_PCI_IO_END	0xE000FFFF
> +#define NUC900_PCI_IO_SIZE	0x10000

Whereas these should probably go in your mach/map.h file and follow the
naming conventions used there, e.g.

#define W90X900_VA_PCI_IO       W90X900_ADDR(0xsomewhere)
#define W90X900_PA_PCI_IO	0xE0000000
#define W90X900_SZ_PCI_IO	0x10000

so you can map the I/O window along with the other static mappings.

This goes along with changing your __io() definition to

#define __io(a)        (((a) & IO_SPACE_LIMIT) + W90X900_VA_PCI_IO)

> +#define NUC900_PCI_MEM_BASE	0xC0000000
> +#define NUC900_PCI_MEM_END	0xDFFFEFFFF
> +#define NUC900_PCI_MEM_SIZE	0x20000000

This probably fits there, too, so you can remove the pci header file.

> diff --git a/arch/arm/mach-w90x900/nuc960.c b/arch/arm/mach-w90x900/nuc960.c
> index 8851a3a..0212964 100644
> --- a/arch/arm/mach-w90x900/nuc960.c
> +++ b/arch/arm/mach-w90x900/nuc960.c
> @@ -19,6 +19,7 @@
>  #include <asm/mach/map.h>
>  #include <mach/hardware.h>
>  #include "cpu.h"
> +#include "clock.h"
> 
>  /* define specific CPU platform device */
> 
> @@ -30,6 +31,7 @@ static struct platform_device *nuc960_dev[] __initdata = {
>  /* define specific CPU platform io map */
> 
>  static struct map_desc nuc960evb_iodesc[] __initdata = {
> +	IODESC_ENT(PCI),
>  };

It seems that you don't currently map the I/O window, which is a bug
and means that you cannot use any card with PIO resources.

> +static int nuc900_read_config(struct pci_bus *bus, unsigned int devfn,
> +				int where,  int size, unsigned int  *val)
> +{
> +	unsigned int v;
> +
> +	__raw_writel(devfn * 0x100 + (where & 0xfffffffc), REG_CFGADDR);
> +	v = __raw_readl(REG_CFGDATA);
> +	switch (size) {

Please use writel_relaxed/readl_relaxed instead of the __raw versions
for new code.

> +static struct pci_ops pci_nuc900_ops = {
> +	.read	= nuc900_read_config,
> +	.write	= nuc900_write_config,
> +};
> +
> +static struct resource pci_io = {
> +	.name	= "NUC900 PCI IO",
> +	.start	= NUC900_PCI_IO_BASE,
> +	.end	= NUC900_PCI_IO_BASE + NUC900_PCI_IO_SIZE - 1,
> +	.flags	= IORESOURCE_IO,
> +};

As Russell mentioned, the I/O space window itself is not an IORESOURCE_IO
resource. Just register it using request_mem_region, or at least make
it IORESOURCE_MEM and register it to iomem_resource.

> +	__raw_writel(RESET_VAL1, REG_PCICTR);
> +
> +	mdelay(100);
> +
> +	__raw_writel(RESET_VAL2, REG_PCICTR);
> +
> +	mdelay(200);
> +}

Using mdelay is rather rude, especially in code that is actually allowed to
sleep. Better use msleep here, or (even better) find a way to detect from
the hardware if you have waited long enough, using a small msleep to back
off while waiting.

Not specific to your driver, I'm wondering whether we should start moving
pci host drivers to some new directory under drivers/pci/, similar to what
we do in other subsystems. Unfortunately, pci host drivers are rather
architecture specific right now, so we might have to clean that up first:
If we move a PCI host driver to an arch independent place, it should
really work on anything that has the same hardware interface.

	Arnd
