Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140Ab2LMWHB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 17:07:01 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:26684 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756481Ab2LMWCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 17:02:53 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v6 15/27] x86, kexec: set ident mapping for kernel that is above max_pfn
Date: Thu, 13 Dec 2012 14:02:09 -0800
Message-Id: <1355436141-8668-16-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1355436141-8668-1-git-send-email-yinghai@kernel.org>
References: <1355436141-8668-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When first kernel is booted with memmap= or mem=  to limit max_pfn.
kexec can load second kernel above that max_pfn.

We need to set ident mapping for whole image in this case not just
for first 2M.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/machine_kexec_64.c |   43 +++++++++++++++++++++++++++++++-----
 1 file changed, 37 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
index b3ea9db..be14ee1 100644
--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -56,6 +56,25 @@ out:
 	return result;
 }
 
+static int ident_mapping_init(struct kimage *image, pgd_t *level4p,
+				unsigned long mstart, unsigned long mend)
+{
+	int result;
+
+	mstart = round_down(mstart, PMD_SIZE);
+	mend   = round_up(mend - 1, PMD_SIZE);
+
+	while (mstart < mend) {
+		result = init_one_level2_page(image, level4p, mstart);
+		if (result)
+			return result;
+
+		mstart += PMD_SIZE;
+	}
+
+	return 0;
+}
+
 static void init_level2_page(pmd_t *level2p, unsigned long addr)
 {
 	unsigned long end_addr;
@@ -184,22 +203,34 @@ err:
 	return result;
 }
 
-
 static int init_pgtable(struct kimage *image, unsigned long start_pgtable)
 {
+	unsigned long mstart, mend;
 	pgd_t *level4p;
 	int result;
+	int i;
+
 	level4p = (pgd_t *)__va(start_pgtable);
 	result = init_level4_page(image, level4p, 0, max_pfn << PAGE_SHIFT);
 	if (result)
 		return result;
+
 	/*
-	 * image->start may be outside 0 ~ max_pfn, for example when
-	 * jump back to original kernel from kexeced kernel
+	 * segments's mem ranges could be outside 0 ~ max_pfn,
+	 * for example when jump back to original kernel from kexeced kernel.
+	 * or first kernel is booted with user mem map, and second kernel
+	 * could be loaded out of that range.
 	 */
-	result = init_one_level2_page(image, level4p, image->start);
-	if (result)
-		return result;
+	for (i = 0; i < image->nr_segments; i++) {
+		mstart = image->segment[i].mem;
+		mend   = mstart + image->segment[i].memsz;
+
+		result = ident_mapping_init(image, level4p, mstart, mend);
+
+		if (result)
+			return result;
+	}
+
 	return init_transition_pgtable(image, level4p);
 }
 
-- 
1.7.10.4

