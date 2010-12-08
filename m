Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411Ab0LHVgO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 16:36:14 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:40695 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755167Ab0LHVgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 16:36:11 -0500
Subject: [PATCH 1/5] resources: add arch hook for preventing allocation in
	reserved areas
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Adam Belay <abelay@mit.edu>
Date: Wed, 08 Dec 2010 14:36:06 -0700
Message-ID: <20101208213606.13026.47657.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This adds arch_remove_reservations(), which an arch can implement if it
needs to protect part of the address space from allocation.

Sometimes that can be done by just requesting a resource.  This hook is to
cover cases where protected area doesn't fit well in the hierarchical
resource tree.  For example, x86 BIOS E820 reservations are not related
to devices, so they may overlap part of, all of, or more than a device
resource.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 include/linux/ioport.h |    1 +
 kernel/resource.c      |    8 ++++++++
 2 files changed, 9 insertions(+), 0 deletions(-)


diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index d377ea8..b92b8b4 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -124,6 +124,7 @@ extern void reserve_region_with_split(struct resource *root,
 extern struct resource *insert_resource_conflict(struct resource *parent, struct resource *new);
 extern int insert_resource(struct resource *parent, struct resource *new);
 extern void insert_resource_expand_to_fit(struct resource *root, struct resource *new);
+extern void arch_remove_reservations(struct resource *avail);
 extern int allocate_resource(struct resource *root, struct resource *new,
 			     resource_size_t size, resource_size_t min,
 			     resource_size_t max, resource_size_t align,
diff --git a/kernel/resource.c b/kernel/resource.c
index 9fad33e..246957e 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -374,6 +374,10 @@ int __weak page_is_ram(unsigned long pfn)
 	return walk_system_ram_range(pfn, 1, NULL, __is_ram) == 1;
 }
 
+void __weak arch_remove_reservations(struct resource *avail)
+{
+}
+
 static resource_size_t simple_align_resource(void *data,
 					     const struct resource *avail,
 					     resource_size_t size,
@@ -426,6 +430,7 @@ static int find_resource_from_top(struct resource *root, struct resource *new,
 	struct resource *this;
 	struct resource tmp, avail, alloc;
 
+	tmp.flags = new->flags;
 	tmp.start = root->end;
 	tmp.end = root->end;
 
@@ -438,6 +443,7 @@ static int find_resource_from_top(struct resource *root, struct resource *new,
 			tmp.start = root->start;
 
 		resource_clip(&tmp, min, max);
+		arch_remove_reservations(&tmp);
 
 		/* Check for overflow after ALIGN() */
 		avail = *new;
@@ -478,6 +484,7 @@ static int find_resource(struct resource *root, struct resource *new,
 	struct resource *this = root->child;
 	struct resource tmp = *new, avail, alloc;
 
+	tmp.flags = new->flags;
 	tmp.start = root->start;
 	/*
 	 * Skip past an allocated resource that starts at 0, since the
@@ -495,6 +502,7 @@ static int find_resource(struct resource *root, struct resource *new,
 			tmp.end = root->end;
 
 		resource_clip(&tmp, min, max);
+		arch_remove_reservations(&tmp);
 
 		/* Check for overflow after ALIGN() */
 		avail = *new;

