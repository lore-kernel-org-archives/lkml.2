Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618Ab1HYP0j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:26:39 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:49444 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886Ab1HYP0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:26:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: David Brown <davidb@codeaurora.org>
Subject: Re: [PATCH v3 4/4] ARM: msm: Describe MSM 8660 SURF FPGA registers in DT
Date: Thu, 25 Aug 2011 17:26:32 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Russell King <linux@arm.linux.org.uk>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Boyd <sboyd@codeaurora.org>
References: <1313688345-17699-1-git-send-email-davidb@codeaurora.org> <201108251327.13146.arnd@arndb.de> <20110825145736.GA31331@huya.qualcomm.com>
In-Reply-To: <20110825145736.GA31331@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108251726.32689.arnd@arndb.de>
X-Provags-ID: V02:K0:wR/Ogh2bDJwoJLnCNSMJPtJikwHddgpqx9IZoRJgJOl
 BeNdoCu6bnf5hx8dvpw4oWpdTfsEDo8b//xE+JllZJnwtLxCIo
 agzs+DsiGH80PiczHEqSlw6mlFvWc6W71E+uptDLm6Qp7Enynf
 0VH9TJRZHv7rN5vlMeAxnMJbJclmvcytcf7WdOrzVJDtHQdzkK
 AlF0TAZ6O8PI2Rh54DMHg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 August 2011, David Brown wrote:
> On Thu, Aug 25, 2011 at 01:27:12PM +0200, Arnd Bergmann wrote:
> > On Thursday 18 August 2011, David Brown wrote:
> > > +static void __init msm8660_surf_fpga_init(void __iomem *fpga_mem)
> > > +{
> > > +       /* Advanced mode */
> > > +       writew(0xFFFF, fpga_mem + 0x15C);
> > > +       /* FPGA_UART_SEL */
> > > +       writew(0, fpga_mem + 0x172);
> > > +       /* FPGA_GPIO_CONFIG_117 */
> > > +       writew(1, fpga_mem + 0xEA);
> > > +       /* FPGA_GPIO_CONFIG_118 */
> > > +       writew(1, fpga_mem + 0xEC);
> > > +       dmb();
> > > +}
> > 
> > Does the dmb() do the right thing here? It seems strange to combine a strictly
> > ordered I/O instruction with another ordering instruction, and I think it would
> > be better to use writew_relaxed for the first one, followed by a 'wmb()'.
> 
> I guess I didn't really think about that, I just kind of kept the
> code.  I'll ask Stepan why he did it that way, and come up with a
> cleaner solution.

Yes, no worries. I saw later that the code already exists in similar form,
so it is not urgent to change.

> > > +#ifdef CONFIG_OF
> > > +static void __init msm8660_surf_fpga_init_dt(void)
> > > +{
> > > +       struct device_node *node;
> > > +       void __iomem *fpga_mem;
> > > +
> > > +       node = of_find_compatible_node(NULL, NULL, "qcom,msm8660-surf-fpga");
> > > +       if (!node)
> > > +               return;
> > > +
> > > +       fpga_mem = of_iomap(node, 0);
> > > +       of_node_put(node);
> > > +       if (!fpga_mem) {
> > > +               printk(KERN_ERR "%s: Can't map fpga registers\n", __func__);
> > > +               return;
> > > +       }
> > > +
> > > +       msm8660_surf_fpga_init(fpga_mem);
> > > +       iounmap(fpga_mem);
> > > +}
> > > +#endif
> > 
> > Is the serial port connected through the FPGA or just configured by it?
> 
> The FPGA controls how the UART pins are connected on the development
> board.  The serial port itself is in the MSM, not the FPGA, and on
> other dev boards this isn't needed for the serial port to work.

ok.

> > In the former case, I think it would be better to make this a proper
> > device driver that binds to the qcom,msm8660-surf-fpga device,
> > configures it and then creates the platform_devices for the child
> > nodes (the serial port, possibly others) by calling
> > of_platform_bus_probe.
> 
> It might make sense to have the FPGA as a driver.  I believe it was
> done early to make sure that the pins were configured correctly before
> the serial driver came up.  As far as I can tell, the output pin is
> already configured correctly, so this can actually happen completely
> independently, since early usage of the UART is really only for
> console messages.
> 
> I don't think it makes sense for the serial to be a child node, this
> FPGA configuration is more along the lines of pinmux.  Most
> configurations of this SOC don't have or need this fpga.

Agreed.

> So, if I made it a separate driver, where would it go?  Since this
> board still has platform device support, I suspect the platform data
> needed to describe this device would end up being larger than the
> driver itself.

Excellent question ;-)

When the driver is really small, I would just leave it in the board
file for now, although that might not be a good long-term strategy.
Do we have any similar cases that we can group together with the
fpga to make a subsystem? Maybe it could be a small driver in the
pinmux subsystem when that is established.

	Arnd
