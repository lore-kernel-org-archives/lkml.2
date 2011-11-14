Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340Ab1KNQzE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 11:55:04 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:49355 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123Ab1KNQzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 11:55:01 -0500
Date: Mon, 14 Nov 2011 17:54:59 +0100
From: Borislav Petkov <bp@amd64.org>
To: Niklas =?iso-8859-1?Q?S=F6derlund?= 
	<niklas.soderlund@ericsson.com>
Cc: Tony Luck <tony.luck@gmail.com>,
        "dougthompson@xmission.com" <dougthompson@xmission.com>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] amd64_edac: Fix K8 revD and later chip select sizes
Message-ID: <20111114165459.GA29762@aftab>
References: <1320849178-23340-1-git-send-email-niklas.soderlund@ericsson.com>
 <20111109144258.GD30472@aftab>
 <4EBA98A1.90902@ericsson.com>
 <20111109203546.GI14181@aftab>
 <CA+8MBbLuhhTZW9vB7GvLCd8Uu7bgfUqkO7wu4=Pt7EWyQx0LrQ@mail.gmail.com>
 <20111109210052.GJ14181@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111109210052.GJ14181@aftab>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix DRAM chip select sizes calculation for K8, revisions D and E.

Reported-by: Niklas Söderlund <niklas.soderlund@ericsson.com
Link: http://lkml.kernel.org/r/1320849178-23340-1-git-send-email-niklas.soderlund@ericsson.com
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---

@Niklas: would you please verify this patch fixes your issue?

Thanks.

 drivers/edac/amd64_edac.c |   32 ++++++++++++++++++++++++++++----
 1 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index c9eee6d..6a83d49 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1132,12 +1132,36 @@ static int k8_dbam_to_chip_select(struct amd64_pvt *pvt, u8 dct,
 		return ddr2_cs_size(cs_mode, dclr & WIDTH_128);
 	}
 	else if (pvt->ext_model >= K8_REV_D) {
+		unsigned diff;
 		WARN_ON(cs_mode > 10);
 
-		if (cs_mode == 3 || cs_mode == 8)
-			return 32 << (cs_mode - 1);
-		else
-			return 32 << cs_mode;
+		/*
+		 * the below calculation, besides trying to win an obfuscated C
+		 * contest, maps cs_mode values to DIMM chip select sizes. The
+		 * mappings are:
+		 *
+		 * cs_mode	CS size (mb)
+		 * =======	============
+		 * 0		32
+		 * 1		64
+		 * 2		128
+		 * 3		128
+		 * 4		256
+		 * 5		512
+		 * 6		256
+		 * 7		512
+		 * 8		1024
+		 * 9		1024
+		 * 10		2048
+		 *
+		 * Basically, it calculates a value with which to shift the
+		 * smallest CS size of 32MB.
+		 *
+		 * ddr[23]_cs_size have a similar purpose.
+		 */
+		diff = cs_mode/3 + (unsigned)(cs_mode > 5);
+
+		return 32 << (cs_mode - diff);
 	}
 	else {
 		WARN_ON(cs_mode > 6);
-- 
1.7.8.rc0

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
