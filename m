Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851Ab1FGMDS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 08:03:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:52942 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751147Ab1FGMDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 08:03:17 -0400
Date: Tue, 7 Jun 2011 12:02:29 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-f2513cde93f0957d5dc6c09bc24b0cccd27d8e1d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        lists@die-jansens.de, stable@kernel.org, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: lists@die-jansens.de, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, stable@kernel.org, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1307398759.2497.966.camel@laptop>
References: <1307398759.2497.966.camel@laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] lockdep: Fix lock_is_held() on recursion
Git-Commit-ID: f2513cde93f0957d5dc6c09bc24b0cccd27d8e1d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 07 Jun 2011 12:02:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f2513cde93f0957d5dc6c09bc24b0cccd27d8e1d
Gitweb:     http://git.kernel.org/tip/f2513cde93f0957d5dc6c09bc24b0cccd27d8e1d
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 6 Jun 2011 12:32:43 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 7 Jun 2011 12:25:50 +0200

lockdep: Fix lock_is_held() on recursion

The main lock_is_held() user is lockdep_assert_held(), avoid false
assertions in lockdep_off() sections by unconditionally reporting the
lock is taken.

[ the reason this is important is a lockdep_assert_held() in ttwu()
  which triggers a warning under lockdep_off() as in printk() which
  can trigger another wakeup and lock up due to spinlock
  recursion, as reported and heroically debugged by Arne Jansen ]

Reported-and-tested-by: Arne Jansen <lists@die-jansens.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: <stable@kernel.org>
Link: http://lkml.kernel.org/r/1307398759.2497.966.camel@laptop
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/lockdep.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 63437d0..298c927 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -3426,7 +3426,7 @@ int lock_is_held(struct lockdep_map *lock)
 	int ret = 0;
 
 	if (unlikely(current->lockdep_recursion))
-		return ret;
+		return 1; /* avoid false negative lockdep_assert_held() */
 
 	raw_local_irq_save(flags);
 	check_flags(flags);
