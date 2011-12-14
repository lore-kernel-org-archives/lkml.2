Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756768Ab1LNKWQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 05:22:16 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56584 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793Ab1LNKWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 05:22:14 -0500
Date: Wed, 14 Dec 2011 02:21:36 -0800
From: tip-bot for Will Deacon <will.deacon@arm.com>
Message-ID: <tip-44b7f4b98d8877e2a4427f2a2f2e42ae8227a58f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, will.deacon@arm.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        will.deacon@arm.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20111213152651.GP20297@mudshark.cambridge.arm.com>
References: <20111213152651.GP20297@mudshark.cambridge.arm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf events: Fix ring_buffer_wakeup()
  brown paperbag bug
Git-Commit-ID: 44b7f4b98d8877e2a4427f2a2f2e42ae8227a58f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 14 Dec 2011 02:21:44 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  44b7f4b98d8877e2a4427f2a2f2e42ae8227a58f
Gitweb:     http://git.kernel.org/tip/44b7f4b98d8877e2a4427f2a2f2e42ae8227a58f
Author:     Will Deacon <will.deacon@arm.com>
AuthorDate: Tue, 13 Dec 2011 20:40:45 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 14 Dec 2011 08:44:53 +0100

perf events: Fix ring_buffer_wakeup() brown paperbag bug

Commit 10c6db11 ("perf: Fix loss of notification with multi-event")
seems to unconditionally dereference event->rb in the wakeup handler,
this is wrong, there might not be a buffer attached.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20111213152651.GP20297@mudshark.cambridge.arm.com
[ minor edits ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/events/core.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index d3b9df5..58690af 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3558,9 +3558,13 @@ static void ring_buffer_wakeup(struct perf_event *event)
 
 	rcu_read_lock();
 	rb = rcu_dereference(event->rb);
-	list_for_each_entry_rcu(event, &rb->event_list, rb_entry) {
+	if (!rb)
+		goto unlock;
+
+	list_for_each_entry_rcu(event, &rb->event_list, rb_entry)
 		wake_up_all(&event->waitq);
-	}
+
+unlock:
 	rcu_read_unlock();
 }
 
