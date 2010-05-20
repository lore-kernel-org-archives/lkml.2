Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038Ab0ETMzv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 08:55:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:59872 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752239Ab0ETMzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 08:55:49 -0400
Date: Thu, 20 May 2010 12:54:44 GMT
From: tip-bot for Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
       a.p.zijlstra@chello.nl, fweisbec@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, tzanussi@gmail.com,
       a.p.zijlstra@chello.nl, fweisbec@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1273032130.6383.28.camel@tropicana>
References: <1273032130.6383.28.camel@tropicana>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Use read() instead of lseek() in trace_event_read.c:skip()
Message-ID: <tip-cbb5cf7ff6b298beacfe23db3386335b0b9c0a2d@git.kernel.org>
Git-Commit-ID: cbb5cf7ff6b298beacfe23db3386335b0b9c0a2d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 20 May 2010 12:54:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cbb5cf7ff6b298beacfe23db3386335b0b9c0a2d
Gitweb:     http://git.kernel.org/tip/cbb5cf7ff6b298beacfe23db3386335b0b9c0a2d
Author:     Tom Zanussi <tzanussi@gmail.com>
AuthorDate: Tue, 4 May 2010 23:02:10 -0500
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Thu, 20 May 2010 08:37:17 +0200

perf: Use read() instead of lseek() in trace_event_read.c:skip()

This is a small fix for a problem affecting live-mode, introduced
recently:

root@tropicana:~# perf trace rwtop
perf trace started with Perl
script /root/libexec/perf-core/scripts/perl/rwtop.pl

  Fatal: did not read header event

commit d00a47cce569a3e660a8c9de5d57af28d6a9f0f7 added a skip()
function to skip over e.g. header_page, but this doesn't work for
live mode.  This patch re-implements skip() to use read() instead of
lseek() to fix that.

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <1273032130.6383.28.camel@tropicana>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/util/trace-event-read.c |   19 +++++++++++++------
 1 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
index cb54cd0..f55cc3a 100644
--- a/tools/perf/util/trace-event-read.c
+++ b/tools/perf/util/trace-event-read.c
@@ -53,12 +53,6 @@ static unsigned long	page_size;
 static ssize_t calc_data_size;
 static bool repipe;
 
-/* If it fails, the next read will report it */
-static void skip(int size)
-{
-	lseek(input_fd, size, SEEK_CUR);
-}
-
 static int do_read(int fd, void *buf, int size)
 {
 	int rsize = size;
@@ -98,6 +92,19 @@ static int read_or_die(void *data, int size)
 	return r;
 }
 
+/* If it fails, the next read will report it */
+static void skip(int size)
+{
+	char buf[BUFSIZ];
+	int r;
+
+	while (size) {
+		r = size > BUFSIZ ? BUFSIZ : size;
+		read_or_die(buf, r);
+		size -= r;
+	};
+}
+
 static unsigned int read4(void)
 {
 	unsigned int data;
