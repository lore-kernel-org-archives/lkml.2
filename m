Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933029Ab1C3VFi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:05:38 -0400
Received: from mga02.intel.com ([134.134.136.20]:15019 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933008Ab1C3VFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:05:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="621235645"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: acme@redhat.com, fweisbec@gmail.com, efault@gmx.de, peterz@infradead.org,
        eranian@google.com, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [1/275] perf session: Invalidate last_match when removing threads from rb_tree
Message-Id: <20110330210354.B7B073E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:03:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ upstream commit 70597f21f128b7dd6a2490078bea99d704b6f8c3 ]

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 tools/perf/util/session.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.35.y/tools/perf/util/session.c
===================================================================
--- linux-2.6.35.y.orig/tools/perf/util/session.c	2011-03-29 22:52:06.578019604 -0700
+++ linux-2.6.35.y/tools/perf/util/session.c	2011-03-29 23:02:58.140347711 -0700
@@ -134,6 +134,7 @@
 
 void perf_session__remove_thread(struct perf_session *self, struct thread *th)
 {
+	self->last_match = NULL;
 	rb_erase(&th->rb_node, &self->threads);
 	/*
 	 * We may have references to this thread, for instance in some hist_entry
