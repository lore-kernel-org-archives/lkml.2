Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759723Ab2I1UwV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:52:21 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:58009 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1945930Ab2I1Usi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:48:38 -0400
X-Sasl-enc: i6q4j3SYTddkwpvNcVRafhrrZ7WVSwPYs0e0ism5pElH 1348865317
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Christian Kujau <lists@nerdbynature.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Williams <dan.j.williams@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: [ 101/127] Fix a dead loop in async_synchronize_full()
Date: Fri, 28 Sep 2012 13:34:34 -0700
Message-Id: <20120928203057.718553449@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928203045.835238916@linuxfoundation.org>
References: <20120928203045.835238916@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Zhong <zhong@linux.vnet.ibm.com>

[Fixed upstream by commits 2955b47d2c1983998a8c5915cb96884e67f7cb53 and
a4683487f90bfe3049686fc5c566bdc1ad03ace6 from Dan Williams, but they are much
more intrusive than this tiny fix, according to Andrew - gregkh]

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
Tested-by: Christian Kujau <lists@nerdbynature.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@gmail.com>
Cc: Christian Kujau <lists@nerdbynature.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/async.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/kernel/async.c
+++ b/kernel/async.c
@@ -87,6 +87,13 @@ static async_cookie_t  __lowest_in_progr
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
@@ -236,9 +243,7 @@ EXPORT_SYMBOL_GPL(async_schedule_domain)
  */
 void async_synchronize_full(void)
 {
-	do {
-		async_synchronize_cookie(next_cookie);
-	} while (!list_empty(&async_running) || !list_empty(&async_pending));
+	async_synchronize_cookie_domain(next_cookie, NULL);
 }
 EXPORT_SYMBOL_GPL(async_synchronize_full);
 
@@ -258,7 +263,7 @@ EXPORT_SYMBOL_GPL(async_synchronize_full
 /**
  * async_synchronize_cookie_domain - synchronize asynchronous function calls within a certain domain with cookie checkpointing
  * @cookie: async_cookie_t to use as checkpoint
- * @running: running list to synchronize on
+ * @running: running list to synchronize on, NULL indicates all lists
  *
  * This function waits until all asynchronous function calls for the
  * synchronization domain specified by the running list @list submitted


