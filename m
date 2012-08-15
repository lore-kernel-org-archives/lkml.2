Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769Ab2HOUSJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:18:09 -0400
Received: from mail.windriver.com ([147.11.1.11]:36880 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756735Ab2HOTvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:51:05 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Carsten Otte <cotte@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 089/165] KVM: s390: check cpu_id prior to using it
Date: Wed, 15 Aug 2012 15:47:13 -0400
Message-ID: <1345060109-9187-90-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Carsten Otte <cotte@de.ibm.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 4d47555a80495657161a7e71ec3014ff2021e450 upstream.

We use the cpu id provided by userspace as array index here. Thus we
clearly need to check it first. Ooops.

CC: <stable@vger.kernel.org>
Signed-off-by: Carsten Otte <cotte@de.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/s390/kvm/kvm-s390.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index ee7c713..a6015d1 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -311,11 +311,17 @@ int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu)
 struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
 				      unsigned int id)
 {
-	struct kvm_vcpu *vcpu = kzalloc(sizeof(struct kvm_vcpu), GFP_KERNEL);
-	int rc = -ENOMEM;
+	struct kvm_vcpu *vcpu;
+	int rc = -EINVAL;
+
+	if (id >= KVM_MAX_VCPUS)
+		goto out;
+
+	rc = -ENOMEM;
 
+	vcpu = kzalloc(sizeof(struct kvm_vcpu), GFP_KERNEL);
 	if (!vcpu)
-		goto out_nomem;
+		goto out;
 
 	vcpu->arch.sie_block = (struct kvm_s390_sie_block *)
 					get_zeroed_page(GFP_KERNEL);
@@ -350,7 +356,7 @@ out_free_sie_block:
 	free_page((unsigned long)(vcpu->arch.sie_block));
 out_free_cpu:
 	kfree(vcpu);
-out_nomem:
+out:
 	return ERR_PTR(rc);
 }
 
-- 
1.7.12.rc2

