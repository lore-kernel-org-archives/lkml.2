Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368Ab0HCCJs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 22:09:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:54456 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088Ab0HCCJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 22:09:47 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/3] perf session: Invalidate last_match when removing threads from rb_tree
Date: Mon,  2 Aug 2010 23:09:11 -0300
Message-Id: <1280801352-4630-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1280801352-4630-1-git-send-email-acme@infradead.org>
References: <1280801352-4630-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

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
-- 
1.6.2.5

