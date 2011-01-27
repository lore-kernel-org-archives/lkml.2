Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab1A0NrJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 08:47:09 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:50131 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752213Ab1A0NrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 08:47:08 -0500
Date: Thu, 27 Jan 2011 14:47:03 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: [patch 3/3] memcg: never OOM when charging huge pages
Message-ID: <20110127134703.GB14309@cmpxchg.org>
References: <20110121153431.191134dd.kamezawa.hiroyu@jp.fujitsu.com>
 <20110121154430.70d45f15.kamezawa.hiroyu@jp.fujitsu.com>
 <20110127103438.GC2401@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110127103438.GC2401@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huge page coverage should obviously have less priority than the
continued execution of a process.

Never kill a process when charging it a huge page fails.  Instead,
give up after the first failed reclaim attempt and fall back to
regular pages.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 17c4e36..2945649 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1890,6 +1890,13 @@ static int __mem_cgroup_try_charge(struct mm_struct *mm,
 	int csize = max(CHARGE_SIZE, (unsigned long) page_size);
 
 	/*
+	 * Do not OOM on huge pages.  Fall back to regular pages after
+	 * the first failed reclaim attempt.
+	 */
+	if (page_size > PAGE_SIZE)
+		oom = false;
+
+	/*
 	 * Unlike gloval-vm's OOM-kill, we're not in memory shortage
 	 * in system level. So, allow to go ahead dying process in addition to
 	 * MEMDIE process.
-- 
1.7.3.5

