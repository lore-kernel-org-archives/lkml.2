Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751189Ab1AVTvF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 14:51:05 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:23100 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800Ab1AVTvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 14:51:03 -0500
Date: Sat, 22 Jan 2011 20:51:32 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-mm@kvack.org
cc: linux-kernel@vger.kernel.org, Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Pavel Emelianov <xemul@openvz.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: [PATCH] Fix uninitialized variable use in
 mm/memcontrol.c::mem_cgroup_move_parent()
Message-ID: <alpine.LNX.2.00.1101222044580.7746@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In mm/memcontrol.c::mem_cgroup_move_parent() there's a path that jumps to 
the 'put_back' label
  	ret = __mem_cgroup_try_charge(NULL, gfp_mask, &parent, false, charge);
  	if (ret || !parent)
  		goto put_back;
 where we'll 
  	if (charge > PAGE_SIZE)
  		compound_unlock_irqrestore(page, flags);
but, we have not assigned anything to 'flags' at this point, nor have we 
called 'compound_lock_irqsave()' (which is what sets 'flags').
So, I believe the 'put_back' label should be moved below the call to 
compound_unlock_irqrestore() as per this patch. 

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 memcontrol.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

  compile tested only.

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index db76ef7..4fcf47a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2292,9 +2292,10 @@ static int mem_cgroup_move_parent(struct page_cgroup *pc,
 	ret = mem_cgroup_move_account(pc, child, parent, true, charge);
 	if (ret)
 		mem_cgroup_cancel_charge(parent, charge);
-put_back:
+
 	if (charge > PAGE_SIZE)
 		compound_unlock_irqrestore(page, flags);
+put_back:
 	putback_lru_page(page);
 put:
 	put_page(page);


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

