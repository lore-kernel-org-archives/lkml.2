Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504Ab1AFAao (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:30:44 -0500
Received: from kroah.org ([198.145.64.141]:35882 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754462Ab1AFAag (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:30:36 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:05 2011
Message-Id: <20110106002305.646418041@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:23:12 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        NeilBrown <neilb@suse.de>
Subject: [093/152] md: protect against NULL reference when waiting to start a raid10.
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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

---
 drivers/md/md.c     |    5 ++---
 drivers/md/raid10.c |    2 +-
 2 files changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6040,9 +6040,8 @@ static int md_thread(void * arg)
 			 || kthread_should_stop(),
 			 thread->timeout);
 
-		clear_bit(THREAD_WAKEUP, &thread->flags);
-
-		thread->run(thread->mddev);
+		if (test_and_clear_bit(THREAD_WAKEUP, &thread->flags))
+			thread->run(thread->mddev);
 	}
 
 	return 0;
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2396,13 +2396,13 @@ static int run(mddev_t *mddev)
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


