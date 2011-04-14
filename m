Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933726Ab1DNSBE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:01:04 -0400
Received: from mail.windriver.com ([147.11.1.11]:42522 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933634Ab1DNR7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:59:47 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Roland Dreier <roland@purestorage.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 208/209] Relax si_code check in rt_sigqueueinfo and rt_tgsigqueueinfo
Date: Thu, 14 Apr 2011 13:56:06 -0400
Message-Id: <1302803767-9715-95-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
 <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland Dreier <roland@purestorage.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/signal.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 704c030..137a333 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2411,7 +2411,7 @@ SYSCALL_DEFINE3(rt_sigqueueinfo, pid_t, pid, int, sig,
 	/* Not even root can pretend to send signals from the kernel.
 	 * Nor can they impersonate a kill()/tgkill(), which adds source info.
 	 */
-	if (info.si_code != SI_QUEUE) {
+	if (info.si_code >= 0 || info.si_code == SI_TKILL) {
 		/* We used to allow any < 0 si_code */
 		WARN_ON_ONCE(info.si_code < 0);
 		return -EPERM;
@@ -2431,7 +2431,7 @@ long do_rt_tgsigqueueinfo(pid_t tgid, pid_t pid, int sig, siginfo_t *info)
 	/* Not even root can pretend to send signals from the kernel.
 	 * Nor can they impersonate a kill()/tgkill(), which adds source info.
 	 */
-	if (info->si_code != SI_QUEUE) {
+	if (info->si_code >= 0 || info->si_code == SI_TKILL) {
 		/* We used to allow any < 0 si_code */
 		WARN_ON_ONCE(info->si_code < 0);
 		return -EPERM;
-- 
1.7.4.4

