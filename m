Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932842Ab0IXQeM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:34:12 -0400
Received: from kroah.org ([198.145.64.141]:38457 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932716Ab0IXQ2m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:28:42 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:26:19 2010
Message-Id: <20100924162619.660917470@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:24:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, greg@kroah.com
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, avi@redhat.com,
        mtosatti@redhat.com
Subject: [55/80] KVM: Prevent internal slots from being COWed
In-Reply-To: <20100924162706.GA7381@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Avi Kivity <avi@redhat.com>

commit 7ac77099ce88a0c31b75acd0ec5ef3da4415a6d8 upstream.

If a process with a memory slot is COWed, the page will change its address
(despite having an elevated reference count).  This breaks internal memory
slots which have their physical addresses loaded into vmcs registers (see
the APIC access memory slot).

Signed-off-by: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/kvm/x86.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5438,6 +5438,11 @@ int kvm_arch_prepare_memory_region(struc
 				int user_alloc)
 {
 	int npages = memslot->npages;
+	int map_flags = MAP_PRIVATE | MAP_ANONYMOUS;
+
+	/* Prevent internal slot pages from being moved by fork()/COW. */
+	if (memslot->id >= KVM_MEMORY_SLOTS)
+		map_flags = MAP_SHARED | MAP_ANONYMOUS;
 
 	/*To keep backward compatibility with older userspace,
 	 *x86 needs to hanlde !user_alloc case.
@@ -5450,7 +5455,7 @@ int kvm_arch_prepare_memory_region(struc
 			userspace_addr = do_mmap(NULL, 0,
 						 npages * PAGE_SIZE,
 						 PROT_READ | PROT_WRITE,
-						 MAP_PRIVATE | MAP_ANONYMOUS,
+						 map_flags,
 						 0);
 			up_write(&current->mm->mmap_sem);
 


