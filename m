Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096Ab1G0TMb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 15:12:31 -0400
Received: from mail.cs.tu-berlin.de ([130.149.17.13]:54894 "EHLO
	mail.cs.tu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755067Ab1G0TM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 15:12:28 -0400
From: =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: Paul Turner <pjt@google.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Dipankar Sarma <dipankar@in.ibm.com>, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
Subject: [PATCH RFCv2 5/8] treewide: Use __list_del() instead of __list_link()
Date: Wed, 27 Jul 2011 21:10:22 +0200
Message-Id: <1311793825-31933-6-git-send-email-schnhrr@cs.tu-berlin.de>
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

There are a few cases where __list_link() is actually used
to delete a single list entry like this:

__list_link(entry->prev, entry->next);

For this case, we have the function __list_del() which
does exactly the same, but states the purpose more clearly:

__list_del(entry);

This commit changes these occurrences.

Signed-off-by: Jan H. Schönherr <schnhrr@cs.tu-berlin.de>
---
 include/linux/list.h  |    2 +-
 kernel/mutex.h        |    2 +-
 kernel/timer.c        |    2 +-
 net/ipv4/cipso_ipv4.c |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/list.h b/include/linux/list.h
index 5319099..86a5f3f 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -102,7 +102,7 @@ static inline void __list_del(struct list_head *entry)
 
 static inline void list_del(struct list_head *entry)
 {
-	__list_link(entry->prev, entry->next);
+	__list_del(entry);
 	entry->next = LIST_POISON1;
 	entry->prev = LIST_POISON2;
 }
diff --git a/kernel/mutex.h b/kernel/mutex.h
index bcac8d1..39c02e8 100644
--- a/kernel/mutex.h
+++ b/kernel/mutex.h
@@ -14,7 +14,7 @@
 #define spin_unlock_mutex(lock, flags) \
 		do { spin_unlock(lock); (void)(flags); } while (0)
 #define mutex_remove_waiter(lock, waiter, ti) \
-		__list_link((waiter)->list.prev, (waiter)->list.next)
+		__list_del(&(waiter)->list)
 
 #ifdef CONFIG_SMP
 static inline void mutex_set_owner(struct mutex *lock)
diff --git a/kernel/timer.c b/kernel/timer.c
index 7ecae26..867a7ee 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -615,7 +615,7 @@ static inline void detach_timer(struct timer_list *timer,
 
 	debug_deactivate(timer);
 
-	__list_link(entry->prev, entry->next);
+	__list_del(entry);
 	if (clear_pending)
 		entry->next = NULL;
 	entry->prev = LIST_POISON2;
diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
index 5803807..552603f 100644
--- a/net/ipv4/cipso_ipv4.c
+++ b/net/ipv4/cipso_ipv4.c
@@ -348,7 +348,7 @@ static int cipso_v4_cache_check(const unsigned char *key,
 			if (entry->activity > prev_entry->activity &&
 			    entry->activity - prev_entry->activity >
 			    CIPSO_V4_CACHE_REORDERLIMIT) {
-				__list_link(entry->list.prev, entry->list.next);
+				__list_del(&entry->list);
 				__list_add(&entry->list,
 					   prev_entry->list.prev,
 					   &prev_entry->list);
-- 
1.7.6

