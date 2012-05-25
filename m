Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab2EYHef (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 03:34:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:55982 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984Ab2EYHeb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 03:34:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="148280526"
Subject: [PATCH 2/4] async: make async_synchronize_full() flush all work
 regardless of domain
To: mroos@linux.ee
From: Dan Williams <dan.j.williams@intel.com>
Cc: Len Brown <len.brown@intel.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        James Bottomley <JBottomley@parallels.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Arjan van de Ven <arjan@linux.intel.com>
Date: Fri, 25 May 2012 00:50:32 -0700
Message-ID: <20120525075032.21933.17544.stgit@dwillia2-linux.jf.intel.com>
In-Reply-To: <20120525074813.21933.91876.stgit@dwillia2-linux.jf.intel.com>
References: <20120525074813.21933.91876.stgit@dwillia2-linux.jf.intel.com>
User-Agent: StGit/0.16-1-g7004
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In response to an async related regression James noted:

  "My theory is that this is an init problem: The assumption in a lot of
   our code is that async_synchronize_full() waits for everything ... even
   the domain specific async schedules, which isn't true."

...so make this assumption true.

Each domain, including the default one, registers itself on a global domain
list when work is scheduled.  Once all entries complete it exits that
list.  Waiting for the list to be empty syncs all in-flight work across
all domains.

Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: James Bottomley <JBottomley@parallels.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 kernel/async.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/async.c b/kernel/async.c
index aa23eec..f7d70b1 100644
--- a/kernel/async.c
+++ b/kernel/async.c
@@ -63,6 +63,7 @@ static async_cookie_t next_cookie = 1;
 
 static LIST_HEAD(async_pending);
 static ASYNC_DOMAIN(async_running);
+static LIST_HEAD(async_domains);
 static DEFINE_SPINLOCK(async_lock);
 
 struct async_entry {
@@ -145,6 +146,8 @@ static void async_run_entry_fn(struct work_struct *work)
 	/* 3) remove self from the running queue */
 	spin_lock_irqsave(&async_lock, flags);
 	list_del(&entry->list);
+	if (--running->count == 0)
+		list_del_init(&running->node);
 
 	/* 4) free the entry */
 	kfree(entry);
@@ -187,6 +190,8 @@ static async_cookie_t __async_schedule(async_func_ptr *ptr, void *data, struct a
 	spin_lock_irqsave(&async_lock, flags);
 	newcookie = entry->cookie = next_cookie++;
 	list_add_tail(&entry->list, &async_pending);
+	if (running->count++ == 0)
+		list_add_tail(&running->node, &async_domains);
 	atomic_inc(&entry_count);
 	spin_unlock_irqrestore(&async_lock, flags);
 
@@ -238,7 +243,7 @@ void async_synchronize_full(void)
 {
 	do {
 		async_synchronize_cookie(next_cookie);
-	} while (!list_empty(&async_running.domain) || !list_empty(&async_pending));
+	} while (!list_empty(&async_domains));
 }
 EXPORT_SYMBOL_GPL(async_synchronize_full);
 

