Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529Ab0EFF7J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 01:59:09 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:51196 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374Ab0EFF7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 01:59:07 -0400
Date: Thu, 6 May 2010 14:57:58 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: mmotm-2010-0428: swapper_space error
Message-Id: <20100506145758.84ff7199.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20100506134248.aaba5d0f.nishimura@mxp.nes.nec.co.jp>
References: <20100501084927.2f6c88f6.rdunlap@xenotime.net>
	<20100506134248.aaba5d0f.nishimura@mxp.nes.nec.co.jp>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 May 2010 13:42:48 +0900, Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
> sorry...
> 
> I'll re-check my build test script and prepare a patch as soon as possible.
> 
This is a fix for memcg-move-charge-of-file-pages.patch.

After this patch, it passed the build test for all the configs with possible
combinations of SWAP, SHMEM, MEM_RES_CTLR and MEM_RES_CTLR_SWAP.

===
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

Build fix for !CONFIG_SWAP case.

mm/built-in.o: In function `mem_cgroup_get_shmem_target':
(.text+0xde06): undefined reference to `swapper_space'

Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
---
 mm/shmem.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 6f183ef..6517bbd 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2591,10 +2591,12 @@ void mem_cgroup_get_shmem_target(struct inode *inode, pgoff_t pgoff,
 
 	spin_lock(&info->lock);
 	ptr = shmem_swp_entry(info, pgoff, NULL);
+#ifdef CONFIG_SWAP
 	if (ptr && ptr->val) {
 		entry.val = ptr->val;
 		page = find_get_page(&swapper_space, entry.val);
 	} else
+#endif
 		page = find_get_page(inode->i_mapping, pgoff);
 	if (ptr)
 		shmem_swp_unmap(ptr);
-- 
1.6.5.2

