Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016Ab1GSTKz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 15:10:55 -0400
Received: from mail.cs.tu-berlin.de ([130.149.17.13]:52802 "EHLO
	mail.cs.tu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942Ab1GSTKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 15:10:53 -0400
From: =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
To: Dipankar Sarma <dipankar@in.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Corey Minyard <minyard@acm.org>, Chris Mason <chris.mason@oracle.com>,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
Subject: [PATCH] rcu: Fix wrong check in list_splice_init_rcu()
Date: Tue, 19 Jul 2011 21:10:26 +0200
Message-Id: <1311102626-14831-1-git-send-email-schnhrr@cs.tu-berlin.de>
X-Mailer: git-send-email 1.7.6
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

If I don't miss something obvious, the following patch would
be a good idea.

There are currently two users of list_splice_init_rcu(): IPMI and btrfs.
For these, list_splice_init_rcu() is currently a NOP.

If I interpret the code correctly, this fixes a memory leak for
IPMI and something probably worse for btrfs.

The call from within btrfs was introduced only after v2.6.39 with commit
1f78160 ("Btrfs: using rcu lock in the reader side of devices list") by
converting a list_splice_init() call.

Therefore, this patch might be a candidate for v3.0.

Regards
Jan

----8<----
From: Jan H. Schönherr <schnhrr@cs.tu-berlin.de>

Splicing something into an empty list should work, while there is
nothing to do if the source list is empty.

Signed-off-by: Jan H. Schönherr <schnhrr@cs.tu-berlin.de>
---
 include/linux/rculist.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/rculist.h b/include/linux/rculist.h
index e3beb31..d079290 100644
--- a/include/linux/rculist.h
+++ b/include/linux/rculist.h
@@ -183,7 +183,7 @@ static inline void list_splice_init_rcu(struct list_head *list,
 	struct list_head *last = list->prev;
 	struct list_head *at = head->next;
 
-	if (list_empty(head))
+	if (list_empty(list))
 		return;
 
 	/* "first" and "last" tracking list, so initialize it. */
-- 
1.7.6

