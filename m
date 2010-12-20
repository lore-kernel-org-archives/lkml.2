Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933207Ab0LTVHD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 16:07:03 -0500
Received: from mga09.intel.com ([134.134.136.24]:23686 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933068Ab0LTVHB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 16:07:01 -0500
Message-Id: <0d30dc$kh41r4@orsmga001.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,203,1291622400"; 
   d="scan'208";a="689047396"
Date: Mon, 20 Dec 2010 21:06:47 +0000
To: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [BISECTED] agp/intel: revert "Remove confusion of stolen entries not stolen memory"
Cc: linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>
In-Reply-To: <201012202152.38863.arnd@arndb.de>
References: <201012201912.19051.arnd@arndb.de> <201012202047.08544.arnd@arndb.de> <0d30dc$kh3cm9@orsmga001.jf.intel.com> <201012202152.38863.arnd@arndb.de>
From: Chris Wilson <chris@chris-wilson.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Dec 2010 21:52:38 +0100, Arnd Bergmann <arnd@arndb.de> wrote:
> On Monday 20 December 2010 20:52:07 Chris Wilson wrote:
> > 
> > Also, which modules do you have loaded when using VESA? i.e. is the
> > i915.ko loaded, but in UMS mode (i915.modeset=0)?
> 
> This doesn't seem to matter, as far as I can tell, i915 can be loaded
> or now.

Thanks, that rules out the likely explanation that we [i915] loaded the
GTT with some conflicting entries. Instead it is likely the initialisation
of the GTT to point to the scratch page that is triggering the problem.
Can you try disabling it with:

diff --git a/drivers/char/agp/intel-gtt.c b/drivers/char/agp/intel-gtt.c
index 356f73e..238848e 100644
--- a/drivers/char/agp/intel-gtt.c
+++ b/drivers/char/agp/intel-gtt.c
@@ -867,11 +867,13 @@ static int intel_fake_agp_configure(void)
 
 	agp_bridge->gart_bus_addr = intel_private.gma_bus_addr;
 
+#if 0
 	for (i = 0; i < intel_private.base.gtt_total_entries; i++) {
 		intel_private.driver->write_entry(intel_private.scratch_page_dma,
 						  i, 0);
 	}
 	readl(intel_private.gtt+i-1);	/* PCI Posting. */
+#endif
 
 	global_cache_flush();

> I've seen the system crash once while loading i915 with
> modeset=1 and my revert patch applied and backed it out.
> 
> After that, I could no longer even get i915 to do modesetting,
> the ioremap in intel_opregion_setup now fails because reserve_memtype
> decides that the opregion should be write-back when we ask for
> an uncached mapping. That's probably an unrelated problem, but
> I'm mentioning it anyway in case it's significant.

I hope not. But it sounds like we're in for a turbulent ride if ioremap is
failing in -next.

Thanks,
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
