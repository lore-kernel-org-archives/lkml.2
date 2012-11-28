Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543Ab2K1Q5k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 11:57:40 -0500
Received: from mail.kernel.org ([198.145.19.201]:54111 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754742Ab2K1Q50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 11:57:26 -0500
Date: Wed, 28 Nov 2012 08:57:19 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Eli Billauer <eli.billauer@gmail.com>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [PATCH 2/2] New driver: Xillybus generic interface for FPGA
 (programmable logic)
Message-ID: <20121128165719.GB31314@kroah.com>
References: <1354117293-13632-1-git-send-email-eli.billauer@gmail.com>
 <1354117293-13632-2-git-send-email-eli.billauer@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354117293-13632-2-git-send-email-eli.billauer@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 05:41:33PM +0200, Eli Billauer wrote:
> Xillybus is a general-purpose framework for communication between programmable
> logic (FPGA) and a host. It provides a simple connection between hardware FIFOs
> in the FPGA and their respective device files on the host. The user space
> programming model is like piping data from or to the FPGA.
> 
> The underlying transport between the host and FPGA is either PCIe or AXI
> (AMBA bus by ARM).
> 
> The Xillybus logic (IP core) is configurable in the number of pipes it presents
> and their nature. The driver autodetects these pipes, making it essentially
> forward-compatible to future configurations. The benefit of having this driver
> enabled in the kernel is that hardware vendors may release a new card, knowing
> that it will work out of the box on any future Linux machine, with the specific
> configuration defined for the FPGA part.

What is the user/kernel interface for this driver?  Is it documented
anywhere?

> +config XILLYBUS
> +	tristate "Xillybus Support"
> +	depends on PCI || (OF_ADDRESS && OF_DEVICE && OF_IRQ)
> +	default m

Never default to on, unless you can not boot a box without this option.

> +	help
> +	  Xillybus is a generic interface for peripherals designed on
> +	  programmable logic (FPGA). The driver probes the hardware for
> +	  its capabilities, and creates device files accordingly.
> +
> +	  If unsure, say M.
> +
> +config XILLYBUS_PCIE
> +	bool "Xillybus over PCIe"
> +	depends on XILLYBUS && PCI
> +	default y

Same here.

> +	help
> +	  Set to Y if you want Xillybus to use PCI Express for communicating
> +	  with the FPGA. This option is harmless, but it requires PCI
> +	  support on the kernel. Say Y if the target processor supports
> +	  PCI and/or PCIe.
> +
> +config XILLYBUS_OF
> +	bool "Xillybus over Device Tree"
> +	depends on XILLYBUS && OF_ADDRESS && OF_DEVICE && OF_IRQ
> +	default y

Same here.

> +	help
> +	  Set to Y if you want Xillybus to find its resources from the
> +	  Open Firmware Flattened Device Tree. If the target is an embedded
> +	  system, say Y.  This option is harmless, but it requires Device
> +	  Tree support on the kernel, which is usually not the case for
> +	  kernels for fullblown computers.
> +

Shouldn't both of these options be different modules with a shared core,
instead of a single driver with lots of #ifdefs all over the place,
making it more complex?


>  source "drivers/misc/c2port/Kconfig"
>  source "drivers/misc/eeprom/Kconfig"
>  source "drivers/misc/cb710/Kconfig"
> diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
> index 2129377..fcac6cb 100644
> --- a/drivers/misc/Makefile
> +++ b/drivers/misc/Makefile
> @@ -49,3 +49,4 @@ obj-y				+= carma/
>  obj-$(CONFIG_USB_SWITCH_FSA9480) += fsa9480.o
>  obj-$(CONFIG_ALTERA_STAPL)	+=altera-stapl/
>  obj-$(CONFIG_INTEL_MEI)		+= mei/
> +obj-$(CONFIG_XILLYBUS)		+= xillybus.o
> diff --git a/drivers/misc/xillybus.c b/drivers/misc/xillybus.c
> new file mode 100644
> index 0000000..0b937c2
> --- /dev/null
> +++ b/drivers/misc/xillybus.c
> @@ -0,0 +1,2845 @@
> +#include <linux/version.h>

You don't need this include file.

No copyright notice at the top of the file?

> +#include <linux/list.h>
> +#include <linux/device.h>
> +#include <linux/module.h>
> +#include <linux/io.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/interrupt.h>
> +#include <linux/sched.h>
> +#include <linux/fs.h>
> +#include <linux/cdev.h>
> +#include <linux/spinlock.h>
> +#include <linux/mutex.h>
> +#include <linux/list.h>
> +#include <linux/crc32.h>
> +#include <linux/poll.h>
> +#include <linux/delay.h>
> +#include <linux/io.h>
> +#include <linux/slab.h>
> +#include <linux/workqueue.h>
> +#ifdef CONFIG_XILLYBUS_PCIE
> +#include <linux/pci.h>
> +#include <linux/pci-aspm.h>
> +#endif
> +
> +#ifdef CONFIG_XILLYBUS_OF
> +#include <linux/platform_device.h>
> +#include <linux/of.h>
> +#include <linux/of_irq.h>
> +#include <linux/of_address.h>
> +#include <linux/of_device.h>
> +#include <linux/of_platform.h>
> +#endif
> +
> +MODULE_DESCRIPTION("Xillybus driver");
> +MODULE_AUTHOR("Eli Billauer, Xillybus Ltd.");
> +MODULE_VERSION("1.06");
> +MODULE_ALIAS("xillybus");
> +MODULE_LICENSE("GPL v2");
> +
> +/* General timeout is 100 ms, rx timeout is 10 ms */
> +#define XILLY_RX_TIMEOUT (10*HZ/1000)
> +#define XILLY_TIMEOUT (100*HZ/1000)
> +
> +#define fpga_msg_ctrl_reg 0x0002
> +#define fpga_dma_control_reg 0x0008
> +#define fpga_dma_bufno_reg 0x0009
> +#define fpga_dma_bufaddr_lowaddr_reg 0x000a
> +#define fpga_dma_bufaddr_highaddr_reg 0x000b
> +#define fpga_buf_ctrl_reg 0x000c
> +#define fpga_buf_offset_reg 0x000d
> +#define fpga_endian_reg 0x0010
> +
> +#define XILLYMSG_OPCODE_RELEASEBUF 1
> +#define XILLYMSG_OPCODE_QUIESCEACK 2
> +#define XILLYMSG_OPCODE_FIFOEOF 3
> +#define XILLYMSG_OPCODE_FATAL_ERROR 4
> +#define XILLYMSG_OPCODE_NONEMPTY 5
> +
> +#if (PAGE_SIZE < 4096)
> +#error Your processor architecture has a page size smaller than 4096
> +#endif

That can never happen.  Even if it does, you don't care about that in
the driver.

> +
> +#ifdef CONFIG_XILLYBUS_OF
> +/* Match table for of_platform binding */
> +static struct of_device_id xillybus_of_match[] __devinitdata = {
> +	{ .compatible = "xlnx,xillybus-1.00.a", },
> +	{}
> +};
> +
> +MODULE_DEVICE_TABLE(of, xillybus_of_match);
> +#endif
> +
> +static struct class *xillybus_class;

Why not just use the misc interface instead of your own class?

> +#ifdef CONFIG_XILLYBUS_PCIE
> +static int xilly_probe_or_remove(struct pci_dev *pdev,
> +				 const struct pci_device_id *ent,
> +				 const int what_to_do)
> +{

Why would you call the same function for both probe and release?  That
is very odd.

> +	struct xilly_endpoint *endpoint;
> +	int rc = 0;
> +
> +	if (!what_to_do) {
> +		endpoint = pci_get_drvdata(pdev);
> +		endpoint_discovery_or_remove(endpoint, 1);
> +		goto release;

That's all you need for the remove function, don't try to put them both
in the same function.


> +static int __devinit xilly_probe(struct pci_dev *pdev,
> +				 const struct pci_device_id *ent)
> +{
> +	return xilly_probe_or_remove(pdev, ent, 1);
> +}
> +
> +MODULE_DEVICE_TABLE(pci, xillyids);

You can use the pci_module_init() function instead.

> +
> +static struct pci_driver xillybus_driver = {
> +	.name = (char *) xillyname,

Why are you casting this?  That implies that the original variable isn't
correct :)

> +	.id_table = xillyids,
> +	.probe = xilly_probe,
> +	.remove = __devexit_p(xilly_remove),

__devexit_p is going away, please don't use it.

thanks,

greg k-h
