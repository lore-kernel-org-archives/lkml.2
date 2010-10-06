Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758391Ab0JFDVO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 23:21:14 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:52548 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754007Ab0JFDVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 23:21:13 -0400
Date: Wed, 6 Oct 2010 14:21:10 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Charulatha V <charu@ti.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Tony Lindgren <tony@atomide.com>, <linux-omap@vger.kernel.org>
Subject: linux-next: manual merge of the staging-next tree with the omap
 tree
Message-Id: <20101006142110.e757f27c.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Today's linux-next merge of the staging-next tree got a conflict in
arch/arm/plat-omap/devices.c between commit
f2ce62312650211f6cf665cd6dc519c334c4071e ("OMAP: WDT: Split OMAP1 and
OMAP2PLUS device registration") from the omap tree and commit
90173882ed15a8034d6d162da5f343a2c7d87587 ("omap: add dsp platform
device") from the staging-next tree.

Just overlapping removal/additions (I think).  I fixed it up (see below)
and can carry the changes as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/plat-omap/devices.c
index 1e2383e,4c8f9b9..0000000
--- a/arch/arm/plat-omap/devices.c
+++ b/arch/arm/plat-omap/devices.c
@@@ -231,6 -233,75 +232,35 @@@ static void omap_init_uwire(void
  static inline void omap_init_uwire(void) {}
  #endif
  
 -/*-------------------------------------------------------------------------*/
 -
 -#if	defined(CONFIG_OMAP_WATCHDOG) || defined(CONFIG_OMAP_WATCHDOG_MODULE)
 -
 -static struct resource wdt_resources[] = {
 -	{
 -		.flags		= IORESOURCE_MEM,
 -	},
 -};
 -
 -static struct platform_device omap_wdt_device = {
 -	.name	   = "omap_wdt",
 -	.id	     = -1,
 -	.num_resources	= ARRAY_SIZE(wdt_resources),
 -	.resource	= wdt_resources,
 -};
 -
 -static void omap_init_wdt(void)
 -{
 -	if (cpu_is_omap16xx())
 -		wdt_resources[0].start = 0xfffeb000;
 -	else if (cpu_is_omap2420())
 -		wdt_resources[0].start = 0x48022000; /* WDT2 */
 -	else if (cpu_is_omap2430())
 -		wdt_resources[0].start = 0x49016000; /* WDT2 */
 -	else if (cpu_is_omap343x())
 -		wdt_resources[0].start = 0x48314000; /* WDT2 */
 -	else if (cpu_is_omap44xx())
 -		wdt_resources[0].start = 0x4a314000;
 -	else
 -		return;
 -
 -	wdt_resources[0].end = wdt_resources[0].start + 0x4f;
 -
 -	(void) platform_device_register(&omap_wdt_device);
 -}
 -#else
 -static inline void omap_init_wdt(void) {}
 -#endif
 -
+ #if defined(CONFIG_TIDSPBRIDGE) || defined(CONFIG_TIDSPBRIDGE_MODULE)
+ 
+ static phys_addr_t omap_dsp_phys_mempool_base;
+ 
+ void __init omap_dsp_reserve_sdram_memblock(void)
+ {
+ 	phys_addr_t size = CONFIG_TIDSPBRIDGE_MEMPOOL_SIZE;
+ 	phys_addr_t paddr;
+ 
+ 	if (!size)
+ 		return;
+ 
+ 	paddr = __memblock_alloc_base(size, SZ_1M, MEMBLOCK_REAL_LIMIT);
+ 	if (!paddr) {
+ 		pr_err("%s: failed to reserve %x bytes\n",
+ 				__func__, size);
+ 		return;
+ 	}
+ 
+ 	omap_dsp_phys_mempool_base = paddr;
+ }
+ 
+ phys_addr_t omap_dsp_get_mempool_base(void)
+ {
+ 	return omap_dsp_phys_mempool_base;
+ }
+ EXPORT_SYMBOL(omap_dsp_get_mempool_base);
+ #endif
+ 
  /*
   * This gets called after board-specific INIT_MACHINE, and initializes most
   * on-chip peripherals accessible on this board (except for few like USB):
