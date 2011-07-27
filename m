Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002Ab1G0TM5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 15:12:57 -0400
Received: from mail.cs.tu-berlin.de ([130.149.17.13]:54983 "EHLO
	mail.cs.tu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754705Ab1G0TMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 15:12:53 -0400
From: =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: Paul Turner <pjt@google.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Dipankar Sarma <dipankar@in.ibm.com>, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
Subject: [PATCH RFCv2 7/8] rcu: Make use of __list_link() and __list_link_rcu()
Date: Wed, 27 Jul 2011 21:10:24 +0200
Message-Id: <1311793825-31933-8-git-send-email-schnhrr@cs.tu-berlin.de>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311793825-31933-1-git-send-email-schnhrr@cs.tu-berlin.de>
References: <1311793825-31933-1-git-send-email-schnhrr@cs.tu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan H. Schönherr <schnhrr@cs.tu-berlin.de>

This commit rewrites __list_add_rcu() and list_replace_rcu() to make
use of the new __list_link*() functions improving the readability
of the code.

Compared to the previous code, the assignments of the prev-pointers and
the call to rcu_assign_pointer() are reordered. But this is not a
problem, as readers are forbidden to use the prev-pointers.

Signed-off-by: Jan H. Schönherr <schnhrr@cs.tu-berlin.de>
---
 include/linux/rculist.h |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/include/linux/rculist.h b/include/linux/rculist.h
index 445c4f2..c5db505 100644
--- a/include/linux/rculist.h
+++ b/include/linux/rculist.h
@@ -56,10 +56,8 @@ static inline void __list_link_rcu(struct list_head *prev,
 static inline void __list_add_rcu(struct list_head *new,
 		struct list_head *prev, struct list_head *next)
 {
-	new->next = next;
-	new->prev = prev;
-	rcu_assign_pointer(list_next_rcu(prev), new);
-	next->prev = new;
+	__list_link(new, next);
+	__list_link_rcu(prev, new);
 }
 
 /**
@@ -174,10 +172,8 @@ static inline void hlist_del_init_rcu(struct hlist_node *n)
 static inline void list_replace_rcu(struct list_head *old,
 				struct list_head *new)
 {
-	new->next = old->next;
-	new->prev = old->prev;
-	rcu_assign_pointer(list_next_rcu(new->prev), new);
-	new->next->prev = new;
+	__list_link(new, old->next);
+	__list_link_rcu(old->prev, new);
 	old->prev = LIST_POISON2;
 }
 
-- 
1.7.6

