Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933091Ab0EJXBN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:01:13 -0400
Received: from kroah.org ([198.145.64.141]:51751 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932881Ab0EJW6B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:58:01 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:35:38 2010
Message-Id: <20100510223538.287581768@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:34:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Borislav Petkov <borislav.petkov@amd.com>
Subject: [43/98] edac, mce: Fix wrong mask and macro usage
In-Reply-To: <20100510223714.GA18416@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Borislav Petkov <borislav.petkov@amd.com>

commit 35d824b28fc5544d1eb7c1e3db15a1740df8ec4b upstream.

Correct two mishaps which prevented reporting error type (CECC vs UECC)
and extended error description.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/edac/edac_mce_amd.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/edac/edac_mce_amd.c
+++ b/drivers/edac/edac_mce_amd.c
@@ -295,7 +295,6 @@ wrong_ls_mce:
 void amd_decode_nb_mce(int node_id, struct err_regs *regs, int handle_errors)
 {
 	u32 ec  = ERROR_CODE(regs->nbsl);
-	u32 xec = EXT_ERROR_CODE(regs->nbsl);
 
 	if (!handle_errors)
 		return;
@@ -319,7 +318,7 @@ void amd_decode_nb_mce(int node_id, stru
 		pr_cont("\n");
 	}
 
-	pr_emerg("%s.\n", EXT_ERR_MSG(xec));
+	pr_emerg("%s.\n", EXT_ERR_MSG(regs->nbsl));
 
 	if (BUS_ERROR(ec) && nb_bus_decoder)
 		nb_bus_decoder(node_id, regs);
@@ -382,7 +381,7 @@ static void amd_decode_mce(struct mce *m
 		 ((m->status & MCI_STATUS_PCC) ? "yes" : "no"));
 
 	/* do the two bits[14:13] together */
-	ecc = m->status & (3ULL << 45);
+	ecc = (m->status >> 45) & 0x3;
 	if (ecc)
 		pr_cont(", %sECC Error", ((ecc == 2) ? "C" : "U"));
 


