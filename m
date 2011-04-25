Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932480Ab1DYUjc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:39:32 -0400
Received: from 1wt.eu ([62.212.114.60]:34425 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932338Ab1DYUZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:25:00 -0400
Message-Id: <20110425200238.252706230@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:04:33 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Julien Tinnes <jln@google.com>, Roland Dreier <roland@purestorage.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 121/173] Relax si_code check in rt_sigqueueinfo and rt_tgsigqueueinfo
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Roland Dreier <roland@purestorage.com>

commit 243b422af9ea9af4ead07a8ad54c90d4f9b6081a upstream.

Commit da48524eb206 ("Prevent rt_sigqueueinfo and rt_tgsigqueueinfo
from spoofing the signal code") made the check on si_code too strict.
There are several legitimate places where glibc wants to queue a
negative si_code different from SI_QUEUE:

 - This was first noticed with glibc's aio implementation, which wants
   to queue a signal with si_code SI_ASYNCIO; the current kernel
   causes glibc's tst-aio4 test to fail because rt_sigqueueinfo()
   fails with EPERM.

 - Further examination of the glibc source shows that getaddrinfo_a()
   wants to use SI_ASYNCNL (which the kernel does not even define).
   The timer_create() fallback code wants to queue signals with SI_TIMER.

As suggested by Oleg Nesterov <oleg@redhat.com>, loosen the check to
forbid only the problematic SI_TKILL case.

Reported-by: Klaus Dittrich <kladit@arcor.de>
Acked-by: Julien Tinnes <jln@google.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
[wt: 2.6.27 has no rt_tgsigqueueinfo()]

---
 kernel/signal.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: longterm-2.6.27/kernel/signal.c
===================================================================
--- longterm-2.6.27.orig/kernel/signal.c	2011-04-25 16:06:27.000000000 +0200
+++ longterm-2.6.27/kernel/signal.c	2011-04-25 16:40:37.072279504 +0200
@@ -2296,7 +2296,7 @@
 	/* Not even root can pretend to send signals from the kernel.
 	 * Nor can they impersonate a kill()/tgkill(), which adds source info.
 	 */
-	if (info.si_code != SI_QUEUE) {
+	if (info.si_code >= 0 || info.si_code == SI_TKILL) {
 		/* We used to allow any < 0 si_code */
 		WARN_ON_ONCE(info.si_code < 0);
 		return -EPERM;


