Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946Ab1LPKRL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 05:17:11 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:56804 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755211Ab1LPKRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 05:17:02 -0500
Message-ID: <4EEB1A95.6030708@linux.vnet.ibm.com>
Date: Fri, 16 Dec 2011 18:16:53 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 5/8] KVM: MMU: optimize walking unsync shadow page
References: <4EEB19AF.5070501@linux.vnet.ibm.com>
In-Reply-To: <4EEB19AF.5070501@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 11121610-4790-0000-0000-000000702592
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exactly, unysnc_children is the number of unsync sptes, we can use to
avoid unnecessary spte fetching

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 9bd2084..16e0642 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1468,12 +1468,15 @@ static int __mmu_unsync_walk(struct kvm_mmu_page *sp,
 			   struct kvm_mmu_pages *pvec)
 {
 	u64 *spte;
-	int i, ret, nr_unsync_leaf = 0;
+	int i, ret, nr_unsync_leaf = 0, unysnc_children = sp->unsync_children;

 	for_each_unsync_children(sp, spte, i) {
 		struct kvm_mmu_page *child;
 		u64 ent = *spte;

+		if (!unysnc_children--)
+			break;
+
 		WARN_ON(!is_shadow_present_pte(ent) || is_large_pte(ent));

 		child = page_header(ent & PT64_BASE_ADDR_MASK);
-- 
1.7.7.4

