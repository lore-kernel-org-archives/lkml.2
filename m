Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932280Ab1HCXb4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 19:31:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34198 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756206Ab1HCXa7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 19:30:59 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Aug  3 15:12:53 2011
Message-Id: <20110803221253.230343572@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 03 Aug 2011 15:01:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Manfred Spraul <manfred@colorfullife.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [091/102] ipc/sem.c: fix race with concurrent semtimedop() timeouts and IPC_RMID
In-Reply-To: <20110803221345.GA10346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Manfred Spraul <manfred@colorfullife.com>

commit d694ad62bf539dbb20a0899ac2a954555f9e4a83 upstream.

If a semaphore array is removed and in parallel a sleeping task is woken
up (signal or timeout, does not matter), then the woken up task does not
wait until wake_up_sem_queue_do() is completed.  This will cause crashes,
because wake_up_sem_queue_do() will read from a stale pointer.

The fix is simple: Regardless of anything, always call get_queue_result().
This function waits until wake_up_sem_queue_do() has finished it's task.

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=27142

Reported-by: Yuriy Yevtukhov <yuriy@ucoz.com>
Reported-by: Harald Laabs <kernel@dasr.de>
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 ipc/sem.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -1456,15 +1456,24 @@ SYSCALL_DEFINE4(semtimedop, int, semid,
 	}
 
 	sma = sem_lock(ns, semid);
+
+	/*
+	 * Wait until it's guaranteed that no wakeup_sem_queue_do() is ongoing.
+	 */
+	error = get_queue_result(&queue);
+
+	/*
+	 * Array removed? If yes, leave without sem_unlock().
+	 */
 	if (IS_ERR(sma)) {
 		error = -EIDRM;
 		goto out_free;
 	}
 
-	error = get_queue_result(&queue);
 
 	/*
-	 * If queue.status != -EINTR we are woken up by another process
+	 * If queue.status != -EINTR we are woken up by another process.
+	 * Leave without unlink_queue(), but with sem_unlock().
 	 */
 
 	if (error != -EINTR) {


