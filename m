Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319Ab2AQXM3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 18:12:29 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38866 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756236Ab2AQXM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 18:12:28 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [Update][PATCH] PM / Hibernate: Fix s2disk regression related to unlock_system_sleep()
Date: Wed, 18 Jan 2012 00:15:56 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0+; KDE/4.6.0; x86_64; ; )
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
References: <201201172345.15010.rjw@sisk.pl>
In-Reply-To: <201201172345.15010.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201201180015.56510.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM / Hibernate: Fix s2disk regression related to unlock_system_sleep()

Commit bcda53faf5814c0c6025a0bd47108adfcbe9f199, "PM / Sleep: Replace
mutex_[un]lock(&pm_mutex) with [un]lock_system_sleep()", modified
snapshot_read() and snapshot_write() in kernel/power/user.c, among
other things, by making them use lock_system_sleep() and
unlock_system_sleep() instead of just locking and unlocking pm_mutex.
Unfortunately, however, this was a mistake, because these routines
are supposed to be executed after processes have been frozen
(i.e. when system_freezing_cnt is nonzero), so when
unlock_system_sleep() is executed by one of them, this causes the
caller to execute try_to_freeze() and go into the refrigerator as
a result.  This, in turn, deadlocks the suspend process and locks up
the system.

Fix the problem by reverting the part of commit bcda53faf5814c0c6025a
that changed snapshot_read() and snapshot_write().

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---

Well, it wasn't a good idea to make snapshot_write() check
system_freezing_cnt, because the resume process doesn't freeze tasks.
So, it's better to simply revert the changes that introduced the
original regression.

Thanks,
Rafael

---
 kernel/power/user.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux/kernel/power/user.c
===================================================================
--- linux.orig/kernel/power/user.c
+++ linux/kernel/power/user.c
@@ -137,7 +137,7 @@ static ssize_t snapshot_read(struct file
 	ssize_t res;
 	loff_t pg_offp = *offp & ~PAGE_MASK;
 
-	lock_system_sleep();
+	mutex_lock(&pm_mutex);
 
 	data = filp->private_data;
 	if (!data->ready) {
@@ -158,7 +158,7 @@ static ssize_t snapshot_read(struct file
 		*offp += res;
 
  Unlock:
-	unlock_system_sleep();
+	mutex_unlock(&pm_mutex);
 
 	return res;
 }
@@ -170,7 +170,7 @@ static ssize_t snapshot_write(struct fil
 	ssize_t res;
 	loff_t pg_offp = *offp & ~PAGE_MASK;
 
-	lock_system_sleep();
+	mutex_lock(&pm_mutex);
 
 	data = filp->private_data;
 
@@ -187,7 +187,7 @@ static ssize_t snapshot_write(struct fil
 	if (res > 0)
 		*offp += res;
 unlock:
-	unlock_system_sleep();
+	mutex_unlock(&pm_mutex);
 
 	return res;
 }
