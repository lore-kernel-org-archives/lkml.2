Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839Ab1CPTsf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 15:48:35 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56089 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708Ab1CPTsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 15:48:30 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Marcin Slusarz <marcin.slusarz@gmail.com>,
        Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/2] perf lock: Fix sorting by wait_min
Date: Wed, 16 Mar 2011 16:48:19 -0300
Message-Id: <1300304899-21920-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1300304899-21920-1-git-send-email-acme@infradead.org>
References: <1300304899-21920-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcin Slusarz <marcin.slusarz@gmail.com>

If lock was uncontended, wait_time_min == ULLONG_MAX, so we need to
handle this case differently to show high wait times first

Acked-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20110222174715.GC9687@joi.lan>
Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-lock.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 2e93f99..7a2a79d 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -202,9 +202,20 @@ static struct thread_stat *thread_stat_findnew_first(u32 tid)
 SINGLE_KEY(nr_acquired)
 SINGLE_KEY(nr_contended)
 SINGLE_KEY(wait_time_total)
-SINGLE_KEY(wait_time_min)
 SINGLE_KEY(wait_time_max)
 
+static int lock_stat_key_wait_time_min(struct lock_stat *one,
+					struct lock_stat *two)
+{
+	u64 s1 = one->wait_time_min;
+	u64 s2 = two->wait_time_min;
+	if (s1 == ULLONG_MAX)
+		s1 = 0;
+	if (s2 == ULLONG_MAX)
+		s2 = 0;
+	return s1 > s2;
+}
+
 struct lock_key {
 	/*
 	 * name: the value for specify by user
-- 
1.6.2.5

