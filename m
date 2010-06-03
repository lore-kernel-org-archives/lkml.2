Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429Ab0FCOEi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 10:04:38 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:42177 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753990Ab0FCOEh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 10:04:37 -0400
Date: Thu, 3 Jun 2010 09:54:02 -0400
From: Andres Salomon <dilinger@queued.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, x86@kernel.org
Subject: [PATCH 1/4] x86: mm: create symbolic index into address_markers
 array
Message-ID: <20100603095402.71cab14b@dev.queued.net>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.12.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Without this, adding entries into the address_markers array means adding more
and more of an #ifdef maze in pt_dump_init().  By using indices, we can keep
it a bit saner.

Signed-off-by: Andres Salomon <dilinger@queued.net>
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
-- 
1.5.6.5

