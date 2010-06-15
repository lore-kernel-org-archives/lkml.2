Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757333Ab0FOCuS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 22:50:18 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58581 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753632Ab0FOCuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 22:50:14 -0400
Message-ID: <4C16E98F.2010504@cn.fujitsu.com>
Date: Tue, 15 Jun 2010 10:46:39 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: [PATCH 2/6] KVM: MMU: fix conflict access permissions in direct sp
References: <4C16E6ED.7020009@cn.fujitsu.com> <4C16E75F.6020003@cn.fujitsu.com>
In-Reply-To: <4C16E75F.6020003@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 arch/x86/kvm/paging_tmpl.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 3ebc5a0..eb47148 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -339,6 +339,8 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 			direct = 1;
 			if (!is_dirty_gpte(gw->ptes[level - delta]))
 				access &= ~ACC_WRITE_MASK;
+			access &= gw->pte_access;
+
 			/*
 			 * It is a large guest pages backed by small host pages,
 			 * So we set @direct(@sp->role.direct)=1, and set
-- 
1.6.1.2



