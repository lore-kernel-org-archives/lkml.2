Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757618Ab1F2XfL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 19:35:11 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45463 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417Ab1F2XeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 19:34:23 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>, David Ahern <dsahern@gmail.com>,
        Sam Liao <phyomh@gmail.com>
Subject: [PATCH 4/6] perf tools: Don't display ignored entries on stdio ui
Date: Thu, 30 Jun 2011 01:34:06 +0200
Message-Id: <1309390448-9160-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1309390448-9160-1-git-send-email-fweisbec@gmail.com>
References: <1309390448-9160-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As for newt ui, don't display entries that have been marked
as ignored.

The practical current effect of this is to make parent
filtering really working. Before, entries that were ignored
were given a null parent but were still displayed. This
resulted in some weird effects:

 # Overhead      Command      Shared Object        Symbol
 # ........  ...........  .................  ............
 #
^A
                   |
                   --- __lock_acquire
                      |
                      |--95.97%-- lock_acquire
                      |          |
                      |          |--30.75%-- _raw_spin_lock

Discard these from the stdio display.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Sam Liao <phyomh@gmail.com>
---
 tools/perf/util/hist.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index dae4202..677e1da 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -847,6 +847,9 @@ print_entries:
 	for (nd = rb_first(&self->entries); nd; nd = rb_next(nd)) {
 		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
 
+		if (h->filtered)
+			continue;
+
 		if (show_displacement) {
 			if (h->pair != NULL)
 				displacement = ((long)h->pair->position -
-- 
1.7.5.4

