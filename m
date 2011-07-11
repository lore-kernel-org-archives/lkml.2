Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551Ab1GKTTV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 15:19:21 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53242 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754220Ab1GKTTU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 15:19:20 -0400
Message-ID: <4E1B4D2D.5080109@cn.fujitsu.com>
Date: Tue, 12 Jul 2011 03:21:17 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v4 01/18] KVM: MMU: fix walking shadow page table
References: <4E1B4CF8.605@cn.fujitsu.com>
In-Reply-To: <4E1B4CF8.605@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-12 03:18:36,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-07-12 03:18:36,
	Serialize complete at 2011-07-12 03:18:36
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
index da0f3b0..03323dc 100644
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
1.7.5.4

