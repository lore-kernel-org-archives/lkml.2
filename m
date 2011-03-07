Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927Ab1CGLxS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 06:53:18 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:53494 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546Ab1CGLxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 06:53:15 -0500
Date: Mon, 7 Mar 2011 17:23:09 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: stable@kernel.org
Cc: linux-kernel@vger.kernel.org, greg@kroah.com, anton@samba.org,
        benh@kernel.crashing.org
Subject: [PATCH 5/7] powerpc/kexec: Speedup kexec hash PTE tear down
Message-ID: <20110307115309.GG8194@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    powerpc/kexec: Speedup kexec hash PTE tear down

    Commit: d504bed676caad29a3dba3d3727298c560628f5c upstream

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
---
 arch/powerpc/platforms/pseries/lpar.c |   33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

Index: b/arch/powerpc/platforms/pseries/lpar.c
===================================================================
--- a/arch/powerpc/platforms/pseries/lpar.c	2011-03-07 00:50:53.695992154 -0800
+++ b/arch/powerpc/platforms/pseries/lpar.c	2011-03-07 02:09:06.133815481 -0800
@@ -366,21 +366,28 @@
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
+	 */
+	for (i = 0; i < hpte_count; i += 4) {
+		lpar_rc = plpar_pte_read_4_raw(0, i, (void *)ptes);
+		if (lpar_rc != H_SUCCESS)
+			continue;
+		for (j = 0; j < 4; j++) {
+			if ((ptes[j].pteh & HPTE_V_VRMA_MASK) ==
+				HPTE_V_VRMA_MASK)
+				continue;
+			if (ptes[j].pteh & HPTE_V_VALID)
+				plpar_pte_remove_raw(0, i + j, 0,
+					&(ptes[j].pteh), &(ptes[j].ptel));
		}
	}
 }
