Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673Ab1EDNbT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 09:31:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25778 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753561Ab1EDNbQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 09:31:16 -0400
From: Gleb Natapov <gleb@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: avi@redhat.com, mtosatti@redhat.com, kvm@vger.kernel.org,
        paulmck@linux.vnet.ibm.com
Subject: [PATCH 2/2] KVM: make guest mode entry to be rcu quiescent state
Date: Wed,  4 May 2011 16:31:04 +0300
Message-Id: <1304515864-17105-3-git-send-email-gleb@redhat.com>
In-Reply-To: <1304515864-17105-1-git-send-email-gleb@redhat.com>
References: <1304515864-17105-1-git-send-email-gleb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KVM does not hold any references to rcu protected data when it switches
CPU into a guest mode. In fact switching to a guest mode is very similar
to exiting to userspase from rcu point of view. In addition CPU may stay
in a guest mode for quite a long time (up to one time slice). Lets treat
guest mode as quiescent state, just like we do with user-mode execution.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
---
 include/linux/kvm_host.h |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 0bc3d37..244413f 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -591,8 +591,17 @@ static inline int kvm_deassign_device(struct kvm *kvm,
 
 static inline void kvm_guest_enter(void)
 {
+	BUG_ON(preemptible());
 	account_system_vtime(current);
 	current->flags |= PF_VCPU;
+	/* KVM does not hold any references to rcu protected data when it
+ 	 * switches CPU into a guest mode. In fact switching to a guest mode
+ 	 * is very similar to exiting to userspase from rcu point of view. In
+ 	 * addition CPU may stay in a guest mode for quite a long time (up to
+ 	 * one time slice). Lets treat guest mode as quiescent state, just like
+ 	 * we do with user-mode execution.
+ 	 */
+	rcu_virt_note_context_switch(smp_processor_id());
 }
 
 static inline void kvm_guest_exit(void)
-- 
1.7.4.4

