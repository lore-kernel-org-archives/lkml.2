Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522Ab0DFFJh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 01:09:37 -0400
Received: from gate.crashing.org ([63.228.1.57]:37137 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244Ab0DFFJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 01:09:31 -0400
Subject: mprotect pgprot handling weirdness
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linux-mm@kvack.org
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Apr 2010 15:09:26 +1000
Message-ID: <1270530566.13812.28.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks !

While looking at untangling a bit some of the mess with vm_flags and
pgprot (*), I notices a few things I can't quite explain... they may ..
or may not be bugs, but I though it was worth mentioning:

- In mprotect_fixup() :

	/*
	 * vm_flags and vm_page_prot are protected by the mmap_sem
	 * held in write mode.
	 */
	vma->vm_flags = newflags;
	vma->vm_page_prot = pgprot_modify(vma->vm_page_prot,
					  vm_get_page_prot(newflags));

	if (vma_wants_writenotify(vma)) {
		vma->vm_page_prot = vm_get_page_prot(newflags & ~VM_SHARED);
		dirty_accountable = 1;
	}

So as you can see above, we take great care (using pgprot_modify) to avoid
blasting away some PAT related flags on x86 (no other arch implements
pgprot_modify() today).... but if we hit vma_wants_writenotify(), then
we unconditionally override the entire vma->vm_page_prot field with some
new prot bits born of the new vm_flags. That sounds odd...

- in sys_mprotect: 

	newflags = vm_flags | (vma->vm_flags & ~(VM_READ | VM_WRITE | VM_EXEC));

Do I read correctly that this means we cannot -remove- any flag than
VM_READ, VM_WRITE or VM_EXEC ? That means that we cannot remove PROT_SAO
which gets turned into VM_SAO on powerpc ... Yet another reason to take
those arch specific mapping attributes out of the vm_flags.

(*) Right now it's near impossible to add arch specific PROT_* bits to
mmap/mprotect for fancy things like cachability attributes, or other
nifty things like reverse-endian mappings that we have on some embedded
platforms, I'm investigating ways to better separate vm_page_prot from
vm_flags so some PROT_* bits can go straight to the former without
having to be mirrored in some way in the later.

Cheers,
Ben.


