Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939Ab2FLCrM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 22:47:12 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:48690 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513Ab2FLCrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 22:47:10 -0400
Message-ID: <4FD6ADA6.40008@linux.vnet.ibm.com>
Date: Tue, 12 Jun 2012 10:47:02 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v3 1/6] KVM: fix missing check for memslot flags
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12061117-3568-0000-0000-000001F4B6E1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check flags when memslot is registered from userspace as Avi's suggestion

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 virt/kvm/kvm_main.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 02cb440..6a7756c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -686,6 +686,14 @@ void update_memslots(struct kvm_memslots *slots, struct kvm_memory_slot *new)
 	slots->generation++;
 }

+static int check_memory_region_flags(struct kvm_userspace_memory_region *mem)
+{
+	if (mem->flags & ~KVM_MEM_LOG_DIRTY_PAGES)
+		return -EINVAL;
+
+	return 0;
+}
+
 /*
  * Allocate some memory and give it an address in the guest physical address
  * space.
@@ -706,6 +714,10 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	struct kvm_memory_slot old, new;
 	struct kvm_memslots *slots, *old_memslots;

+	r = check_memory_region_flags(mem);
+	if (r)
+		goto out;
+
 	r = -EINVAL;
 	/* General sanity checks */
 	if (mem->memory_size & (PAGE_SIZE - 1))
-- 
1.7.7.6

