Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab1A2VPf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 16:15:35 -0500
Received: from ud10.udmedia.de ([194.117.254.50]:34132 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022Ab1A2VPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 16:15:34 -0500
Date: Sat, 29 Jan 2011 22:15:31 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: linux-edac@vger.kernel.org
Cc: Borislav Petkov <borislav.petkov@amd.com>,
        Doug Thompson <dougthompson@xmission.com>,
        linux-kernel@vger.kernel.org
Subject: [EDAC-AMD64] Display correct RAM sizes in ganged mode on F10 CPUs
Message-ID: <20110129211531.GA1874@gentoo.trippels.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The EDAC_AMD64 module displays only half the actual memory size, when
RAM is running in ganged mode on F10 CPUs. Fix this by moving the the
conversion factor check out of the if block, where it is never reached.

With this patch:

Unganged: 
 amd64: DRAM ECC enabled.
 EDAC amd64: F10h detected (node 0).
 EDAC amd64: using x4 syndromes.
 EDAC MC: DCT0 chip selects:
 kernel: EDAC amd64: MC: 0:  1024MB 1:  1024MB
 kernel: EDAC amd64: MC: 2:  1024MB 3:  1024MB
 kernel: EDAC amd64: MC: 4:     0MB 5:     0MB
 kernel: EDAC amd64: MC: 6:     0MB 7:     0MB
 kernel: EDAC MC: DCT1 chip selects:
 kernel: EDAC amd64: MC: 0:  1024MB 1:  1024MB
 kernel: EDAC amd64: MC: 2:  1024MB 3:  1024MB
 kernel: EDAC amd64: MC: 4:     0MB 5:     0MB
 kernel: EDAC amd64: MC: 6:     0MB 7:     0MB
 kernel: EDAC amd64: MCT channel count: 2

Ganged:
 EDAC amd64: DRAM ECC enabled.
 EDAC amd64: F10h detected (node 0).
 EDAC amd64: using x4 syndromes.
 EDAC MC: DCT0 chip selects:
 EDAC amd64: MC: 0:  2048MB 1:  2048MB
 EDAC amd64: MC: 2:  2048MB 3:  2048MB
 EDAC amd64: MC: 4:     0MB 5:     0MB
 EDAC amd64: MC: 6:     0MB 7:     0MB


diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 4a5ecc5..e872d79 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1633,10 +1633,10 @@ static void amd64_debug_display_dimm_sizes(int ctrl, struct amd64_pvt *pvt)
 	u32 dbam;
 	u32 *dcsb;
 
-	if (boot_cpu_data.x86 == 0xf) {
-		if (pvt->dclr0 & F10_WIDTH_128)
-			factor = 1;
+	if (pvt->dclr0 & F10_WIDTH_128)
+		factor = 1;
 
+	if (boot_cpu_data.x86 == 0xf) {
 		/* K8 families < revF not supported yet */
 	       if (pvt->ext_model < K8_REV_F)
 			return;

-- 
Markus
