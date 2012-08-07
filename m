Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670Ab2HGJsU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 05:48:20 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:60860 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479Ab2HGJsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 05:48:18 -0400
Message-ID: <5020E455.2090501@linux.vnet.ibm.com>
Date: Tue, 07 Aug 2012 17:48:05 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH v5 01/12] KVM: fix missing check for memslot flags
References: <5020E423.9080004@linux.vnet.ibm.com>
In-Reply-To: <5020E423.9080004@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12080709-9574-0000-0000-000003E0351A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check flags when memslot is registered from userspace as Avi's suggestion

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 virt/kvm/kvm_main.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a2e85af..7b94d70 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -678,6 +678,14 @@ void update_memslots(struct kvm_memslots *slots, struct kvm_memory_slot *new)
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
@@ -698,6 +706,10 @@ int __kvm_set_memory_region(struct kvm *kvm,
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

