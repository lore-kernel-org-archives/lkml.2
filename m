Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020Ab1GUNVO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 09:21:14 -0400
Received: from mail.cs.tu-berlin.de ([130.149.17.13]:64291 "EHLO
	mail.cs.tu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132Ab1GUNVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 09:21:11 -0400
From: =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
To: Paul Turner <pjt@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
Subject: Re: [PATCH 1/2] sched: Enforce order of leaf CFS runqueues
Date: Thu, 21 Jul 2011 15:20:20 +0200
Message-Id: <1311254423-25484-1-git-send-email-schnhrr@cs.tu-berlin.de>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <CAPM31RLqq0hgdhoh3GA-38petKeE1zxcL=uJYba9o3yd+_7jjw@mail.gmail.com>
References: <CAPM31RLqq0hgdhoh3GA-38petKeE1zxcL=uJYba9o3yd+_7jjw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 19.07.2011 01:24, schrieb Paul Turner:
> I wonder if we could move this logic to the enqueue_task_fair path()
> as that is the gating condition to become a leaf for load tracking.
> Ideally we could build up a list of the untracked entities and then
> splice it, but alas we have to use an rculist to track leaf cfs_rq's
> so that we can walk it without locks in update shares.

Out of curiosity I took a closer look at your "ideal" approach.

If I am not mistaken, this should actually work.
The results come as a reply to this mail.

The problem with the rcu-list is, that we cannot put individual
leaves on a different list, as this would irritate concurrent
readers. But what we can do without problems is to assemble
the leaves into something like a "detached list". That is:
while we modify the next-pointers of deleted leaves, we only
let them point to other (possibly deleted) leaves of the same 
list, so that concurrent readers will still find their way back.

As long as there is no error in my RCU reasoning, we get your
ideal approach that is also not subject to Peter's "We do more
work than before" statement.

What do you think of this?


Patch 1: After inventing __list_link(), I realized, that this
	 function already existed, but with a different name.

	 This patch just does some renaming. Not really needed,
	 but if I use the old naming in patch 2+3 it's really 
	 hard to understand what's actually going on.

Patch 2: This introduces new list functions to splice RCU lists.

Patch 3: The actual change to the leaf handling.


Regards
Jan



Jan H. Schönherr (3):
  list, treewide: Rename __list_del() to __list_link()
  rcu: More rcu-variants for list manipulation
  sched: Handle on_list ancestor in list_add_leaf_cfs_rq()

 drivers/firewire/core-topology.c     |    2 +-
 drivers/gpu/drm/ttm/ttm_page_alloc.c |    4 +-
 include/linux/list.h                 |    6 ++--
 include/linux/rculist.h              |   28 +++++++++++++++-
 kernel/sched_fair.c                  |   59 ++++++++++++++++++++++-----------
 lib/list_debug.c                     |    2 +-
 6 files changed, 73 insertions(+), 28 deletions(-)

-- 
1.7.6

