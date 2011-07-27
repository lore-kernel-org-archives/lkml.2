Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543Ab1G0TLZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 15:11:25 -0400
Received: from mail.cs.tu-berlin.de ([130.149.17.13]:54641 "EHLO
	mail.cs.tu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754114Ab1G0TLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 15:11:23 -0400
From: =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: Paul Turner <pjt@google.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Dipankar Sarma <dipankar@in.ibm.com>, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
Subject: [PATCH RFCv2 0/8] sched: Enforce order of leaf CFS runqueues (and list cleanup)
Date: Wed, 27 Jul 2011 21:10:17 +0200
Message-Id: <1311793825-31933-1-git-send-email-schnhrr@cs.tu-berlin.de>
X-Mailer: git-send-email 1.7.6
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Code review showed, that the hierarchical order of the leaf
CFS runqueues introduced by commit 67e8625 ("sched: Introduce 
hierarchal order on shares update list") is not yet achieved.
(See description of third patch for an example.)

During the discussion of possible solutions [1], Paul Turner
mentioned an "ideal approach" to solve that.

This is the second iteration of the patch-set that tries to
realize this "ideal" approach. 

The first iteration got some positive feedback from Paul E. McKenney
regarding its "advanced" RCU usage. His negative feedback -- missing
comments -- should be addressed, now.

Changes since v1:
- rebased against v3.0
- included follow-up patches 4 to 8 (demonstrating the purpose of patch 1)
- patch 1 should be complete this time
- moved more functionality to rculist.h (see patch 2+3)
- more comments everywhere


Patch 1: After inventing __list_link(), I realized, that this
	 function already existed, but with a different name.

	 This patch just does some renaming. Not really needed,
	 but if I use the old naming in patch 2 it's really 
	 hard to understand what's actually going on.

	 It also helps to increase the readability of the existing
	 code, see patches 6-8.

Patch 2: This introduces new list functions to splice RCU lists
	 and handle deleted RCU list entries.

Patch 3: The actual bugfix.

Patch 4+5: Follow-ups to patch 1. Some more renaming and use of
	   appropriate functions.

Patch 6: Another follow-up to patch 1, improving the readability of
	 the list routines a bit.

Patch 7+8: Follow-ups to patch 2. Make use of the introduced
           functionality in the already existing code.


Comments?

Regards
Jan


[1] http://lkml.org/lkml/2011/7/18/86



Jan H. Schönherr (8):
  list, treewide: Rename __list_del() to __list_link()
  rcu: More rcu-variants for list manipulation
  sched: Handle on_list ancestor in list_add_leaf_cfs_rq()
  list, treewide: Rename __list_del_entry() to __list_del()
  treewide: Use __list_del() instead of __list_link()
  list: Make use of __list_link()
  rcu: Make use of __list_link() and __list_link_rcu()
  rcu: Rewrite and rename list_splice_init_rcu()

 drivers/char/ipmi/ipmi_msghandler.c  |    2 +-
 drivers/firewire/core-topology.c     |    2 +-
 drivers/gpu/drm/ttm/ttm_page_alloc.c |    4 +-
 fs/btrfs/volumes.c                   |    2 +-
 include/linux/list.h                 |   80 ++++++++----------
 include/linux/rculist.h              |  155 +++++++++++++++++++++++++++++----
 kernel/mutex.h                       |    2 +-
 kernel/sched_fair.c                  |   93 ++++++++++++++++-----
 kernel/timer.c                       |    2 +-
 lib/list_debug.c                     |    8 +-
 net/ipv4/cipso_ipv4.c                |    2 +-
 11 files changed, 257 insertions(+), 95 deletions(-)

-- 
1.7.6

