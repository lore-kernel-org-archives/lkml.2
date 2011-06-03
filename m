Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035Ab1FCUFF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 16:05:05 -0400
Received: from smtp-out.google.com ([216.239.44.51]:40306 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437Ab1FCUFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 16:05:03 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=X+rOfy0+Q5z3oRgmxXDO7tBgqxkfAdjo6YqOF8ER5tXnK2MeKTyUVni6LanL5947O
	46/sw2Jv3isegBZg0/Oqg==
From: Mike Waychison <mikew@google.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: digitaleric@google.com, san@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Mike Waychison <mikew@google.com>
Subject: [PATCH] KVM: Initialize kvm before registering the mmu notifier
Date: Fri,  3 Jun 2011 13:04:53 -0700
Message-Id: <1307131493-553-1-git-send-email-mikew@google.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It doesn't make sense to ever see a half-initialized kvm structure on
mmu notifier callbacks.  Previously, 85722cda changed the ordering to
ensure that the mmu_lock was initialized before mmu notifier
registration, but there is still a race where the mmu notifier could
come in and try accessing other portions of struct kvm before they are
intialized.

Solve this by moving the mmu notifier registration to occur after the
structure is completely initialized.

Google-Bug-Id: 452199
Signed-off-by: Mike Waychison <mikew@google.com>

---
Applies to Linus' tree.
---
 virt/kvm/kvm_main.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 22cdb96..ba781f4 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -467,12 +467,8 @@ static struct kvm *kvm_create_vm(void)
 		if (!kvm->buses[i])
 			goto out_err;
 	}
-	spin_lock_init(&kvm->mmu_lock);
-
-	r = kvm_init_mmu_notifier(kvm);
-	if (r)
-		goto out_err;
 
+	spin_lock_init(&kvm->mmu_lock);
 	kvm->mm = current->mm;
 	atomic_inc(&kvm->mm->mm_count);
 	kvm_eventfd_init(kvm);
@@ -480,6 +476,11 @@ static struct kvm *kvm_create_vm(void)
 	mutex_init(&kvm->irq_lock);
 	mutex_init(&kvm->slots_lock);
 	atomic_set(&kvm->users_count, 1);
+
+	r = kvm_init_mmu_notifier(kvm);
+	if (r)
+		goto out_err;
+
 	raw_spin_lock(&kvm_lock);
 	list_add(&kvm->vm_list, &vm_list);
 	raw_spin_unlock(&kvm_lock);
-- 
1.7.3.1

