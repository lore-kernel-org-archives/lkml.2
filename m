Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759412Ab1CDKzs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 05:55:48 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64423 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752084Ab1CDKzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 05:55:46 -0500
Message-ID: <4D70C569.1030107@cn.fujitsu.com>
Date: Fri, 04 Mar 2011 18:56:41 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 1/10] KVM: MMU: fix kvm_mmu_slot_remove_write_access
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-04 18:54:33,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-04 18:54:35,
	Serialize complete at 2011-03-04 18:54:35
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only remove write access in the last sptes

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index b6a9963..b9bf016 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3540,12 +3540,17 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm, int slot)
 
 		pt = sp->spt;
 		for (i = 0; i < PT64_ENT_PER_PAGE; ++i) {
-			if (sp->role.level != PT_PAGE_TABLE_LEVEL
-			    && is_large_pte(pt[i])) {
+			if (!is_shadow_present_pte(pt[i]) ||
+			      !is_last_spte(pt[i], sp->role.level))
+				continue;
+
+			if (is_large_pte(pt[i])) {
 				drop_spte(kvm, &pt[i],
 					  shadow_trap_nonpresent_pte);
 				--kvm->stat.lpages;
+				continue;
 			}
+
 			/* avoid RMW */
 			if (is_writable_pte(pt[i]))
 				update_spte(&pt[i], pt[i] & ~PT_WRITABLE_MASK);
-- 
1.7.4
