Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760361Ab0FKNgI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 09:36:08 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52545 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1760320Ab0FKNgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 09:36:06 -0400
Message-ID: <4C123AF2.80803@cn.fujitsu.com>
Date: Fri, 11 Jun 2010 21:32:34 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: [PATCH 5/7] KVM: MMU: cleanup for __mmu_unsync_walk()
References: <4C1239EE.3090904@cn.fujitsu.com> <4C123ABA.3000601@cn.fujitsu.com>
In-Reply-To: <4C123ABA.3000601@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Decrease sp->unsync_children after clear unsync_child_bitmap bit

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/kvm/mmu.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 18c14c5..c4b980a 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1160,9 +1160,11 @@ static int __mmu_unsync_walk(struct kvm_mmu_page *sp,
 					return -ENOSPC;
 
 				ret = __mmu_unsync_walk(child, pvec);
-				if (!ret)
+				if (!ret) {
 					__clear_bit(i, sp->unsync_child_bitmap);
-				else if (ret > 0)
+					sp->unsync_children--;
+					WARN_ON((int)sp->unsync_children < 0);
+				} else if (ret > 0)
 					nr_unsync_leaf += ret;
 				else
 					return ret;
@@ -1176,8 +1178,6 @@ static int __mmu_unsync_walk(struct kvm_mmu_page *sp,
 		}
 	}
 
-	if (find_first_bit(sp->unsync_child_bitmap, 512) == 512)
-		sp->unsync_children = 0;
 
 	return nr_unsync_leaf;
 }
-- 
1.6.1.2


