Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758869Ab0GBP1w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 11:27:52 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:48597 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757289Ab0GBP1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 11:27:51 -0400
Date: Fri, 2 Jul 2010 17:29:44 +0200
From: Borislav Petkov <bp@amd64.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeffrey Merkey <jeffmerkey@gmail.com>, Doug Thompson <norsk5@yahoo.com>,
       LKML <linux-kernel@vger.kernel.org>,
       edac-devel <linux-edac@vger.kernel.org>
Subject: [GIT PULL] AMD64 EDAC fixlet for 2.6.35-rc4
Message-ID: <20100702152944.GD24553@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull this small fixlet which corrects syndrome calculation on K8.
Full patch added below for reference.

Thanks.

The following changes since commit 7e27d6e778cd87b6f2415515d7127eba53fe5d02:

  Linux 2.6.35-rc3 (2010-06-11 19:14:04 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git for-linus

Borislav Petkov (1):
      amd64_edac: Fix syndrome calculation on K8

 drivers/edac/amd64_edac.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

---
From: Borislav Petkov <borislav.petkov@amd.com>
Date: Fri, 2 Jul 2010 17:02:43 +0200
Subject: [PATCH] amd64_edac: Fix syndrome calculation on K8

When calculating the DCT channel from the syndrome we need to know the
syndrome type (x4 vs x8). On F10h, this is read out from extended PCI
cfg space register F3x180 while on K8 we only support x4 syndromes and
don't have extended PCI config space anyway.

Make the code accessing F3x180 F10h only and fall back to x4 syndromes
on everything else.

Cc: <stable@kernel.org> # .33.x
Reported-by: Jeffrey Merkey <jeffmerkey@gmail.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/amd64_edac.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index cf17dbb..ac9f798 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1958,20 +1958,20 @@ static int get_channel_from_ecc_syndrome(struct mem_ctl_info *mci, u16 syndrome)
 	u32 value = 0;
 	int err_sym = 0;
 
-	amd64_read_pci_cfg(pvt->misc_f3_ctl, 0x180, &value);
+	if (boot_cpu_data.x86 == 0x10) {
 
-	/* F3x180[EccSymbolSize]=1, x8 symbols */
-	if (boot_cpu_data.x86 == 0x10 &&
-	    boot_cpu_data.x86_model > 7 &&
-	    value & BIT(25)) {
-		err_sym = decode_syndrome(syndrome, x8_vectors,
-					  ARRAY_SIZE(x8_vectors), 8);
-		return map_err_sym_to_channel(err_sym, 8);
-	} else {
-		err_sym = decode_syndrome(syndrome, x4_vectors,
-					  ARRAY_SIZE(x4_vectors), 4);
-		return map_err_sym_to_channel(err_sym, 4);
+		amd64_read_pci_cfg(pvt->misc_f3_ctl, 0x180, &value);
+
+		/* F3x180[EccSymbolSize]=1 => x8 symbols */
+		if (boot_cpu_data.x86_model > 7 &&
+		    value & BIT(25)) {
+			err_sym = decode_syndrome(syndrome, x8_vectors,
+						  ARRAY_SIZE(x8_vectors), 8);
+			return map_err_sym_to_channel(err_sym, 8);
+		}
 	}
+	err_sym = decode_syndrome(syndrome, x4_vectors, ARRAY_SIZE(x4_vectors), 4);
+	return map_err_sym_to_channel(err_sym, 4);
 }
 
 /*
-- 
1.7.1


-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
