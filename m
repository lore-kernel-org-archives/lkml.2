Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721Ab2FZS6f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 14:58:35 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:29810 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758728Ab2FZSyi (ORCPT
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
Subject: [PATCH -v12 01/15] resources: Split out __allocate_resource()
Date: Tue, 26 Jun 2012 11:53:55 -0700
Message-Id: <1340736849-14875-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1340736849-14875-1-git-send-email-yinghai@kernel.org>
References: <1340736849-14875-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It will take bool lock, so we could use it in other functions that
hold the resource lock already.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 kernel/resource.c |   26 +++++++++++++++++++++-----
 1 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/kernel/resource.c b/kernel/resource.c
index dc8b477..3f6e522 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -521,14 +521,14 @@ out:
  * @alignf: alignment function, optional, called if not NULL
  * @alignf_data: arbitrary data to pass to the @alignf function
  */
-int allocate_resource(struct resource *root, struct resource *new,
+static int __allocate_resource(struct resource *root, struct resource *new,
 		      resource_size_t size, resource_size_t min,
 		      resource_size_t max, resource_size_t align,
 		      resource_size_t (*alignf)(void *,
 						const struct resource *,
 						resource_size_t,
 						resource_size_t),
-		      void *alignf_data)
+		      void *alignf_data, bool lock)
 {
 	int err;
 	struct resource_constraint constraint;
@@ -542,19 +542,35 @@ int allocate_resource(struct resource *root, struct resource *new,
 	constraint.alignf = alignf;
 	constraint.alignf_data = alignf_data;
 
-	if ( new->parent ) {
+	if (new->parent && lock) {
 		/* resource is already allocated, try reallocating with
 		   the new constraints */
 		return reallocate_resource(root, new, size, &constraint);
 	}
 
-	write_lock(&resource_lock);
+	if (lock)
+		write_lock(&resource_lock);
 	err = find_resource(root, new, size, &constraint);
 	if (err >= 0 && __request_resource(root, new))
 		err = -EBUSY;
-	write_unlock(&resource_lock);
+	if (lock)
+		write_unlock(&resource_lock);
 	return err;
 }
+int allocate_resource(struct resource *root, struct resource *new,
+		      resource_size_t size, resource_size_t min,
+		      resource_size_t max, resource_size_t align,
+		      resource_size_t (*alignf)(void *,
+						const struct resource *,
+						resource_size_t,
+						resource_size_t),
+		      void *alignf_data)
+{
+	bool lock = true;
+
+	return __allocate_resource(root, new, size, min, max, align,
+				   alignf, alignf_data, lock);
+}
 
 EXPORT_SYMBOL(allocate_resource);
 
-- 
1.7.7

