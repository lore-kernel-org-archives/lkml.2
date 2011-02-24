Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080Ab1BXN60 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 08:58:26 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33847 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629Ab1BXN6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 08:58:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mfVAWrbS7QibhnOlGv/UnyPZxF/dYc0goh8WtcL35tD41whLd6x+8xAG+YIjmu3D/L
         tVT6LQpDxjRSzAZFfJW8s/BR2KhaW+hEDu2PosDrv5JVYxIo2jSECah5u1FU4bDBkzMu
         hkQbGEMr26MNFgjomS1Vi51A6ZPHgKhdS+DuI=
Date: Thu, 24 Feb 2011 14:58:20 +0100
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        David Miller <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] bootmem: Move contig_page_data definition to
 bootmem.c/nobootmem.c
Message-ID: <20110224135820.GI7840@htj.dyndns.org>
References: <1297120632-24933-1-git-send-email-yinghai@kernel.org>
 <1297120632-24933-11-git-send-email-yinghai@kernel.org>
 <20110222154806.0be18267.akpm@linux-foundation.org>
 <4D660375.10005@kernel.org>
 <4D6604C5.2080904@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6604C5.2080904@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From e782ab421bbba1912c87934bd0e8998630736418 Mon Sep 17 00:00:00 2001
From: Yinghai Lu <yinghai@kernel.org>
Date: Thu, 24 Feb 2011 14:43:06 +0100

Now that bootmem.c and nobootmem.c are separate, it's cleaner to
define contig_page_data in each file than in page_alloc.c with #ifdef.
Move it.

This patch doesn't introduce any behavior change.

-v2: According to Andrew, fixed the struct layout.
-tj: Updated commit description.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
Committed to misc:x86-numa with description updates.  Thanks.

 mm/bootmem.c    |    7 +++++++
 mm/nobootmem.c  |    5 +++++
 mm/page_alloc.c |    9 ---------
 3 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/mm/bootmem.c b/mm/bootmem.c
index 4403e2f..07aeb89 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -23,6 +23,13 @@
 
 #include "internal.h"
 
+#ifndef CONFIG_NEED_MULTIPLE_NODES
+struct pglist_data __refdata contig_page_data = {
+	.bdata = &bootmem_node_data[0]
+};
+EXPORT_SYMBOL(contig_page_data);
+#endif
+
 unsigned long max_low_pfn;
 unsigned long min_low_pfn;
 unsigned long max_pfn;
diff --git a/mm/nobootmem.c b/mm/nobootmem.c
index f220b8d..6a018e4 100644
--- a/mm/nobootmem.c
+++ b/mm/nobootmem.c
@@ -23,6 +23,11 @@
 
 #include "internal.h"
 
+#ifndef CONFIG_NEED_MULTIPLE_NODES
+struct pglist_data __refdata contig_page_data;
+EXPORT_SYMBOL(contig_page_data);
+#endif
+
 unsigned long max_low_pfn;
 unsigned long min_low_pfn;
 unsigned long max_pfn;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 887ce3b..a243a7f 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4841,15 +4841,6 @@ void __init set_dma_reserve(unsigned long new_dma_reserve)
 	dma_reserve = new_dma_reserve;
 }
 
-#ifndef CONFIG_NEED_MULTIPLE_NODES
-struct pglist_data __refdata contig_page_data = {
-#ifndef CONFIG_NO_BOOTMEM
- .bdata = &bootmem_node_data[0]
-#endif
- };
-EXPORT_SYMBOL(contig_page_data);
-#endif
-
 void __init free_area_init(unsigned long *zones_size)
 {
 	free_area_init_node(0, zones_size,
-- 
1.7.1

