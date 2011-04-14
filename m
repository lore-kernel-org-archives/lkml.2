Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933011Ab1DNRqU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:46:20 -0400
Received: from mail.windriver.com ([147.11.1.11]:37949 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932959Ab1DNRqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:46:16 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Dan Rosenberg <drosenberg@vsecurity.com>,
        Dan Rosenberg <dan.j.rosenberg@gmail.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 045/209] sys_semctl: fix kernel stack leakage
Date: Thu, 14 Apr 2011 13:41:15 -0400
Message-Id: <1302803039-9400-46-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Rosenberg <drosenberg@vsecurity.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 ipc/sem.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/ipc/sem.c b/ipc/sem.c
index dbef95b..b4c1641 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -608,6 +608,8 @@ static unsigned long copy_semid_to_user(void __user *buf, struct semid64_ds *in,
 	    {
 		struct semid_ds out;
 
+		memset(&out, 0, sizeof(out));
+
 		ipc64_perm_to_ipc_perm(&in->sem_perm, &out.sem_perm);
 
 		out.sem_otime	= in->sem_otime;
-- 
1.7.4.4

