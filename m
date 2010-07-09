Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124Ab0GIUtA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 16:49:00 -0400
Received: from mail.tpi.com ([70.99.223.143]:3622 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753897Ab0GIUs7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 16:48:59 -0400
Message-ID: <4C378B32.9060802@canonical.com>
Date: Fri, 09 Jul 2010 14:48:50 -0600
From: Tim Gardner <tim.gardner@canonical.com>
Reply-To: tim.gardner@canonical.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100528 Thunderbird/3.0.5
MIME-Version: 1.0
To: airlied@linux.ie
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Kees Cook <kees.cook@canonical.com>, chris@chris-wilson.co.uk,
       eric@anholt.net, jbarnes@virtuousgeek.org
Subject: i915 boot regression on Q35 chipset with 2.6.35-rc4
Content-Type: multipart/mixed;
 boundary="------------000106050108090600060006"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000106050108090600060006
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Dave,

Please find attached a patch that fixes a boot time regression caused by 
commit f1befe71fa7a79ab733011b045639d8d809924ad. It has been reported to 
fix at least one user's boot problems.

I think it is also likely the source of the problems reported in 
http://marc.info/?l=linux-kernel&m=127869783002454&w=2

rtg
-- 
Tim Gardner tim.gardner@canonical.com

--------------000106050108090600060006
Content-Type: text/x-patch;
 name="0001-UBUNTU-Upstream-i915-Use-the-correct-mask-to-detect-.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-UBUNTU-Upstream-i915-Use-the-correct-mask-to-detect-.pa";
 filename*1="tch"

>From e025bfb96059be648074a02f60dff92fb658cb9a Mon Sep 17 00:00:00 2001
From: Tim Gardner <tim.gardner@canonical.com>
Date: Fri, 9 Jul 2010 11:14:41 -0600
Subject: [PATCH] i915: Use the correct mask to detect i830 aperture size.

BugLink: https://bugs.launchpad.net/bugs/597075

commit f1befe71fa7a79ab733011b045639d8d809924ad introduced a regression when
detecting aperture size of some i915 adapters, e.g., those on the
Intel Q35 chipset.

The original report: https://bugzilla.kernel.org/show_bug.cgi?id=15733
The regression report: https://bugzilla.kernel.org/show_bug.cgi?id=16294

According to the specification found at http://intellinuxgraphics.org/VOL_1_graphics_core.pdf,
the PCI config space register I830_GMCH_CTRL is a mirror of GMCH Graphics Control. The correct
macro for isolating the aperture size bits is therefore I830_GMCH_GMS_MASK along with the
attendant changes to the case statement.

Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Tested-by: Kees Cook <kees.cook@canonical.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Eric Anholt <eric@anholt.net>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 drivers/char/agp/intel-gtt.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/char/agp/intel-gtt.c b/drivers/char/agp/intel-gtt.c
index 9344216..a754715 100644
--- a/drivers/char/agp/intel-gtt.c
+++ b/drivers/char/agp/intel-gtt.c
@@ -1216,17 +1216,20 @@ static int intel_i915_get_gtt_size(void)
 
 		/* G33's GTT size defined in gmch_ctrl */
 		pci_read_config_word(agp_bridge->dev, I830_GMCH_CTRL, &gmch_ctrl);
-		switch (gmch_ctrl & G33_PGETBL_SIZE_MASK) {
-		case G33_PGETBL_SIZE_1M:
+		switch (gmch_ctrl & I830_GMCH_GMS_MASK) {
+		case I830_GMCH_GMS_STOLEN_512:
+			size = 512;
+			break;
+		case I830_GMCH_GMS_STOLEN_1024:
 			size = 1024;
 			break;
-		case G33_PGETBL_SIZE_2M:
-			size = 2048;
+		case I830_GMCH_GMS_STOLEN_8192:
+			size = 8*1024;
 			break;
 		default:
 			dev_info(&agp_bridge->dev->dev,
 				 "unknown page table size 0x%x, assuming 512KB\n",
-				(gmch_ctrl & G33_PGETBL_SIZE_MASK));
+				(gmch_ctrl & I830_GMCH_GMS_MASK));
 			size = 512;
 		}
 	} else {
-- 
1.7.0.4


--------------000106050108090600060006--
