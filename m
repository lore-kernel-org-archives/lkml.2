Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759334Ab0GAVRH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:17:07 -0400
Received: from kroah.org ([198.145.64.141]:32915 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759134Ab0GAVO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:14:27 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:42:56 2010
Message-Id: <20100701174256.720703211@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:43:32 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
       David Howells <dhowells@redhat.com>, Eric Paris <eparis@parisplace.org>,
       Jakub Jelinek <jakub@redhat.com>, James Morris <jmorris@namei.org>,
       Stephen Smalley <sds@tycho.nsa.gov>
Subject: [122/200] signals: check_kill_permission(): dont check creds if same_thread_group()
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit 065add3941bdca54fe04ed3471a96bce9af88793 upstream.

Andrew Tridgell reports that aio_read(SIGEV_SIGNAL) can fail if the
notification from the helper thread races with setresuid(), see
http://samba.org/~tridge/junkcode/aio_uid.c

This happens because check_kill_permission() doesn't permit sending a
signal to the task with the different cred->xids.  But there is not any
security reason to check ->cred's when the task sends a signal (private or
group-wide) to its sub-thread.  Whatever we do, any thread can bypass all
security checks and send SIGKILL to all threads, or it can block a signal
SIG and do kill(gettid(), SIG) to deliver this signal to another
sub-thread.  Not to mention that CLONE_THREAD implies CLONE_VM.

Change check_kill_permission() to avoid the credentials check when the
sender and the target are from the same thread group.

Also, move "cred = current_cred()" down to avoid calling get_current()
twice.

Note: David Howells pointed out we could relax this even more, the
CLONE_SIGHAND (without CLONE_THREAD) case probably does not need
these checks too.

Roland said:
: The glibc (libpthread) that does set*id across threads has
: been in use for a while (2.3.4?), probably in distro's using kernels as old
: or older than any active -stable streams.  In the race in question, this
: kernel bug is breaking valid POSIX application expectations.

Reported-by: Andrew Tridgell <tridge@samba.org>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Roland McGrath <roland@redhat.com>
Acked-by: David Howells <dhowells@redhat.com>
Cc: Eric Paris <eparis@parisplace.org>
Cc: Jakub Jelinek <jakub@redhat.com>
Cc: James Morris <jmorris@namei.org>
Cc: Roland McGrath <roland@redhat.com>
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/signal.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/kernel/signal.c
+++ b/kernel/signal.c
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


