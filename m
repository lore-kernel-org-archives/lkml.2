Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266Ab2HHFyF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 01:54:05 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39147 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756525Ab2HHFyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 01:54:02 -0400
Message-ID: <5021FEF6.2020101@jp.fujitsu.com>
Date: Wed, 08 Aug 2012 14:53:58 +0900
From: Seiichi Ikarashi <s.ikarashi@jp.fujitsu.com>
Organization: Fujitsu Limited
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:12.0) Gecko/20120420 Thunderbird/12.0
MIME-Version: 1.0
To: Manfred Spraul <manfred@colorfullife.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipc/sem.c: prevent ENOMEM in semop() w/ SEM_UNDO flag
References: <501BC8BE.6000405@jp.fujitsu.com> <501C0CB6.7070409@colorfullife.com> <501EFED2.1070901@jp.fujitsu.com> <CALgW_8V=E0kuArcFCUXTOuNiay794Nd8tge=T65q0Fxp2Wnaow@mail.gmail.com>
In-Reply-To: <CALgW_8V=E0kuArcFCUXTOuNiay794Nd8tge=T65q0Fxp2Wnaow@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Manfred,

(2012-08-07 20:10), Manfred Spraul wrote:
> Hi Seiichi,
> 
> 2012/8/6 Seiichi Ikarashi <s.ikarashi@jp.fujitsu.com>
>>
>>
>>  A real case was as follows.
>>      semget(IPC_PRIVATE, 70000, IPC_CREAT | IPC_EXCL);
>>      sops[0].sem_num = 0;
>>      sops[0].sem_op  = 1;
>>      sops[0].sem_flg = SEM_UNDO;
>>      semop(semid, sops, 1);
>>
> 
> I think this can't work: sops[].sem_num is defined as "unsigned short".
> Thus more than 65500 semaphores in one semaphore set do not make
> any sense.
> "unsigned short" is also specified in the opengroup standard:
> 
> http://pubs.opengroup.org/onlinepubs/7908799/xsh/syssem.h.html
> 
> Thus: The hard limit is 65535. Perhaps slightly less, I haven't checked
> if (-1) is used somewhere to indicate an error.

Oops, you are correct.
More than 65536 semaphores in one set do not make sense
according to the definition.

> 
> Is it possible to split the semaphores into multiple semphore ids?
> e.g. 70 ids, each with 1000 semaphores?
> 
> The atomicity would be lost (e.g. all SEM_UNDO operations within
> one id are performed at once. With 70 ids, the SEM_UNDOs are not
> atomic anymore)

Thank you for your kind suggestion.

> 
>>
>>    #define SEMMSL  250             /* <= 8 000 max num of semaphores per id */
>>
> 
> As far as I can see your patch removes the last part of the code that
> caused the restriction to 8.000 semaphores per id.

Unfortunately no. My previous patch modified only the allocation part
and ignored the free part. Now I think the patch should be like this;

--- a/ipc/sem.c	2012-08-03 16:52:01.000000000 +0900
+++ b/ipc/sem.c	2012-08-08 14:16:11.000000000 +0900
@@ -735,6 +735,11 @@ static int count_semzcnt (struct sem_arr
 	return semzcnt;
 }
 
+static void vfree_rcu( , )
+{
+	// something like call_rcu()
+}
+
 /* Free a semaphore set. freeary() is called with sem_ids.rw_mutex locked
  * as a writer and the spinlock for this semaphore set hold. sem_ids.rw_mutex
  * remains locked on exit.
@@ -754,7 +759,7 @@ static void freeary(struct ipc_namespace
 		un->semid = -1;
 		list_del_rcu(&un->list_proc);
 		spin_unlock(&un->ulp->lock);
-		kfree_rcu(un, rcu);
+		vfree_rcu(un, rcu);
 	}
 
 	/* Wake up all pending processes and let them fail with EIDRM. */
@@ -1258,17 +1263,18 @@ static struct sem_undo *find_alloc_undo(
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
 	if (sma->sem_perm.deleted) {
 		sem_unlock(sma);
-		kfree(new);
+		ipc_free(new);
 		un = ERR_PTR(-EIDRM);
 		goto out;
 	}
@@ -1279,7 +1285,7 @@ static struct sem_undo *find_alloc_undo(
 	 */
 	un = lookup_undo(ulp, semid);
 	if (un) {
-		kfree(new);
+		ipc_free(new);
 		goto success;
 	}
 	/* step 5: initialize & link new undo structure */
@@ -1348,7 +1354,7 @@ SYSCALL_DEFINE4(semtimedop, int, semid, 
 	if (nsops > ns->sc_semopm)
 		return -E2BIG;
 	if(nsops > SEMOPM_FAST) {
-		sops = kmalloc(sizeof(*sops)*nsops,GFP_KERNEL);
+		sops = ipc_alloc(sizeof(*sops)*nsops,GFP_KERNEL);
 		if(sops==NULL)
 			return -ENOMEM;
 	}
@@ -1541,7 +1547,7 @@ out_unlock_free:
 	wake_up_sem_queue_do(&tasks);
 out_free:
 	if(sops != fast_sops)
-		kfree(sops);
+		ipc_free(sops);
 	return error;
 }
 
@@ -1669,7 +1675,7 @@ void exit_sem(struct task_struct *tsk)
 		sem_unlock(sma);
 		wake_up_sem_queue_do(&tasks);
 
-		kfree_rcu(un, rcu);
+		vfree_rcu(un, rcu);
 	}
 	kfree(ulp);
 }


I think I need a replacement of kfree_rcu() here, something like vfree_rcu().
I'm reading kernel/rcu* files now...

> 
> Thus I'd propose that your patch changes this line to
> 
> + #define SEMMSL  250             /* <= 65 500 max num of semaphores per id */

Sure, when above rcu matter is solved.

> 
> And:
> I would add a comment into the patch description all semaphores
> from one id share a single kernel spinlock. This could be changed, but

Are you mentioning struct sem_array.sem_perm.lock?

> it would
> a) add complexity for all users and
> b) change user space visible behavior
> Thus I would prefer to avoid to implement it unless there are real
> applications that need this implementation.

Regards,
Seiichi

