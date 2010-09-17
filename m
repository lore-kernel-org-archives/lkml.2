Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331Ab0IQWc3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 18:32:29 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:9229 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755293Ab0IQWc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 18:32:26 -0400
Subject: [PATCH v2 3/4] resources: allocate space within a region from the top
	down
To: Jesse Barnes <jbarnes@virtuousgeek.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Brian Bloniarz <phunge0@hotmail.com>,
        Charles Butterfield <charles.butterfield@nextcentury.com>,
        Denys Vlasenko <dvlasenk@redhat.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stefan Becker <chemobejk@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
Date: Fri, 17 Sep 2010 16:32:22 -0600
Message-ID: <20100917223222.24687.6486.stgit@bob.kio>
In-Reply-To: <20100917223109.24687.17697.stgit@bob.kio>
References: <20100917223109.24687.17697.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Allocate space from the top of a region first, then work downward.

When we allocate space from a resource, we look for gaps between children
of the resource.  Previously, we looked at gaps from the bottom up.  For
example, given this:

    [mem 0xbff00000-0xf7ffffff] PCI Bus 0000:00
      [mem 0xc0000000-0xdfffffff] PCI Bus 0000:02

we attempted to allocate from the [mem 0xbff00000-0xbfffffff] gap first,
then the [mem 0xe0000000-0xf7ffffff] gap.

With this patch, we allocate from [mem 0xe0000000-0xf7ffffff] first.

Low addresses are generally scarce, so it's better to use high addresses
when possible.  This follows Windows practice for PCI allocation.

Reference: https://bugzilla.kernel.org/show_bug.cgi?id=16228#c42
Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 kernel/resource.c |   40 ++++++++++++++++++++++++----------------
 1 files changed, 24 insertions(+), 16 deletions(-)


diff --git a/kernel/resource.c b/kernel/resource.c
index ace2269..1a2a40e 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -358,6 +358,20 @@ int __weak page_is_ram(unsigned long pfn)
 }
 
 /*
+ * Find the resource before "child" in the sibling list of "root" children.
+ */
+static struct resource *find_sibling_prev(struct resource *root, struct resource *child)
+{
+	struct resource *this;
+
+	for (this = root->child; this; this = this->sibling)
+		if (this->sibling == child)
+			return this;
+
+	return NULL;
+}
+
+/*
  * Find empty slot in the resource tree given range and alignment.
  */
 static int find_resource(struct resource *root, struct resource *new,
@@ -369,24 +383,18 @@ static int find_resource(struct resource *root, struct resource *new,
 						   resource_size_t),
 			 void *alignf_data)
 {
-	struct resource *this = root->child;
+	struct resource *this;
 	struct resource tmp = *new;
 	resource_size_t start;
 
-	tmp.start = root->start;
-	/*
-	 * Skip past an allocated resource that starts at 0, since the assignment
-	 * of this->start - 1 to tmp->end below would cause an underflow.
-	 */
-	if (this && this->start == 0) {
-		tmp.start = this->end + 1;
-		this = this->sibling;
-	}
-	for(;;) {
+	tmp.end = root->end;
+
+	this = find_sibling_prev(root, NULL);
+	for (;;) {
 		if (this)
-			tmp.end = this->start - 1;
+			tmp.start = this->end + 1;
 		else
-			tmp.end = root->end;
+			tmp.start = root->start;
 		if (tmp.start < min)
 			tmp.start = min;
 		if (tmp.end > max)
@@ -404,10 +412,10 @@ static int find_resource(struct resource *root, struct resource *new,
 			new->end = tmp.start + size - 1;
 			return 0;
 		}
-		if (!this)
+		if (!this || this->start == root->start)
 			break;
-		tmp.start = this->end + 1;
-		this = this->sibling;
+		tmp.end = this->start - 1;
+		this = find_sibling_prev(root, this);
 	}
 	return -EBUSY;
 }

