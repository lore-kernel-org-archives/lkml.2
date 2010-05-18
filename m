Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544Ab0ERNmI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 09:42:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20213 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757526Ab0ERNmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 09:42:05 -0400
Date: Tue, 18 May 2010 15:39:25 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andrew Tridgell <tridge@samba.org>, Eric Paris <eparis@parisplace.org>,
       Jakub Jelinek <jakub@redhat.com>, James Morris <jmorris@namei.org>,
       Roland McGrath <roland@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] signals: check_kill_permission: don't check creds if
	same_thread_group()
Message-ID: <20100518133925.GA1353@redhat.com>
References: <20100517195414.GA21504@redhat.com> <2996.1274172907@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2996.1274172907@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18, David Howells wrote:
>
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > Also, move "cred = current_cred()" down to avoid calling get_current()
> > twice.
>
> I don't see what you mean by this.  same_thread_group() doesn't call
> current_cred(), so why this change?

Yes, but both current_cred() and same_thread_group(current, t) call
get_current(), and gcc doesn't cache the result because we call
audit_signal_info() in between.

In fact, initially I was going to send the patch below, but then
decided to make a more simple change.

Oleg.

--- x/kernel/signal.c
+++ x/kernel/signal.c
@@ -642,8 +642,6 @@ static inline bool si_fromuser(const str
 static int check_kill_permission(int sig, struct siginfo *info,
 				 struct task_struct *t)
 {
-	const struct cred *cred = current_cred(), *tcred;
-	struct pid *sid;
 	int error;
 
 	if (!valid_signal(sig))
@@ -656,23 +654,29 @@ static int check_kill_permission(int sig
 	if (error)
 		return error;
 
-	tcred = __task_cred(t);
-	if ((cred->euid ^ tcred->suid) &&
-	    (cred->euid ^ tcred->uid) &&
-	    (cred->uid  ^ tcred->suid) &&
-	    (cred->uid  ^ tcred->uid) &&
-	    !capable(CAP_KILL)) {
-		switch (sig) {
-		case SIGCONT:
-			sid = task_session(t);
-			/*
-			 * We don't return the error if sid == NULL. The
-			 * task was unhashed, the caller must notice this.
-			 */
-			if (!sid || sid == task_session(current))
-				break;
-		default:
-			return -EPERM;
+	if (!same_thread_group(current, t)) {
+		const struct cred *cred = current_cred();
+		const struct cred *tcred = __task_cred(t);
+		struct pid *sid;
+
+		if ((cred->euid ^ tcred->suid) &&
+		    (cred->euid ^ tcred->uid) &&
+		    (cred->uid  ^ tcred->suid) &&
+		    (cred->uid  ^ tcred->uid) &&
+		    !capable(CAP_KILL)) {
+			switch (sig) {
+			case SIGCONT:
+				sid = task_session(t);
+				/*
+				 * We don't return the error if sid == NULL.
+				 * The task was unhashed, the caller must
+				 * notice this.
+				 */
+				if (!sid || sid == task_session(current))
+					break;
+			default:
+				return -EPERM;
+			}
 		}
 	}
 

