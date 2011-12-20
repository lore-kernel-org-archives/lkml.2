Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073Ab1LTWVf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 17:21:35 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:58358 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216Ab1LTWVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 17:21:32 -0500
Message-ID: <1324419687.20886.2.camel@raz>
Subject: Subject: PATCH[1:2] priority System V Semaphores
From: raz ben yehuda <raziebe@gmail.com>
To: manfred@colorfullife.com, linux-kernel@vger.kernel.org,
        rt-users@vger.kernel.org
Cc: Lior Brafman <LBrafman@manz.com>, Rasty Slutsker <RSlutsker@manz.com>,
        Torsten Scherer <TScherer@manz.com>
Date: Wed, 21 Dec 2011 00:21:27 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From bf3cbcb4d90bdd0b06048091ff516e1dfd61e349 Mon Sep 17 00:00:00 2001
From: raz <raziebe@gmail.com>
Date: Tue, 20 Dec 2011 22:38:14 +0200

Current Linux implementation for System V semaphores is FIFO.
Meaning, first task to sleep on the semaphore is the first
task to awake.
This patch (and the one follows) makes it possible to
have the higher (rt) priority task awake first.

For user space usage i present SETFIFO and SETPRIO
new options for semctl.
To define a priority semaphore do:

...
semid = semget(..)
..
semctl(semid, semnum, SETPRIO)

semctl marks semnum semaphore in a semaphore array
as priority semaphore.

Signed-off-by: raz <raziebe@gmail.com>
---
 include/linux/sem.h |    4 ++++
 ipc/sem.c           |   17 +++++++++++++++++
 2 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/include/linux/sem.h b/include/linux/sem.h
index 10d6b22..d553406 100644
--- a/include/linux/sem.h
+++ b/include/linux/sem.h
@@ -19,6 +19,10 @@
 #define SEM_STAT 18
 #define SEM_INFO 19
 
+/* semctl Additional Command Definitions. */
+#define SETPRIO 20	 /* priority semaphore */
+#define SETFIFO	21	 /* fifo based semahphore */
+
 /* Obsolete, used only for backwards compatibility and libc5 compiles */
 struct semid_ds {
 	struct ipc_perm	sem_perm;		/* permissions .. see ipc.h */
diff --git a/ipc/sem.c b/ipc/sem.c
index 5215a81..90dc5a1 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -90,10 +90,13 @@
 #include <asm/uaccess.h>
 #include "util.h"
 
+#define PRIO_SEM	1
+
 /* One semaphore structure for each semaphore in the system. */
 struct sem {
 	int	semval;		/* current value */
 	int	sempid;		/* pid of last operation */
+	int	flags;		/* PRIO of FIFO, defaults to FIFO */
 	struct list_head sem_pending; /* pending single-sop operations */
 };
 
@@ -1009,6 +1012,18 @@ static int semctl_main(struct ipc_namespace *ns, int semid, int semnum,
 	case GETNCNT:
 		err = count_semncnt(sma,semnum);
 		goto out_unlock;
+	case SETPRIO:
+	{
+		curr->flags |= PRIO_SEM;
+		err = 0;
+		goto out_unlock;
+	}
+	case SETFIFO:
+	{
+		curr->flags &= ~PRIO_SEM;
+		err = 0;
+		goto out_unlock;
+	}
 	case GETZCNT:
 		err = count_semzcnt(sma,semnum);
 		goto out_unlock;
@@ -1144,6 +1159,8 @@ SYSCALL_DEFINE(semctl)(int semid, int semnum, int cmd, union semun arg)
 	case GETZCNT:
 	case SETVAL:
 	case SETALL:
+	case SETFIFO:
+	case SETPRIO:
 		err = semctl_main(ns,semid,semnum,cmd,version,arg);
 		return err;
 	case IPC_RMID:
-- 
1.7.5.4




