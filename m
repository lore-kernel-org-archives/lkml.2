Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757957Ab1GAVbL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 17:31:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22625 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757801Ab1GAVav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 17:30:51 -0400
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Gleb Natapov <gleb@redhat.com>
Subject: [PATCH v4 1/9] introduce kvm_read_guest_cached
Date: Fri,  1 Jul 2011 17:22:41 -0400
Message-Id: <1309555369-16867-2-git-send-email-glommer@redhat.com>
In-Reply-To: <1309555369-16867-1-git-send-email-glommer@redhat.com>
References: <1309555369-16867-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

Introduce kvm_read_guest_cached() function in addition to write one we
already have.

[ by glauber: export function signature in kvm header ]

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Glauber Costa <glommer@redhat.com>
---
 include/linux/kvm_host.h |    2 ++
 virt/kvm/kvm_main.c      |   20 ++++++++++++++++++++
 2 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 31ebb59..f7df0a3 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -381,6 +381,8 @@ int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
 int kvm_read_guest_atomic(struct kvm *kvm, gpa_t gpa, void *data,
 			  unsigned long len);
 int kvm_read_guest(struct kvm *kvm, gpa_t gpa, void *data, unsigned long len);
+int kvm_read_guest_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
+			   void *data, unsigned long len);
 int kvm_write_guest_page(struct kvm *kvm, gfn_t gfn, const void *data,
 			 int offset, int len);
 int kvm_write_guest(struct kvm *kvm, gpa_t gpa, const void *data,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 11d2783..d5ef9eb 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1418,6 +1418,26 @@ int kvm_write_guest_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
 }
 EXPORT_SYMBOL_GPL(kvm_write_guest_cached);
 
+int kvm_read_guest_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
+			   void *data, unsigned long len)
+{
+	struct kvm_memslots *slots = kvm_memslots(kvm);
+	int r;
+
+	if (slots->generation != ghc->generation)
+		kvm_gfn_to_hva_cache_init(kvm, ghc, ghc->gpa);
+
+	if (kvm_is_error_hva(ghc->hva))
+		return -EFAULT;
+
+	r = __copy_from_user(data, (void __user *)ghc->hva, len);
+	if (r)
+		return -EFAULT;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kvm_read_guest_cached);
+
 int kvm_clear_guest_page(struct kvm *kvm, gfn_t gfn, int offset, int len)
 {
 	return kvm_write_guest_page(kvm, gfn, (const void *) empty_zero_page,
-- 
1.7.3.4

