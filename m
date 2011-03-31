Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757149Ab1CaMlw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 08:41:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:56808 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752409Ab1CaMlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 08:41:51 -0400
Date: Thu, 31 Mar 2011 12:41:31 GMT
From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, fweisbec@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1301535324-9735-1-git-send-email-fweisbec@gmail.com>
References: <1301535324-9735-1-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: mmap 512 kiB by default
Message-ID: <tip-800cd25c12981c99e5401c3551ffffd99f1c6c85@git.kernel.org>
Git-Commit-ID: 800cd25c12981c99e5401c3551ffffd99f1c6c85
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 31 Mar 2011 12:41:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  800cd25c12981c99e5401c3551ffffd99f1c6c85
Gitweb:     http://git.kernel.org/tip/800cd25c12981c99e5401c3551ffffd99f1c6c85
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Thu, 31 Mar 2011 03:35:24 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 31 Mar 2011 13:02:55 +0200

perf: mmap 512 kiB by default

The default setting of perf record is to mmap 128 pages if the user
did not override with -m.

However the page size may vary accross different architecture
settings, giving different default size between each.

Moreover the kernel side still has a default max number of mlocked
pages of 512 kiB + 1 page for unprivileged users. 128 + 1 pages
with page size > 4096 overlaps this threshold.

Thus, better adapt to this limitation and set the default number of
pages to fit those 512 kiB + 1 page.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <1301535324-9735-1-git-send-email-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-record.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index db6adec..17d1dcb 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -41,7 +41,7 @@ static u64			user_interval			= ULLONG_MAX;
 static u64			default_interval		=      0;
 
 static unsigned int		page_size;
-static unsigned int		mmap_pages			=    128;
+static unsigned int		mmap_pages			= UINT_MAX;
 static unsigned int		user_freq 			= UINT_MAX;
 static int			freq				=   1000;
 static int			output;
@@ -513,6 +513,10 @@ static int __cmd_record(int argc, const char **argv)
 	if (have_tracepoints(&evsel_list->entries))
 		perf_header__set_feat(&session->header, HEADER_TRACE_INFO);
 
+	/* 512 kiB: default amount of unprivileged mlocked memory */
+	if (mmap_pages == UINT_MAX)
+		mmap_pages = (512 * 1024) / page_size;
+
 	if (forks) {
 		child_pid = fork();
 		if (child_pid < 0) {
