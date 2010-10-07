Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760142Ab0JGHmh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 03:42:37 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:36933 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760100Ab0JGHmg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 03:42:36 -0400
Message-ID: <4CAD7A00.6060003@fusionio.com>
Date: Thu, 07 Oct 2010 09:42:56 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] single block fix for 2.6.36
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The API that was added for drivers to switch IO schedulers
when loaded does not work if the driver isn't in a fully
initialized state. The in-kernel ones call it right after
blk_init_queue(), which will result in an oops when the
elevator core tries to unregister unregistered kobjects.

Add a registered bit and only do the unregister/register
dance in elevator_switch() if we need to. The other call
path for this is the sysfs parts to allow online switching,
which can only be called with a fully setup driver.

Please pull, this is a regression introduced in this series.

are available in the git repository at:
  git://git.kernel.dk/linux-2.6-block.git for-linus

Jens Axboe (1):
      elevator: fix oops on early call to elevator_change()

 block/elevator.c         |   12 ++++++++----
 include/linux/elevator.h |    1 +
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/block/elevator.c b/block/elevator.c
index 205b09a..4e11559 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -938,6 +938,7 @@ int elv_register_queue(struct request_queue *q)
 			}
 		}
 		kobject_uevent(&e->kobj, KOBJ_ADD);
+		e->registered = 1;
 	}
 	return error;
 }
@@ -947,6 +948,7 @@ static void __elv_unregister_queue(struct elevator_queue *e)
 {
 	kobject_uevent(&e->kobj, KOBJ_REMOVE);
 	kobject_del(&e->kobj);
+	e->registered = 0;
 }
 
 void elv_unregister_queue(struct request_queue *q)
@@ -1042,11 +1044,13 @@ static int elevator_switch(struct request_queue *q, struct elevator_type *new_e)
 
 	spin_unlock_irq(q->queue_lock);
 
-	__elv_unregister_queue(old_elevator);
+	if (old_elevator->registered) {
+		__elv_unregister_queue(old_elevator);
 
-	err = elv_register_queue(q);
-	if (err)
-		goto fail_register;
+		err = elv_register_queue(q);
+		if (err)
+			goto fail_register;
+	}
 
 	/*
 	 * finally exit old elevator and turn off BYPASS.
diff --git a/include/linux/elevator.h b/include/linux/elevator.h
index 926b503..4fd978e 100644
--- a/include/linux/elevator.h
+++ b/include/linux/elevator.h
@@ -93,6 +93,7 @@ struct elevator_queue
 	struct elevator_type *elevator_type;
 	struct mutex sysfs_lock;
 	struct hlist_head *hash;
+	unsigned int registered:1;
 };
 
 /*

-- 
Jens Axboe

