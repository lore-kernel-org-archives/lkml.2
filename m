Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757536Ab1BPB2l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:28:41 -0500
Received: from kroah.org ([198.145.64.141]:39435 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932087Ab1BPAV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:21:59 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:38 2011
Message-Id: <20110216001438.743560914@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:13:14 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>,
        "Fabio M. Di NItto" <fabbione@fabbione.net>
Subject: [137/272] atyfb: Fix bootup hangs on sparc64.
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David S. Miller <davem@davemloft.net>

[ Upstream commit 09798eb9479da3413bdf96e7d22a84d8b21e05e1 ]

After commit 25edd6946a1d74e5e77813c2324a0908c68bcf9e ("sparc64: Get
rid of indirect p1275 PROM call buffer.")  we can't pass virtual
addresses >4GB to PROM calls.

Largely this is never necessary in drivers because we have a copy of
the entire PROM device tree in the kernel and a set of of_*()
interfaces to access it.

Unfortunately there were some lingering prom calls in the atyfb
driver, in particular prom_finddevice() was being called with an
on-stack address which could be anywhere.

This code is actually probing for information we already have, the
PROM choosen console output device is stored in of_console_device so
all of this nasty code consolidates into a one-line comparison.

Next we have some prom_getintdefault() calls which are trivially
transformed into the equivalent of_getintprop_default().

Special thanks to Fabio, who figured out exactly where the bootup
was hanging.  That made this bug trivial to fix.

Reported-by: Fabio M. Di NItto <fabbione@fabbione.net>
Reported-by: Sam Ravnborg <sam@ravnborg.org>
Reported-by: Frans van Berckel <fberckel@xs4all.nl>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Fabio M. Di NItto <fabbione@fabbione.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/video/aty/atyfb_base.c |   27 +++++----------------------
 1 file changed, 5 insertions(+), 22 deletions(-)

--- a/drivers/video/aty/atyfb_base.c
+++ b/drivers/video/aty/atyfb_base.c
@@ -2969,10 +2969,8 @@ static int __devinit atyfb_setup_sparc(s
 {
 	struct atyfb_par *par = info->par;
 	struct device_node *dp;
-	char prop[128];
-	phandle node;
-	int len, i, j, ret;
 	u32 mem, chip_id;
+	int i, j, ret;
 
 	/*
 	 * Map memory-mapped registers.
@@ -3088,23 +3086,8 @@ static int __devinit atyfb_setup_sparc(s
 		aty_st_le32(MEM_CNTL, mem, par);
 	}
 
-	/*
-	 * If this is the console device, we will set default video
-	 * settings to what the PROM left us with.
-	 */
-	node = prom_getchild(prom_root_node);
-	node = prom_searchsiblings(node, "aliases");
-	if (node) {
-		len = prom_getproperty(node, "screen", prop, sizeof(prop));
-		if (len > 0) {
-			prop[len] = '\0';
-			node = prom_finddevice(prop);
-		} else
-			node = 0;
-	}
-
 	dp = pci_device_to_OF_node(pdev);
-	if (node == dp->phandle) {
+	if (dp == of_console_device) {
 		struct fb_var_screeninfo *var = &default_var;
 		unsigned int N, P, Q, M, T, R;
 		u32 v_total, h_total;
@@ -3112,9 +3095,9 @@ static int __devinit atyfb_setup_sparc(s
 		u8 pll_regs[16];
 		u8 clock_cntl;
 
-		crtc.vxres = prom_getintdefault(node, "width", 1024);
-		crtc.vyres = prom_getintdefault(node, "height", 768);
-		var->bits_per_pixel = prom_getintdefault(node, "depth", 8);
+		crtc.vxres = of_getintprop_default(dp, "width", 1024);
+		crtc.vyres = of_getintprop_default(dp, "height", 768);
+		var->bits_per_pixel = of_getintprop_default(dp, "depth", 8);
 		var->xoffset = var->yoffset = 0;
 		crtc.h_tot_disp = aty_ld_le32(CRTC_H_TOTAL_DISP, par);
 		crtc.h_sync_strt_wid = aty_ld_le32(CRTC_H_SYNC_STRT_WID, par);


