Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758299Ab1D1JwN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 05:52:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17410 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754597Ab1D1JwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 05:52:10 -0400
From: Gleb Natapov <gleb@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: paulmck@linux.vnet.ibm.com, avi@redhat.com, mtosatti@redhat.com,
        kvm@vger.kernel.org
Subject: [PATCH 2/2] KVM: make guest mode entry to be rcu quiescent state
Date: Thu, 28 Apr 2011 12:52:03 +0300
Message-Id: <1303984323-3203-3-git-send-email-gleb@redhat.com>
In-Reply-To: <1303984323-3203-1-git-send-email-gleb@redhat.com>
References: <1303984323-3203-1-git-send-email-gleb@redhat.com>
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
 include/linux/kvm_host.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 0bc3d37..a347bce 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -593,6 +593,7 @@ static inline void kvm_guest_enter(void)
 {
 	account_system_vtime(current);
 	current->flags |= PF_VCPU;
+	rcu_note_context_switch(smp_processor_id());
 }
 
 static inline void kvm_guest_exit(void)
-- 
1.7.2.3

