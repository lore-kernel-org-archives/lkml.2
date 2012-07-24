Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195Ab2GXNRH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 09:17:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50780 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754056Ab2GXNRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 09:17:05 -0400
From: Yuanhan Liu <yliu.null@gmail.com>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Yuanhan Liu <yliu.null@gmail.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86/mm: stop allocating pmd page if failed
Date: Tue, 24 Jul 2012 21:15:51 +0800
Message-Id: <1343135751-8336-1-git-send-email-yliu.null@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The old code would call __get_free_page() even though previous
allocation fail met. This is not needed.

Signed-off-by: Yuanhan Liu <yliu.null@gmail.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/mm/pgtable.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index 8573b83..6760348 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -181,24 +181,24 @@ static void free_pmds(pmd_t *pmds[])
 {
 	int i;
 
-	for(i = 0; i < PREALLOCATED_PMDS; i++)
-		if (pmds[i])
-			free_page((unsigned long)pmds[i]);
+	for(i = 0; i < PREALLOCATED_PMDS; i++) {
+		if (pmds[i] == NULL)
+			break;
+		free_page((unsigned long)pmds[i]);
+	}
 }
 
 static int preallocate_pmds(pmd_t *pmds[])
 {
 	int i;
-	bool failed = false;
 
 	for(i = 0; i < PREALLOCATED_PMDS; i++) {
-		pmd_t *pmd = (pmd_t *)__get_free_page(PGALLOC_GFP);
-		if (pmd == NULL)
-			failed = true;
-		pmds[i] = pmd;
+		pmds[i] = (pmd_t *)__get_free_page(PGALLOC_GFP);
+		if (pmds[i] == NULL)
+			break;
 	}
 
-	if (failed) {
+	if (i < PREALLOCATED_PMDS) {
 		free_pmds(pmds);
 		return -ENOMEM;
 	}
-- 
1.7.4.4

