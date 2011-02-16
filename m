Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932665Ab1BPAok (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:44:40 -0500
Received: from kroah.org ([198.145.64.141]:49317 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757546Ab1BPAXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:23:05 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:42 2011
Message-Id: <20110216001442.625816419@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:13:52 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@in.ibm.com>
Subject: [175/272] memcg: fix account leak at failure of memsw acconting
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

commit 01c88e2d6b7330c0cc5867fe2297e7d826e1337d upstream.

Commit 4b53433468 ("memcg: clean up try_charge main loop") removes a
cancel of charge at case: memory charge-> success.  mem+swap charge->
failure.

This leaks usage of memory.  Fix it.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/memcontrol.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1842,6 +1842,7 @@ static int __mem_cgroup_do_charge(struct
 		if (likely(!ret))
 			return CHARGE_OK;
 
+		res_counter_uncharge(&mem->res, csize);
 		mem_over_limit = mem_cgroup_from_res_counter(fail_res, memsw);
 		flags |= MEM_CGROUP_RECLAIM_NOSWAP;
 	} else


