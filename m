Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933070Ab1LFJin (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 04:38:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34708 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932974Ab1LFJil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 04:38:41 -0500
Date: Tue, 6 Dec 2011 01:38:09 -0800
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-xopopjjens57r0i13qnyh2yo@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu,
        ben@decadent.org.uk
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, ben@decadent.org.uk,
        mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] lockdep, bug: Exclude TAINT_FIRMWARE_WORKAROUND from disabling lockdep
Git-Commit-ID: df754e6af2f237a6c020c0daff55a1a609338e31
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 06 Dec 2011 01:38:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  df754e6af2f237a6c020c0daff55a1a609338e31
Gitweb:     http://git.kernel.org/tip/df754e6af2f237a6c020c0daff55a1a609338e31
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 14 Nov 2011 13:13:49 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 6 Dec 2011 08:16:47 +0100

lockdep, bug: Exclude TAINT_FIRMWARE_WORKAROUND from disabling lockdep

It's unlikely that TAINT_FIRMWARE_WORKAROUND causes false
lockdep messages, so do not disable lockdep in that case.
We still want to keep lockdep disabled in the
TAINT_OOT_MODULE case:

  - bin-only modules can cause various instabilities in
    their and in unrelated kernel code

  - they are impossible to debug for kernel developers

  - they also typically do not have the copyright license
    permission to link to the GPL-ed lockdep code.

Suggested-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-xopopjjens57r0i13qnyh2yo@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/panic.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/kernel/panic.c b/kernel/panic.c
index b2659360..1b83fd8 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -240,8 +240,16 @@ void add_taint(unsigned flag)
 	 * Also we want to keep up lockdep for staging development and
 	 * post-warning case.
 	 */
-	if (flag != TAINT_CRAP && flag != TAINT_WARN && __debug_locks_off())
-		printk(KERN_WARNING "Disabling lock debugging due to kernel taint\n");
+	switch (flag) {
+	case TAINT_CRAP:
+	case TAINT_WARN:
+	case TAINT_FIRMWARE_WORKAROUND:
+		break;
+
+	default:
+		if (__debug_locks_off())
+			printk(KERN_WARNING "Disabling lock debugging due to kernel taint\n");
+	}
 
 	set_bit(flag, &tainted_mask);
 }
