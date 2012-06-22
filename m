Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762577Ab2FVR01 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 13:26:27 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:56425 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756056Ab2FVR00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 13:26:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH RESEND] of: add const to struct of_device_id.data
Date: Fri, 22 Jun 2012 17:26:22 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>, kernel@pengutronix.de
References: <1335171381-24869-1-git-send-email-u.kleine-koenig@pengutronix.de> <20120607102014.GI22191@pengutronix.de> <20120622055613.GL5642@pengutronix.de>
In-Reply-To: <20120622055613.GL5642@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <201206221726.22285.arnd@arndb.de>
X-Provags-ID: V02:K0:+ywmpfdHmpd2xxGjlExDzVEkMhfYH+R5a9hIVfDdlnN
 00vFBV6oXt+yowwaI+I243w+qPEv2ebqndS3wLgLlFtsTWa1UY
 6bLh+sUazwz2AQTiXFf0LEst6oHcE94+CVVH20dGYmSa1M8W0v
 22C0T0boKFr5jqh+b3FF1EY+GH8Ipm4zM9YZYUIJSt63UkNkvT
 KpO3VbDzFEBerwWah4K1YKSCjpqHGpMPXStEsHLrU5gMcfOH0c
 bDvtpoAxPjHE1AUaz7vzdsQMM6SHydKyYQpvlSndlPkF+4naxO
 DtybPZtgLwMGOF64nZjt4QTJ3oVYPXbyc39kA9DF5gl7CEZj+D
 t+Z88AcUzzVPo4AINPpY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 June 2012, Uwe Kleine-König wrote:
> On Thu, Jun 07, 2012 at 12:20:14PM +0200, Uwe Kleine-König wrote:
> > Drivers should never need to modify the data of a device id. So it can
> > be const which in turn allows more consts in the driver.
> > 
> > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > ---
> > (Cc += lkml + Grant)
> > 
> > Hello,
> > 
> > this might introduce warnings in drivers that access the data member
> > without using const, so this is definitly merge window material if it is
> > considered at all.
>
> ping

Sorry for the delayed response. I think the approach is right, but I
am a bit worried about adding warnings for legit code.

A quick test with the defconfigs gave me this error for prima2_defconfig
and kzm9g_defconfig:

/home/arnd/linux-arm/arch/arm/mm/cache-l2x0.c: In function 'l2x0_of_init':
/home/arnd/linux-arm/arch/arm/mm/cache-l2x0.c:573:7: error: assignment discards 'const' qualifier from pointer target type [-Werror]

and this one with at91sam9263_defconfig:
/home/arnd/linux-arm/drivers/misc/atmel_tclib.c: In function 'tc_probe':
/home/arnd/linux-arm/drivers/misc/atmel_tclib.c:170:19: error: assignment discards 'const' qualifier from pointer target type [-Werror]

I haven't checked all the defconfigs yet, but I think we should at least
make sure they build fine before applying your patch.

	Arnd

8<---
diff --git a/arch/arm/mm/cache-l2x0.c b/arch/arm/mm/cache-l2x0.c
index 2a8e380..577baf7 100644
--- a/arch/arm/mm/cache-l2x0.c
+++ b/arch/arm/mm/cache-l2x0.c
@@ -554,7 +554,7 @@ static const struct of_device_id l2x0_ids[] __initconst = {
 int __init l2x0_of_init(u32 aux_val, u32 aux_mask)
 {
 	struct device_node *np;
-	struct l2x0_of_data *data;
+	const struct l2x0_of_data *data;
 	struct resource res;
 
 	np = of_find_matching_node(NULL, l2x0_ids);
diff --git a/include/linux/atmel_tc.h b/include/linux/atmel_tc.h
index 1d14b1dc..89a931b 100644
--- a/include/linux/atmel_tc.h
+++ b/include/linux/atmel_tc.h
@@ -63,7 +63,7 @@ struct atmel_tc {
 	struct platform_device	*pdev;
 	struct resource		*iomem;
 	void __iomem		*regs;
-	struct atmel_tcb_config	*tcb_config;
+	const struct atmel_tcb_config *tcb_config;
 	int			irq[3];
 	struct clk		*clk[3];
 	struct list_head	node;
