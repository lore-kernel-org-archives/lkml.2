Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317Ab1DLO4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:56:19 -0400
Received: from kroah.org ([198.145.64.141]:57453 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757148Ab1DLOhq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:37:46 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 12 07:35:50 2011
Message-Id: <20110412143550.400293821@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 12 Apr 2011 07:34:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Julien Tinnes <jln@google.com>, Roland Dreier <roland@purestorage.com>
Subject: [023/105] Relax si_code check in rt_sigqueueinfo and rt_tgsigqueueinfo
In-Reply-To: <20110412143613.GA19478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

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

---
 kernel/signal.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2423,7 +2423,7 @@ SYSCALL_DEFINE3(rt_sigqueueinfo, pid_t,
 	/* Not even root can pretend to send signals from the kernel.
 	 * Nor can they impersonate a kill()/tgkill(), which adds source info.
 	 */
-	if (info.si_code != SI_QUEUE) {
+	if (info.si_code >= 0 || info.si_code == SI_TKILL) {
 		/* We used to allow any < 0 si_code */
 		WARN_ON_ONCE(info.si_code < 0);
 		return -EPERM;
@@ -2443,7 +2443,7 @@ long do_rt_tgsigqueueinfo(pid_t tgid, pi
 	/* Not even root can pretend to send signals from the kernel.
 	 * Nor can they impersonate a kill()/tgkill(), which adds source info.
 	 */
-	if (info->si_code != SI_QUEUE) {
+	if (info->si_code >= 0 || info->si_code == SI_TKILL) {
 		/* We used to allow any < 0 si_code */
 		WARN_ON_ONCE(info->si_code < 0);
 		return -EPERM;


