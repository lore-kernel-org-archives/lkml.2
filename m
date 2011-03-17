Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab1CQLEp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 07:04:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:60734 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753851Ab1CQLEo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 07:04:44 -0400
Date: Thu, 17 Mar 2011 11:04:18 GMT
From: tip-bot for Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        mitake@dcl.info.waseda.ac.jp, marcin.slusarz@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        mitake@dcl.info.waseda.ac.jp, marcin.slusarz@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110222174715.GC9687@joi.lan>
References: <20110222174715.GC9687@joi.lan>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf lock: Fix sorting by wait_min
Message-ID: <tip-9df03abeda3d928ecdedc0f427336931eac0a477@git.kernel.org>
Git-Commit-ID: 9df03abeda3d928ecdedc0f427336931eac0a477
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 17 Mar 2011 11:04:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9df03abeda3d928ecdedc0f427336931eac0a477
Gitweb:     http://git.kernel.org/tip/9df03abeda3d928ecdedc0f427336931eac0a477
Author:     Marcin Slusarz <marcin.slusarz@gmail.com>
AuthorDate: Tue, 22 Feb 2011 18:47:15 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 16 Mar 2011 09:05:58 -0300

perf lock: Fix sorting by wait_min

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
