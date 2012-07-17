Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011Ab2GQOkm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 10:40:42 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:40589 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258Ab2GQOkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 10:40:41 -0400
Message-ID: <50057962.1020603@linux.vnet.ibm.com>
Date: Tue, 17 Jul 2012 22:40:34 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 01/10] KVM: fix missing check for memslot flags
References: <5005791B.8040807@linux.vnet.ibm.com>
In-Reply-To: <5005791B.8040807@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12071714-8256-0000-0000-00000359A1F4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check flags when memslot is registered from userspace as Avi's suggestion

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 virt/kvm/kvm_main.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 78cf42f..7cb29bb 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -689,6 +689,14 @@ void update_memslots(struct kvm_memslots *slots, struct kvm_memory_slot *new)
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
@@ -709,6 +717,10 @@ int __kvm_set_memory_region(struct kvm *kvm,
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

