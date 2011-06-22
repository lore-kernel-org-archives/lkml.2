Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758057Ab1FVOWo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 10:22:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:58889 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755582Ab1FVOWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 10:22:43 -0400
Date: Wed, 22 Jun 2011 14:22:19 GMT
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
Message-ID: <tip-4f2a8d3cf5e0486fd547633fa86c5d130ae98cad@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        peterz@infradead.org, akpm@linux-foundation.org, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, peterz@infradead.org,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1308734409.1022.14.camel@twins>
References: <1308734409.1022.14.camel@twins>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/printk] printk: Fix console_sem vs logbuf_lock unlock race
Git-Commit-ID: 4f2a8d3cf5e0486fd547633fa86c5d130ae98cad
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 22 Jun 2011 14:22:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4f2a8d3cf5e0486fd547633fa86c5d130ae98cad
Gitweb:     http://git.kernel.org/tip/4f2a8d3cf5e0486fd547633fa86c5d130ae98cad
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 22 Jun 2011 11:20:09 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 22 Jun 2011 11:39:34 +0200

printk: Fix console_sem vs logbuf_lock unlock race

Fix up the fallout from commit 0b5e1c5255 ("printk: Release
console_sem after logbuf_lock").

The reason for unlocking the console_sem under the logbuf_lock
is that a concurrent printk() might fill up the buffer but fail
to acquire the console sem, resulting in a missed write to the
console until a subsequent console_sem acquire/release cycle.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: efault@gmx.de
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/1308734409.1022.14.camel@twins
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/printk.c |   20 ++++++++++++++++++--
 1 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 751e7b8..37dff34 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1244,7 +1244,7 @@ void console_unlock(void)
 {
 	unsigned long flags;
 	unsigned _con_start, _log_end;
-	unsigned wake_klogd = 0;
+	unsigned wake_klogd = 0, retry = 0;
 
 	if (console_suspended) {
 		up(&console_sem);
@@ -1253,6 +1253,7 @@ void console_unlock(void)
 
 	console_may_schedule = 0;
 
+again:
 	for ( ; ; ) {
 		spin_lock_irqsave(&logbuf_lock, flags);
 		wake_klogd |= log_start - log_end;
@@ -1273,8 +1274,23 @@ void console_unlock(void)
 	if (unlikely(exclusive_console))
 		exclusive_console = NULL;
 
-	spin_unlock_irqrestore(&logbuf_lock, flags);
+	spin_unlock(&logbuf_lock);
+
 	up(&console_sem);
+
+	/*
+	 * Someone could have filled up the buffer again, so re-check if there's
+	 * something to flush. In case we cannot trylock the console_sem again,
+	 * there's a new owner and the console_unlock() from them will do the
+	 * flush, no worries.
+	 */
+	spin_lock(&logbuf_lock);
+	if (con_start != log_end)
+		retry = 1;
+	spin_unlock_irqrestore(&logbuf_lock, flags);
+	if (retry && console_trylock())
+		goto again;
+
 	if (wake_klogd)
 		wake_up_klogd();
 }
