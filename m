Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124Ab1ABHdU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:33:20 -0500
Received: from mail.windriver.com ([147.11.1.11]:37123 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754867Ab1ABHZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:25:39 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 234/260] KVM: MMU: fix conflict access permissions in direct sp
Date: Sun,  2 Jan 2011 02:18:50 -0500
Message-Id: <1293952756-15010-235-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:24:26.0027 (UTC) FILETIME=[15CF4FB0:01CBAA4E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>

commit 5fd5387c89ec99ff6cb82d2477ffeb7211b781c2 upstream.

In no-direct mapping, we mark sp is 'direct' when we mapping the
guest's larger page, but its access is encoded form upper page-struct
entire not include the last mapping, it will cause access conflict.

For example, have this mapping:
        [W]
      / PDE1 -> |---|
  P[W]          |   | LPA
      \ PDE2 -> |---|
        [R]

P have two children, PDE1 and PDE2, both PDE1 and PDE2 mapping the
same lage page(LPA). The P's access is WR, PDE1's access is WR,
PDE2's access is RO(just consider read-write permissions here)

When guest access PDE1, we will create a direct sp for LPA, the sp's
access is from P, is W, then we will mark the ptes is W in this sp.

Then, guest access PDE2, we will find LPA's shadow page, is the same as
PDE's, and mark the ptes is RO.

So, if guest access PDE1, the incorrect #PF is occured.

Fixed by encode the last mapping access into direct shadow page

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/x86/kvm/paging_tmpl.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index a535c87..2bd2b3e 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -356,6 +356,8 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 			direct = 1;
 			if (!is_dirty_gpte(gw->ptes[level - delta]))
 				access &= ~ACC_WRITE_MASK;
+			access &= gw->pte_access;
+
 			table_gfn = gpte_to_gfn(gw->ptes[level - delta]);
 			/* advance table_gfn when emulating 1gb pages with 4k */
 			if (delta == 0)
-- 
1.7.3.3

