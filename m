Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172Ab2DCRcR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 13:32:17 -0400
Received: from gw.danplanet.com ([50.43.125.66]:46024 "EHLO mail.danplanet.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754318Ab2DCRcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 13:32:16 -0400
From: Dan Smith <danms@us.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [RFC][PATCH 06/26] mm: Migrate misplaced page
References: <20120316144028.036474157@chello.nl>
	<20120316144240.492318994@chello.nl>
Date: Tue, 03 Apr 2012 10:32:13 -0700
In-Reply-To: <20120316144240.492318994@chello.nl> (Peter Zijlstra's message of
	"Fri, 16 Mar 2012 15:40:34 +0100")
Message-ID: <87iphg67s2.fsf@danplanet.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PZ> XXX: hnaz, dansmith saw some bad_page() reports when using memcg, I
PZ> could not reproduce -- is there something funny with the mem_cgroup
PZ> calls in the below patch?

I think the problem stems from the final put_page() on the old page
being called before the charge commit. I think something like the
following should do the trick (and appears to work for me):

diff --git a/mm/migrate.c b/mm/migrate.c
index b7fa472..fd88f4b 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1590,7 +1590,6 @@ migrate_misplaced_page(struct page *page, struct mm_struct
                put_page(page);         /* drop       "          "  */
 
                unlock_page(page);
-               put_page(page);         /* drop fault path ref & free */
 
                page = newpage;
        }
@@ -1599,6 +1598,9 @@ out:
        if (!charge)
                mem_cgroup_end_migration(mcg, oldpage, newpage, !rc);
 
+       if (oldpage != page)
+               put_page(oldpage);
+
        if (rc) {
                unlock_page(newpage);
                __free_page(newpage);


-- 
Dan Smith
IBM Linux Technology Center
