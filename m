Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751473Ab0DMGR6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 02:17:58 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:56135 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab0DMGR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 02:17:57 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 13 Apr 2010 15:14:00 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][BUGFIX][PATCH] memcg: fix underflow of mapped_file stat
Message-Id: <20100413151400.cb89beb7.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100413134207.f12cdc9c.nishimura@mxp.nes.nec.co.jp>
References: <20100413134207.f12cdc9c.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Apr 2010 13:42:07 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> Hi.
> 
> When I was testing page migration, I found underflow problem of "mapped_file" field
> in memory.stat. This is a fix for the problem.
> 
> This patch is based on mmotm-2010-04-05-16-09, and IIUC it conflicts with Mel's
> compaction patches, so I send it as RFC for now. After next mmotm, which will
> include those patches, I'll update and resend this patch.
> 
> ===
> From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> 
> page_add_file_rmap(), which can be called from remove_migration_ptes(), is
> assumed to increment memcg's stat of mapped file. But on success of page
> migration, the newpage(mapped file) has not been charged yet, so the stat will
> not be incremented. This behavior leads to underflow of memcg's stat because
> when the newpage is unmapped afterwards, page_remove_rmap() decrements the stat.
> This problem doesn't happen on failure path of page migration, because the old
> page(mapped file) hasn't been uncharge at the point of remove_migration_ptes().
> This patch fixes this problem by calling commit_charge(mem_cgroup_end_migration)
> before remove_migration_ptes().
> 
> Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

Nice catch. but...I want to make all kind of complicated things under
prepare/end migration. (And I want to avoid changes in migrate.c...)

Considering some racy condistions, I wonder memcg_update_file_mapped() itself
still need fixes..

So, how about this ? We already added FILE_MAPPED flags, then, make use of it.
==


At migrating mapped file, events happens in following sequence.

 1. allocate a new page.
 2. get memcg of an old page.
 3. charge ageinst new page, before migration. But at this point
    no changes to page_cgroup, no commit-charge.
 4. page migration replaces radix-tree, old-page and new-page.
 5. page migration remaps the new page if the old page was mapped.
 6. memcg commits the charge for newpage.

Because "commit" happens after page-remap, we lose file_mapped
accounting information at migration.

This patch fixes it by accounting file_mapped information at
commiting charge.

Reported-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

Index: mmotm-temp/mm/memcontrol.c
===================================================================
--- mmotm-temp.orig/mm/memcontrol.c
+++ mmotm-temp/mm/memcontrol.c
@@ -1435,11 +1435,13 @@ void mem_cgroup_update_file_mapped(struc
 
 	/*
 	 * Preemption is already disabled. We can use __this_cpu_xxx
+	 * We have no lock per page at inc/dec mapcount of pages. We have to do
+	 * check by ourselves under lock_page_cgroup().
 	 */
-	if (val > 0) {
+	if (val > 0 && !PageCgroupFileMapped(pc)) {
 		__this_cpu_inc(mem->stat->count[MEM_CGROUP_STAT_FILE_MAPPED]);
 		SetPageCgroupFileMapped(pc);
-	} else {
+	} else if (PageCgroupFileMapped(pc)) {
 		__this_cpu_dec(mem->stat->count[MEM_CGROUP_STAT_FILE_MAPPED]);
 		ClearPageCgroupFileMapped(pc);
 	}
@@ -2563,6 +2565,15 @@ void mem_cgroup_end_migration(struct mem
 	 */
 	if (ctype == MEM_CGROUP_CHARGE_TYPE_MAPPED)
 		mem_cgroup_uncharge_page(target);
+	else {
+		/*
+		 * When a migrated file cache is remapped, it's not charged.
+		 * Verify it. Because we're under lock_page(), there are
+		 * no race with uncharge.
+		 */
+		if (page_mapped(target))
+			mem_cgroup_update_file_mapped(mem, target, 1);
+	}
 	/*
 	 * At migration, we may charge account against cgroup which has no tasks
 	 * So, rmdir()->pre_destroy() can be called while we do this charge.

