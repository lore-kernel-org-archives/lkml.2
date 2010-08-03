Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257Ab0HCFz3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 01:55:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:45658 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755093Ab0HCFz0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 01:55:26 -0400
Date: Tue, 3 Aug 2010 05:54:59 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, acme@redhat.com,
        hpa@zytor.com, mingo@redhat.com, peterz@infradead.org, efault@gmx.de,
        fweisbec@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, eranian@google.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, efault@gmx.de,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf session: Invalidate last_match when removing threads from rb_tree
Message-ID: <tip-70597f21f128b7dd6a2490078bea99d704b6f8c3@git.kernel.org>
Git-Commit-ID: 70597f21f128b7dd6a2490078bea99d704b6f8c3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 03 Aug 2010 05:54:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  70597f21f128b7dd6a2490078bea99d704b6f8c3
Gitweb:     http://git.kernel.org/tip/70597f21f128b7dd6a2490078bea99d704b6f8c3
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 2 Aug 2010 18:59:28 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 2 Aug 2010 19:01:09 -0300

perf session: Invalidate last_match when removing threads from rb_tree

If we receive two PERF_RECORD_EXIT for the same thread, we can end up
reusing session->last_match and trying to remove the thread twice from
the rb_tree, causing a segfault, so invalidade last_match in
perf_session__remove_thread.

Receiving two PERF_RECORD_EXIT for the same thread is a bug, but its a
harmless one if we make the tool more robust, like this patch does.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 5d2fd52..fa9d652 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -166,6 +166,7 @@ void perf_session__delete(struct perf_session *self)
 
 void perf_session__remove_thread(struct perf_session *self, struct thread *th)
 {
+	self->last_match = NULL;
 	rb_erase(&th->rb_node, &self->threads);
 	/*
 	 * We may have references to this thread, for instance in some hist_entry
