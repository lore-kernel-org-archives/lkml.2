Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760639Ab2EJRgQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:36:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53504 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757580Ab2EJRgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:36:10 -0400
Message-Id: <20120510173135.860774574@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 10 May 2012 10:32:06 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jens Freimann <jfrei@linux.vnet.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi@redhat.com>
Subject: [ 34/52] KVM: s390: do store status after handling STOP_ON_STOP bit
In-Reply-To: <20120510173229.GA5678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Jens Freimann <jfrei@linux.vnet.ibm.com>

(cherry picked from commit 9e0d5473e2f0ba2d2fe9dab9408edef3060b710e)

In handle_stop() handle the stop bit before doing the store status as
described for "Stop and Store Status" in the Principles of Operation.
We have to give up the local_int.lock before calling kvm store status
since it calls gmap_fault() which might sleep. Since local_int.lock
only protects local_int.* and not guest memory we can give up the lock.

Signed-off-by: Jens Freimann <jfrei@linux.vnet.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kvm/intercept.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

--- a/arch/s390/kvm/intercept.c
+++ b/arch/s390/kvm/intercept.c
@@ -133,13 +133,6 @@ static int handle_stop(struct kvm_vcpu *
 
 	vcpu->stat.exit_stop_request++;
 	spin_lock_bh(&vcpu->arch.local_int.lock);
-	if (vcpu->arch.local_int.action_bits & ACTION_STORE_ON_STOP) {
-		vcpu->arch.local_int.action_bits &= ~ACTION_STORE_ON_STOP;
-		rc = kvm_s390_vcpu_store_status(vcpu,
-						  KVM_S390_STORE_STATUS_NOADDR);
-		if (rc >= 0)
-			rc = -EOPNOTSUPP;
-	}
 
 	if (vcpu->arch.local_int.action_bits & ACTION_RELOADVCPU_ON_STOP) {
 		vcpu->arch.local_int.action_bits &= ~ACTION_RELOADVCPU_ON_STOP;
@@ -155,7 +148,18 @@ static int handle_stop(struct kvm_vcpu *
 		rc = -EOPNOTSUPP;
 	}
 
-	spin_unlock_bh(&vcpu->arch.local_int.lock);
+	if (vcpu->arch.local_int.action_bits & ACTION_STORE_ON_STOP) {
+		vcpu->arch.local_int.action_bits &= ~ACTION_STORE_ON_STOP;
+		/* store status must be called unlocked. Since local_int.lock
+		 * only protects local_int.* and not guest memory we can give
+		 * up the lock here */
+		spin_unlock_bh(&vcpu->arch.local_int.lock);
+		rc = kvm_s390_vcpu_store_status(vcpu,
+						KVM_S390_STORE_STATUS_NOADDR);
+		if (rc >= 0)
+			rc = -EOPNOTSUPP;
+	} else
+		spin_unlock_bh(&vcpu->arch.local_int.lock);
 	return rc;
 }
 


