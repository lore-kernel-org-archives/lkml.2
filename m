Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733Ab1EXFvk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 01:51:40 -0400
Received: from mtagate4.uk.ibm.com ([194.196.100.164]:43770 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697Ab1EXFvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 01:51:37 -0400
Date: Tue, 24 May 2011 07:51:27 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Subject: [PATCH] kvm: add missing void __user * cast to access_ok() call
Message-ID: <20110524055127.GA2460@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

fa3d315a "KVM: Validate userspace_addr of memslot when registered" introduced
this new warning onn s390:

kvm_main.c: In function '__kvm_set_memory_region':
kvm_main.c:654:7: warning: passing argument 1 of '__access_ok' makes pointer from integer without a cast
arch/s390/include/asm/uaccess.h:53:19: note: expected 'const void *' but argument is of type '__u64'

Add the missing cast to get rid of it again...

Cc: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 virt/kvm/kvm_main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -651,7 +651,8 @@ int __kvm_set_memory_region(struct kvm *
 	/* We can read the guest memory with __xxx_user() later on. */
 	if (user_alloc &&
 	    ((mem->userspace_addr & (PAGE_SIZE - 1)) ||
-	     !access_ok(VERIFY_WRITE, mem->userspace_addr, mem->memory_size)))
+	     !access_ok(VERIFY_WRITE, (void __user *)mem->userspace_addr,
+			mem->memory_size)))
 		goto out;
 	if (mem->slot >= KVM_MEMORY_SLOTS + KVM_PRIVATE_MEM_SLOTS)
 		goto out;
