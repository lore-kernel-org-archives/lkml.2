Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322Ab0EDCyB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 22:54:01 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:54600 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754430Ab0EDCx7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 22:53:59 -0400
Date: Tue, 4 May 2010 12:53:55 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Will Deacon <will.deacon@arm.com>, Russell King <rmk@arm.linux.org.uk>,
       Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: linux-next: manual merge of the crypto tree with the arm tree
Message-Id: <20100504125355.810e6f54.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Herbert,

Today's linux-next merge of the crypto tree got a conflict in
arch/arm/mach-omap2/devices.c between commit
883413341e479d4e9f9c69def4884b4c6e1cef4e ("ARM: 6046/1: ARM: OMAP:
register PMU IRQs during board initialisation") from the arm tree and
commit ee5500c45c4860a84bba502c6d9ef5af6395dad6 ("crypto: omap - Updates
omap sham device related platform code") from the crypto tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-omap2/devices.c
index 12154d1,beac46c..0000000
--- a/arch/arm/mach-omap2/devices.c
+++ b/arch/arm/mach-omap2/devices.c
@@@ -455,39 -454,10 +456,41 @@@ static void omap_init_mcspi(void
  static inline void omap_init_mcspi(void) {}
  #endif
  
 +static struct resource omap2_pmu_resource = {
 +	.start	= 3,
 +	.end	= 3,
 +	.flags	= IORESOURCE_IRQ,
 +};
 +
 +static struct resource omap3_pmu_resource = {
 +	.start	= INT_34XX_BENCH_MPU_EMUL,
 +	.end	= INT_34XX_BENCH_MPU_EMUL,
 +	.flags	= IORESOURCE_IRQ,
 +};
 +
 +static struct platform_device omap_pmu_device = {
 +	.name		= "arm-pmu",
 +	.id		= ARM_PMU_DEVICE_CPU,
 +	.num_resources	= 1,
 +};
 +
 +static void omap_init_pmu(void)
 +{
 +	if (cpu_is_omap24xx())
 +		omap_pmu_device.resource = &omap2_pmu_resource;
 +	else if (cpu_is_omap34xx())
 +		omap_pmu_device.resource = &omap3_pmu_resource;
 +	else
 +		return;
 +
 +	platform_device_register(&omap_pmu_device);
 +}
 +
 +
- #ifdef CONFIG_OMAP_SHA1_MD5
- static struct resource sha1_md5_resources[] = {
+ #if defined(CONFIG_CRYPTO_DEV_OMAP_SHAM) || defined(CONFIG_CRYPTO_DEV_OMAP_SHAM_MODULE)
+ 
+ #ifdef CONFIG_ARCH_OMAP24XX
+ static struct resource omap2_sham_resources[] = {
  	{
  		.start	= OMAP24XX_SEC_SHA1MD5_BASE,
  		.end	= OMAP24XX_SEC_SHA1MD5_BASE + 0x64,
@@@ -830,10 -835,9 +868,10 @@@ static int __init omap2_init_devices(vo
  	omap_init_camera();
  	omap_init_mbox();
  	omap_init_mcspi();
 +	omap_init_pmu();
  	omap_hdq_init();
  	omap_init_sti();
- 	omap_init_sha1_md5();
+ 	omap_init_sham();
  
  	return 0;
  }
