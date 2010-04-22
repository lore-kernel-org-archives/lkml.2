Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932127Ab0DVUGV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:06:21 -0400
Received: from kroah.org ([198.145.64.141]:60152 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758193Ab0DVUCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 16:02:16 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:54:19 2010
Message-Id: <20100422195419.224841637@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:55:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ralf Baechle <ralf@linux-mips.org>,
       Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: [139/139] MIPS: Sibyte: Fix M3 TLB exception handler workaround.
In-Reply-To: <20100422195715.GA25490@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ralf Baechle <ralf@linux-mips.org>

commit 3d45285dd1ff4d4a1361b95e2d6508579a4402b5 upstream.

The M3 workaround needs to cmpare the region and VPN2 fields only.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/mips/mm/tlbex.c |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

--- a/arch/mips/mm/tlbex.c
+++ b/arch/mips/mm/tlbex.c
@@ -741,10 +741,15 @@ static void __cpuinit build_r4000_tlb_re
 	 * create the plain linear handler
 	 */
 	if (bcm1250_m3_war()) {
-		UASM_i_MFC0(&p, K0, C0_BADVADDR);
-		UASM_i_MFC0(&p, K1, C0_ENTRYHI);
+		unsigned int segbits = 44;
+
+		uasm_i_dmfc0(&p, K0, C0_BADVADDR);
+		uasm_i_dmfc0(&p, K1, C0_ENTRYHI);
 		uasm_i_xor(&p, K0, K0, K1);
-		UASM_i_SRL(&p, K0, K0, PAGE_SHIFT + 1);
+		uasm_i_dsrl32(&p, K1, K0, 62 - 32);
+		uasm_i_dsrl(&p, K0, K0, 12 + 1);
+		uasm_i_dsll32(&p, K0, K0, 64 + 12 + 1 - segbits - 32);
+		uasm_i_or(&p, K0, K0, K1);
 		uasm_il_bnez(&p, &r, K0, label_leave);
 		/* No need for uasm_i_nop */
 	}
@@ -1260,10 +1265,15 @@ static void __cpuinit build_r4000_tlb_lo
 	memset(relocs, 0, sizeof(relocs));
 
 	if (bcm1250_m3_war()) {
-		UASM_i_MFC0(&p, K0, C0_BADVADDR);
-		UASM_i_MFC0(&p, K1, C0_ENTRYHI);
+		unsigned int segbits = 44;
+
+		uasm_i_dmfc0(&p, K0, C0_BADVADDR);
+		uasm_i_dmfc0(&p, K1, C0_ENTRYHI);
 		uasm_i_xor(&p, K0, K0, K1);
-		UASM_i_SRL(&p, K0, K0, PAGE_SHIFT + 1);
+		uasm_i_dsrl32(&p, K1, K0, 62 - 32);
+		uasm_i_dsrl(&p, K0, K0, 12 + 1);
+		uasm_i_dsll32(&p, K0, K0, 64 + 12 + 1 - segbits - 32);
+		uasm_i_or(&p, K0, K0, K1);
 		uasm_il_bnez(&p, &r, K0, label_leave);
 		/* No need for uasm_i_nop */
 	}


