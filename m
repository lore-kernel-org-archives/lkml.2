Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932362Ab2GBGEu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 02:04:50 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:32896 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932199Ab2GBGEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 02:04:49 -0400
Message-ID: <1341209044.5102.20.camel@ThinkPad-T420>
Subject: [PATCH] Fix a dead loop in async_synchronize_full()
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: arjan@linux.intel.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Mon, 02 Jul 2012 14:04:04 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 12070206-2674-0000-0000-00000518456F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch tries to fix a dead loop in  async_synchronize_full(), which
could be seen when preemption is disabled on a single cpu machine. 

void async_synchronize_full(void)
{
        do {
                async_synchronize_cookie(next_cookie);
        } while (!list_empty(&async_running) || !
list_empty(&async_pending));
}

async_synchronize_cookie() calls async_synchronize_cookie_domain() with
&async_running as the default domain to synchronize. 

However, there might be some works in the async_pending list from other
domains. On a single cpu system, without preemption, there is no chance
for the other works to finish, so async_synchronize_full() enters a dead
loop. 

It seems async_synchronize_full() wants to synchronize all entries in
all running lists(domains), so maybe we could just check the entry_count
to know whether all works are finished. 

Currently, async_synchronize_cookie_domain() expects a non-NULL running
list ( if NULL, there would be NULL pointer dereference ), so maybe a
NULL pointer could be used as an indication for the functions to
synchronize all works in all domains. 

Reported-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
Tested-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/async.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/kernel/async.c b/kernel/async.c
index bd0c168..32d8dc9 100644
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -86,6 +86,13 @@ static async_cookie_t  __lowest_in_progress(struct
list_head *running)
 {
 	struct async_entry *entry;
 
+	if (!running) { /* just check the entry count */
+		if (atomic_read(&entry_count))
+			return 0; /* smaller than any cookie */
+		else
+			return next_cookie;
+	}
+
 	if (!list_empty(running)) {
 		entry = list_first_entry(running,
 			struct async_entry, list);
@@ -236,9 +243,7 @@ EXPORT_SYMBOL_GPL(async_schedule_domain);
  */
 void async_synchronize_full(void)
 {
-	do {
-		async_synchronize_cookie(next_cookie);
-	} while (!list_empty(&async_running) || !list_empty(&async_pending));
+	async_synchronize_cookie_domain(next_cookie, NULL);
 }
 EXPORT_SYMBOL_GPL(async_synchronize_full);
 
@@ -258,7 +263,7 @@ EXPORT_SYMBOL_GPL(async_synchronize_full_domain);
 /**
  * async_synchronize_cookie_domain - synchronize asynchronous function
calls within a certain domain with cookie checkpointing
  * @cookie: async_cookie_t to use as checkpoint
- * @running: running list to synchronize on
+ * @running: running list to synchronize on, NULL indicates all lists
  *
  * This function waits until all asynchronous function calls for the
  * synchronization domain specified by the running list @list submitted
-- 
1.7.9.5

