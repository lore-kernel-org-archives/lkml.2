Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538Ab2CHV3p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 16:29:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52318 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757269Ab2CHV3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 16:29:34 -0500
Date: Thu, 8 Mar 2012 16:29:30 -0500
From: Jason Baron <jbaron@redhat.com>
To: roland@hack.frob.com, akpm@linux-foundation.org
Cc: torvalds@linux-foundation.org, avi@redhat.com, cmetcalf@tilera.com,
        linux-kernel@vger.kernel.org
Message-Id: <f52c6c288ec291c8cdc6176673d5b0d3d33a6f14.1331238525.git.jbaron@redhat.com>
In-Reply-To: <cover.1331238525.git.jbaron@redhat.com>
References: <cover.1331238525.git.jbaron@redhat.com>
Subject: [PATCH 2/2 v2] core dump: add VM_NODUMP, MADV_NODUMP, MADV_CLEAR_NODUMP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we no longer need the VM_ALWAYSDUMP flag, let's use the freed bit for
'VM_NODUMP' flag. The idea is is to add a new madvise() flag: MADV_NODUMP,
which can be set by applications to specifically request memory regions which
should not dump core. The specific application I have in mind is qemu: we
can add a flag there that wouldn't dump all of guest memory when qemu dumps
core. This flag might also be useful for security sensitive apps that want to
absolutely make sure that parts of memory are not dumped. To clear the flag
use: MADV_CLEAR_NODUMP.

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 fs/binfmt_elf.c                   |    3 +++
 include/asm-generic/mman-common.h |    4 ++++
 include/linux/mm.h                |    1 +
 mm/madvise.c                      |    8 ++++++++
 4 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 93b7adb..2bbf26f 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1129,6 +1129,9 @@ static unsigned long vma_dump_size(struct vm_area_struct *vma,
 	if (always_dump_vma(vma))
 		goto whole;
 
+	if (vma->vm_flags & VM_NODUMP)
+		return 0;
+
 	/* Hugetlb memory check */
 	if (vma->vm_flags & VM_HUGETLB) {
 		if ((vma->vm_flags & VM_SHARED) && FILTER(HUGETLB_SHARED))
diff --git a/include/asm-generic/mman-common.h b/include/asm-generic/mman-common.h
index 787abbb..57e6324 100644
--- a/include/asm-generic/mman-common.h
+++ b/include/asm-generic/mman-common.h
@@ -48,6 +48,10 @@
 #define MADV_HUGEPAGE	14		/* Worth backing with hugepages */
 #define MADV_NOHUGEPAGE	15		/* Not worth backing with hugepages */
 
+#define MADV_NODUMP 16			/* Explicity exclude from the core dump,
+					   overrides the coredump filter bits */
+#define MADV_CLEAR_NODUMP 17		/* Clear the MADV_NODUMP flag */
+
 /* compatibility flags */
 #define MAP_FILE	0
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index a296709..c3b70b5 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -111,6 +111,7 @@ extern unsigned int kobjsize(const void *objp);
 #define VM_HUGEPAGE	0x01000000	/* MADV_HUGEPAGE marked this vma */
 #endif
 #define VM_INSERTPAGE	0x02000000	/* The vma has had "vm_insert_page()" done on it */
+#define VM_NODUMP	0x04000000	/* Do not include in the core dump */
 
 #define VM_CAN_NONLINEAR 0x08000000	/* Has ->fault & does nonlinear pages */
 #define VM_MIXEDMAP	0x10000000	/* Can contain "struct page" and pure PFN pages */
diff --git a/mm/madvise.c b/mm/madvise.c
index 74bf193..eb89826 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -65,6 +65,12 @@ static long madvise_behavior(struct vm_area_struct * vma,
 		}
 		new_flags &= ~VM_DONTCOPY;
 		break;
+	case MADV_NODUMP:
+		new_flags |= VM_NODUMP;
+		break;
+	case MADV_CLEAR_NODUMP:
+		new_flags &= ~VM_NODUMP;
+		break;
 	case MADV_MERGEABLE:
 	case MADV_UNMERGEABLE:
 		error = ksm_madvise(vma, start, end, behavior, &new_flags);
@@ -293,6 +299,8 @@ madvise_behavior_valid(int behavior)
 	case MADV_HUGEPAGE:
 	case MADV_NOHUGEPAGE:
 #endif
+	case MADV_NODUMP:
+	case MADV_CLEAR_NODUMP:
 		return 1;
 
 	default:
-- 
1.7.7.6

