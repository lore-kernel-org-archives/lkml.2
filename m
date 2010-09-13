Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965Ab0IMHN5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 03:13:57 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53016 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434Ab0IMHN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 03:13:56 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 13 Sep 2010 16:08:22 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        gthelen@google.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        stable@kernel.org
Subject: [BUGFIX][PATCH] memcg: fix race in file_mapped accouting flag
 management
Message-Id: <20100913160822.0c2cd732.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I think this small race is not very critical but it's bug.
We have this race since 2.6.34. 
=
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Now. memory cgroup accounts file-mapped by counter and flag.
counter is working in the same way with zone_stat but FileMapped flag only
exists in memcg (for helping move_account).

This flag can be updated wrongly in a case. Assume CPU0 and CPU1
and a thread mapping a page on CPU0, another thread unmapping it on CPU1.

    CPU0                   		CPU1
				rmv rmap (mapcount 1->0)
   add rmap (mapcount 0->1)
   lock_page_cgroup()
   memcg counter+1		(some delay)
   set MAPPED FLAG.
   unlock_page_cgroup()
				lock_page_cgroup()
				memcg counter-1
				clear MAPPED flag

In above sequence, counter is properly updated but FLAG is not.
This means that representing a state by a flag which is maintained by
counter needs some specail care.

To handle this, at claering a flag, this patch check mapcount directly and
clear the flag only when mapcount == 0. (if mapcount >0, someone will make
it to zero later and flag will be cleared.)

Reverse case, dec-after-inc cannot be a problem because page_table_lock()
works well for it. (IOW, to make above sequence, 2 processes should touch
the same page at once with map/unmap.)

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: lockless-update/mm/memcontrol.c
===================================================================
--- lockless-update.orig/mm/memcontrol.c
+++ lockless-update/mm/memcontrol.c
@@ -1485,7 +1485,8 @@ void mem_cgroup_update_file_mapped(struc
 		SetPageCgroupFileMapped(pc);
 	} else {
 		__this_cpu_dec(mem->stat->count[MEM_CGROUP_STAT_FILE_MAPPED]);
-		ClearPageCgroupFileMapped(pc);
+		if (page_mapped(page)) /* for race between dec->inc counter */
+			ClearPageCgroupFileMapped(pc);
 	}
 
 done:

