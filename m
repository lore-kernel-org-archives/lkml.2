Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158Ab2AQWlr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 17:41:47 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38821 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755241Ab2AQWlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 17:41:45 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH] PM / Hibernate: Fix s2disk regression related to unlock_system_sleep()
Date: Tue, 17 Jan 2012 23:45:14 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0+; KDE/4.6.0; x86_64; ; )
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201201172345.15010.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

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
that changed snapshot_read() and snapshot_write().  Additionally,
make these functions check system_freezing_cnt and return error codes
if it is zero to ensure that they won't do anything if tasks have not
been frozen.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/user.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

Index: linux/kernel/power/user.c
===================================================================
--- linux.orig/kernel/power/user.c
+++ linux/kernel/power/user.c
@@ -137,7 +137,10 @@ static ssize_t snapshot_read(struct file
 	ssize_t res;
 	loff_t pg_offp = *offp & ~PAGE_MASK;
 
-	lock_system_sleep();
+	if (!atomic_read(&system_freezing_cnt))
+		return -EBUSY;
+
+	mutex_lock(&pm_mutex);
 
 	data = filp->private_data;
 	if (!data->ready) {
@@ -158,7 +161,7 @@ static ssize_t snapshot_read(struct file
 		*offp += res;
 
  Unlock:
-	unlock_system_sleep();
+	mutex_unlock(&pm_mutex);
 
 	return res;
 }
@@ -170,7 +173,10 @@ static ssize_t snapshot_write(struct fil
 	ssize_t res;
 	loff_t pg_offp = *offp & ~PAGE_MASK;
 
-	lock_system_sleep();
+	if (!atomic_read(&system_freezing_cnt))
+		return -EBUSY;
+
+	mutex_lock(&pm_mutex);
 
 	data = filp->private_data;
 
@@ -187,7 +193,7 @@ static ssize_t snapshot_write(struct fil
 	if (res > 0)
 		*offp += res;
 unlock:
-	unlock_system_sleep();
+	mutex_unlock(&pm_mutex);
 
 	return res;
 }
