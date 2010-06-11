Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760353Ab0FKNhi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 09:37:38 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52656 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1760268Ab0FKNhh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 09:37:37 -0400
Message-ID: <4C123B4C.9010705@cn.fujitsu.com>
Date: Fri, 11 Jun 2010 21:34:04 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: [PATCH 6/7] KVM: MMU: clear unsync_child_bitmap completely
References: <4C1239EE.3090904@cn.fujitsu.com> <4C123ABA.3000601@cn.fujitsu.com> <4C123AF2.80803@cn.fujitsu.com>
In-Reply-To: <4C123AF2.80803@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In current code, some page's unsync_child_bitmap is not cleared completely
in mmu_sync_children(), for example, if two PDPEs shard one PDT, one of
PDPE's unsync_child_bitmap is not cleared.

Currently, it not harm anything just little overload, but it's the prepare
work for the later patch

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |   55 ++++++++++++++++++++++++++++-----------------------
 1 files changed, 30 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index c4b980a..eb20682 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1149,33 +1149,38 @@ static int __mmu_unsync_walk(struct kvm_mmu_page *sp,
 	int i, ret, nr_unsync_leaf = 0;
 
 	for_each_unsync_children(sp->unsync_child_bitmap, i) {
+		struct kvm_mmu_page *child;
 		u64 ent = sp->spt[i];
 
-		if (is_shadow_present_pte(ent) && !is_large_pte(ent)) {
-			struct kvm_mmu_page *child;
-			child = page_header(ent & PT64_BASE_ADDR_MASK);
-
-			if (child->unsync_children) {
-				if (mmu_pages_add(pvec, child, i))
-					return -ENOSPC;
-
-				ret = __mmu_unsync_walk(child, pvec);
-				if (!ret) {
-					__clear_bit(i, sp->unsync_child_bitmap);
-					sp->unsync_children--;
-					WARN_ON((int)sp->unsync_children < 0);
-				} else if (ret > 0)
-					nr_unsync_leaf += ret;
-				else
-					return ret;
-			}
+		if (!is_shadow_present_pte(ent) || is_large_pte(ent))
+			goto clear_child_bitmap;
+
+		child = page_header(ent & PT64_BASE_ADDR_MASK);
+
+		if (child->unsync_children) {
+			if (mmu_pages_add(pvec, child, i))
+				return -ENOSPC;
+
+			ret = __mmu_unsync_walk(child, pvec);
+			if (!ret)
+				goto clear_child_bitmap;
+			else if (ret > 0)
+				nr_unsync_leaf += ret;
+			else
+				return ret;
+		} else if (child->unsync) {
+			nr_unsync_leaf++;
+			if (mmu_pages_add(pvec, child, i))
+				return -ENOSPC;
+		} else
+			 goto clear_child_bitmap;
 
-			if (child->unsync) {
-				nr_unsync_leaf++;
-				if (mmu_pages_add(pvec, child, i))
-					return -ENOSPC;
-			}
-		}
+		continue;
+
+clear_child_bitmap:
+		__clear_bit(i, sp->unsync_child_bitmap);
+		sp->unsync_children--;
+		WARN_ON((int)sp->unsync_children < 0);
 	}
 
 
-- 
1.6.1.2



