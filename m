Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932315Ab1HCXej (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 19:34:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34151 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932161Ab1HCXam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 19:30:42 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Aug  3 15:12:52 2011
Message-Id: <20110803221252.700455462@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 03 Aug 2011 15:01:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Ying Han <yinghan@google.com>
Subject: [086/102] memcg: fix behavior of mem_cgroup_resize_limit()
In-Reply-To: <20110803221345.GA10346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

commit 108b6a78463bb8c7163e4f9779f36ad8bbade334 upstream.

Commit 22a668d7c3ef ("memcg: fix behavior under memory.limit equals to
memsw.limit") introduced "memsw_is_minimum" flag, which becomes true
when mem_limit == memsw_limit.  The flag is checked at the beginning of
reclaim, and "noswap" is set if the flag is true, because using swap is
meaningless in this case.

This works well in most cases, but when we try to shrink mem_limit,
which is the same as memsw_limit now, we might fail to shrink mem_limit
because swap doesn't used.

This patch fixes this behavior by:
 - check MEM_CGROUP_RECLAIM_SHRINK at the begining of reclaim
 - If it is set, don't set "noswap" flag even if memsw_is_minimum is true.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <bsingharora@gmail.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1730,7 +1730,7 @@ static int mem_cgroup_hierarchical_recla
 	excess = res_counter_soft_limit_excess(&root_mem->res) >> PAGE_SHIFT;
 
 	/* If memsw_is_minimum==1, swap-out is of-no-use. */
-	if (!check_soft && root_mem->memsw_is_minimum)
+	if (!check_soft && !shrink && root_mem->memsw_is_minimum)
 		noswap = true;
 
 	while (1) {


