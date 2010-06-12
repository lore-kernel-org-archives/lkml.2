Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825Ab0FLGyU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 02:54:20 -0400
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:42493 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699Ab0FLGyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 02:54:18 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
Organization: IBM
To: Martin Schwidefsky <schwidefsky@de.ibm.com>, Avi Kivity <avi@redhat.com>
Subject: Re: next June 10: S390 build failure [arch/s390/kvm/kvm.ko]
Date: Sat, 12 Jun 2010 08:54:13 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc2-self-00089-g63a07cb; KDE/4.4.3; x86_64; ; )
Cc: Sachin Sant <sachinp@in.ibm.com>, Carsten Otte <cotte@de.ibm.com>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-s390@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>
References: <20100610160012.30ea7606.sfr@canb.auug.org.au> <4C10DCB7.7090903@in.ibm.com> <20100610154848.616aff99@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <20100610154848.616aff99@mschwide.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006120854.14259.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 10 Juni 2010, 15:48:48 schrieb Martin Schwidefsky:
> On Thu, 10 Jun 2010 18:08:15 +0530
> Sachin Sant <sachinp@in.ibm.com> wrote:
> 
> > Today's next fails to build on a s390 box with
> > 
> > ERROR: "__kvm_s390_vcpu_store_status" [arch/s390/kvm/kvm.ko] undefined!
> > 
> > Yesterday's next was good.
> 
> That is caused by git commit fbc5eec58e652339e9df1332cd5e10e8d8250aaf
> which fails to take git commit 5288fbf0ef041ba0e8b4dcb2df4536b5e3a48b32
> into account. There is a second caller of __kvm_s390_vcpu_store_status
> in arch/s390/kvm/intercept.c. As far as I understand the code you could
> just drop the 'static' from kvm_s390_vcpu_store_status and call it from
> handle_stop instead of the old __kvm_s390_vcpu_store_status.
> 
> Carsten, Christian: could one of you have a look please?

that patch should do the trick. Avi can you add that to kvm.git?

kvm-s390: Fix build failure 

This patch fixes 
ERROR: "__kvm_s390_vcpu_store_status" [arch/s390/kvm/kvm.ko] undefined!

triggered by
commit 3268c56840dcee78c3e928336550f4e1861504c4 (kvm.git)
Author: Avi Kivity <avi@redhat.com>
Date:   Thu May 13 12:21:46 2010 +0300
    KVM: s390: Centrally lock arch specific vcpu ioctls
    
Reported-by: Sachin Sant <sachinp@in.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>

---
 arch/s390/kvm/intercept.c |    2 +-
 arch/s390/kvm/kvm-s390.c  |    2 +-
 arch/s390/kvm/kvm-s390.h  |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

Index: kvm/arch/s390/kvm/intercept.c
===================================================================
--- kvm.orig/arch/s390/kvm/intercept.c
+++ kvm/arch/s390/kvm/intercept.c
@@ -135,7 +135,7 @@ static int handle_stop(struct kvm_vcpu *
 	spin_lock_bh(&vcpu->arch.local_int.lock);
 	if (vcpu->arch.local_int.action_bits & ACTION_STORE_ON_STOP) {
 		vcpu->arch.local_int.action_bits &= ~ACTION_STORE_ON_STOP;
-		rc = __kvm_s390_vcpu_store_status(vcpu,
+		rc = kvm_s390_vcpu_store_status(vcpu,
 						  KVM_S390_STORE_STATUS_NOADDR);
 		if (rc >= 0)
 			rc = -EOPNOTSUPP;
Index: kvm/arch/s390/kvm/kvm-s390.c
===================================================================
--- kvm.orig/arch/s390/kvm/kvm-s390.c
+++ kvm/arch/s390/kvm/kvm-s390.c
@@ -569,7 +569,7 @@ static int __guestcopy(struct kvm_vcpu *
  * KVM_S390_STORE_STATUS_NOADDR: -> 0x1200 on 64 bit
  * KVM_S390_STORE_STATUS_PREFIXED: -> prefix
  */
-static int kvm_s390_vcpu_store_status(struct kvm_vcpu *vcpu, unsigned long addr)
+int kvm_s390_vcpu_store_status(struct kvm_vcpu *vcpu, unsigned long addr)
 {
 	const unsigned char archmode = 1;
 	int prefix;
Index: kvm/arch/s390/kvm/kvm-s390.h
===================================================================
--- kvm.orig/arch/s390/kvm/kvm-s390.h
+++ kvm/arch/s390/kvm/kvm-s390.h
@@ -92,7 +92,7 @@ int kvm_s390_handle_b2(struct kvm_vcpu *
 int kvm_s390_handle_sigp(struct kvm_vcpu *vcpu);
 
 /* implemented in kvm-s390.c */
-int __kvm_s390_vcpu_store_status(struct kvm_vcpu *vcpu,
+int kvm_s390_vcpu_store_status(struct kvm_vcpu *vcpu,
 				 unsigned long addr);
 /* implemented in diag.c */
 int kvm_s390_handle_diag(struct kvm_vcpu *vcpu);
