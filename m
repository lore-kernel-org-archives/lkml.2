Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263Ab0J3Sig (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 14:38:36 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:29417 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab0J3Sie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 14:38:34 -0400
Date: Sat, 30 Oct 2010 20:28:17 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: kvm@vger.kernel.org
cc: Avi Kivity <avi@redhat.com>, Avi Kivity <avi@qumranet.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Yaniv Kamay <yaniv@qumranet.com>, Amit Shah <amit.shah@qumranet.com>,
        Ben-Ami Yassour <benami@il.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM x86: remove memset, use vzalloc and don't assign the
 same value to a variable twice
Message-ID: <alpine.LNX.2.00.1010302020150.1572@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We can improve kvm_vm_ioctl_get_dirty_log() slightly by using vzalloc() 
rather than first allocating and then manually zero the memory with 
memset(). Also, while I was looking at this I noticed that we assign 
-ENOMEM to the 'r' variable twice even though none of the code inbetween 
the two assignments can change 'r', so I removed the second assignment.

Patch has been compile tested only.

Please consider merging and please CC me on all replies as I'm not 
subscribed to the kvm mailing list.


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 x86.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2288ad8..29f9c0a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3174,12 +3174,10 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
 		spin_unlock(&kvm->mmu_lock);
 
 		r = -ENOMEM;
-		dirty_bitmap = vmalloc(n);
+		dirty_bitmap = vzalloc(n);
 		if (!dirty_bitmap)
 			goto out;
-		memset(dirty_bitmap, 0, n);
 
-		r = -ENOMEM;
 		slots = kzalloc(sizeof(struct kvm_memslots), GFP_KERNEL);
 		if (!slots) {
 			vfree(dirty_bitmap);


-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html

