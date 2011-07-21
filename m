Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104Ab1GUNVe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 09:21:34 -0400
Received: from mail.cs.tu-berlin.de ([130.149.17.13]:64358 "EHLO
	mail.cs.tu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981Ab1GUNVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 09:21:31 -0400
From: =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
To: Paul Turner <pjt@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
Subject: [PATCH RFC 2/3] rcu: More rcu-variants for list manipulation
Date: Thu, 21 Jul 2011 15:20:22 +0200
Message-Id: <1311254423-25484-3-git-send-email-schnhrr@cs.tu-berlin.de>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311254423-25484-1-git-send-email-schnhrr@cs.tu-berlin.de>
References: <CAPM31RLqq0hgdhoh3GA-38petKeE1zxcL=uJYba9o3yd+_7jjw@mail.gmail.com>
 <1311254423-25484-1-git-send-email-schnhrr@cs.tu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan H. Schönherr <schnhrr@cs.tu-berlin.de>

This commit introduces some more *_rcu variants of some list
manipulation functions:

__list_link_rcu()
__list_splice_rcu()
list_splice_tail_init_rcu()

An important difference of the new rcu-splice functions
compared to the existing function is that they require
that there are either no concurrent readers on the list to
be spliced or that these readers are still from the list
where the list is spliced into.

Signed-off-by: Jan H. Schönherr <schnhrr@cs.tu-berlin.de>

---
TODO:
- add comments
- rephrase existing splice function using __list_splice_rcu()
  and probably add "_sync" to the name
---
 include/linux/rculist.h |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/include/linux/rculist.h b/include/linux/rculist.h
index 748401b..56385c8 100644
--- a/include/linux/rculist.h
+++ b/include/linux/rculist.h
@@ -24,6 +24,15 @@
  */
 #define list_next_rcu(list)	(*((struct list_head __rcu **)(&(list)->next)))
 
+
+static inline void __list_link_rcu(struct list_head *prev,
+					struct list_head *next)
+{
+	rcu_assign_pointer(list_next_rcu(prev), next);
+	next->prev = prev;
+}
+
+
 /*
  * Insert a new entry between two known consecutive entries.
  *
@@ -158,6 +167,23 @@ static inline void list_replace_rcu(struct list_head *old,
 	old->prev = LIST_POISON2;
 }
 
+static inline void __list_splice_rcu(struct list_head *list,
+					struct list_head *prev,
+					struct list_head *next)
+{
+	__list_link(list->prev, next);
+	__list_link_rcu(prev, list->next);
+}
+
+static inline void list_splice_tail_init_rcu(struct list_head *list,
+						struct list_head *head)
+{
+	if (!list_empty(list)) {
+		__list_splice_rcu(list, head->prev, head);
+		INIT_LIST_HEAD(list);
+	}
+}
+
 /**
  * list_splice_init_rcu - splice an RCU-protected list into an existing list.
  * @list:	the RCU-protected list to splice
-- 
1.7.6

