Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878Ab0ETG7R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 02:59:17 -0400
Received: from cantor.suse.de ([195.135.220.2]:54433 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752734Ab0ETG7Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 02:59:16 -0400
Date: Thu, 20 May 2010 16:59:11 +1000
From: Nick Piggin <npiggin@suse.de>
To: Manfred Spraul <manfred@colorfullife.com>, linux-kernel@vger.kernel.org
Subject: [patch 1/3] ipc: rename IPCMNI to IPCMNI_MAX
Message-ID: <20100520065911.GG2516@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Just a couple of small IPC patches I have, I wonder if you could
comment on or merge?

--
The IPCMNI limit is different from the other MNI limits. It is not exposed
to userspace, it is not tunable via sysctl -- it is a hard limit. Rename it
to IPCMNI_MAX, to signify it is a maximum rather than default value.

It is an internal value tied to IPC sequence numbering, so move it into
ipc/util.h.

Index: linux-2.6/include/linux/ipc.h
===================================================================
--- linux-2.6.orig/include/linux/ipc.h
+++ linux-2.6/include/linux/ipc.h
@@ -80,8 +80,6 @@ struct ipc_kludge {
 #ifdef __KERNEL__
 #include <linux/spinlock.h>
 
-#define IPCMNI 32768  /* <= MAX_INT limit for ipc arrays (including sysctl changes) */
-
 /* used by in-kernel data structures */
 struct kern_ipc_perm
 {
Index: linux-2.6/include/linux/msg.h
===================================================================
--- linux-2.6.orig/include/linux/msg.h
+++ linux-2.6/include/linux/msg.h
@@ -55,11 +55,11 @@ struct msginfo {
  * at most 1/MSG_MEM_SCALE of the lowmem (see the formula in ipc/msg.c):
  * up to 8MB       : msgmni = 16 (MSGMNI)
  * 4 GB            : msgmni = 8K
- * more than 16 GB : msgmni = 32K (IPCMNI)
+ * more than 16 GB : msgmni = 32K (IPCMNI_MAX)
  */
 #define MSG_MEM_SCALE 32
 
-#define MSGMNI    16   /* <= IPCMNI */     /* max # of msg queue identifiers */
+#define MSGMNI    16   /* <= IPCMNI_MAX */ /* max # of msg queue identifiers */
 #define MSGMAX  8192   /* <= INT_MAX */   /* max size of message (bytes) */
 #define MSGMNB 16384   /* <= INT_MAX */   /* default max size of a message queue */
 
Index: linux-2.6/include/linux/sem.h
===================================================================
--- linux-2.6.orig/include/linux/sem.h
+++ linux-2.6/include/linux/sem.h
@@ -63,7 +63,7 @@ struct  seminfo {
 	int semaem;
 };
 
-#define SEMMNI  128             /* <= IPCMNI  max # of semaphore identifiers */
+#define SEMMNI  128             /* <= IPCMNI_MAX  max semaphore identifiers */
 #define SEMMSL  250             /* <= 8 000 max num of semaphores per id */
 #define SEMMNS  (SEMMNI*SEMMSL) /* <= INT_MAX max # of semaphores in system */
 #define SEMOPM  32	        /* <= 1 000 max num of ops per semop call */
Index: linux-2.6/include/linux/shm.h
===================================================================
--- linux-2.6.orig/include/linux/shm.h
+++ linux-2.6/include/linux/shm.h
@@ -14,15 +14,15 @@
  * be increased by sysctl
  */
 
-#define SHMMAX 0x2000000		 /* max shared seg size (bytes) */
-#define SHMMIN 1			 /* min shared seg size (bytes) */
-#define SHMMNI 4096			 /* max num of segs system wide */
+#define SHMMAX 0x2000000	 /* max shared seg size (bytes) */
+#define SHMMIN 1		 /* min shared seg size (bytes) */
+#define SHMMNI 4096		 /* <= IPCMNI_MAX max num of segs system wide */
 #ifdef __KERNEL__
 #define SHMALL (SHMMAX/PAGE_SIZE*(SHMMNI/16)) /* max shm system wide (pages) */
 #else
 #define SHMALL (SHMMAX/getpagesize()*(SHMMNI/16))
 #endif
-#define SHMSEG SHMMNI			 /* max shared segs per process */
+#define SHMSEG SHMMNI		 /* max shared segs per process */
 
 #ifdef __KERNEL__
 #include <asm/shmparam.h>
Index: linux-2.6/ipc/msg.c
===================================================================
--- linux-2.6.orig/ipc/msg.c
+++ linux-2.6/ipc/msg.c
@@ -81,7 +81,7 @@ static int sysvipc_msg_proc_show(struct
  * Scale msgmni with the available lowmem size: the memory dedicated to msg
  * queues should occupy at most 1/MSG_MEM_SCALE of lowmem.
  * Also take into account the number of nsproxies created so far.
- * This should be done staying within the (MSGMNI , IPCMNI/nr_ipc_ns) range.
+ * This should be done staying within the (MSGMNI , IPCMNI_MAX/nr_ipc_ns) range.
  */
 void recompute_msgmni(struct ipc_namespace *ns)
 {
@@ -100,8 +100,8 @@ void recompute_msgmni(struct ipc_namespa
 		return;
 	}
 
-	if (allowed > IPCMNI / nb_ns) {
-		ns->msg_ctlmni = IPCMNI / nb_ns;
+	if (allowed > IPCMNI_MAX / nb_ns) {
+		ns->msg_ctlmni = IPCMNI_MAX / nb_ns;
 		return;
 	}
 
Index: linux-2.6/ipc/util.c
===================================================================
--- linux-2.6.orig/ipc/util.c
+++ linux-2.6/ipc/util.c
@@ -113,7 +113,7 @@ __initcall(ipc_init);
  *	@ids: Identifier set
  *
  *	Set up the sequence range to use for the ipc identifier range (limited
- *	below IPCMNI) then initialise the ids idr.
+ *	below IPCMNI_MAX) then initialise the ids idr.
  */
  
 void ipc_init_ids(struct ipc_ids *ids)
@@ -218,12 +218,12 @@ int ipc_get_maxid(struct ipc_ids *ids)
 	if (ids->in_use == 0)
 		return -1;
 
-	if (ids->in_use == IPCMNI)
-		return IPCMNI - 1;
+	if (ids->in_use == IPCMNI_MAX)
+		return IPCMNI_MAX - 1;
 
 	/* Look for the last assigned id */
 	total = 0;
-	for (id = 0; id < IPCMNI && total < ids->in_use; id++) {
+	for (id = 0; id < IPCMNI_MAX && total < ids->in_use; id++) {
 		ipc = idr_find(&ids->ipcs_idr, id);
 		if (ipc != NULL) {
 			max_id = id;
@@ -253,8 +253,8 @@ int ipc_addid(struct ipc_ids* ids, struc
 	gid_t egid;
 	int id, err;
 
-	if (size > IPCMNI)
-		size = IPCMNI;
+	if (size > IPCMNI_MAX)
+		size = IPCMNI_MAX;
 
 	if (ids->in_use >= size)
 		return -ENOSPC;
@@ -859,7 +859,7 @@ static struct kern_ipc_perm *sysvipc_fin
 	if (total >= ids->in_use)
 		return NULL;
 
-	for ( ; pos < IPCMNI; pos++) {
+	for ( ; pos < IPCMNI_MAX; pos++) {
 		ipc = idr_find(&ids->ipcs_idr, pos);
 		if (ipc != NULL) {
 			*new_pos = pos + 1;
Index: linux-2.6/ipc/util.h
===================================================================
--- linux-2.6.orig/ipc/util.h
+++ linux-2.6/ipc/util.h
@@ -13,7 +13,9 @@
 #include <linux/unistd.h>
 #include <linux/err.h>
 
-#define SEQ_MULTIPLIER	(IPCMNI)
+#define IPCMNI_MAX 32768  /* <= MAX_INT absolute limit for ipc arrays */
+
+#define SEQ_MULTIPLIER	(IPCMNI_MAX)
 
 void sem_init (void);
 void msg_init (void);
