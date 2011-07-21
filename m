Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701Ab1GUTc5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 15:32:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:50396 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752977Ab1GUTcz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 15:32:55 -0400
Date: Thu, 21 Jul 2011 19:32:36 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-2dp5vmpsxeraqm42kgww6ge2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] lockdep: Fix lockdep_no_validate against IRQ states
Git-Commit-ID: efbe2eee6dc0f179be84292bf269528b3ec365e9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 21 Jul 2011 19:32:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  efbe2eee6dc0f179be84292bf269528b3ec365e9
Gitweb:     http://git.kernel.org/tip/efbe2eee6dc0f179be84292bf269528b3ec365e9
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 7 Jul 2011 11:39:45 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 21 Jul 2011 20:43:16 +0200

lockdep: Fix lockdep_no_validate against IRQ states

Thomas noticed that a lock marked with lockdep_set_novalidate_class()
will still trigger warnings for IRQ inversions. Cure this by skipping
those when marking irq state.

Reported-and-tested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-2dp5vmpsxeraqm42kgww6ge2@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/lockdep.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 298c927..628276d 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -2468,6 +2468,9 @@ mark_held_locks(struct task_struct *curr, enum mark_type mark)
 
 		BUG_ON(usage_bit >= LOCK_USAGE_STATES);
 
+		if (hlock_class(hlock)->key == &__lockdep_no_validate__)
+			continue;
+
 		if (!mark_lock(curr, hlock, usage_bit))
 			return 0;
 	}
