Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932707Ab1DYUh0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:37:26 -0400
Received: from 1wt.eu ([62.212.114.60]:34398 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932367Ab1DYUZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:25:11 -0400
Message-Id: <20110425200236.296423501@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:03:48 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Michael Neuling <mikey@neuling.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kamalesh babulal <kamalesh@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 076/173] powerpc/kexec: Speedup kexec hash PTE tear down
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Michael Neuling <mikey@neuling.org>

commit d504bed676caad29a3dba3d3727298c560628f5c upstream.

Currently for kexec the PTE tear down on 1TB segment systems normally
requires 3 hcalls for each PTE removal. On a machine with 32GB of
memory it can take around a minute to remove all the PTEs.

This optimises the path so that we only remove PTEs that are valid.
It also uses the read 4 PTEs at once HCALL.  For the common case where
a PTEs is invalid in a 1TB segment, this turns the 3 HCALLs per PTE
down to 1 HCALL per 4 PTEs.

This gives an > 10x speedup in kexec times on PHYP, taking a 32GB
machine from around 1 minute down to a few seconds.

Signed-off-by: Michael Neuling <mikey@neuling.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Kamalesh babulal <kamalesh@linux.vnet.ibm.com>
cc: Anton Blanchard <anton@samba.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/platforms/pseries/lpar.c |   33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

--- a/arch/powerpc/platforms/pseries/lpar.c
+++ b/arch/powerpc/platforms/pseries/lpar.c
@@ -366,21 +366,28 @@ static void pSeries_lpar_hptab_clear(voi
 {
 	unsigned long size_bytes = 1UL << ppc64_pft_size;
 	unsigned long hpte_count = size_bytes >> 4;
-	unsigned long dummy1, dummy2, dword0;
+	struct {
+		unsigned long pteh;
+		unsigned long ptel;
+	} ptes[4];
 	long lpar_rc;
-	int i;
+	int i, j;
 
-	/* TODO: Use bulk call */
-	for (i = 0; i < hpte_count; i++) {
-		/* dont remove HPTEs with VRMA mappings */
-		lpar_rc = plpar_pte_remove_raw(H_ANDCOND, i, HPTE_V_1TB_SEG,
-						&dummy1, &dummy2);
-		if (lpar_rc == H_NOT_FOUND) {
-			lpar_rc = plpar_pte_read_raw(0, i, &dword0, &dummy1);
-			if (!lpar_rc && ((dword0 & HPTE_V_VRMA_MASK)
-				!= HPTE_V_VRMA_MASK))
-				/* Can be hpte for 1TB Seg. So remove it */
-				plpar_pte_remove_raw(0, i, 0, &dummy1, &dummy2);
+	/* Read in batches of 4,
+	 * invalidate only valid entries not in the VRMA
+	 * hpte_count will be a multiple of 4
+         */
+	for (i = 0; i < hpte_count; i += 4) {
+		lpar_rc = plpar_pte_read_4_raw(0, i, (void *)ptes);
+		if (lpar_rc != H_SUCCESS)
+			continue;
+		for (j = 0; j < 4; j++){
+			if ((ptes[j].pteh & HPTE_V_VRMA_MASK) ==
+				HPTE_V_VRMA_MASK)
+				continue;
+			if (ptes[j].pteh & HPTE_V_VALID)
+				plpar_pte_remove_raw(0, i + j, 0,
+					&(ptes[j].pteh), &(ptes[j].ptel));
 		}
 	}
 }


