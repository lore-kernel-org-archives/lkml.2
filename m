Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107Ab0JMQPT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 12:15:19 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:24499 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878Ab0JMQPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 12:15:17 -0400
Subject: [PATCH v3 2/6] resources: allocate space within a region from the top
	down
To: Jesse Barnes <jbarnes@virtuousgeek.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Bob Picco <bpicco@redhat.com>, Brian Bloniarz <phunge0@hotmail.com>,
        Charles Butterfield <charles.butterfield@nextcentury.com>,
        Denys Vlasenko <dvlasenk@redhat.com>, linux-pci@vger.kernel.org,
        "Horst H. von Brand" <vonbrand@inf.utfsm.cl>,
        linux-kernel@vger.kernel.org, Stefan Becker <chemobejk@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
Date: Wed, 13 Oct 2010 10:15:15 -0600
Message-ID: <20101013161515.28476.99253.stgit@bob.kio>
In-Reply-To: <20101013161359.28476.6050.stgit@bob.kio>
References: <20101013161359.28476.6050.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Allocate space from the top of a region first, then work downward,
if an architecture desires this.

I think it's too dangerous to do this across the board, because
iomem_resource.end is initialized to -1, which is 0xffffffff_ffffffff
on 64-bit architectures, and most machines can't address the entire
64-bit physical address space.  So this patch is only effective if the
architecture defines ARCH_HAS_TOP_DOWN_ALLOC.

When we allocate space from a resource, we look for gaps between children
of the resource.  Previously, we always looked at gaps from the bottom up.
For example, given this:

    [mem 0xbff00000-0xf7ffffff] PCI Bus 0000:00
      [mem 0xc0000000-0xdfffffff] PCI Bus 0000:02

we attempted to allocate from the [mem 0xbff00000-0xbfffffff] gap first,
then the [mem 0xe0000000-0xf7ffffff] gap.

With this patch, if the architecture defines ARCH_HAS_TOP_DOWN_ALLOC,
we allocate from [mem 0xe0000000-0xf7ffffff] first.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 kernel/resource.c |   70 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 70 insertions(+), 0 deletions(-)


diff --git a/kernel/resource.c b/kernel/resource.c
index ace2269..9218e8e 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -357,8 +357,77 @@ int __weak page_is_ram(unsigned long pfn)
 	return walk_system_ram_range(pfn, 1, NULL, __is_ram) == 1;
 }
 
+#ifdef ARCH_HAS_TOP_DOWN_ALLOC
+/*
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
 /*
  * Find empty slot in the resource tree given range and alignment.
+ * This version allocates from the end of the root resource first.
+ */
+static int find_resource(struct resource *root, struct resource *new,
+			 resource_size_t size, resource_size_t min,
+			 resource_size_t max, resource_size_t align,
+			 resource_size_t (*alignf)(void *,
+						   const struct resource *,
+						   resource_size_t,
+						   resource_size_t),
+			 void *alignf_data)
+{
+	struct resource *this;
+	struct resource tmp = *new;
+	resource_size_t start;
+
+	tmp.start = root->end;
+	tmp.end = root->end;
+
+	this = find_sibling_prev(root, NULL);
+	for (;;) {
+		if (this && this->end < root->end)
+			tmp.start = this->end + 1;
+		else
+			tmp.start = root->start;
+		if (tmp.start < min)
+			tmp.start = min;
+		if (tmp.end > max)
+			tmp.end = max;
+		tmp.start = ALIGN(tmp.start, align);
+		if (alignf) {
+			start = alignf(alignf_data, &tmp, size, align);
+			if (tmp.start <= start && start <= tmp.end)
+				tmp.start = start;
+			else
+				tmp.start = tmp.end;
+		}
+		if (tmp.start < tmp.end && tmp.end - tmp.start >= size - 1) {
+			new->start = tmp.start;
+			new->end = tmp.start + size - 1;
+			return 0;
+		}
+		if (!this || this->start == root->start)
+			break;
+		tmp.end = this->start - 1;
+		this = find_sibling_prev(root, this);
+	}
+	return -EBUSY;
+}
+
+#else
+
+/*
+ * Find empty slot in the resource tree given range and alignment.
+ * This version allocates from the beginning of the root resource first.
  */
 static int find_resource(struct resource *root, struct resource *new,
 			 resource_size_t size, resource_size_t min,
@@ -411,6 +480,7 @@ static int find_resource(struct resource *root, struct resource *new,
 	}
 	return -EBUSY;
 }
+#endif
 
 /**
  * allocate_resource - allocate empty slot in the resource tree given range & alignment

