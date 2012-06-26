Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932158Ab2FZSyk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 14:54:40 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:36577 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755324Ab2FZSyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 14:54:38 -0400
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
Subject: [PATCH -v12 02/15] resources: Add probe_resource()
Date: Tue, 26 Jun 2012 11:53:56 -0700
Message-Id: <1340736849-14875-3-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1340736849-14875-1-git-send-email-yinghai@kernel.org>
References: <1340736849-14875-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is changed from busn_res only version, because Bjorn found that version
was not holding resource_lock.
Even it may be ok for busn_res not holding resource_lock.
It would be better to have it to be generic and use lock and we may
use it for other resources.

probe_resource() will try to find specified size or more in parent bus.
If can not find current parent resource, and it will try to expand parents
top.
If still can not find that specified on top, it will try to reduce target size
until find one.

It will return 0, if it find any resource that could be used.

Returned resource is registered in the tree.
So caller may need to use replace_resource to put real resource in tree.

-v3: remove two parameters that is for debug purpose.
-v4: fix stop_flags checking.
-v5: adjust stop_flags checking position to avoid not needed calling
	into allocate_resource().

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 include/linux/ioport.h |    7 ++
 kernel/resource.c      |  149 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 156 insertions(+), 0 deletions(-)

diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index 589e0e7..8292e8b 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -156,6 +156,13 @@ extern int allocate_resource(struct resource *root, struct resource *new,
 						       resource_size_t,
 						       resource_size_t),
 			     void *alignf_data);
+void resource_shrink_parents_top(struct resource *b_res,
+				 long size, struct resource *parent_res);
+struct device;
+int probe_resource(struct resource *b_res,
+			struct resource *busn_res,
+			resource_size_t needed_size, struct resource **p,
+			int skip_nr, int limit, int flags);
 struct resource *lookup_resource(struct resource *root, resource_size_t start);
 int adjust_resource(struct resource *res, resource_size_t start,
 		    resource_size_t size);
diff --git a/kernel/resource.c b/kernel/resource.c
index 3f6e522..d5d9aef 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -980,6 +980,155 @@ void __release_region(struct resource *parent, resource_size_t start,
 }
 EXPORT_SYMBOL(__release_region);
 
+static void __resource_extend_parents_top(struct resource *b_res,
+		 long size, struct resource *parent_res)
+{
+	struct resource *res = b_res;
+
+	if (!size)
+		return;
+
+	while (res && res != parent_res) {
+		res->end += size;
+		res = res->parent;
+	}
+}
+
+void resource_shrink_parents_top(struct resource *b_res,
+		 long size, struct resource *parent_res)
+{
+	write_lock(&resource_lock);
+	__resource_extend_parents_top(b_res, -size, parent_res);
+	write_unlock(&resource_lock);
+}
+
+static resource_size_t __find_res_top_free_size(struct resource *res,
+						 int skip_nr)
+{
+	resource_size_t n_size;
+	struct resource tmp_res;
+
+	/*
+	 *   find out free number below res->end that we can use.
+	 *	res->start to res->start + skip_nr - 1 can not be used.
+	 */
+	n_size = resource_size(res);
+	if (n_size <= skip_nr)
+		return 0;
+
+	n_size -= skip_nr;
+	memset(&tmp_res, 0, sizeof(struct resource));
+	while (n_size > 0) {
+		int ret;
+
+		ret = __allocate_resource(res, &tmp_res, n_size,
+			res->end - n_size + skip_nr, res->end,
+			1, NULL, NULL, false, false);
+		if (ret == 0) {
+			__release_resource(&tmp_res);
+			break;
+		}
+		n_size--;
+	}
+
+	return n_size;
+}
+
+/**
+ * probe_resource - Probe resource in parent resource.
+ * @b_res: parent resource descriptor
+ * @busn_res: return probed resource
+ * @needed_size: target size
+ * @p: pointer to farest parent that we extend the top
+ * @skip_nr: number in b_res start that we need to skip.
+ * @limit: local boundary
+ * @stop_flags: flags for stopping extend parent res
+ *
+ * will try to allocate resource in b_res, if can not find the range
+ *  will try to extend parent resources' top.
+ * if still can not make it, will reduce needed_size.
+ */
+int probe_resource(struct resource *b_res,
+			 struct resource *busn_res,
+			 resource_size_t needed_size, struct resource **p,
+			 int skip_nr, int limit, int stop_flags)
+{
+	int ret = -ENOMEM;
+	resource_size_t n_size;
+	struct resource *parent_res = NULL;
+	resource_size_t tmp = b_res->end + 1;
+
+again:
+	/*
+	 * We first try to allocate biggest range in b_res that
+	 *  we can use in b_res directly.
+	 *  we also need to skip skip_nr from start of b_res.
+	 */
+	n_size = resource_size(b_res);
+	if (n_size > skip_nr)
+		n_size -= skip_nr;
+	else
+		n_size = 0;
+	memset(busn_res, 0, sizeof(struct resource));
+	while (n_size >= needed_size) {
+		ret = allocate_resource(b_res, busn_res, n_size,
+				b_res->start + skip_nr, b_res->end,
+				1, NULL, NULL);
+		if (!ret)
+			return ret;
+		n_size--;
+	}
+
+	/* Try to extend the top of parent resources to meet needed_size */
+	write_lock(&resource_lock);
+
+	/* b_res could be root bus resource and can not be extended */
+	if (b_res->flags & stop_flags)
+		goto reduce_needed_size;
+
+	/* find out free range under top at first */
+	n_size = __find_res_top_free_size(b_res, skip_nr);
+	/* can not extend cross local boundary */
+	if ((limit - b_res->end) < (needed_size - n_size))
+		goto reduce_needed_size;
+
+	/* Probe extended range above top */
+	memset(busn_res, 0, sizeof(struct resource));
+	parent_res = b_res->parent;
+	while (parent_res && !(parent_res->flags & stop_flags)) {
+		ret = __allocate_resource(parent_res, busn_res,
+			 needed_size - n_size,
+			 tmp, tmp + needed_size - n_size - 1,
+			 1, NULL, NULL, false, false);
+		if (!ret) {
+			/* save parent_res, we need it as stopper later */
+			*p = parent_res;
+
+			/* prepare busn_res for return */
+			__release_resource(busn_res);
+			busn_res->start -= n_size;
+
+			/* extend parent resources top */
+			__resource_extend_parents_top(b_res,
+					 needed_size - n_size, parent_res);
+			__request_resource(b_res, busn_res);
+
+			write_unlock(&resource_lock);
+			return ret;
+		}
+		parent_res = parent_res->parent;
+	}
+
+reduce_needed_size:
+	write_unlock(&resource_lock);
+	/* ret must not be 0 here */
+	needed_size--;
+	if (needed_size)
+		goto again;
+
+	return ret;
+}
+
 /*
  * Managed region resource
  */
-- 
1.7.7

