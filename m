Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404Ab2HEJww (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 05:52:52 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:9388 "EHLO
	mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754253Ab2HEJwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 05:52:46 -0400
X-IronPort-AV: E=Sophos;i="4.77,715,1336341600"; 
   d="scan'208";a="152465605"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Alexander Graf <agraf@suse.de>
Cc: kernel-janitors@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Julia Lawall <julia@diku.dk>
Subject: [PATCH 3/6] arch/powerpc/kvm/e500_tlb.c: fix error return code
Date: Sun,  5 Aug 2012 11:52:33 +0200
Message-Id: <1344160356-387-4-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1344160356-387-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1344160356-387-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Convert a 0 error return code to a negative one, as returned elsewhere in the
function.

A new label is also added to avoid freeing things that are known to not yet
be allocated.

A simplified version of the semantic match that finds the first problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
identifier ret;
expression e,e1,e2,e3,e4,x;
@@

(
if (\(ret != 0\|ret < 0\) || ...) { ... return ...; }
|
ret = 0
)
... when != ret = e1
*x = \(kmalloc\|kzalloc\|kcalloc\|devm_kzalloc\|ioremap\|ioremap_nocache\|devm_ioremap\|devm_ioremap_nocache\)(...);
... when != x = e2
    when != ret = e3
*if (x == NULL || ...)
{
  ... when != ret = e4
*  return ret;
}
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 arch/powerpc/kvm/e500_tlb.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/kvm/e500_tlb.c b/arch/powerpc/kvm/e500_tlb.c
index c8f6c58..85fcdf7 100644
--- a/arch/powerpc/kvm/e500_tlb.c
+++ b/arch/powerpc/kvm/e500_tlb.c
@@ -1176,21 +1176,27 @@ int kvm_vcpu_ioctl_config_tlb(struct kvm_vcpu *vcpu,
 	}
 
 	virt = vmap(pages, num_pages, VM_MAP, PAGE_KERNEL);
-	if (!virt)
+	if (!virt) {
+		ret = -ENOMEM;
 		goto err_put_page;
+	}
 
 	privs[0] = kzalloc(sizeof(struct tlbe_priv) * params.tlb_sizes[0],
 			   GFP_KERNEL);
 	privs[1] = kzalloc(sizeof(struct tlbe_priv) * params.tlb_sizes[1],
 			   GFP_KERNEL);
 
-	if (!privs[0] || !privs[1])
-		goto err_put_page;
+	if (!privs[0] || !privs[1]) {
+		ret = -ENOMEM;
+		goto err_privs;
+	}
 
 	g2h_bitmap = kzalloc(sizeof(u64) * params.tlb_sizes[1],
 	                     GFP_KERNEL);
-	if (!g2h_bitmap)
-		goto err_put_page;
+	if (!g2h_bitmap) {
+		ret = -ENOMEM;
+		goto err_privs;
+	}
 
 	free_gtlb(vcpu_e500);
 
@@ -1230,10 +1236,11 @@ int kvm_vcpu_ioctl_config_tlb(struct kvm_vcpu *vcpu,
 	kvmppc_recalc_tlb1map_range(vcpu_e500);
 	return 0;
 
-err_put_page:
+err_privs:
 	kfree(privs[0]);
 	kfree(privs[1]);
 
+err_put_page:
 	for (i = 0; i < num_pages; i++)
 		put_page(pages[i]);
 
