Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498Ab0GFQZg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 12:25:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11138 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753550Ab0GFQZe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 12:25:34 -0400
From: Gleb Natapov <gleb@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, avi@redhat.com,
       mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       hpa@zytor.com, riel@redhat.com, cl@linux-foundation.org,
       mtosatti@redhat.com
Subject: [PATCH v4 07/12] Maintain memslot version number
Date: Tue,  6 Jul 2010 19:24:55 +0300
Message-Id: <1278433500-29884-8-git-send-email-gleb@redhat.com>
In-Reply-To: <1278433500-29884-1-git-send-email-gleb@redhat.com>
References: <1278433500-29884-1-git-send-email-gleb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Code that depends on particular memslot layout can track changes and
adjust to new layout.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
---
 include/linux/kvm_host.h |    1 +
 virt/kvm/kvm_main.c      |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index e796326..64f62f1 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -177,6 +177,7 @@ struct kvm {
 	raw_spinlock_t requests_lock;
 	struct mutex slots_lock;
 	struct mm_struct *mm; /* userspace tied to this vm */
+	u32 memslot_version;
 	struct kvm_memslots *memslots;
 	struct srcu_struct srcu;
 #ifdef CONFIG_KVM_APIC_ARCHITECTURE
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a60b6b0..733558c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -730,6 +730,7 @@ skip_lpage:
 	slots->memslots[mem->slot] = new;
 	old_memslots = kvm->memslots;
 	rcu_assign_pointer(kvm->memslots, slots);
+	kvm->memslot_version++;
 	synchronize_srcu_expedited(&kvm->srcu);
 
 	kvm_arch_commit_memory_region(kvm, mem, old, user_alloc);
-- 
1.7.1

