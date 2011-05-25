Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932674Ab1EYICc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 04:02:32 -0400
Received: from mtagate4.uk.ibm.com ([194.196.100.164]:37231 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932182Ab1EYIC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 04:02:29 -0400
Date: Wed, 25 May 2011 10:02:23 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Avi Kivity <avi@qumranet.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree (kvm
 tree related)
Message-ID: <20110525080223.GC2498@osiris.boeblingen.de.ibm.com>
References: <20110525132809.6d85b3c2.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110525132809.6d85b3c2.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 25, 2011 at 01:28:09PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the final tree, today's linux-next build (powerpc
> ppc44x_defconfig) failed like this:
> 
> cc1: warnings being treated as errors
> arch/powerpc/kvm/../../../virt/kvm/kvm_main.c: In function '__kvm_set_memory_region':
> arch/powerpc/kvm/../../../virt/kvm/kvm_main.c:654: error: cast to pointer from integer of different size
> arch/powerpc/kvm/../../../virt/kvm/kvm_main.c:654: error: cast to pointer from integer of different size
> 
> Caused by commit 95de6ce677d6 ("KVM: add missing void __user * cast to
> access_ok() call").
> 
> I have reverted that commit for today.

My fault.. sigh.

Avi could you apply the patch below as well (or merge with the previous one)?

Thanks!

Subject: [PATCH] KVM: fix userspace_addr cast in access_ok() call

From: Heiko Carstens <heiko.carstens@de.ibm.com>

mem->userspace_addr is u64. Casting that to a pointer will cause build
breakage (or warnings) on 32 bit architectures. So add an explicit
unsigned long cast as well...

Fixes this:

cc1: warnings being treated as errors
arch/powerpc/kvm/../../../virt/kvm/kvm_main.c: In function '__kvm_set_memory_region':
arch/powerpc/kvm/../../../virt/kvm/kvm_main.c:654: error: cast to pointer from integer of different size

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
-	     !access_ok(VERIFY_WRITE, (void __user *)mem->userspace_addr,
+	     !access_ok(VERIFY_WRITE,
+			(void __user *)(unsigned long)mem->userspace_addr,
 			mem->memory_size)))
 		goto out;
 	if (mem->slot >= KVM_MEMORY_SLOTS + KVM_PRIVATE_MEM_SLOTS)
