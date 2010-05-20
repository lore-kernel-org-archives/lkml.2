Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979Ab0ETHAT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 03:00:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53213 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753530Ab0ETHAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 03:00:17 -0400
Date: Thu, 20 May 2010 17:00:04 +1000
From: Nick Piggin <npiggin@suse.de>
To: Manfred Spraul <manfred@colorfullife.com>, linux-kernel@vger.kernel.org
Subject: [patch 2/3] ipc: use shifts to extract seq/idx
Message-ID: <20100520070004.GH2516@laptop>
References: <20100520065911.GG2516@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100520065911.GG2516@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


All the ipc ids and sequences are signed integers, so power of 2
sequence multiplier does not work so well. Convert it to use shifts,
which improves generated code particularly in ipc_lock/ipc_lock_check
fast paths.

Index: linux-2.6/ipc/util.c
===================================================================
--- linux-2.6.orig/ipc/util.c
+++ linux-2.6/ipc/util.c
@@ -123,7 +123,7 @@ void ipc_init_ids(struct ipc_ids *ids)
 	ids->in_use = 0;
 	ids->seq = 0;
 	{
-		int seq_limit = INT_MAX/SEQ_MULTIPLIER;
+		int seq_limit = INT_MAX >> SEQ_SHIFT;
 		if (seq_limit > USHORT_MAX)
 			ids->seq_max = USHORT_MAX;
 		 else
Index: linux-2.6/ipc/util.h
===================================================================
--- linux-2.6.orig/ipc/util.h
+++ linux-2.6/ipc/util.h
@@ -13,9 +13,11 @@
 #include <linux/unistd.h>
 #include <linux/err.h>
 
-#define IPCMNI_MAX 32768  /* <= MAX_INT absolute limit for ipc arrays */
+/* IPCMNI_MAX should be <= MAX_INT, absolute limit for ipc arrays */
+#define IPCMNI_MAX_SHIFT	15
+#define IPCMNI_MAX		(1 << IPCMNI_MAX_SHIFT)
 
-#define SEQ_MULTIPLIER	(IPCMNI_MAX)
+#define SEQ_SHIFT		IPCMNI_MAX_SHIFT
 
 void sem_init (void);
 void msg_init (void);
@@ -93,7 +95,7 @@ void __init ipc_init_proc_interface(cons
 #define IPC_MSG_IDS	1
 #define IPC_SHM_IDS	2
 
-#define ipcid_to_idx(id) ((id) % SEQ_MULTIPLIER)
+#define ipcid_to_idx(id) ((id) & ((1UL << SEQ_SHIFT) - 1))
 
 /* must be called with ids->rw_mutex acquired for writing */
 int ipc_addid(struct ipc_ids *, struct kern_ipc_perm *, int);
@@ -146,7 +148,7 @@ extern void recompute_msgmni(struct ipc_
 
 static inline int ipc_buildid(int id, int seq)
 {
-	return SEQ_MULTIPLIER * seq + id;
+	return (seq << SEQ_SHIFT) + id;
 }
 
 /*
@@ -154,7 +156,7 @@ static inline int ipc_buildid(int id, in
  */
 static inline int ipc_checkid(struct kern_ipc_perm *ipcp, int uid)
 {
-	if (uid / SEQ_MULTIPLIER != ipcp->seq)
+	if ((uid >> SEQ_SHIFT) != ipcp->seq)
 		return 1;
 	return 0;
 }
