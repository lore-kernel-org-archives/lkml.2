Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748Ab1HYO5l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 10:57:41 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:23857 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612Ab1HYO5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 10:57:38 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6448"; a="112887961"
Date: Thu, 25 Aug 2011 07:57:36 -0700
From: David Brown <davidb@codeaurora.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: David Brown <davidb@codeaurora.org>, Russell King <linux@arm.linux.org.uk>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH v3 4/4] ARM: msm: Describe MSM 8660 SURF FPGA registers
 in DT
Message-ID: <20110825145736.GA31331@huya.qualcomm.com>
References: <1313688345-17699-1-git-send-email-davidb@codeaurora.org>
 <1313688345-17699-5-git-send-email-davidb@codeaurora.org>
 <201108251327.13146.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201108251327.13146.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 01:27:12PM +0200, Arnd Bergmann wrote:
> On Thursday 18 August 2011, David Brown wrote:
> > +static void __init msm8660_surf_fpga_init(void __iomem *fpga_mem)
> > +{
> > +       /* Advanced mode */
> > +       writew(0xFFFF, fpga_mem + 0x15C);
> > +       /* FPGA_UART_SEL */
> > +       writew(0, fpga_mem + 0x172);
> > +       /* FPGA_GPIO_CONFIG_117 */
> > +       writew(1, fpga_mem + 0xEA);
> > +       /* FPGA_GPIO_CONFIG_118 */
> > +       writew(1, fpga_mem + 0xEC);
> > +       dmb();
> > +}
> 
> Does the dmb() do the right thing here? It seems strange to combine a strictly
> ordered I/O instruction with another ordering instruction, and I think it would
> be better to use writew_relaxed for the first one, followed by a 'wmb()'.

I guess I didn't really think about that, I just kind of kept the
code.  I'll ask Stepan why he did it that way, and come up with a
cleaner solution.

> > +#ifdef CONFIG_OF
> > +static void __init msm8660_surf_fpga_init_dt(void)
> > +{
> > +       struct device_node *node;
> > +       void __iomem *fpga_mem;
> > +
> > +       node = of_find_compatible_node(NULL, NULL, "qcom,msm8660-surf-fpga");
> > +       if (!node)
> > +               return;
> > +
> > +       fpga_mem = of_iomap(node, 0);
> > +       of_node_put(node);
> > +       if (!fpga_mem) {
> > +               printk(KERN_ERR "%s: Can't map fpga registers\n", __func__);
> > +               return;
> > +       }
> > +
> > +       msm8660_surf_fpga_init(fpga_mem);
> > +       iounmap(fpga_mem);
> > +}
> > +#endif
> 
> Is the serial port connected through the FPGA or just configured by it?

The FPGA controls how the UART pins are connected on the development
board.  The serial port itself is in the MSM, not the FPGA, and on
other dev boards this isn't needed for the serial port to work.

> In the former case, I think it would be better to make this a proper
> device driver that binds to the qcom,msm8660-surf-fpga device,
> configures it and then creates the platform_devices for the child
> nodes (the serial port, possibly others) by calling
> of_platform_bus_probe.

It might make sense to have the FPGA as a driver.  I believe it was
done early to make sure that the pins were configured correctly before
the serial driver came up.  As far as I can tell, the output pin is
already configured correctly, so this can actually happen completely
independently, since early usage of the UART is really only for
console messages.

I don't think it makes sense for the serial to be a child node, this
FPGA configuration is more along the lines of pinmux.  Most
configurations of this SOC don't have or need this fpga.

So, if I made it a separate driver, where would it go?  Since this
board still has platform device support, I suspect the platform data
needed to describe this device would end up being larger than the
driver itself.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
