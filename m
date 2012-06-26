Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183Ab2FZSys (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 14:54:48 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:29852 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932161Ab2FZSyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 14:54:45 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v12 03/15] resources: Replace registered resource in tree.
Date: Tue, 26 Jun 2012 11:53:57 -0700
Message-Id: <1340736849-14875-4-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1340736849-14875-1-git-send-email-yinghai@kernel.org>
References: <1340736849-14875-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We could have one resource inserted in tree at first during probing.

Later we need to put real resource into the tree.

So try to hold the lock to swap them.

-v2: make it more generic to handle old one with children or no parent.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 include/linux/ioport.h |    1 +
 kernel/resource.c      |   25 +++++++++++++++++++++++++
 2 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index 8292e8b..cbf3480 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -163,6 +163,7 @@ int probe_resource(struct resource *b_res,
 			struct resource *busn_res,
 			resource_size_t needed_size, struct resource **p,
 			int skip_nr, int limit, int flags);
+void replace_resource(struct resource *old_res, struct resource *new_res);
 struct resource *lookup_resource(struct resource *root, resource_size_t start);
 int adjust_resource(struct resource *res, resource_size_t start,
 		    resource_size_t size);
diff --git a/kernel/resource.c b/kernel/resource.c
index d5d9aef..8da0e76 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -1129,6 +1129,31 @@ reduce_needed_size:
 	return ret;
 }
 
+/* replace old with new in the resource tree */
+void replace_resource(struct resource *old, struct resource *new)
+{
+	struct resource *parent, *tmp, *p;
+
+	write_lock(&resource_lock);
+	new->start = old->start;
+	new->end = old->end;
+	new->flags = old->flags;
+
+	p = old->child;
+	while (p) {
+		tmp = p;
+		p = p->sibling;
+		__release_resource(tmp);
+		__request_resource(new, tmp);
+	}
+	parent = old->parent;
+	if (parent) {
+		__release_resource(old);
+		__request_resource(parent, new);
+	}
+	write_unlock(&resource_lock);
+}
+
 /*
  * Managed region resource
  */
-- 
1.7.7

