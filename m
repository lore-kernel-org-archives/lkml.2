Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab0FWU2G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 16:28:06 -0400
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:56983 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674Ab0FWU2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 16:28:04 -0400
Date: Wed, 23 Jun 2010 15:27:44 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Manfred Spraul <manfred@colorfullife.com>
cc: Luca Tettamanti <kronos.it@gmail.com>, linux-kernel@vger.kernel.org,
       Julia Lawall <julia@diku.dk>, Andrew Morton <akpm@linux-foundation.org>,
       maciej.rutecki@gmail.com
Subject: Re: 2.6.35-rc3 deadlocks on semaphore operations
In-Reply-To: <4C223657.3030507@colorfullife.com>
Message-ID: <alpine.DEB.2.00.1006231527260.19225@router.home>
References: <alpine.DEB.2.00.1006180940140.11575@router.home> <20100621200118.GA4021@nb-core2.darkstar.lan> <4C223657.3030507@colorfullife.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/Mixed; BOUNDARY=------------000706090806010703060900
Content-ID: <alpine.DEB.2.00.1006231527261.19225@router.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--------------000706090806010703060900
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII; FORMAT=flowed
Content-ID: <alpine.DEB.2.00.1006231527262.19225@router.home>

On Wed, 23 Jun 2010, Manfred Spraul wrote:

> Attached is a patch that should fix the bug.

I have not seen the bug since I applied the fix.

--------------000706090806010703060900
Content-Type: TEXT/PLAIN; NAME=0001-ipc-sem.c-Bugfix-for-semop.patch
Content-ID: <alpine.DEB.2.00.1006231527263.19225@router.home>
Content-Description: 
Content-Disposition: ATTACHMENT; FILENAME=0001-ipc-sem.c-Bugfix-for-semop.patch

>From 5e047a60a625397d7b4c4a5f6ab088296258e065 Mon Sep 17 00:00:00 2001

From: Manfred Spraul <manfred@colorfullife.com>

Date: Wed, 23 Jun 2010 18:05:46 +0200

Subject: [PATCH] ipc/sem.c: Bugfix for semop() not reporting successful operation



The last change to improve the scalability moved the actual wake-up out of

the section that is protected by spin_lock(sma->sem_perm.lock).



This means that IN_WAKEUP can be in queue.status even when the spinlock is

acquired by the current task. Thus the same loop that is performed when

queue.status is read without the spinlock acquired must be performed when

the spinlock is acquired.



Signed-off-by: Manfred Spraul <manfred@colorfullife.com>

---

 ipc/sem.c |   36 ++++++++++++++++++++++++++++++------

 1 files changed, 30 insertions(+), 6 deletions(-)



diff --git a/ipc/sem.c b/ipc/sem.c

index 506c849..523665f 100644

--- a/ipc/sem.c

+++ b/ipc/sem.c

@@ -1256,6 +1256,32 @@ out:

 	return un;

 }

 

+

+/** get_queue_result - Retrieve the result code from sem_queue

+ * @q: Pointer to queue structure

+ *

+ * The function retrieve the return code from the pending queue. If 

+ * IN_WAKEUP is found in q->status, then we must loop until the value

+ * is replaced with the final value: This may happen if a task is

+ * woken up by an unrelated event (e.g. signal) and in parallel the task

+ * is woken up by another task because it got the requested semaphores.

+ *

+ * The function can be called with or without holding the semaphore spinlock.

+ */

+static int get_queue_result(struct sem_queue *q)

+{

+	int error;

+

+	error = q->status;

+	while(unlikely(error == IN_WAKEUP)) {

+		cpu_relax();

+		error = q->status;

+	}

+

+	return error;

+}

+

+

 SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,

 		unsigned, nsops, const struct timespec __user *, timeout)

 {

@@ -1409,11 +1435,7 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,

 	else

 		schedule();

 

-	error = queue.status;

-	while(unlikely(error == IN_WAKEUP)) {

-		cpu_relax();

-		error = queue.status;

-	}

+	error = get_queue_result(&queue);

 

 	if (error != -EINTR) {

 		/* fast path: update_queue already obtained all requested

@@ -1427,10 +1449,12 @@ SYSCALL_DEFINE4(semtimedop, int, semid, struct sembuf __user *, tsops,

 		goto out_free;

 	}

 

+	error = get_queue_result(&queue);

+

 	/*

 	 * If queue.status != -EINTR we are woken up by another process

 	 */

-	error = queue.status;

+

 	if (error != -EINTR) {

 		goto out_unlock_free;

 	}

-- 

1.7.0.1




--------------000706090806010703060900--
