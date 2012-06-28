Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932668Ab2F1GL4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 02:11:56 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:51506 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932560Ab2F1GIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 02:08:42 -0400
X-AuditID: b753bd60-900c0ba0000047ca-04-4febf4d3f481
X-AuditID: b753bd60-900c0ba0000047ca-04-4febf4d3f481
From: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Subject: [RFC PATCH 10/18] KVM: proxy slab operations for slave CPUs on online
 CPUs
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 28 Jun 2012 15:08:11 +0900
Message-ID: <20120628060811.19298.91859.stgit@localhost.localdomain>
In-Reply-To: <20120628060719.19298.43879.stgit@localhost.localdomain>
References: <20120628060719.19298.43879.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add some fix-ups that proxy slab operations on online CPUs for the guest,
in order to avoid touching slab on slave CPUs where some slab functions
are not activated.

Currently, slab may be touched on slave CPUs in following 3 cases.
For each cases, the fix-ups below are introduced:

* kvm_mmu_commit_zap_page
    With this patch, Instead of commiting zap pages, the pages are added
    into invalid_mmu_pages list and make KVM_REQ_COMMIT_ZAP_PAGE request.
    Then, the pages are freed on online CPUs after the execution of vCPU
    thread is resumed.

* mmu_topup_memory_caches
    Preallocate caches for mmu operations in vcpu_enter_guest_slave,
    which is done by online CPUs before entering guests.

* kvm_async_pf_wakeup_all
    If this function is called on slave CPUs, it makes KVM_REQ_WAKEUP_APF.
    The request is handled by calling kvm_async_pf_wakeup_all on online CPUs.

Signed-off-by: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---

 arch/x86/include/asm/kvm_host.h |    5 ++++
 arch/x86/kvm/mmu.c              |   50 ++++++++++++++++++++++++++++-----------
 arch/x86/kvm/mmu.h              |    4 +++
 arch/x86/kvm/x86.c              |   15 ++++++++++++
 virt/kvm/async_pf.c             |    8 ++++++
 5 files changed, 68 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f8fd1a1..6745057 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -69,6 +69,8 @@
 #ifdef CONFIG_SLAVE_CPU
 /* Requests to handle VM exit on online cpu */
 #define KVM_REQ_HANDLE_PF	32
+#define KVM_REQ_COMMIT_ZAP_PAGE	33
+#define KVM_REQ_WAKEUP_APF	34
 #endif
 
 /* KVM Hugepage definitions for x86 */
@@ -529,6 +531,9 @@ struct kvm_arch {
 	 * Hash table of struct kvm_mmu_page.
 	 */
 	struct list_head active_mmu_pages;
+#ifdef CONFIG_SLAVE_CPU
+	struct list_head invalid_mmu_pages;
+#endif
 	struct list_head assigned_dev_head;
 	struct iommu_domain *iommu_domain;
 	int iommu_flags;
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index a179ebc..9ceafa5 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -585,6 +585,10 @@ static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache,
 
 	if (cache->nobjs >= min)
 		return 0;
+#ifdef CONFIG_SLAVE_CPU
+	if (cpu_slave(smp_processor_id()))
+		return -ENOMEM;
+#endif
 	while (cache->nobjs < ARRAY_SIZE(cache->objects)) {
 		obj = kmem_cache_zalloc(base_cache, GFP_KERNEL);
 		if (!obj)
@@ -628,7 +632,7 @@ static void mmu_free_memory_cache_page(struct kvm_mmu_memory_cache *mc)
 		free_page((unsigned long)mc->objects[--mc->nobjs]);
 }
 
-static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu)
+int mmu_topup_memory_caches(struct kvm_vcpu *vcpu)
 {
 	int r;
 
@@ -1545,7 +1549,7 @@ static void kvm_unlink_unsync_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 
 static int kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
 				    struct list_head *invalid_list);
-static void kvm_mmu_commit_zap_page(struct kvm *kvm,
+static void kvm_mmu_commit_zap_page(struct kvm *kvm, struct kvm_vcpu *vcpu,
 				    struct list_head *invalid_list);
 
 #define for_each_gfn_sp(kvm, sp, gfn, pos)				\
@@ -1588,7 +1592,7 @@ static int kvm_sync_page_transient(struct kvm_vcpu *vcpu,
 
 	ret = __kvm_sync_page(vcpu, sp, &invalid_list, false);
 	if (ret)
-		kvm_mmu_commit_zap_page(vcpu->kvm, &invalid_list);
+		kvm_mmu_commit_zap_page(vcpu->kvm, vcpu, &invalid_list);
 
 	return ret;
 }
@@ -1628,7 +1632,7 @@ static void kvm_sync_pages(struct kvm_vcpu *vcpu,  gfn_t gfn)
 		flush = true;
 	}
 
-	kvm_mmu_commit_zap_page(vcpu->kvm, &invalid_list);
+	kvm_mmu_commit_zap_page(vcpu->kvm, vcpu, &invalid_list);
 	if (flush)
 		kvm_mmu_flush_tlb(vcpu);
 }
