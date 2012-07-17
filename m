Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222Ab2GQFAq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 01:00:46 -0400
Received: from ozlabs.org ([203.10.76.45]:33679 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754077Ab2GQFAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 01:00:43 -0400
From: Michael Ellerman <michael@ellerman.id.au>
To: <kvm@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <matt@ozlabs.org>, <penberg@kernel.org>,
        <kvm-ppc@vger.kernel.org>, <prerna@linux.vnet.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>
Subject: [PATCH 01/10] kvm tools: Move mmap_anon_or_hugetblfs() into util
Date: Tue, 17 Jul 2012 15:00:11 +1000
Message-Id: <1342501220-10209-2-git-send-email-michael@ellerman.id.au>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1342501220-10209-1-git-send-email-michael@ellerman.id.au>
References: <1342501220-10209-1-git-send-email-michael@ellerman.id.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So we can use it on powerpc.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
---
 tools/kvm/include/kvm/util.h |    2 +-
 tools/kvm/util/util.c        |   13 +++++++++++++
 tools/kvm/x86/kvm.c          |   13 -------------
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/tools/kvm/include/kvm/util.h b/tools/kvm/include/kvm/util.h
index dabf544..3d1d987 100644
--- a/tools/kvm/include/kvm/util.h
+++ b/tools/kvm/include/kvm/util.h
@@ -90,6 +90,6 @@ static inline void msleep(unsigned int msecs)
 	usleep(MSECS_TO_USECS(msecs));
 }
 
-void *mmap_hugetlbfs(const char *htlbfs_path, u64 size);
+void *mmap_anon_or_hugetlbfs(const char *hugetlbfs_path, u64 size);
 
 #endif /* KVM__UTIL_H */
diff --git a/tools/kvm/util/util.c b/tools/kvm/util/util.c
index e7feebc..a80cf86 100644
--- a/tools/kvm/util/util.c
+++ b/tools/kvm/util/util.c
@@ -113,3 +113,16 @@ void *mmap_hugetlbfs(const char *htlbfs_path, u64 size)
 
 	return addr;
 }
+
+/* This function wraps the decision between hugetlbfs map (if requested) or normal mmap */
+void *mmap_anon_or_hugetlbfs(const char *hugetlbfs_path, u64 size)
+{
+	if (hugetlbfs_path)
+		/*
+		 * We don't /need/ to map guest RAM from hugetlbfs, but we do so
+		 * if the user specifies a hugetlbfs path.
+		 */
+		return mmap_hugetlbfs(hugetlbfs_path, size);
+	else
+		return mmap(NULL, size, PROT_RW, MAP_ANON_NORESERVE, -1, 0);
+}
diff --git a/tools/kvm/x86/kvm.c b/tools/kvm/x86/kvm.c
index 10a1212..8931639 100644
--- a/tools/kvm/x86/kvm.c
+++ b/tools/kvm/x86/kvm.c
@@ -128,19 +128,6 @@ void kvm__arch_set_cmdline(char *cmdline, bool video)
 		strcat(cmdline, " console=ttyS0 earlyprintk=serial i8042.noaux=1");
 }
 
-/* This function wraps the decision between hugetlbfs map (if requested) or normal mmap */
-static void *mmap_anon_or_hugetlbfs(const char *hugetlbfs_path, u64 size)
-{
-	if (hugetlbfs_path)
-		/*
-		 * We don't /need/ to map guest RAM from hugetlbfs, but we do so
-		 * if the user specifies a hugetlbfs path.
-		 */
-		return mmap_hugetlbfs(hugetlbfs_path, size);
-	else
-		return mmap(NULL, size, PROT_RW, MAP_ANON_NORESERVE, -1, 0);
-}
-
 /* Architecture-specific KVM init */
 void kvm__arch_init(struct kvm *kvm, const char *hugetlbfs_path, u64 ram_size)
 {
-- 
1.7.9.5

