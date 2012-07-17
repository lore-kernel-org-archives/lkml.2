Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502Ab2GQCmf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 22:42:35 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:51145 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754463Ab2GQCm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 22:42:28 -0400
Message-ID: <1342492936.2884.8.camel@ThinkPad-T420>
Subject: [PATCH RESEND] Fix a dead loop in async_synchronize_full()
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: paulmck@linux.vnet.ibm.com
Cc: Dan Williams <dan.j.williams@gmail.com>,
        Christian Kujau <lists@nerdbynature.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, arjan@linux.intel.com,
        Cong Wang <xiyou.wangcong@gmail.com>, JBottomley@parallels.com,
        zhong@linux.vnet.ibm.com
Date: Tue, 17 Jul 2012 10:42:16 +0800
In-Reply-To: <20120717015710.GA2438@linux.vnet.ibm.com>
References: <1341817465.4579.5.camel@ThinkPad-T420>
	 <20120711154232.165cbca9.akpm@linux-foundation.org>
	 <CABE8wwsqyo=BPCy4xy1PAVKFWe=GqYRdYowXkQ6UZoXdtEdCZA@mail.gmail.com>
	 <1342086988.4091.44.camel@ThinkPad-T420>
	 <alpine.DEB.2.01.1207161130080.26923@trent.utfs.org>
	 <CAA9_cmf-5CW0KW=721Hh3GCKGgQYsJo1UX3AFbG+7c4fTGw-Yw@mail.gmail.com>
	 <20120717015710.GA2438@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 12071616-9264-0000-0000-000001ED5558
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

resend it again with the email client fixed... in case it is needed

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
---
 kernel/async.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/kernel/async.c b/kernel/async.c
index bd0c168..32d8dc9 100644
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -86,6 +86,13 @@ static async_cookie_t  __lowest_in_progress(struct list_head *running)
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
  * async_synchronize_cookie_domain - synchronize asynchronous function calls within a certain domain with cookie checkpointing
  * @cookie: async_cookie_t to use as checkpoint
- * @running: running list to synchronize on
+ * @running: running list to synchronize on, NULL indicates all lists
  *
  * This function waits until all asynchronous function calls for the
  * synchronization domain specified by the running list @list submitted
-- 
1.7.9.5


