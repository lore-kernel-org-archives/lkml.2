Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268Ab1BBAzN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:55:13 -0500
Received: from mga02.intel.com ([134.134.136.20]:59105 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753661Ab1BBAot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:44:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="703028528"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: neilb@suse.de, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [87/139] md: protect against NULL reference when waiting to start a raid10.
Message-Id: <20110202004444.CD5A23E09C6@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:44:44 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: NeilBrown <neilb@suse.de>

commit 589a594be1fb8815b3f18e517be696c48664f728 upstream.

When we fail to start a raid10 for some reason, we call
md_unregister_thread to kill the thread that was created.

Unfortunately md_thread() will then make one call into the handler
(raid10d) even though md_wakeup_thread has not been called.  This is
not safe and as md_unregister_thread is called after mddev->private
has been set to NULL, it will definitely cause a NULL dereference.

So fix this at both ends:
 - md_thread should only call the handler if THREAD_WAKEUP has been
   set.
 - raid10 should call md_unregister_thread before setting things
   to NULL just like all the other raid modules do.

This is applicable to 2.6.35 and later.

Reported-by: "Citizen" <citizen_lee@thecus.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/md/md.c     |    5 ++---
 drivers/md/raid10.c |    2 +-
 2 files changed, 3 insertions(+), 4 deletions(-)

Index: linux-2.6.35.y/drivers/md/md.c
===================================================================
--- linux-2.6.35.y.orig/drivers/md/md.c
+++ linux-2.6.35.y/drivers/md/md.c
@@ -5989,9 +5989,8 @@ static int md_thread(void * arg)
 			 || kthread_should_stop(),
 			 thread->timeout);
 
-		clear_bit(THREAD_WAKEUP, &thread->flags);
-
-		thread->run(thread->mddev);
+		if (test_and_clear_bit(THREAD_WAKEUP, &thread->flags))
+			thread->run(thread->mddev);
 	}
 
 	return 0;
Index: linux-2.6.35.y/drivers/md/raid10.c
===================================================================
--- linux-2.6.35.y.orig/drivers/md/raid10.c
+++ linux-2.6.35.y/drivers/md/raid10.c
@@ -2393,13 +2393,13 @@ static int run(mddev_t *mddev)
 	return 0;
 
 out_free_conf:
+	md_unregister_thread(mddev->thread);
 	if (conf->r10bio_pool)
 		mempool_destroy(conf->r10bio_pool);
 	safe_put_page(conf->tmppage);
 	kfree(conf->mirrors);
 	kfree(conf);
 	mddev->private = NULL;
-	md_unregister_thread(mddev->thread);
 out:
 	return -EIO;
 }
