Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980Ab1AYGGq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 01:06:46 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34732 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354Ab1AYGGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 01:06:44 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 25 Jan 2011 15:00:42 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        stable@kernel.org
Subject: [PATCH 1/3] memcg: fix account leak at failure of memsw acconting.
Message-Id: <20110125150042.fa7a9a9a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110125145720.cd0cbe16.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110125145720.cd0cbe16.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is required for 2.6.36-stable and later.
==
Commit 4b53433468c87794b523e4683fbd4e8e8aca1f63 removes
a cancel of charge at case: 
memory charge-> success.
mem+swap charge-> failure.

This leaks usage of memory. Fix it.

This patch is required for stable tree since 2.6.36.

CC: stable@kernel.org
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.38-rc2/mm/memcontrol.c
===================================================================
--- linux-2.6.38-rc2.orig/mm/memcontrol.c
+++ linux-2.6.38-rc2/mm/memcontrol.c
@@ -1832,6 +1832,7 @@ static int __mem_cgroup_do_charge(struct
 		if (likely(!ret))
 			return CHARGE_OK;
 
+		res_counter_uncharge(&mem->res, csize);
 		mem_over_limit = mem_cgroup_from_res_counter(fail_res, memsw);
 		flags |= MEM_CGROUP_RECLAIM_NOSWAP;
 	} else

