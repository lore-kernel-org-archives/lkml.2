Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302Ab2GQFAu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 01:00:50 -0400
Received: from ozlabs.org ([203.10.76.45]:43122 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754077Ab2GQFAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 01:00:47 -0400
From: Michael Ellerman <michael@ellerman.id.au>
To: <kvm@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <matt@ozlabs.org>, <penberg@kernel.org>,
        <kvm-ppc@vger.kernel.org>, <prerna@linux.vnet.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>
Subject: [PATCH 03/10] kvm tools: Remember page size as kvm->ram_pagesize
Date: Tue, 17 Jul 2012 15:00:13 +1000
Message-Id: <1342501220-10209-4-git-send-email-michael@ellerman.id.au>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1342501220-10209-1-git-send-email-michael@ellerman.id.au>
References: <1342501220-10209-1-git-send-email-michael@ellerman.id.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some powerpc platforms we need to make sure we only advertise page
sizes to the guest which are <= the size of the pages backing guest RAM.

So have mmap_hugetblfs() save the hugetblfs page size for us, and also
teach mmap_anon_or_hugetblfs() to set the page size for anonymous mmap.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
---
 tools/kvm/include/kvm/util.h             |    4 +++-
 tools/kvm/powerpc/include/kvm/kvm-arch.h |    1 +
 tools/kvm/powerpc/kvm.c                  |    2 +-
 tools/kvm/util/util.c                    |   13 +++++++++----
 tools/kvm/x86/include/kvm/kvm-arch.h     |    1 +
 tools/kvm/x86/kvm.c                      |    4 ++--
 6 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/tools/kvm/include/kvm/util.h b/tools/kvm/include/kvm/util.h
index 3d1d987..0df9f0d 100644
--- a/tools/kvm/include/kvm/util.h
+++ b/tools/kvm/include/kvm/util.h
@@ -90,6 +90,8 @@ static inline void msleep(unsigned int msecs)
 	usleep(MSECS_TO_USECS(msecs));
 }
 
-void *mmap_anon_or_hugetlbfs(const char *hugetlbfs_path, u64 size);
+struct kvm;
+void *mmap_hugetlbfs(struct kvm *kvm, const char *htlbfs_path, u64 size);
+void *mmap_anon_or_hugetlbfs(struct kvm *kvm, const char *hugetlbfs_path, u64 size);
 
 #endif /* KVM__UTIL_H */
diff --git a/tools/kvm/powerpc/include/kvm/kvm-arch.h b/tools/kvm/powerpc/include/kvm/kvm-arch.h
index 404e33e..316fe79 100644
--- a/tools/kvm/powerpc/include/kvm/kvm-arch.h
+++ b/tools/kvm/powerpc/include/kvm/kvm-arch.h
@@ -54,6 +54,7 @@ struct kvm {
 
 	u64			ram_size;
 	void			*ram_start;
+	u64			ram_pagesize;
 
 	u64			sdr1;
 	u32			pvr;
diff --git a/tools/kvm/powerpc/kvm.c b/tools/kvm/powerpc/kvm.c
index 0d8a9da..e3a7e52 100644
--- a/tools/kvm/powerpc/kvm.c
+++ b/tools/kvm/powerpc/kvm.c
@@ -101,7 +101,7 @@ void kvm__arch_init(struct kvm *kvm, const char *hugetlbfs_path, u64 ram_size)
 	if (hugetlbfs_path && !strcmp(hugetlbfs_path, "default"))
 		hugetlbfs_path = HUGETLBFS_PATH;
 
-	kvm->ram_start = mmap_anon_or_hugetlbfs(hugetlbfs_path, kvm->ram_size);
+	kvm->ram_start = mmap_anon_or_hugetlbfs(kvm, hugetlbfs_path, kvm->ram_size);
 
 	if (kvm->ram_start == MAP_FAILED)
 		die("Couldn't map %lld bytes for RAM (%d)\n",
diff --git a/tools/kvm/util/util.c b/tools/kvm/util/util.c
index a80cf86..c11a15a 100644
--- a/tools/kvm/util/util.c
+++ b/tools/kvm/util/util.c
@@ -4,6 +4,7 @@
 
 #include "kvm/util.h"
 
+#include <kvm/kvm.h>
 #include <linux/magic.h>	/* For HUGETLBFS_MAGIC */
 #include <sys/mman.h>
 #include <sys/stat.h>
@@ -80,7 +81,7 @@ void die_perror(const char *s)
 	exit(1);
 }
 
-void *mmap_hugetlbfs(const char *htlbfs_path, u64 size)
+void *mmap_hugetlbfs(struct kvm *kvm, const char *htlbfs_path, u64 size)
 {
 	char mpath[PATH_MAX];
 	int fd;
@@ -100,6 +101,8 @@ void *mmap_hugetlbfs(const char *htlbfs_path, u64 size)
 		    blk_size, size);
 	}
 
