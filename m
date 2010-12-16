Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756965Ab0LPRix (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 12:38:53 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:6656 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756939Ab0LPRis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 12:38:48 -0500
Subject: [PATCH 6/9] resources: add arch hook for preventing allocation in
	reserved areas
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Adam Belay <abelay@mit.edu>
Date: Thu, 16 Dec 2010 10:38:46 -0700
Message-ID: <20101216173846.8185.82045.stgit@bob.kio>
In-Reply-To: <20101216173614.8185.19462.stgit@bob.kio>
References: <20101216173614.8185.19462.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This adds arch_remove_reservations(), which an arch can implement if it
needs to protect part of the address space from allocation.

Sometimes that can be done by just putting a region in the resource tree,
but there are cases where that doesn't work well.  For example, x86 BIOS
E820 reservations are not related to devices, so they may overlap part of,
all of, or more than a device resource, so they may not end up at the
correct spot in the resource tree.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 include/linux/ioport.h |    1 +
 kernel/resource.c      |    6 ++++++
 2 files changed, 7 insertions(+), 0 deletions(-)


diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index b227902..e9bb22c 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -123,6 +123,7 @@ extern void reserve_region_with_split(struct resource *root,
 extern struct resource *insert_resource_conflict(struct resource *parent, struct resource *new);
 extern int insert_resource(struct resource *parent, struct resource *new);
 extern void insert_resource_expand_to_fit(struct resource *root, struct resource *new);
+extern void arch_remove_reservations(struct resource *avail);
 extern int allocate_resource(struct resource *root, struct resource *new,
 			     resource_size_t size, resource_size_t min,
 			     resource_size_t max, resource_size_t align,
diff --git a/kernel/resource.c b/kernel/resource.c
index 560659f..798e2fa 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -357,6 +357,10 @@ int __weak page_is_ram(unsigned long pfn)
 	return walk_system_ram_range(pfn, 1, NULL, __is_ram) == 1;
 }
 
+void __weak arch_remove_reservations(struct resource *avail)
+{
+}
+
 static resource_size_t simple_align_resource(void *data,
 					     const struct resource *avail,
 					     resource_size_t size,
@@ -394,6 +398,7 @@ static int find_resource(struct resource *root, struct resource *new,
 	struct resource *this = root->child;
 	struct resource tmp = *new, avail, alloc;
 
+	tmp.flags = new->flags;
 	tmp.start = root->start;
 	/*
 	 * Skip past an allocated resource that starts at 0, since the assignment
@@ -410,6 +415,7 @@ static int find_resource(struct resource *root, struct resource *new,
 			tmp.end = root->end;
 
 		resource_clip(&tmp, min, max);
+		arch_remove_reservations(&tmp);
 
 		/* Check for overflow after ALIGN() */
 		avail = *new;

