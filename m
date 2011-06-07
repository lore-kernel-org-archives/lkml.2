Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540Ab1FGM4k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 08:56:40 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49738 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753053Ab1FGM4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 08:56:38 -0400
Message-ID: <4DEE2084.3000801@cn.fujitsu.com>
Date: Tue, 07 Jun 2011 20:58:44 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH 01/15] KVM: MMU: fix walking shadow page table
References: <4DEE205E.8000601@cn.fujitsu.com>
In-Reply-To: <4DEE205E.8000601@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-07 20:56:26,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-07 20:56:27,
	Serialize complete at 2011-06-07 20:56:27
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Properly check the last mapping, and do not walk to the next level if last spte
is met

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 2d14434..cda666a 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1517,10 +1517,6 @@ static bool shadow_walk_okay(struct kvm_shadow_walk_iterator *iterator)
 	if (iterator->level < PT_PAGE_TABLE_LEVEL)
 		return false;
 
-	if (iterator->level == PT_PAGE_TABLE_LEVEL)
-		if (is_large_pte(*iterator->sptep))
-			return false;
-
 	iterator->index = SHADOW_PT_INDEX(iterator->addr, iterator->level);
 	iterator->sptep	= ((u64 *)__va(iterator->shadow_addr)) + iterator->index;
 	return true;
@@ -1528,6 +1524,11 @@ static bool shadow_walk_okay(struct kvm_shadow_walk_iterator *iterator)
 
 static void shadow_walk_next(struct kvm_shadow_walk_iterator *iterator)
 {
+	if (is_last_spte(*iterator->sptep, iterator->level)) {
+		iterator->level = 0;
+		return;
+	}
+
 	iterator->shadow_addr = *iterator->sptep & PT64_BASE_ADDR_MASK;
 	--iterator->level;
 }
-- 
1.7.4.4

