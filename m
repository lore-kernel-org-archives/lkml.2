Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658Ab2E1Dyw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:54:52 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51853 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753368Ab2E1D3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:04 -0400
Message-Id: <20120528031203.715402396@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:12:08 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Marcelo Tosatti <mtosatti@redhat.com>,
        Jens Freimann <jfrei@linux.vnet.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Avi Kivity <avi@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 006/117] KVM: s390: do store status after handling STOP_ON_STOP bit
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcelo Tosatti <mtosatti@redhat.com>

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/s390/kvm/intercept.c |   20 ++++++++++++--------
 1 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
index 0243454..a5f6eff 100644
--- a/arch/s390/kvm/intercept.c
+++ b/arch/s390/kvm/intercept.c
@@ -133,13 +133,6 @@ static int handle_stop(struct kvm_vcpu *vcpu)
 
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
@@ -155,7 +148,18 @@ static int handle_stop(struct kvm_vcpu *vcpu)
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
 


