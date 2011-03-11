Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415Ab1CKC7N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 21:59:13 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48783 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239Ab1CKC7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 21:59:12 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 11 Mar 2011 11:52:35 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, Chris Mason <chris.mason@oracle.com>,
        Andreas Dilger <adilger@dilger.ca>,
        Justin TerAvest <teravest@google.com>, m-ikeda <m-ikeda@ds.jp.nec.com>,
        jaxboe <jaxboe@fusionio.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, ryov <ryov@valinux.co.jp>,
        taka <taka@valinux.co.jp>, "righi.andrea" <righi.andrea@gmail.com>,
        guijianfeng <guijianfeng@cn.fujitsu.com>,
        balbir <balbir@linux.vnet.ibm.com>, ctalbott <ctalbott@google.com>,
        nauman <nauman@google.com>, mrubin <mrubin@google.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [RFC] Storing cgroup id in page->private (Was: Re: [RFC] [PATCH
 0/6] Provide cgroup isolation for buffered writes.)
Message-Id: <20110311115235.3663792c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110311021531.GA11710@redhat.com>
References: <AANLkTimRRAEp75CfyJFxU-5wOYfety6gjq=msZf0Wp8P@mail.gmail.com>
	<20110310181529.GF29464@redhat.com>
	<AANLkTi=LL6JEwOcZfSsapYn-isA3RBrV8kPq8EK6va8=@mail.gmail.com>
	<20110310191115.GG29464@redhat.com>
	<20110310194106.GH29464@redhat.com>
	<1299791640-sup-1874@think>
	<3EC7D30A-B8F7-416B-8B1D-A19350C57D82@dilger.ca>
	<20110310213832.GK29464@redhat.com>
	<1299793340-sup-9066@think>
	<20110311014618.GC15097@dastard>
	<20110311021531.GA11710@redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Mar 2011 21:15:31 -0500
Vivek Goyal <vgoyal@redhat.com> wrote:
 
> > IMO, if you really need some per-page information, then just put it
> > in the struct page - you can't hide the memory overhead just by
> > having the filesystem to store it for you. That just adds
> > unnecessary complexity...
> 
> Ok. I guess adding anything to struct page is going to be hard and 
> we might have to fall back to looking into using page_cgroup for
> tracking page state. I was trying to explore the ways so that we don't
> have to instantiate whole page_cgroup structure just for trying
> to figure out who dirtied the page.
> 

Is this bad ?
==

At handling ASYNC I/O in blkio layer, it's unknown that who dirtied the page.
This lack of information makes impossible to throttole Async I/O per
cgroup in blkio queue layer.

This patch records the information into radix-tree and preserve the
information. There is no 'clear' operation because all I/O starts when
the page is marked as DIRTY.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 include/linux/radix-tree.h |    3 +++
 lib/radix-tree.c           |   42 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 45 insertions(+)

Index: mmotm-Mar10/include/linux/radix-tree.h
===================================================================
--- mmotm-Mar10.orig/include/linux/radix-tree.h
+++ mmotm-Mar10/include/linux/radix-tree.h
@@ -58,12 +58,14 @@ struct radix_tree_root {
 	unsigned int		height;
 	gfp_t			gfp_mask;
 	struct radix_tree_node	__rcu *rnode;
+	int			iohint;
 };
 
 #define RADIX_TREE_INIT(mask)	{					\
 	.height = 0,							\
 	.gfp_mask = (mask),						\
 	.rnode = NULL,							\
+	.iohint = 0,							\
 }
 
 #define RADIX_TREE(name, mask) \
@@ -74,6 +76,7 @@ do {									\
 	(root)->height = 0;						\
 	(root)->gfp_mask = (mask);					\
 	(root)->rnode = NULL;						\
+	(root)->iohint = 0;						\
 } while (0)
 
 /**
Index: mmotm-Mar10/lib/radix-tree.c
===================================================================
--- mmotm-Mar10.orig/lib/radix-tree.c
+++ mmotm-Mar10/lib/radix-tree.c
@@ -31,6 +31,7 @@
 #include <linux/string.h>
 #include <linux/bitops.h>
 #include <linux/rcupdate.h>
+#include <linux/blkdev.h>
 
 
 #ifdef __KERNEL__
@@ -51,6 +52,9 @@ struct radix_tree_node {
 	struct rcu_head	rcu_head;
 	void __rcu	*slots[RADIX_TREE_MAP_SIZE];
 	unsigned long	tags[RADIX_TREE_MAX_TAGS][RADIX_TREE_TAG_LONGS];
+#ifdef CONFIG_BLK_CGROUP
+	unsigned short  iohint[RADIX_TREE_MAP_SIZE];
+#endif
 };
 
 struct radix_tree_path {
@@ -473,6 +477,8 @@ void *radix_tree_tag_set(struct radix_tr
 		offset = (index >> shift) & RADIX_TREE_MAP_MASK;
 		if (!tag_get(slot, tag, offset))
 			tag_set(slot, tag, offset);
+		if (height == 1 && slot && tag == PAGECACHE_TAG_DIRTY)
+			blkio_record_hint(&slot->iohint[offset]);
 		slot = slot->slots[offset];
 		BUG_ON(slot == NULL);
 		shift -= RADIX_TREE_MAP_SHIFT;
@@ -1418,3 +1425,38 @@ void __init radix_tree_init(void)
 	radix_tree_init_maxindex();
 	hotcpu_notifier(radix_tree_callback, 0);
 }
+
+#ifdef CONFIG_BLK_CGROUP
+
+unsigned short radix_tree_lookup_iohint(struct radix_tree_root *root,
+				int index)
+{
+	unsigned int height, shift;
+	struct radix_tree_node *node;
+
+	node = rcu_redereference(root->rnode);
+	if (node == NULL)
+		return 0;
+	if (!radix_tree_is_indirect_ptr(node))
+		return root->iohint;
+	node = radxi_tree_indirect_to_ptr(node);
+
+	height = node->height;
+	if (index > radix_tree_maxindex(height))
+		return 0;
+	shift = (height - 1) * RADIX_TREE_MAP_SHIFT;
+	for ( ; ; ) {
+		int offset;
+
+		if (node == NULL)
+			return 0;
+		offset = (index >> shift) & RADIX_TREE_MAP_MASK;
+		if (height == 1)
+			return node->iohint[offset];
+		node = rcu_rereference(node->slots[offset]);
+		shift -= RADIX_TREE_MAP_SHIFT;
+		height--;
+	}
+}
+EXPORT_SYMBOL(radix_tree_lookup_iohint);
+#endif

