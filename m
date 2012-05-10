Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757760Ab2EJJLC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 05:11:02 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48527 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754113Ab2EJJK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 05:10:59 -0400
Date: Thu, 10 May 2012 02:10:27 -0700
From: tip-bot for David Ahern <dsahern@gmail.com>
Message-ID: <tip-20d23aaa31da295378abff4272716e3dfc72baf0@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, peterz@infradead.org, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1336490956-57145-1-git-send-email-dsahern@gmail.com>
References: <1336490956-57145-1-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf stat:
  handle ENXIO error for perf_event_open
Git-Commit-ID: 20d23aaa31da295378abff4272716e3dfc72baf0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 10 May 2012 02:10:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  20d23aaa31da295378abff4272716e3dfc72baf0
Gitweb:     http://git.kernel.org/tip/20d23aaa31da295378abff4272716e3dfc72baf0
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Tue, 8 May 2012 09:29:16 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 9 May 2012 14:14:41 -0300

perf stat: handle ENXIO error for perf_event_open

perf stat on PPC currently fails to run:

$ perf stat -- sleep 1
  Error: open_counter returned with 6 (No such device or address). /bin/dmesg may provide additional information.

  Fatal: Not all events could be opened.

The problem is that until 2.6.37 (behavior changed with commit b0a873e)
perf on PPC returns ENXIO when hw_perf_event_init() fails. With this
patch we get the expected behavior:

$ perf stat -v -- sleep 1
cycles event is not supported by the kernel.
stalled-cycles-frontend event is not supported by the kernel.
stalled-cycles-backend event is not supported by the kernel.
instructions event is not supported by the kernel.
branches event is not supported by the kernel.
branch-misses event is not supported by the kernel.

...

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1336490956-57145-1-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-stat.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 4532a78..1e5e9b2 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -488,8 +488,13 @@ static int run_perf_stat(int argc __used, const char **argv)
 
 	list_for_each_entry(counter, &evsel_list->entries, node) {
 		if (create_perf_stat_counter(counter, first) < 0) {
+			/*
+			 * PPC returns ENXIO for HW counters until 2.6.37
+			 * (behavior changed with commit b0a873e).
+			 */
 			if (errno == EINVAL || errno == ENOSYS ||
-			    errno == ENOENT || errno == EOPNOTSUPP) {
+			    errno == ENOENT || errno == EOPNOTSUPP ||
+			    errno == ENXIO) {
 				if (verbose)
 					ui__warning("%s event is not supported by the kernel.\n",
 						    event_name(counter));
