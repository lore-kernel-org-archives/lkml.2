Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161014Ab2CSGJC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 02:09:02 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:29856 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030649Ab2CSFpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 01:45:30 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH -v11 18/30] resources: Replace registered resource in tree.
Date: Sun, 18 Mar 2012 22:42:49 -0700
Message-Id: <1332135781-13695-19-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1332135781-13695-1-git-send-email-yinghai@kernel.org>
References: <1332135781-13695-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-CT-RefId: str=0001.0A090209.4F66C7F1.0053,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We could have one resource inserted in tree at first during proble.

Later we need to put real resource into the tree.

So try to hold the lock to swap them.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 include/linux/ioport.h |    1 +
 kernel/resource.c      |   15 +++++++++++++++
 2 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index 20a30df..62af212 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -163,6 +163,7 @@ int probe_resource(struct resource *b_res,
 			struct device *dev, struct resource *busn_res,
 			resource_size_t needed_size, struct resource **p,
 			int skip_nr, int limit, char *name);
+void resource_replace(struct resource *old_res, struct resource *new_res);
 struct resource *lookup_resource(struct resource *root, resource_size_t start);
 int adjust_resource(struct resource *res, resource_size_t start,
 		    resource_size_t size);
diff --git a/kernel/resource.c b/kernel/resource.c
index 0c9616f..ea96dcf 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -1112,6 +1112,21 @@ reduce_needed_size:
 	return ret;
 }
 
+/* replace old with new in the resource tree */
+void resource_replace(struct resource *old, struct resource *new)
+{
+	struct resource *parent;
+
+	write_lock(&resource_lock);
+	parent = old->parent;
+	new->start = old->start;
+	new->end = old->end;
+	new->flags = old->flags;
+	__release_resource(old);
+	__request_resource(parent, new);
+	write_unlock(&resource_lock);
+}
+
 /*
  * Managed region resource
  */
-- 
1.7.7