+	kvm->ram_pagesize = blk_size;
+
 	snprintf(mpath, PATH_MAX, "%s/kvmtoolXXXXXX", htlbfs_path);
 	fd = mkstemp(mpath);
 	if (fd < 0)
@@ -115,14 +118,16 @@ void *mmap_hugetlbfs(const char *htlbfs_path, u64 size)
 }
 
 /* This function wraps the decision between hugetlbfs map (if requested) or normal mmap */
-void *mmap_anon_or_hugetlbfs(const char *hugetlbfs_path, u64 size)
+void *mmap_anon_or_hugetlbfs(struct kvm *kvm, const char *hugetlbfs_path, u64 size)
 {
 	if (hugetlbfs_path)
 		/*
 		 * We don't /need/ to map guest RAM from hugetlbfs, but we do so
 		 * if the user specifies a hugetlbfs path.
 		 */
-		return mmap_hugetlbfs(hugetlbfs_path, size);
-	else
+		return mmap_hugetlbfs(kvm, hugetlbfs_path, size);
+	else {
+		kvm->ram_pagesize = getpagesize();
 		return mmap(NULL, size, PROT_RW, MAP_ANON_NORESERVE, -1, 0);
+	}
 }
diff --git a/tools/kvm/x86/include/kvm/kvm-arch.h b/tools/kvm/x86/include/kvm/kvm-arch.h
index 551c8b4..dd385d4 100644
--- a/tools/kvm/x86/include/kvm/kvm-arch.h
+++ b/tools/kvm/x86/include/kvm/kvm-arch.h
@@ -34,6 +34,7 @@ struct kvm {
 
 	u64			ram_size;
 	void			*ram_start;
+	u64			ram_pagesize;
 
 	bool			nmi_disabled;
 
diff --git a/tools/kvm/x86/kvm.c b/tools/kvm/x86/kvm.c
index 8931639..0a40fd5 100644
--- a/tools/kvm/x86/kvm.c
+++ b/tools/kvm/x86/kvm.c
@@ -144,9 +144,9 @@ void kvm__arch_init(struct kvm *kvm, const char *hugetlbfs_path, u64 ram_size)
 
 	if (ram_size < KVM_32BIT_GAP_START) {
 		kvm->ram_size = ram_size;
-		kvm->ram_start = mmap_anon_or_hugetlbfs(hugetlbfs_path, ram_size);
+		kvm->ram_start = mmap_anon_or_hugetlbfs(kvm, hugetlbfs_path, ram_size);
 	} else {
-		kvm->ram_start = mmap_anon_or_hugetlbfs(hugetlbfs_path, ram_size + KVM_32BIT_GAP_SIZE);
+		kvm->ram_start = mmap_anon_or_hugetlbfs(kvm, hugetlbfs_path, ram_size + KVM_32BIT_GAP_SIZE);
 		kvm->ram_size = ram_size + KVM_32BIT_GAP_SIZE;
 		if (kvm->ram_start != MAP_FAILED)
 			/*
-- 
1.7.9.5

