Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756411Ab1GRKv7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 06:51:59 -0400
Received: from mail.cs.tu-berlin.de ([130.149.17.13]:34922 "EHLO
	mail.cs.tu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756380Ab1GRKv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 06:51:58 -0400
From: =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
Subject: [PATCH 0/2] Enforce hierarchical order of leaf CFS runqueues
Date: Mon, 18 Jul 2011 12:50:56 +0200
Message-Id: <1310986258-29985-1-git-send-email-schnhrr@cs.tu-berlin.de>
X-Mailer: git-send-email 1.7.3.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Code review showed, that the hierarchical order of the leaf
CFS runqueues introduced by commit 67e8625 ("sched: Introduce 
hierarchal order on shares update list") is not yet achieved.
(See description of first patch for an example.)

These two patches (against v3.0-rc7) try to fix that.

Patch 1 causes all leaves that are inserted during one 
enqueue_task_fair() call to be inserted right next to each other
at the beginning of the list.

Patch 2 prevents the existing code from punching holes
in the leaf-hierarchy as this would cause patch 1 to
re-insert them at possibly wrong positions.


What remains are some multiprocessor aspects: the leaf_cfs_rq_list
is traversed without holding rq->lock. So it can be modified while
a traversal is in progress. That means: while users of the list are 
guaranteed to traverse all elements in hierarchical order, they
are not guaranteed that they will see the parent of an already visited
child. But as far as I currently understand the code, this seems not
to be a problem as the code only relies on the former guarantee.

Regards
Jan

Jan H. Schönherr (2):
  sched: Enforce order of leaf CFS runqueues
  sched: Prevent removal of leaf CFS runqueues with on_list children

 kernel/sched.c      |    1 +
 kernel/sched_fair.c |   45 +++++++++++++++++++++++++++++----------------
 2 files changed, 30 insertions(+), 16 deletions(-)

-- 
1.7.3.4

