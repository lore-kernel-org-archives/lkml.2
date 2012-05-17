Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778Ab2EQUmU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 16:42:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34001 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500Ab2EQUmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 16:42:17 -0400
Date: Thu, 17 May 2012 13:42:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: <spear-devel@list.st.com>, <viresh.linux@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <mturquette@linaro.org>, <sshtylyov@mvista.com>, <jgarzik@redhat.com>,
        <linux@arm.linux.org.uk>, <w.sang@pengutronix.de>,
        <LW@KARO-electronics.de>, <andrew@lunn.ch>,
        <linux-ide@vger.kernel.org>
Subject: Re: [PATCH V3 Resend 07/12] ata/sata_mv: Remove conditional
 compilation of clk code
Message-Id: <20120517134216.8590c88a.akpm@linux-foundation.org>
In-Reply-To: <ae865cae6b4961dea0e48d07da74b181c3958507.1336448639.git.viresh.kumar@st.com>
References: <cover.1336448639.git.viresh.kumar@st.com>
	<ae865cae6b4961dea0e48d07da74b181c3958507.1336448639.git.viresh.kumar@st.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2012 09:22:34 +0530
Viresh Kumar <viresh.kumar@st.com> wrote:

> With addition of dummy clk_*() calls for non CONFIG_HAVE_CLK cases in clk.h,
> there is no need to have clk code enclosed in #ifdef CONFIG_HAVE_CLK, #endif
> macros.

There have been significant changes to drivers/ata/sata_mv.c in
linux-next so I have reworked the patch as below.

I notice that with x86_64 allmodconfig (CONFIG_HAVE_CLK=n), this patch
adds quite a lot of program text:

   text    data     bss     dec     hex filename
  26926    2657    7648   37231    916f drivers/ata/sata_mv.o
  27528    2657    7832   38017    9481 drivers/ata/sata_mv.o

This is an unacceptable increase for a purely cosmetic change!

For some reason,
ata-pata_arasan-remove-conditional-compilation-of-clk-code.patch
shrinks drivers/ata/pata_arasan_cf.o by 60 bytes, so that's good.

drivers/net/can/c_can/c_can_platform.o got 18 bytes bigger, which we
can live with.



I checked a few other patches and didn't see similar code bloat.

I note that usb-musb-remove-conditional-compilation-of-clk-code.patch
accidentally fixed the build of drivers/usb/musb/ux500.c.  In the
mainline kernel I get

drivers/usb/musb/ux500.c: In function 'ux500_probe':
drivers/usb/musb/ux500.c:89: error: expected expression before 'do'
drivers/usb/musb/ux500.c: In function 'ux500_resume':
drivers/usb/musb/ux500.c:175: error: expected expression before 'do'

possibly because this driver isn't supposed to be built with x86_64
allmodconfig, but someone obviously has a borked clk_enable()
definition.  drivers/usb/gadget/pxa25x_udc.c does it wrongly.

Anyway, I will drop
ata-sata_mv-remove-conditional-compilation-of-clk-code.patch - please
grab current linux-next and see what we can do about the code size
issue?

Thanks.


From: Viresh Kumar <viresh.kumar@st.com>
Subject: ata/sata_mv: remove conditional compilation of clk code

With addition of dummy clk_*() calls for non CONFIG_HAVE_CLK cases in
clk.h, there is no need to have clk code enclosed in #ifdef
CONFIG_HAVE_CLK, #endif macros.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Cc: Jeff Garzik <jgarzik@redhat.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/sata_mv.c |   14 --------------
 1 file changed, 14 deletions(-)

diff -puN drivers/ata/sata_mv.c~ata-sata_mv-remove-conditional-compilation-of-clk-code drivers/ata/sata_mv.c
--- a/drivers/ata/sata_mv.c~ata-sata_mv-remove-conditional-compilation-of-clk-code
+++ a/drivers/ata/sata_mv.c
@@ -551,10 +551,8 @@ struct mv_host_priv {
 	u32			irq_mask_offset;
 	u32			unmask_all_irqs;
 
-#if defined(CONFIG_HAVE_CLK)
 	struct clk		*clk;
 	struct clk              **port_clks;
-#endif
 	/*
 	 * These consistent DMA memory pools give us guaranteed
 	 * alignment for hardware-accessed data structures,
@@ -4028,9 +4026,7 @@ static int mv_platform_probe(struct plat
 	struct resource *res;
 	int n_ports = 0;
 	int rc;
-#if defined(CONFIG_HAVE_CLK)
 	int port;
-#endif
 
 	ata_print_version_once(&pdev->dev, DRV_VERSION);
 
@@ -4058,13 +4054,11 @@ static int mv_platform_probe(struct plat
 
 	if (!host || !hpriv)
 		return -ENOMEM;
-#if defined(CONFIG_HAVE_CLK)
 	hpriv->port_clks = devm_kzalloc(&pdev->dev,
 					sizeof(struct clk *) * n_ports,
 					GFP_KERNEL);
 	if (!hpriv->port_clks)
 		return -ENOMEM;
-#endif
 	host->private_data = hpriv;
 	hpriv->n_ports = n_ports;
 	hpriv->board_idx = chip_soc;
@@ -4074,7 +4068,6 @@ static int mv_platform_probe(struct plat
 				   resource_size(res));
 	hpriv->base -= SATAHC0_REG_BASE;
 
-#if defined(CONFIG_HAVE_CLK)
 	hpriv->clk = clk_get(&pdev->dev, NULL);
 	if (IS_ERR(hpriv->clk))
 		dev_notice(&pdev->dev, "cannot get optional clkdev\n");
@@ -4088,7 +4081,6 @@ static int mv_platform_probe(struct plat
 		if (!IS_ERR(hpriv->port_clks[port]))
 			clk_prepare_enable(hpriv->port_clks[port]);
 	}
-#endif
 
 	/*
 	 * (Re-)program MBUS remapping windows if we are asked to.
@@ -4115,7 +4107,6 @@ static int mv_platform_probe(struct plat
 		return 0;
 
 err:
-#if defined(CONFIG_HAVE_CLK)
 	if (!IS_ERR(hpriv->clk)) {
 		clk_disable_unprepare(hpriv->clk);
 		clk_put(hpriv->clk);
@@ -4126,7 +4117,6 @@ err:
 			clk_put(hpriv->port_clks[port]);
 		}
 	}
-#endif
 
 	return rc;
 }
@@ -4142,13 +4132,10 @@ err:
 static int __devexit mv_platform_remove(struct platform_device *pdev)
 {
 	struct ata_host *host = platform_get_drvdata(pdev);
-#if defined(CONFIG_HAVE_CLK)
 	struct mv_host_priv *hpriv = host->private_data;
 	int port;
-#endif
 	ata_host_detach(host);
 
-#if defined(CONFIG_HAVE_CLK)
 	if (!IS_ERR(hpriv->clk)) {
 		clk_disable_unprepare(hpriv->clk);
 		clk_put(hpriv->clk);
@@ -4159,7 +4146,6 @@ static int __devexit mv_platform_remove(
 			clk_put(hpriv->port_clks[port]);
 		}
 	}
-#endif
 	return 0;
 }
 
_

