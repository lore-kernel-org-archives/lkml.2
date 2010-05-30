Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909Ab0E3U21 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 16:28:27 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:36221 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754522Ab0E3U2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 16:28:25 -0400
Date: Sun, 30 May 2010 22:28:14 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Carsten Otte <cotte@de.ibm.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>, linux390@de.ibm.com,
       Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 3/3] arch/s390/kvm: Use GFP_ATOMIC when a lock is held
Message-ID: <Pine.LNX.4.64.1005302227470.19253@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The containing function is called from several places.  At one of them, in
the function __sigp_stop, the spin lock &fi->lock is held.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@gfp exists@
identifier fn;
position p;
@@

fn(...) {
... when != spin_unlock
    when any
  GFP_KERNEL@p
 ... when any
}

@locked@
identifier gfp.fn;
@@

spin_lock(...)
... when != spin_unlock
fn(...)

@depends on locked@
position gfp.p;
@@

- GFP_KERNEL@p
+ GFP_ATOMIC
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 arch/s390/kvm/sigp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/arch/s390/kvm/sigp.c b/arch/s390/kvm/sigp.c
--- a/arch/s390/kvm/sigp.c
+++ b/arch/s390/kvm/sigp.c
@@ -113,7 +113,7 @@ static int __inject_sigp_stop(struct kvm
 {
 	struct kvm_s390_interrupt_info *inti;
 
-	inti = kzalloc(sizeof(*inti), GFP_KERNEL);
+	inti = kzalloc(sizeof(*inti), GFP_ATOMIC);
 	if (!inti)
 		return -ENOMEM;
 	inti->type = KVM_S390_SIGP_STOP;
