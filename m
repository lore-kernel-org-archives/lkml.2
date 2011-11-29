Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905Ab1K2Vg1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 16:36:27 -0500
Received: from oz.csail.mit.edu ([128.30.30.239]:41249 "EHLO mail.mgebm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752781Ab1K2VgY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 16:36:24 -0500
From: Eric B Munson <emunson@mgebm.net>
To: qemu-devel@nongnu.org
Cc: Eric B Munson <emunson@mgebm.net>, ryanh@linux.vnet.ibm.com,
        aliguori@us.ibm.com, mtosatti@redhat.com, avi@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Guest stop notification
Date: Tue, 29 Nov 2011 16:36:14 -0500
Message-Id: <1322602574-27072-1-git-send-email-emunson@mgebm.net>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Often when a guest is stopped from the qemu console, it will report spurious
soft lockup warnings on resume.  There are kernel patches being discussed that
will give the host the ability to tell the guest that it is being stopped and
should ignore the soft lockup warning that generates.

Signed-off-by: Eric B Munson <emunson@mgebm.net>
Cc: ryanh@linux.vnet.ibm.com
Cc: aliguori@us.ibm.com
Cc: mtosatti@redhat.com
Cc: avi@redhat.com
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 target-i386/kvm.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/target-i386/kvm.c b/target-i386/kvm.c
index 5bfc21f..defd364 100644
--- a/target-i386/kvm.c
+++ b/target-i386/kvm.c
@@ -336,12 +336,18 @@ static int kvm_inject_mce_oldstyle(CPUState *env)
     return 0;
 }
 
+static void kvm_put_guest_paused(CPUState *penv)
+{
+    kvm_vcpu_ioctl(penv, KVM_GUEST_PAUSED, 0);
+}
+
 static void cpu_update_state(void *opaque, int running, RunState state)
 {
     CPUState *env = opaque;
 
     if (running) {
         env->tsc_valid = false;
+	kvm_put_guest_paused(env);
     }
 }
 
-- 
1.7.5.4

