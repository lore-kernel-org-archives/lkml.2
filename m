Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757667Ab0CaA3b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:29:31 -0400
Received: from kroah.org ([198.145.64.141]:48884 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756414Ab0C3XMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:12:17 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:58:26 2010
Message-Id: <20100330225825.805481953@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:57:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Al Viro <viro@ZenIV.linux.org.uk>, Tavis Ormandy <taviso@google.com>,
       Jeff Dike <jdike@addtoit.com>, Julien Tinnes <jln@google.com>,
       Matt Mackall <mpm@selenic.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [28/89] tty: fix race in tty_fasync
In-Reply-To: <20100330230520.GA28779@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Greg Kroah-Hartman <gregkh@suse.de>

commit 703625118069f9f8960d356676662d3db5a9d116 upstream.

We need to keep the lock held over the call to __f_setown() to
prevent a PID race.

Thanks to Al Viro for pointing out the problem, and to Travis for
making us look here in the first place.

Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tavis Ormandy <taviso@google.com>
Cc: Jeff Dike <jdike@addtoit.com>
Cc: Julien Tinnes <jln@google.com>
Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/tty_io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -1912,8 +1912,8 @@ static int tty_fasync(int fd, struct fil
 			pid = task_pid(current);
 			type = PIDTYPE_PID;
 		}
-		spin_unlock_irqrestore(&tty->ctrl_lock, flags);
 		retval = __f_setown(filp, pid, type, 0);
+		spin_unlock_irqrestore(&tty->ctrl_lock, flags);
 		if (retval)
 			goto out;
 	} else {