@@ -1715,7 +1719,7 @@ static void mmu_sync_children(struct kvm_vcpu *vcpu,
 			kvm_sync_page(vcpu, sp, &invalid_list);
 			mmu_pages_clear_parents(&parents);
 		}
-		kvm_mmu_commit_zap_page(vcpu->kvm, &invalid_list);
+		kvm_mmu_commit_zap_page(vcpu->kvm, vcpu, &invalid_list);
 		cond_resched_lock(&vcpu->kvm->mmu_lock);
 		kvm_mmu_pages_init(parent, &parents, &pages);
 	}
@@ -2001,7 +2005,7 @@ static int kvm_mmu_prepare_zap_page(struct kvm *kvm, struct kvm_mmu_page *sp,
 	return ret;
 }
 
-static void kvm_mmu_commit_zap_page(struct kvm *kvm,
+static void kvm_mmu_commit_zap_page(struct kvm *kvm, struct kvm_vcpu *vcpu,
 				    struct list_head *invalid_list)
 {
 	struct kvm_mmu_page *sp;
@@ -2015,6 +2019,16 @@ static void kvm_mmu_commit_zap_page(struct kvm *kvm,
 	 */
 	smp_mb();
 
+#ifdef CONFIG_SLAVE_CPU
+	if (cpu_slave(smp_processor_id())) {
+		/* Avoid touching kmem_cache on slave cpu */
+		list_splice_init(invalid_list, &kvm->arch.invalid_mmu_pages);
+		if (vcpu)
+			kvm_make_request(KVM_REQ_COMMIT_ZAP_PAGE, vcpu);
+		return;
+	}
+#endif
+
 	/*
 	 * Wait for all vcpus to exit guest mode and/or lockless shadow
 	 * page table walks.
@@ -2029,6 +2043,14 @@ static void kvm_mmu_commit_zap_page(struct kvm *kvm,
 	} while (!list_empty(invalid_list));
 }
 
+#ifdef CONFIG_SLAVE_CPU
+void kvm_mmu_commit_zap_page_late(struct kvm_vcpu *vcpu)
+{
+	kvm_mmu_commit_zap_page(vcpu->kvm, vcpu,
+				&vcpu->kvm->arch.invalid_mmu_pages);
+}
+#endif
+
 /*
  * Changing the number of mmu pages allocated to the vm
  * Note: if goal_nr_mmu_pages is too small, you will get dead lock
@@ -2051,7 +2073,7 @@ void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned int goal_nr_mmu_pages)
 					    struct kvm_mmu_page, link);
 			kvm_mmu_prepare_zap_page(kvm, page, &invalid_list);
 		}
-		kvm_mmu_commit_zap_page(kvm, &invalid_list);
+		kvm_mmu_commit_zap_page(kvm, NULL, &invalid_list);
 		goal_nr_mmu_pages = kvm->arch.n_used_mmu_pages;
 	}
 
@@ -2074,7 +2096,7 @@ int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn)
 		r = 1;
 		kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
 	}
-	kvm_mmu_commit_zap_page(kvm, &invalid_list);
+	kvm_mmu_commit_zap_page(kvm, NULL, &invalid_list);
 	spin_unlock(&kvm->mmu_lock);
 
 	return r;
@@ -2702,7 +2724,7 @@ static void mmu_free_roots(struct kvm_vcpu *vcpu)
 		--sp->root_count;
 		if (!sp->root_count && sp->role.invalid) {
 			kvm_mmu_prepare_zap_page(vcpu->kvm, sp, &invalid_list);
-			kvm_mmu_commit_zap_page(vcpu->kvm, &invalid_list);
+			kvm_mmu_commit_zap_page(vcpu->kvm, vcpu, &invalid_list);
 		}
 		vcpu->arch.mmu.root_hpa = INVALID_PAGE;
 		spin_unlock(&vcpu->kvm->mmu_lock);
@@ -2721,7 +2743,7 @@ static void mmu_free_roots(struct kvm_vcpu *vcpu)
 		}
 		vcpu->arch.mmu.pae_root[i] = INVALID_PAGE;
 	}
-	kvm_mmu_commit_zap_page(vcpu->kvm, &invalid_list);
+	kvm_mmu_commit_zap_page(vcpu->kvm, vcpu, &invalid_list);
 	spin_unlock(&vcpu->kvm->mmu_lock);
 	vcpu->arch.mmu.root_hpa = INVALID_PAGE;
 }
@@ -3734,7 +3756,7 @@ void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 		}
 	}
 	mmu_pte_write_flush_tlb(vcpu, zap_page, remote_flush, local_flush);
-	kvm_mmu_commit_zap_page(vcpu->kvm, &invalid_list);
+	kvm_mmu_commit_zap_page(vcpu->kvm, vcpu, &invalid_list);
 	kvm_mmu_audit(vcpu, AUDIT_POST_PTE_WRITE);
 	spin_unlock(&vcpu->kvm->mmu_lock);
 }
@@ -3768,7 +3790,7 @@ void __kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu)
 		kvm_mmu_prepare_zap_page(vcpu->kvm, sp, &invalid_list);
 		++vcpu->kvm->stat.mmu_recycled;
 	}
-	kvm_mmu_commit_zap_page(vcpu->kvm, &invalid_list);
+	kvm_mmu_commit_zap_page(vcpu->kvm, vcpu, &invalid_list);
 }
 
 static bool is_mmio_page_fault(struct kvm_vcpu *vcpu, gva_t addr)
@@ -3941,7 +3963,7 @@ restart:
 		if (kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list))
 			goto restart;
 
-	kvm_mmu_commit_zap_page(kvm, &invalid_list);
+	kvm_mmu_commit_zap_page(kvm, NULL, &invalid_list);
 	spin_unlock(&kvm->mmu_lock);
 }
 
@@ -3980,7 +4002,7 @@ static int mmu_shrink(struct shrinker *shrink, struct shrink_control *sc)
 		}
 		nr_to_scan--;
 
-		kvm_mmu_commit_zap_page(kvm, &invalid_list);
+		kvm_mmu_commit_zap_page(kvm, NULL, &invalid_list);
 		spin_unlock(&kvm->mmu_lock);
 		srcu_read_unlock(&kvm->srcu, idx);
 	}
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index e374db9..32efc36 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -52,6 +52,10 @@ int kvm_mmu_get_spte_hierarchy(struct kvm_vcpu *vcpu, u64 addr, u64 sptes[4]);
 void kvm_mmu_set_mmio_spte_mask(u64 mmio_mask);
 int handle_mmio_page_fault_common(struct kvm_vcpu *vcpu, u64 addr, bool direct);
 int kvm_init_shadow_mmu(struct kvm_vcpu *vcpu, struct kvm_mmu *context);
+int mmu_topup_memory_caches(struct kvm_vcpu *vcpu);
+#ifdef CONFIG_SLAVE_CPU
+void kvm_mmu_commit_zap_page_late(struct kvm_vcpu *vcpu);
+#endif
 
 static inline unsigned int kvm_mmu_available_pages(struct kvm *kvm)
 {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1558ec2..df5eb05 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5558,6 +5558,11 @@ static void __vcpu_enter_guest_slave(void *_arg)
 			arg->ret = LOOP_ONLINE;
 			break;
 		}
+		if (test_bit(KVM_REQ_COMMIT_ZAP_PAGE, &vcpu->requests) ||
+		    test_bit(KVM_REQ_WAKEUP_APF,      &vcpu->requests)) {
+			r = LOOP_ONLINE;
+			break;
+		}
 
 		r = vcpu_post_run(vcpu, arg->task, &arg->apf_pending);
 
@@ -5587,6 +5592,9 @@ static int vcpu_enter_guest_slave(struct kvm_vcpu *vcpu,
 
 	BUG_ON((unsigned)slave >= nr_cpu_ids || !cpu_slave(slave));
 
+	/* Refill memory caches here to avoid calling slab on slave cpu */
+	mmu_topup_memory_caches(vcpu);
+
 	preempt_disable();
 	preempt_notifier_unregister(&vcpu->preempt_notifier);
 	kvm_arch_vcpu_put_migrate(vcpu);
@@ -5618,6 +5626,10 @@ static int vcpu_enter_guest_slave(struct kvm_vcpu *vcpu,
 				       vcpu->arch.page_fault.insn,
 				       vcpu->arch.page_fault.insn_len);
 	}
+	if (kvm_check_request(KVM_REQ_WAKEUP_APF, vcpu))
+		kvm_async_pf_wakeup_all(vcpu);
+	if (kvm_check_request(KVM_REQ_COMMIT_ZAP_PAGE, vcpu))
+		kvm_mmu_commit_zap_page_late(vcpu);
 
 	return r;
 }
@@ -6472,6 +6484,9 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 		return -EINVAL;
 
 	INIT_LIST_HEAD(&kvm->arch.active_mmu_pages);
+#ifdef CONFIG_SLAVE_CPU
+	INIT_LIST_HEAD(&kvm->arch.invalid_mmu_pages);
+#endif
 	INIT_LIST_HEAD(&kvm->arch.assigned_dev_head);
 
 	/* Reserve bit 0 of irq_sources_bitmap for userspace irq source */
diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
index feb5e76..8314225 100644
--- a/virt/kvm/async_pf.c
+++ b/virt/kvm/async_pf.c
@@ -204,6 +204,14 @@ int kvm_async_pf_wakeup_all(struct kvm_vcpu *vcpu)
 	if (!list_empty_careful(&vcpu->async_pf.done))
 		return 0;
 
+#ifdef CONFIG_SLAVE_CPU
+	if (cpu_slave(smp_processor_id())) {
+		/* Redo on online cpu to avoid kmem_cache_alloc on slave cpu */
+		kvm_make_request(KVM_REQ_WAKEUP_APF, vcpu);
+		return -ENOMEM;
+	}
+#endif
+
 	work = kmem_cache_zalloc(async_pf_cache, GFP_ATOMIC);
 	if (!work)
 		return -ENOMEM;


