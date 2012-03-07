Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758592Ab2CGRBD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 12:01:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41709 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757643Ab2CGRA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 12:00:57 -0500
Date: Wed, 7 Mar 2012 12:00:53 -0500
From: Jason Baron <jbaron@redhat.com>
To: mcgrathr@google.com
Cc: akpm@linux-foundation.org, avi@redhat.com, linux-kernel@vger.kernel.org,
        qemu-devel@nongnu.org
Message-Id: <fcc863c3e95eb29cd60360d84fbc85ebd07ef843.1331137504.git.jbaron@redhat.com>
In-Reply-To: <cover.1331137504.git.jbaron@redhat.com>
References: <cover.1331137504.git.jbaron@redhat.com>
Subject: [PATCH 2/2] core dump: add a new VM_DONTDUMP flag
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we no longer need the VM_ALWAYSDUMP flag, let's use the freed bit for
'VM_DONTDUMP' flag. The idea is to add a new madvise() flag: MADV_DONTDUMP,
which can be set by applications to specifically request memory regions which
should not dump core. The specific application I have in mind is qemu: we
can add a flag there that wouldn't dump all of guest memory when qemu dumps
core. This flag might also be useful for security sensitive apps that want to
absolutely make sure that parts of memory are not dumped.

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 fs/binfmt_elf.c                   |    3 +++
 include/asm-generic/mman-common.h |    3 +++
 include/linux/mm.h                |    1 +
 mm/madvise.c                      |    8 ++++++++
 4 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 320cc01..df3f950 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1122,6 +1122,9 @@ static unsigned long vma_dump_size(struct vm_area_struct *vma,
 	if (always_dump_vma(vma))
 		goto whole;
 
+	if (vma->vm_flags & VM_DONTDUMP)
+		return 0;
+
 	/* Hugetlb memory check */
 	if (vma->vm_flags & VM_HUGETLB) {
 		if ((vma->vm_flags & VM_SHARED) && FILTER(HUGETLB_SHARED))
diff --git a/include/asm-generic/mman-common.h b/include/asm-generic/mman-common.h
index 787abbb..0016ce3 100644
--- a/include/asm-generic/mman-common.h
+++ b/include/asm-generic/mman-common.h
@@ -48,6 +48,9 @@
 #define MADV_HUGEPAGE	14		/* Worth backing with hugepages */
 #define MADV_NOHUGEPAGE	15		/* Not worth backing with hugepages */
 
+#define MADV_DUMP 16
+#define MADV_DONTDUMP 17
+
 /* compatibility flags */
 #define MAP_FILE	0
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index a296709..23684cf 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -111,6 +111,7 @@ extern unsigned int kobjsize(const void *objp);
 #define VM_HUGEPAGE	0x01000000	/* MADV_HUGEPAGE marked this vma */
 #endif
 #define VM_INSERTPAGE	0x02000000	/* The vma has had "vm_insert_page()" done on it */
+#define VM_DONTDUMP    0x04000000      /* Do not include in core dump */
 
 #define VM_CAN_NONLINEAR 0x08000000	/* Has ->fault & does nonlinear pages */
 #define VM_MIXEDMAP	0x10000000	/* Can contain "struct page" and pure PFN pages */
diff --git a/mm/madvise.c b/mm/madvise.c
index 74bf193..10b52f8 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -65,6 +65,12 @@ static long madvise_behavior(struct vm_area_struct * vma,
 		}
 		new_flags &= ~VM_DONTCOPY;
 		break;
+	case MADV_DONTDUMP:
+		new_flags |= VM_DONTDUMP;
+		break;
+	case MADV_DUMP:
+		new_flags &= ~VM_DONTDUMP;
+		break;
 	case MADV_MERGEABLE:
 	case MADV_UNMERGEABLE:
 		error = ksm_madvise(vma, start, end, behavior, &new_flags);
@@ -293,6 +299,8 @@ madvise_behavior_valid(int behavior)
 	case MADV_HUGEPAGE:
 	case MADV_NOHUGEPAGE:
 #endif
+	case MADV_DUMP:
+	case MADV_DONTDUMP:
 		return 1;
 
 	default:
-- 
1.7.7.6

