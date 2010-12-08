Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036Ab0LHCP5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 21:15:57 -0500
Received: from kroah.org ([198.145.64.141]:46003 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755958Ab0LHAq5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:46:57 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:44:27 2010
Message-Id: <20101208004427.543828486@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:43:38 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Rosenberg <dan.j.rosenberg@gmail.com>,
        Manfred Spraul <manfred@colorfullife.com>
Subject: [032/127] sys_semctl: fix kernel stack leakage
In-Reply-To: <20101208004456.GA23578@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dan Rosenberg <drosenberg@vsecurity.com>

commit 982f7c2b2e6a28f8f266e075d92e19c0dd4c6e56 upstream.

The semctl syscall has several code paths that lead to the leakage of
uninitialized kernel stack memory (namely the IPC_INFO, SEM_INFO,
IPC_STAT, and SEM_STAT commands) during the use of the older, obsolete
version of the semid_ds struct.

The copy_semid_to_user() function declares a semid_ds struct on the stack
and copies it back to the user without initializing or zeroing the
"sem_base", "sem_pending", "sem_pending_last", and "undo" pointers,
allowing the leakage of 16 bytes of kernel stack memory.

The code is still reachable on 32-bit systems - when calling semctl()
newer glibc's automatically OR the IPC command with the IPC_64 flag, but
invoking the syscall directly allows users to use the older versions of
the struct.

Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 ipc/sem.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -560,6 +560,8 @@ static unsigned long copy_semid_to_user(
 	    {
 		struct semid_ds out;
 
+		memset(&out, 0, sizeof(out));
+
 		ipc64_perm_to_ipc_perm(&in->sem_perm, &out.sem_perm);
 
 		out.sem_otime	= in->sem_otime;


