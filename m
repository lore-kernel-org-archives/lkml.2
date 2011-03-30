Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965210Ab1C3VWM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:22:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:9067 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964903Ab1C3VJd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:09:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="727133915"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: jln@google.com, oleg@redhat.com, torvalds@linux-foundation.org,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [226/275] Prevent rt_sigqueueinfo and rt_tgsigqueueinfo from spoofing the signal code
Message-Id: <20110330210751.A9ADB3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:07:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 kernel/signal.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

Index: linux-2.6.35.y/kernel/signal.c
===================================================================
--- linux-2.6.35.y.orig/kernel/signal.c	2011-03-29 22:50:25.616602954 -0700
+++ linux-2.6.35.y/kernel/signal.c	2011-03-29 23:03:02.941224912 -0700
@@ -2410,9 +2410,13 @@
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
@@ -2426,9 +2430,13 @@
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
