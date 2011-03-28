Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab1C1SYN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 14:24:13 -0400
Received: from na3sys010aog101.obsmtp.com ([74.125.245.70]:33291 "HELO
	na3sys010aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751237Ab1C1SYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 14:24:12 -0400
From: Roland Dreier <roland@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Julien Tinnes <jln@google.com>, Klaus Dittrich <kladit@arcor.de>
Subject: [PATCH] Allow rt_sigqueueinfo and rt_tgsigqueueinfo to use si_code == SI_ASYNCIO
Date: Mon, 28 Mar 2011 11:24:00 -0700
Message-Id: <1301336640-16348-1-git-send-email-roland@kernel.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland Dreier <roland@purestorage.com>

Commit da48524eb206 ("Prevent rt_sigqueueinfo and rt_tgsigqueueinfo
from spoofing the signal code") made the check on si_code too strict:
glibc's aio implementation wants to queue signals with SI_ASYNCIO, and
indeed glibc's tst-aio4 fails with the patched kernel.

Fix this by loosening the new check to allow SI_ASYNCIO as well.

Reported-by: Klaus Dittrich <kladit@arcor.de>
Signed-off-by: Roland Dreier <roland@purestorage.com>
---
 kernel/signal.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 324eff5..b2bfa3a 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2437,7 +2437,7 @@ SYSCALL_DEFINE3(rt_sigqueueinfo, pid_t, pid, int, sig,
 	/* Not even root can pretend to send signals from the kernel.
 	 * Nor can they impersonate a kill()/tgkill(), which adds source info.
 	 */
-	if (info.si_code != SI_QUEUE) {
+	if (info.si_code != SI_QUEUE && info.si_code != SI_ASYNCIO) {
 		/* We used to allow any < 0 si_code */
 		WARN_ON_ONCE(info.si_code < 0);
 		return -EPERM;
@@ -2457,7 +2457,7 @@ long do_rt_tgsigqueueinfo(pid_t tgid, pid_t pid, int sig, siginfo_t *info)
 	/* Not even root can pretend to send signals from the kernel.
 	 * Nor can they impersonate a kill()/tgkill(), which adds source info.
 	 */
-	if (info->si_code != SI_QUEUE) {
+	if (info->si_code != SI_QUEUE && info->si_code != SI_ASYNCIO) {
 		/* We used to allow any < 0 si_code */
 		WARN_ON_ONCE(info->si_code < 0);
 		return -EPERM;
