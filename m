Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425Ab2GQFDO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 01:03:14 -0400
Received: from ozlabs.org ([203.10.76.45]:55684 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752431Ab2GQFAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 01:00:45 -0400
From: Michael Ellerman <michael@ellerman.id.au>
To: <kvm@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <matt@ozlabs.org>, <penberg@kernel.org>,
        <kvm-ppc@vger.kernel.org>, <prerna@linux.vnet.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>
Subject: [PATCH 02/10] kvm tools, powerpc: Use mmap_anon_or_hugetblfs() in kvm__arch_init()
Date: Tue, 17 Jul 2012 15:00:12 +1000
Message-Id: <1342501220-10209-3-git-send-email-michael@ellerman.id.au>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1342501220-10209-1-git-send-email-michael@ellerman.id.au>
References: <1342501220-10209-1-git-send-email-michael@ellerman.id.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It implements essentially the same logic. The one difference is it sets
MAP_NORESERVE when using anonymous mmap, but I think that is OK.

Reword the comment about hugetblfs, we are no longer required to use
hugepages to back the guest.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
---
 tools/kvm/powerpc/kvm.c |   20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/tools/kvm/powerpc/kvm.c b/tools/kvm/powerpc/kvm.c
index cbc0d8f..0d8a9da 100644
--- a/tools/kvm/powerpc/kvm.c
+++ b/tools/kvm/powerpc/kvm.c
@@ -97,20 +97,12 @@ void kvm__arch_init(struct kvm *kvm, const char *hugetlbfs_path, u64 ram_size)
 
 	kvm->ram_size		= ram_size;
 
-	/*
-	 * Currently, HV-mode PPC64 SPAPR requires that we map from hugetlfs.
-	 * Allow a 'default' option to assist.
-	 * PR-mode does not require this.
-	 */
-	if (hugetlbfs_path) {
-		if (!strcmp(hugetlbfs_path, "default"))
-			hugetlbfs_path = HUGETLBFS_PATH;
-		kvm->ram_start = mmap_hugetlbfs(hugetlbfs_path, kvm->ram_size);
-	} else {
-		kvm->ram_start = mmap(0, kvm->ram_size, PROT_READ | PROT_WRITE,
-				      MAP_ANON | MAP_PRIVATE,
-				      -1, 0);
-	}
+	/* Map "default" hugetblfs path to the standard 16M mount point */
+	if (hugetlbfs_path && !strcmp(hugetlbfs_path, "default"))
+		hugetlbfs_path = HUGETLBFS_PATH;
+
+	kvm->ram_start = mmap_anon_or_hugetlbfs(hugetlbfs_path, kvm->ram_size);
+
 	if (kvm->ram_start == MAP_FAILED)
 		die("Couldn't map %lld bytes for RAM (%d)\n",
 		    kvm->ram_size, errno);
-- 
1.7.9.5

