Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209Ab2BEW0g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:26:36 -0500
Received: from 1wt.eu ([62.212.114.60]:61953 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754036Ab2BEW0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:26:31 -0500
Message-Id: <20120205220951.461594058@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:10:36 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Carsten Otte <cotte@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 47/91] KVM: s390: check cpu_id prior to using it
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

commit 4d47555a80495657161a7e71ec3014ff2021e450 upstream.

We use the cpu id provided by userspace as array index here. Thus we
clearly need to check it first. Ooops.

Signed-off-by: Carsten Otte <cotte@de.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/s390/kvm/kvm-s390.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)

Index: longterm-2.6.27/arch/s390/kvm/kvm-s390.c
===================================================================
--- longterm-2.6.27.orig/arch/s390/kvm/kvm-s390.c	2012-02-05 22:34:33.588915140 +0100
+++ longterm-2.6.27/arch/s390/kvm/kvm-s390.c	2012-02-05 22:34:41.524915249 +0100
@@ -274,11 +274,17 @@
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
@@ -313,7 +319,7 @@
 	return vcpu;
 out_free_cpu:
 	kfree(vcpu);
-out_nomem:
+out:
 	return ERR_PTR(rc);
 }
 


