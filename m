Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751291Ab1LQHyN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 02:54:13 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64338 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704Ab1LQHyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 02:54:07 -0500
Date: Fri, 16 Dec 2011 23:53:57 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Randy Dunlap <rdunlap@xenotime.net>, Naveen Yadav <yad.naveen@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] rtth: fix Segmentation fault
In-Reply-To: <alpine.LSU.2.00.1112162347440.1981@eggly.anvils>
Message-ID: <alpine.LSU.2.00.1112162352210.1981@eggly.anvils>
References: <alpine.LSU.2.00.1112162347440.1981@eggly.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rtth radix_tree source was updated but never tested after the update??
Currently gives Segmentation fault after big_gang_check() because we
forget to remove the low bitflag from the node address in rnode:
for which we need indirect_to_ptr() not radix_tree_deref_slot().

Signed-off-by: Hugh Dickins <hughd@google.com>
---

 test.c |    2 +-
 test.h |    5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

--- rtth0/test.c	2010-11-10 16:35:29.000000000 -0800
+++ rtth1/test.c	2011-12-16 18:44:02.475897094 -0800
@@ -184,7 +184,7 @@ void verify_tag_consistency(struct radix
 {
 	if (!root->height)
 		return;
-	verify_node(radix_tree_deref_slot((void **)&root->rnode),
+	verify_node(indirect_to_ptr(root->rnode),
 			tag, root->height, !!root_tag_get(root, tag));
 }
 
--- rtth0/test.h	2010-08-25 13:30:45.000000000 -0700
+++ rtth1/test.h	2011-12-16 18:44:02.475897094 -0800
@@ -18,6 +18,11 @@ struct radix_tree_node {
         unsigned long   tags[RADIX_TREE_MAX_TAGS][RADIX_TREE_TAG_LONGS];
 };
 
+static inline void *indirect_to_ptr(void *ptr)
+{
+	return (void *)((unsigned long)ptr & ~RADIX_TREE_INDIRECT_PTR);
+}
+
 unsigned long radix_tree_maxindex(unsigned int height);
 int root_tag_get(struct radix_tree_root *root, unsigned int tag);
 /* Upto here */
