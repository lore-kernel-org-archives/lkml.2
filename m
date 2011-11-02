Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935087Ab1KCBo2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:44:28 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51622 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935068Ab1KCBoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:44:05 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:27:47 2011
Message-Id: <20111102222746.995042061@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:27:03 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Carsten Otte <cotte@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [079/101] KVM: s390: check cpu_id prior to using it
In-Reply-To: <20111102222755.GA10893@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Carsten Otte <cotte@de.ibm.com>

commit 4d47555a80495657161a7e71ec3014ff2021e450 upstream.

We use the cpu id provided by userspace as array index here. Thus we
clearly need to check it first. Ooops.

Signed-off-by: Carsten Otte <cotte@de.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/s390/kvm/kvm-s390.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -309,11 +309,17 @@ int kvm_arch_vcpu_setup(struct kvm_vcpu
 struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm,
 				      unsigned int id)
 {
-	struct kvm_vcpu *vcpu = kzalloc(sizeof(struct kvm_vcpu), GFP_KERNEL);
-	int rc = -ENOMEM;
+	struct kvm_vcpu *vcpu;
+	int rc = -EINVAL;
 
+	if (id >= KVM_MAX_VCPUS)
+		goto out;
+
+	rc = -ENOMEM;
+
+	vcpu = kzalloc(sizeof(struct kvm_vcpu), GFP_KERNEL);
 	if (!vcpu)
-		goto out_nomem;
+		goto out;
 
 	vcpu->arch.sie_block = (struct kvm_s390_sie_block *)
 					get_zeroed_page(GFP_KERNEL);
@@ -348,7 +354,7 @@ out_free_sie_block:
 	free_page((unsigned long)(vcpu->arch.sie_block));
 out_free_cpu:
 	kfree(vcpu);
-out_nomem:
+out:
 	return ERR_PTR(rc);
 }
 


