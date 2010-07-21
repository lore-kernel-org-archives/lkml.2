Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761936Ab0GUAlF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 20:41:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:37920 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761597Ab0GUAlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 20:41:00 -0400
Date: Wed, 21 Jul 2010 00:40:41 GMT
From: tip-bot for Andres Salomon <dilinger@queued.net>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        jordan.crouse@amd.com, akpm@linux-foundation.org, dilinger@queued.net,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jordan.crouse@amd.com, akpm@linux-foundation.org, dilinger@queued.net,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <201007202219.o6KMJkUs021052@imap1.linux-foundation.org>
References: <201007202219.o6KMJkUs021052@imap1.linux-foundation.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, mm: Create symbolic index into address_markers array
Message-ID: <tip-92851e2fca48f1893f899963c13b55b61ac6956c@git.kernel.org>
Git-Commit-ID: 92851e2fca48f1893f899963c13b55b61ac6956c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 21 Jul 2010 00:40:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  92851e2fca48f1893f899963c13b55b61ac6956c
Gitweb:     http://git.kernel.org/tip/92851e2fca48f1893f899963c13b55b61ac6956c
Author:     Andres Salomon <dilinger@queued.net>
AuthorDate: Tue, 20 Jul 2010 15:19:46 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 20 Jul 2010 16:56:19 -0700

x86, mm: Create symbolic index into address_markers array

Without this, adding entries into the address_markers array means adding
more and more of an #ifdef maze in pt_dump_init().  By using indices, we
can keep it a bit saner.

Signed-off-by: Andres Salomon <dilinger@queued.net>
LKML-Reference: <201007202219.o6KMJkUs021052@imap1.linux-foundation.org>
Cc: Jordan Crouse <jordan.crouse@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/dump_pagetables.c |   32 ++++++++++++++++++++++++++------
 1 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/arch/x86/mm/dump_pagetables.c b/arch/x86/mm/dump_pagetables.c
index a725b7f..0002a3a 100644
--- a/arch/x86/mm/dump_pagetables.c
+++ b/arch/x86/mm/dump_pagetables.c
@@ -37,6 +37,28 @@ struct addr_marker {
 	const char *name;
 };
 
+/* indices for address_markers; keep sync'd w/ address_markers below */
+enum address_markers_idx {
+	USER_SPACE_NR = 0,
+#ifdef CONFIG_X86_64
+	KERNEL_SPACE_NR,
+	LOW_KERNEL_NR,
+	VMALLOC_START_NR,
+	VMEMMAP_START_NR,
+	HIGH_KERNEL_NR,
+	MODULES_VADDR_NR,
+	MODULES_END_NR,
+#else
+	KERNEL_SPACE_NR,
+	VMALLOC_START_NR,
+	VMALLOC_END_NR,
+# ifdef CONFIG_HIGHMEM
+	PKMAP_BASE_NR,
+# endif
+	FIXADDR_START_NR,
+#endif
+};
+
 /* Address space markers hints */
 static struct addr_marker address_markers[] = {
 	{ 0, "User Space" },
@@ -331,14 +353,12 @@ static int pt_dump_init(void)
 
 #ifdef CONFIG_X86_32
 	/* Not a compile-time constant on x86-32 */
-	address_markers[2].start_address = VMALLOC_START;
-	address_markers[3].start_address = VMALLOC_END;
+	address_markers[VMALLOC_START_NR].start_address = VMALLOC_START;
+	address_markers[VMALLOC_END_NR].start_address = VMALLOC_END;
 # ifdef CONFIG_HIGHMEM
-	address_markers[4].start_address = PKMAP_BASE;
-	address_markers[5].start_address = FIXADDR_START;
-# else
-	address_markers[4].start_address = FIXADDR_START;
+	address_markers[PKMAP_BASE_NR].start_address = PKMAP_BASE;
 # endif
+	address_markers[FIXADDR_START_NR].start_address = FIXADDR_START;
 #endif
 
 	pe = debugfs_create_file("kernel_page_tables", 0600, NULL, NULL,
