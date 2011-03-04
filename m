Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759482Ab1CDK7u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 05:59:50 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52228 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759274Ab1CDK7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 05:59:48 -0500
Message-ID: <4D70C657.4030105@cn.fujitsu.com>
Date: Fri, 04 Mar 2011 19:00:39 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 7/10] KVM: MMU: introduce a common function to get no-dirty-logged
 slot
References: <4D70C569.1030107@cn.fujitsu.com>
In-Reply-To: <4D70C569.1030107@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-04 18:58:31,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-04 18:58:37,
	Serialize complete at 2011-03-04 18:58:37
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pte_prefetch_gfn_to_memslot and mapping_level_dirty_bitmap have the same
operation, so integrated

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |   26 ++++++++++++++++++--------
 1 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index cd35e71..8acb8e3 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -554,13 +554,24 @@ static int host_mapping_level(struct kvm *kvm, gfn_t gfn)
 	return ret;
 }
 
-static bool mapping_level_dirty_bitmap(struct kvm_vcpu *vcpu, gfn_t large_gfn)
+static struct kvm_memory_slot *
+gfn_to_memslot_dirty_bitmap(struct kvm_vcpu *vcpu, gfn_t gfn, bool no_dirty_log)
 {
 	struct kvm_memory_slot *slot;
-	slot = gfn_to_memslot(vcpu->kvm, large_gfn);
-	if (slot && slot->dirty_bitmap)
-		return true;
-	return false;
+
+	slot = gfn_to_memslot(vcpu->kvm, gfn);
+	if (!slot)
+		return NULL;
+
+	if (no_dirty_log && slot->dirty_bitmap)
+		return NULL;
+
+	return slot;
+}
+
+static bool mapping_level_dirty_bitmap(struct kvm_vcpu *vcpu, gfn_t large_gfn)
+{
+	return !!gfn_to_memslot_dirty_bitmap(vcpu, large_gfn, true);
 }
 
 static int mapping_level(struct kvm_vcpu *vcpu, gfn_t large_gfn)
@@ -2155,9 +2166,8 @@ pte_prefetch_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn_t gfn, bool no_dirty_log)
 {
 	struct kvm_memory_slot *slot;
 
-	slot = gfn_to_memslot(vcpu->kvm, gfn);
-	if (!slot || slot->flags & KVM_MEMSLOT_INVALID ||
-	      (no_dirty_log && slot->dirty_bitmap))
+	slot = gfn_to_memslot_dirty_bitmap(vcpu, gfn, no_dirty_log);
+	if (slot && slot->flags & KVM_MEMSLOT_INVALID)
 		slot = NULL;
 
 	return slot;
-- 
1.7.4

