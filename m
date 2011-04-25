Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932746Ab1DYUnv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:43:51 -0400
Received: from 1wt.eu ([62.212.114.60]:34332 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932278Ab1DYUYu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:24:50 -0400
Message-Id: <20110425200237.513372128@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:04:16 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Julien Tinnes <jln@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 104/173] Prevent rt_sigqueueinfo and rt_tgsigqueueinfo from spoofing the signal code
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Julien Tinnes <jln@google.com>

commit da48524eb20662618854bb3df2db01fc65f3070c upstream.

Userland should be able to trust the pid and uid of the sender of a
signal if the si_code is SI_TKILL.

Unfortunately, the kernel has historically allowed sigqueueinfo() to
send any si_code at all (as long as it was negative - to distinguish it
from kernel-generated signals like SIGILL etc), so it could spoof a
SI_TKILL with incorrect siginfo values.

Happily, it looks like glibc has always set si_code to the appropriate
SI_QUEUE, so there are probably no actual user code that ever uses
anything but the appropriate SI_QUEUE flag.

So just tighten the check for si_code (we used to allow any negative
value), and add a (one-time) warning in case there are binaries out
there that might depend on using other si_code values.

Signed-off-by: Julien Tinnes <jln@google.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
[wt: 2.6.27 does not have do_rt_tgsigqueueinfo()]

---
 kernel/signal.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

Index: longterm-2.6.27/kernel/signal.c
===================================================================
--- longterm-2.6.27.orig/kernel/signal.c	2011-01-23 10:52:37.000000000 +0100
+++ longterm-2.6.27/kernel/signal.c	2011-04-25 16:06:27.491278774 +0200
@@ -2294,9 +2294,13 @@
 		return -EFAULT;
 
 	/* Not even root can pretend to send signals from the kernel.
-	   Nor can they impersonate a kill(), which adds source info.  */
-	if (info.si_code >= 0)
+	 * Nor can they impersonate a kill()/tgkill(), which adds source info.
+	 */
+	if (info.si_code != SI_QUEUE) {
+		/* We used to allow any < 0 si_code */
+		WARN_ON_ONCE(info.si_code < 0);
 		return -EPERM;
+	}
 	info.si_signo = sig;
 
 	/* POSIX.1b doesn't mention process groups.  */


