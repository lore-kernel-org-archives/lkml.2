Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973Ab2CWJod (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 05:44:33 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:55915 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753618Ab2CWJoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 05:44:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Roland Stigge <stigge@antcom.de>
Subject: Re: [PATCH] USB: gadget driver for LPC32xx
Date: Fri, 23 Mar 2012 08:38:54 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        w.sang@pengutronix.de, kevin.wells@nxp.com,
        linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        srinivas.bakki@nxp.com
References: <1332191930-2433-1-git-send-email-stigge@antcom.de>
In-Reply-To: <1332191930-2433-1-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201203230838.55014.arnd@arndb.de>
X-Provags-ID: V02:K0:m+TRYVohCyBrbBcTsnjskCRbD9dSyF2Y+D4P5H7F+iH
 vX795h729iXo1WOt2qxG0D7lger266lzXpCnpCqeBNtpJ1MSYJ
 l0r/fjqAUHsYZlojy+E9AEDYpOnJZMHNpmNorUjoEiLKnt8C1A
 5m6SmhYkhkhZud/jJb7cD8MiQN8OYgsEMM4h/umgg+0V1KMVei
 XkdTvy/gWIoJaqGDPLw5yArjIoIYliNmmcUhQL+IbYiFKlnscY
 4TX9kU+86QgiVjJ640GJ0mdIAB5zIc2pX0raIumrilmFYSSCQw
 XOi6qtyhG4iMYuA1Y5lTPB+aCXfsdO8AdvsF7V1QK/WB36uOpL
 60VmZ2LMnMmteyYiUHcU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 March 2012, Roland Stigge wrote:
> This patch adds a USB gadget driver.
> 
> Signed-off-by: Roland Stigge <stigge@antcom.de>

Some more comments:
> +
> +	/* DMA support */
> +	dma_addr_t		*udca_v_base;

I think you mean either

	u32 			*udca_v_base;
or
	void			*udca_v_base;

Since it's not a pointer to dma_addr_t variables:
dma_addr_t can be either 32 or 64 bit, depending on
kernel config options, while your hardware certainly
expects a fixed size.


> +/* DD (DMA Descriptor) structure, requires word alignment, this is already
> + * defined in the LPC32XX USB device header file, but this version is slightly
> + * modified to tag some work data with each DMA descriptor. */
> +struct lpc32xx_usbd_dd_gad {
> +       struct lpc32xx_usbd_dd_gad *dd_next_phy;
> +       u32 dd_setup;
> +       dma_addr_t dd_buffer_addr;
> +       u32 dd_status;
> +       dma_addr_t dd_iso_ps_mem_addr;
> +       dma_addr_t this_dma;
> +       u32 iso_status[6]; /* 5 spare */
> +       struct lpc32xx_usbd_dd_gad *dd_next_v;
> +};

If this is a structure that is shared with hardware, it should have no
variable length fields in it, in particular no pointers or dma_addr_t members.

> +	/* Work queues related to I2C support */
> +	struct work_struct	pullup_wq;
> +	struct work_struct	vbus_wq;
> +	struct work_struct	power_wq;

These are not actually work queues, that would be
a workqueue_struct, but they are work elements or
jobs that get sent to the global workqueue.

> +	/* USB device peripheral - various */
> +	struct lpc32xx_ep	ep[NUM_ENDPOINTS];
> +	u32			enabled:1;
> +	u32			clocked:1;
> +	u32			suspended:1;
> +	u32			selfpowered:1;

defining a u32 member with a size other than 32 bits is
a bit confusing. I would suggest turning these into 'bool'
or using a single unsigned long with set_bit()/test_bit()
for clarity.

If you really like bit fields that much, using bool or
unsigned int would be more appropriate.

> +
> +#define ep_dbg(epp, fmt, arg...) \
> +	dev_dbg(epp->udc->dev, "%s:%s: " fmt, epp->ep.name, __func__, ## arg)
> +#define ep_err(epp, fmt, arg...) \
> +	dev_err(epp->udc->dev, "%s:%s: " fmt, epp->ep.name, __func__, ## arg)
> +#define ep_info(epp, fmt, arg...) \
> +	dev_info(epp->udc->dev, "%s:%s: " fmt, epp->ep.name, __func__, ## arg)
> +#define ep_warn(epp, fmt, arg...) \
> +	dev_warn(epp->udc->dev, "%s:%s:" fmt, epp->ep.name, __func__, ## arg)

it seems redundant to pass the name a second time when dev_* already prints
the device name.

> +#define UDCA_BUFF_SIZE (128)
> +
> +#define USB_CTRL		IO_ADDRESS(LPC32XX_CLK_PM_BASE + 0x64)
> +#define USB_CLOCK_MASK		(AHB_M_CLOCK_ON | OTG_CLOCK_ON | \
> +				 DEV_CLOCK_ON | I2C_CLOCK_ON)
> +
> +/* USB_CTRL bit defines */
> +#define USB_SLAVE_HCLK_EN	(1 << 24)
> +#define USB_HOST_NEED_CLK_EN	(1 << 21)
> +#define USB_DEV_NEED_CLK_EN	(1 << 22)
> +
> +#define USB_OTG_CLK_CTRL	IO_ADDRESS(LPC32XX_USB_BASE + 0xFF4)
> +#define USB_OTG_CLK_STAT	IO_ADDRESS(LPC32XX_USB_BASE + 0xFF8)

All the instances of IO_ADDRESS need to be replaced by platform device
resources that you ioremap. In case of the clock register, you should
probably use the clock framework.

> +
> +static void udc_set_address(struct lpc32xx_udc *udc, u32 addr);
> +static int udc_ep_in_req_dma(struct lpc32xx_udc *udc, struct lpc32xx_ep *ep);
> +static int udc_ep_out_req_dma(struct lpc32xx_udc *udc, struct lpc32xx_ep *ep);
> +static int udc_ep0_in_req(struct lpc32xx_udc *udc);
> +static int udc_ep0_out_req(struct lpc32xx_udc *udc);

Best remove any forward declarations by reordering the functions in call order.

> +static void create_debug_file(struct lpc32xx_udc *udc)
> +{
> +	udc->pde = proc_create_data(debug_filename, 0, NULL, &proc_ops, udc);
> +}
> +
> +static void remove_debug_file(struct lpc32xx_udc *udc)
> +{
> +	if (udc->pde)
> +		remove_proc_entry(debug_filename, NULL);
> +}

Do not introduce new driver specific /proc files. Instead, use 
debugfs_create_file() to put the file into debugfs.
> +
> +	/* Discharge VBUS (just in case) */
> +	i2c_write(OTG1_VBUS_DISCHRG, ISP1301_I2C_OTG_CONTROL_1);
> +	mdelay(1);
> +	i2c_write(OTG1_VBUS_DISCHRG,
> +		  (ISP1301_I2C_OTG_CONTROL_1 | ISP1301_I2C_REG_CLEAR_ADDR));

mdelay() is very nasty because it blocks the CPU for a long time.
Use msleep() instead, so another process can do useful work or the
CPU can go into low power during this time.

> +	/* Enable usb_need_clk clock after transceiver is initialized */
> +	__raw_writel((__raw_readl(USB_CTRL) | (1 << 22)), USB_CTRL);

__raw_readl/__raw_writel are not appropriate for device drivers. Better
use readl/writel for normal I/O, or readl_relaxed()/writel_relaxed() if
it's performance critical and you know that the device does not perform
DMA operations that interact with those accesses.

> +/* Enables or disables the USB device pullup via the ISP1301 transceiver */
> +static void isp1301_pullup_set(int en_pullup)
> +{
> +	if (en_pullup)
> +		/* Enable pullup for bus signalling */
> +		i2c_write(OTG1_DP_PULLUP, ISP1301_I2C_OTG_CONTROL_1);
> +	else
> +		/* Enable pullup for bus signalling */
> +		i2c_write(OTG1_DP_PULLUP, (ISP1301_I2C_OTG_CONTROL_1 |
> +					   ISP1301_I2C_REG_CLEAR_ADDR));
> +}
> +
> +static void pullup_work(struct work_struct *work)
> +{
> +	struct lpc32xx_udc *udc =
> +		container_of(work, struct lpc32xx_udc, pullup_wq);
> +
> +	isp1301_pullup_set(udc->pullup);
> +}
> +
> +static void isp1301_pullup_enable(struct lpc32xx_udc *udc, int en_pullup,
> +				  int block)
> +{
> +	if (en_pullup == udc->pullup)
> +		return;
> +
> +	udc->pullup = en_pullup;
> +	if (block)
> +		isp1301_pullup_set(en_pullup);
> +	else
> +		schedule_work(&udc->pullup_wq);
> +}

Can you add a comment here why you need to use a workqueue in the second
case? I assume it's necessary but it's not clear from the code why that
is the case.

> +/*
> + *
> + * USB protocol engine command/data read/write helper functions
> + *
> + */
> +/* Issues a single command to the USB device state machine */
> +static void udc_protocol_cmd_w(struct lpc32xx_udc *udc, u32 cmd)
> +{
> +	u32 pass = 0;
> +	int to;
> +
> +	/* EP may lock on CLRI if this read isn't done */
> +	u32 tmp = __raw_readl(USBD_DEVINTST(udc->udp_baseaddr));
> +	(void) tmp;
> +
> +	while (pass == 0) {
> +		__raw_writel(USBD_CCEMPTY, USBD_DEVINTCLR(udc->udp_baseaddr));
> +
> +		/* Write command code */
> +		__raw_writel(cmd, USBD_CMDCODE(udc->udp_baseaddr));
> +		to = 10000;
> +		while (((__raw_readl(USBD_DEVINTST(udc->udp_baseaddr)) &
> +			 USBD_CCEMPTY) == 0) && (to > 0)) {
> +			to--;
> +		}
> +
> +		if (to > 0)
> +			pass = 1;
> +	}
> +}

This can take an unbounded amount of time. I would suggest you add a
cond_resched() in an appropriate place if you are allowed to sleep here.
if not, it at least do cpu_relax().

>
> +	/*
> +	 * Resources are mapped as follows:
> +	 *  [0] = IORESOURCE_MEM, base address and size of USB space
> +	 *  [1] = IORESOURCE_IRQ, USB device low priority interrupt number
> +	 *  [2] = IORESOURCE_IRQ, USB device high priority interrupt number
> +	 *  [3] = IORESOURCE_IRQ, USB device interrupt number
> +	 *  [4] = IORESOURCE_IRQ, USB transciever interrupt number
> +	 */
> +	if (pdev->num_resources != 5) {
> +		dev_err(udc->dev, "invalid num_resources\n");
> +		return -ENODEV;
> +	}
> +
> +	if (pdev->resource[0].flags != IORESOURCE_MEM) {
> +		dev_err(udc->dev, "invalid resource type\n");
> +		return -ENODEV;
> +	}

This check looks bogus and will probably fail when you move
to device tree based probing.

> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res)
> +		return -ENXIO;
> +
> +	spin_lock_init(&udc->lock);
> +
> +	/* Get IRQs */
> +	for (i = 0; i < 4; i++) {
> +		if (pdev->resource[i + 1].flags != IORESOURCE_IRQ) {
> +			dev_err(udc->dev, "invalid resource type\n");
> +			return -ENODEV;
> +		}
> +		udc->udp_irq[i] = platform_get_irq(pdev, i);
> +	}
> +
> +	udc->io_p_start = res->start;
> +	udc->io_p_size = res->end - res->start + 1;

resource_size()

> +	/* All clocks are now on */
> +	udc->clocked = 1;
> +
> +	retval = i2c_add_driver(&isp1301_driver);
> +	if (retval < 0) {
> +		dev_err(udc->dev, "Failed to add ISP1301 driver\n");
> +		goto i2c_add_fail;
> +	}

You can't register a driver from a probe() function, that would fail horribly
if you have two devices of the same type because each driver can only be
registered once.

> +	i2c_adap = i2c_get_adapter(2);

What is "2"?

> +
> +static int __exit lpc32xx_udc_remove(struct platform_device *pdev)

__devexit

> +
> +static struct platform_driver lpc32xx_udc_driver = {
> +	.remove		= __exit_p(lpc32xx_udc_remove),

			__devexit_p()

	Arnd

