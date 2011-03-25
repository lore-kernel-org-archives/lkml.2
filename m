Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932973Ab1CZACg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 20:02:36 -0400
Received: from kroah.org ([198.145.64.141]:48887 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932603Ab1CYX6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 19:58:14 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar 25 16:56:37 2011
Message-Id: <20110325235637.198037011@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 25 Mar 2011 16:55:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Julien Tinnes <jln@google.com>, Oleg Nesterov <oleg@redhat.com>
Subject: [07/23] Prevent rt_sigqueueinfo and rt_tgsigqueueinfo from spoofing the signal code
References: <20110325235537.660072281@clark.kroah.org>
Content-Disposition: inline; filename=prevent-rt_sigqueueinfo-and-rt_tgsigqueueinfo-from-spoofing-the-signal-code.patch
In-Reply-To: <20110325235654.GA24416@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

---
 kernel/signal.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2351,9 +2351,13 @@ SYSCALL_DEFINE3(rt_sigqueueinfo, pid_t,
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
@@ -2367,9 +2371,13 @@ long do_rt_tgsigqueueinfo(pid_t tgid, pi
 		return -EINVAL;
 
 	/* Not even root can pretend to send signals from the kernel.
-	   Nor can they impersonate a kill(), which adds source info.  */
-	if (info->si_code >= 0)
+	 * Nor can they impersonate a kill()/tgkill(), which adds source info.
+	 */
+	if (info->si_code != SI_QUEUE) {
+		/* We used to allow any < 0 si_code */
+		WARN_ON_ONCE(info->si_code < 0);
 		return -EPERM;
+	}
 	info->si_signo = sig;
 
 	return do_send_specific(tgid, pid, sig, info);


