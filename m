Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115Ab0EQT5M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 15:57:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36606 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560Ab0EQT5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 15:57:11 -0400
Date: Mon, 17 May 2010 21:54:14 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrew Tridgell <tridge@samba.org>, David Howells <dhowells@redhat.com>,
       Eric Paris <eparis@parisplace.org>, Jakub Jelinek <jakub@redhat.com>,
       James Morris <jmorris@namei.org>, Roland McGrath <roland@redhat.com>,
       Stephen Smalley <sds@tycho.nsa.gov>, linux-kernel@vger.kernel.org
Subject: [PATCH] signals: check_kill_permission: don't check creds if
	same_thread_group()
Message-ID: <20100517195414.GA21504@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Tridgell reports that aio_read(SIGEV_SIGNAL) can fail if the
the notification from the helper thread races with setresuid(), see
http://samba.org/~tridge/junkcode/aio_uid.c

This happens because check_kill_permission() doesn't allow to send
a signal to the task with the different cred->xids. But there is no
any security reason to check ->cred's when the task sends a signal
(private or group-wide) to its sub-thread. Whatever we do, any thread
can bypass all security checks and send SIGKILL to all threads, or
it can block a signal SIG and do kill(gettid(), SIG) to deliver this
signal to another sub-thread. Not to mention that CLONE_THREAD implies
CLONE_VM.

Change check_kill_permission() to avoid the credentials check when
the sender and the target are from the same thread group.

Also, move "cred = current_cred()" down to avoid calling get_current()
twice.

Note: David Howells pointed out we could relax this even more, the
CLONE_SIGHAND (without CLONE_THREAD) case probably does not need
these checks too.

Reported-by: Andrew Tridgell <tridge@samba.org>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/signal.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- 34-rc1/kernel/signal.c~CKP_CK_STG	2010-05-09 21:09:31.000000000 +0200
+++ 34-rc1/kernel/signal.c	2010-05-17 17:02:09.000000000 +0200
@@ -642,7 +642,7 @@ static inline bool si_fromuser(const str
 static int check_kill_permission(int sig, struct siginfo *info,
 				 struct task_struct *t)
 {
-	const struct cred *cred = current_cred(), *tcred;
+	const struct cred *cred, *tcred;
 	struct pid *sid;
 	int error;
 
@@ -656,8 +656,10 @@ static int check_kill_permission(int sig
 	if (error)
 		return error;
 
+	cred = current_cred();
 	tcred = __task_cred(t);
-	if ((cred->euid ^ tcred->suid) &&
+	if (!same_thread_group(current, t) &&
+	    (cred->euid ^ tcred->suid) &&
 	    (cred->euid ^ tcred->uid) &&
 	    (cred->uid  ^ tcred->suid) &&
 	    (cred->uid  ^ tcred->uid) &&

