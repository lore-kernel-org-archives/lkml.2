Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292Ab1HYL1V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 07:27:21 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:57549 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204Ab1HYL1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 07:27:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: David Brown <davidb@codeaurora.org>
Subject: Re: [PATCH v3 4/4] ARM: msm: Describe MSM 8660 SURF FPGA registers in DT
Date: Thu, 25 Aug 2011 13:27:12 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Russell King <linux@arm.linux.org.uk>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Boyd <sboyd@codeaurora.org>
References: <1313688345-17699-1-git-send-email-davidb@codeaurora.org> <1313688345-17699-5-git-send-email-davidb@codeaurora.org>
In-Reply-To: <1313688345-17699-5-git-send-email-davidb@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201108251327.13146.arnd@arndb.de>
X-Provags-ID: V02:K0:WFdrwx61OO2hQ06xTL9Zv0J4b9FrGr/c9PfAZzAhF3B
 cC+lA0DYYd1yAyEJxr+fy3/+SWRqgedVmK0BUlvDqJ7zzBIIce
 6fOzG4o13JK9JVVkI76rVh71L2GJHT8biUXhh1YtRc9Rj9DRyW
 R989ohYxaS9D1yRJEwQylhbkDpNC0BD77IqzsY3Mr66MbMWbl1
 Y4iVe56VKOd35zeMrBxgzOdfiffl4o+au3QtdwqeiBAsfT/Xrc
 vppX6DFypwGEeIh2H3Ak+8pVuHjBFXwBis6UseSu0TlInLPDbq
 WgIPcyoHnFPWBPOGcQOYRYd8khjZ9dNVX+uGnY/gNu+xdGQaex
 IwY5lhbvIgCcNnAyrXUs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 August 2011, David Brown wrote:
> +static void __init msm8660_surf_fpga_init(void __iomem *fpga_mem)
> +{
> +       /* Advanced mode */
> +       writew(0xFFFF, fpga_mem + 0x15C);
> +       /* FPGA_UART_SEL */
> +       writew(0, fpga_mem + 0x172);
> +       /* FPGA_GPIO_CONFIG_117 */
> +       writew(1, fpga_mem + 0xEA);
> +       /* FPGA_GPIO_CONFIG_118 */
> +       writew(1, fpga_mem + 0xEC);
> +       dmb();
> +}

Does the dmb() do the right thing here? It seems strange to combine a strictly
ordered I/O instruction with another ordering instruction, and I think it would
be better to use writew_relaxed for the first one, followed by a 'wmb()'.

> +#ifdef CONFIG_OF
> +static void __init msm8660_surf_fpga_init_dt(void)
> +{
> +       struct device_node *node;
> +       void __iomem *fpga_mem;
> +
> +       node = of_find_compatible_node(NULL, NULL, "qcom,msm8660-surf-fpga");
> +       if (!node)
> +               return;
> +
> +       fpga_mem = of_iomap(node, 0);
> +       of_node_put(node);
> +       if (!fpga_mem) {
> +               printk(KERN_ERR "%s: Can't map fpga registers\n", __func__);
> +               return;
> +       }
> +
> +       msm8660_surf_fpga_init(fpga_mem);
> +       iounmap(fpga_mem);
> +}
> +#endif

Is the serial port connected through the FPGA or just configured by it?

In the former case, I think it would be better to make this a proper device driver that
binds to the qcom,msm8660-surf-fpga device, configures it and then creates the
platform_devices for the child nodes (the serial port, possibly others) by calling
of_platform_bus_probe.

	Arnd
