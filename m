Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052Ab1KRXNO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 18:13:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52966 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757589Ab1KRXNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 18:13:13 -0500
Date: Fri, 18 Nov 2011 15:12:48 -0800
From: tip-bot for Gleb Natapov <gleb@redhat.com>
Message-ID: <tip-c8452afb7426f7e21388492f40227582e3e83879@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, gleb@redhat.com, rostedt@goodmis.org,
        tglx@linutronix.de, jbaron@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, gleb@redhat.com, rostedt@goodmis.org,
        tglx@linutronix.de, jbaron@redhat.com
In-Reply-To: <20111018175551.GH17571@redhat.com>
References: <20111018175551.GH17571@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] jump_label: jump_label_inc may return before the code is patched
Git-Commit-ID: c8452afb7426f7e21388492f40227582e3e83879
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 Nov 2011 15:12:54 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c8452afb7426f7e21388492f40227582e3e83879
Gitweb:     http://git.kernel.org/tip/c8452afb7426f7e21388492f40227582e3e83879
Author:     Gleb Natapov <gleb@redhat.com>
AuthorDate: Tue, 18 Oct 2011 19:55:51 +0200
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 7 Nov 2011 11:02:34 -0500

jump_label: jump_label_inc may return before the code is patched

If cpu A calls jump_label_inc() just after atomic_add_return() is
called by cpu B, atomic_inc_not_zero() will return value greater then
zero and jump_label_inc() will return to a caller before jump_label_update()
finishes its job on cpu B.

Link: http://lkml.kernel.org/r/20111018175551.GH17571@redhat.com

Cc: stable@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Jason Baron <jbaron@redhat.com>
Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/jump_label.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index a8ce450..e6f1f24 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -66,8 +66,9 @@ void jump_label_inc(struct jump_label_key *key)
 		return;
 
 	jump_label_lock();
-	if (atomic_add_return(1, &key->enabled) == 1)
+	if (atomic_read(&key->enabled) == 0)
 		jump_label_update(key, JUMP_LABEL_ENABLE);
+	atomic_inc(&key->enabled);
 	jump_label_unlock();
 }
 
