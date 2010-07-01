Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759348Ab0GAVa1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:30:27 -0400
Received: from kroah.org ([198.145.64.141]:33236 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759124Ab0GAVPX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:15:23 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:43:02 2010
Message-Id: <20100701174302.073506620@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:44:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Wei Yongjun <yjwei@cn.fujitsu.com>, Carsten Otte <cotte@de.ibm.com>,
       Avi Kivity <avi@redhat.com>
Subject: [184/200] KVM: s390: Fix possible memory leak of in kvm_arch_vcpu_create()
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Yongjun <yjwei@cn.fujitsu.com>

This patch fixed possible memory leak in kvm_arch_vcpu_create()
under s390, which would happen when kvm_arch_vcpu_create() fails.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
Acked-by: Carsten Otte <cotte@de.ibm.com>
Cc: stable@kernel.org
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

(Cherry-picked from commit 7b06bf2ffa15e119c7439ed0b024d44f66d7b605)
---
 arch/s390/kvm/kvm-s390.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -341,11 +341,13 @@ struct kvm_vcpu *kvm_arch_vcpu_create(st
 
 	rc = kvm_vcpu_init(vcpu, kvm, id);
 	if (rc)
-		goto out_free_cpu;
+		goto out_free_sie_block;
 	VM_EVENT(kvm, 3, "create cpu %d at %p, sie block at %p", id, vcpu,
 		 vcpu->arch.sie_block);
 
 	return vcpu;
+out_free_sie_block:
+	free_page((unsigned long)(vcpu->arch.sie_block));
 out_free_cpu:
 	kfree(vcpu);
 out_nomem:


