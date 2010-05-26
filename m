Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774Ab0EZP5O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 11:57:14 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:40750 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755484Ab0EZP5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 11:57:10 -0400
Date: Wed, 26 May 2010 17:57:05 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       Xiantao Zhang <xiantao.zhang@intel.com>,
       Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
       kvm@vger.kernel.org, kvm-ia64@vger.kernel.org,
       linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 10/17] arch/ia64/kvm: Add missing spin_unlock
Message-ID: <Pine.LNX.4.64.1005261756490.23743@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Add a spin_unlock missing on the error path.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression E1;
@@

* spin_lock(E1,...);
  <+... when != E1
  if (...) {
    ... when != E1
*   return ...;
  }
  ...+>
* spin_unlock(E1,...);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 arch/ia64/kvm/kvm-ia64.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index d5f4e91..21b7013 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -144,6 +144,7 @@ int kvm_arch_hardware_enable(void *garbage)
 				VP_INIT_ENV : VP_INIT_ENV_INITALIZE,
 			__pa(kvm_vm_buffer), KVM_VM_BUFFER_BASE, &tmp_base);
 	if (status != 0) {
+		spin_unlock(&vp_lock);
 		printk(KERN_WARNING"kvm: Failed to Enable VT Support!!!!\n");
 		return -EINVAL;
 	}
