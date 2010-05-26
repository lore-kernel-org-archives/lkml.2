Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934170Ab0EZIsc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 04:48:32 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57227 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932536Ab0EZIsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 04:48:30 -0400
Message-ID: <4BFCE053.6040505@cn.fujitsu.com>
Date: Wed, 26 May 2010 16:48:19 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Lai Jiangshan <laijs@cn.fujitsu.com>, Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       kvm@vger.kernel.org
Subject: [RESEND PATCH 1/3] kvm: calculate correct gfn for small host pages
 which emulates large guest pages
References: <4BD97AC1.8070704@cn.fujitsu.com>
In-Reply-To: <4BD97AC1.8070704@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In Document/kvm/mmu.txt:
  gfn:
    Either the guest page table containing the translations shadowed by this
    page, or the base page frame for linear translations. See role.direct.

But in function FNAME(fetch)(), sp->gfn is incorrect when one of following
situations occurred:
 1) guest is 32bit paging and the guest PDE maps a 4-MByte page
    (backed by 4k host pages), FNAME(fetch)() miss handling the quadrant.

    And if guest use pse-36, "table_gfn = gpte_to_gfn(gw->ptes[level - delta]);"
    is incorrect.
 2) guest is long mode paging and the guest PDPTE maps a 1-GByte page
    (backed by 4k or 2M host pages).

So we fix it to suit to the document and suit to the code which
requires sp->gfn correct when sp->role.direct=1.

We use the goal mapping gfn(gw->gfn) to calculate the base page frame
for linear translations, it is simple and easy to be understood.

Reported-by: Marcelo Tosatti <mtosatti@redhat.com>
Reported-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 702c016..958e9c6 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -338,10 +338,13 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 			direct = 1;
 			if (!is_dirty_gpte(gw->ptes[level - delta]))
 				access &= ~ACC_WRITE_MASK;
-			table_gfn = gpte_to_gfn(gw->ptes[level - delta]);
-			/* advance table_gfn when emulating 1gb pages with 4k */
-			if (delta == 0)
-				table_gfn += PT_INDEX(addr, level);
+			/*
+			 * It is a large guest pages backed by small host pages,
+			 * So we set @direct(@shadow_page->role.direct)=1, and
+			 * set @table_gfn(@shadow_page->gfn)=the base page frame
+			 * for linear translations.
+			 */
+			table_gfn = gw->gfn & ~(KVM_PAGES_PER_HPAGE(level) - 1);
 		} else {
 			direct = 0;
 			table_gfn = gw->table_gfn[level - 2];

