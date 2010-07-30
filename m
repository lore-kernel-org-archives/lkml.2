Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759264Ab0G3Rgm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:36:42 -0400
Received: from kroah.org ([198.145.64.141]:35840 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932299Ab0G3Re6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:34:58 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:31:08 2010
Message-Id: <20100730173108.861401116@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:30:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [068/140] amd64_edac: Fix syndrome calculation on K8
In-Reply-To: <20100730173205.GA22581@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Borislav Petkov <borislav.petkov@amd.com>

commit 41c310447fe06bcedc22b75752c18b60e0b9521b upstream.

When calculating the DCT channel from the syndrome we need to know the
syndrome type (x4 vs x8). On F10h, this is read out from extended PCI
cfg space register F3x180 while on K8 we only support x4 syndromes and
don't have extended PCI config space anyway.

Make the code accessing F3x180 F10h only and fall back to x4 syndromes
on everything else.

Reported-by: Jeffrey Merkey <jeffmerkey@gmail.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/edac/amd64_edac.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1958,20 +1958,20 @@ static int get_channel_from_ecc_syndrome
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


