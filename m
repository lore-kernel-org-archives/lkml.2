Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015Ab2HCMtH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 08:49:07 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46790 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876Ab2HCMtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 08:49:05 -0400
Message-ID: <501BC8BE.6000405@jp.fujitsu.com>
Date: Fri, 03 Aug 2012 21:49:02 +0900
From: Seiichi Ikarashi <s.ikarashi@jp.fujitsu.com>
Organization: Fujitsu Limited
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:12.0) Gecko/20120420 Thunderbird/12.0
MIME-Version: 1.0
To: manfred@colorfullife.com, linux-kernel@vger.kernel.org
Subject: [PATCH] ipc/sem.c: prevent ENOMEM in semop() w/ SEM_UNDO flag
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

semop() with SEM_UNDO sem_flg can result in ENOMEM even after
succeeding semget() with large nsems. This is because
semop() uses kzalloc() via find_alloc_undo() though
semget() uses vmalloc() via ipc_rcu_alloc().
This patch makes semop() be able to use vmalloc() via ipc_alloc().

Signed-off-by: Seiichi Ikarashi <s.ikarashi@jp.fujitsu.com>

--- a/ipc/sem.c	2012-08-03 16:52:01.000000000 +0900
+++ b/ipc/sem.c	2012-08-03 20:40:57.000000000 +0900
@@ -1258,11 +1258,12 @@ static struct sem_undo *find_alloc_undo(
 	sem_getref_and_unlock(sma);
 
 	/* step 2: allocate new undo structure */
-	new = kzalloc(sizeof(struct sem_undo) + sizeof(short)*nsems, GFP_KERNEL);
+	new = ipc_alloc(sizeof(struct sem_undo) + sizeof(short)*nsems, GFP_KERNEL);
 	if (!new) {
 		sem_putref(sma);
 		return ERR_PTR(-ENOMEM);
 	}
+	memset(new, 0, sizeof(struct sem_undo) + sizeof(short)*nsems);
 
 	/* step 3: Acquire the lock on semaphore array */
 	sem_lock_and_putref(sma);
@@ -1348,7 +1349,7 @@ SYSCALL_DEFINE4(semtimedop, int, semid, 
 	if (nsops > ns->sc_semopm)
 		return -E2BIG;
 	if(nsops > SEMOPM_FAST) {
-		sops = kmalloc(sizeof(*sops)*nsops,GFP_KERNEL);
+		sops = ipc_alloc(sizeof(*sops)*nsops,GFP_KERNEL);
 		if(sops==NULL)
 			return -ENOMEM;
 	}
