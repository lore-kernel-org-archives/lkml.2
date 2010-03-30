Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757610Ab0CaAZY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:25:24 -0400
Received: from kroah.org ([198.145.64.141]:48990 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756457Ab0C3XMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:12:34 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:58:37 2010
Message-Id: <20100330225836.830303692@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:57:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Al Viro <viro@ZenIV.linux.org.uk>, Tavis Ormandy <taviso@google.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [46/89] fnctl: f_modown should call write_lock_irqsave/restore
In-Reply-To: <20100330230520.GA28779@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Greg Kroah-Hartman <gregkh@suse.de>

commit b04da8bfdfbbd79544cab2fadfdc12e87eb01600 upstream.

Commit 703625118069f9f8960d356676662d3db5a9d116 exposed that f_modown()
should call write_lock_irqsave instead of just write_lock_irq so that
because a caller could have a spinlock held and it would not be good to
renable interrupts.

Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Tavis Ormandy <taviso@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

---
 fs/fcntl.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -199,7 +199,9 @@ static int setfl(int fd, struct file * f
 static void f_modown(struct file *filp, struct pid *pid, enum pid_type type,
                      int force)
 {
-	write_lock_irq(&filp->f_owner.lock);
+	unsigned long flags;
+
+	write_lock_irqsave(&filp->f_owner.lock, flags);
 	if (force || !filp->f_owner.pid) {
 		put_pid(filp->f_owner.pid);
 		filp->f_owner.pid = get_pid(pid);
@@ -211,7 +213,7 @@ static void f_modown(struct file *filp,
 			filp->f_owner.euid = cred->euid;
 		}
 	}
-	write_unlock_irq(&filp->f_owner.lock);
+	write_unlock_irqrestore(&filp->f_owner.lock, flags);
 }
 
 int __f_setown(struct file *filp, struct pid *pid, enum pid_type type,


