Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932Ab2KGP0G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 10:26:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43060 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752314Ab2KGP0D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 10:26:03 -0500
Date: Wed, 7 Nov 2012 15:25:58 +0000
From: Mel Gorman <mgorman@suse.de>
To: Zhouping Liu <zliu@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        CAI Qian <caiqian@redhat.com>
Subject: Re: [RFC PATCH 00/19] Foundation for automatic NUMA balancing
Message-ID: <20121107152558.GZ8218@suse.de>
References: <1352193295-26815-1-git-send-email-mgorman@suse.de>
 <509A2970.9000408@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <509A2970.9000408@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2012 at 05:27:12PM +0800, Zhouping Liu wrote:
> 
> Hello Mel,
> 
> my 2 nodes machine hit a panic fault after applied the patch
> set(based on kernel-3.7.0-rc4), please review it:
> 
> <SNIP>

Early initialisation problem by the looks of things. Try this please

---8<---
mm: numa: Check that preferred_node_policy is initialised

Zhouping Liu reported the following

[ 0.000000] ------------[ cut here ]------------
[ 0.000000] kernel BUG at mm/mempolicy.c:1785!
[ 0.000000] invalid opcode: 0000 [#1] SMP
[ 0.000000] Modules linked in:
[ 0.000000] CPU 0
....
[    0.000000] Call Trace:
[    0.000000] [<ffffffff81176966>] alloc_pages_current+0xa6/0x170
[    0.000000] [<ffffffff81137a44>] __get_free_pages+0x14/0x50
[    0.000000] [<ffffffff819efd9b>] kmem_cache_init+0x53/0x2d2
[    0.000000] [<ffffffff819caa53>] start_kernel+0x1e0/0x3c7

Problem is that early in boot preferred_nod_policy and SLUB
initialisation trips up. Check it is initialised.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/mempolicy.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 11d4b6b..8cfa6dc 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -129,6 +129,10 @@ static struct mempolicy *get_task_policy(struct task_struct *p)
 		node = numa_node_id();
 		if (node != -1)
 			pol = &preferred_node_policy[node];
+
+		/* preferred_node_policy is not initialised early in boot */
+		if (!pol->mode)
+			pol = NULL;
 	}
 
 	return pol;
