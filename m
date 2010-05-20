Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364Ab0ETJou (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 05:44:50 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36083 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755201Ab0ETJoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 05:44:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=aCMJyAu9bQVzSC9sYknE/cLCpI0ORRF1T2hoIIgNOGzVJ/tO70Mf0NOU84lc/eLxgy
         EhgSkz/RYI7Hn1CwFwT8/yihys1rJ+iJwrAO2OZ7xVNLmV6NZPZzPDVgkZpiokqITUSg
         Q8rMrEISi6lGV/8cW5fJUykstZIkSIiYeBi2k=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Tom Zanussi <tzanussi@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/3] perf: Use read() instead of lseek() in trace_event_read.c:skip()
Date: Thu, 20 May 2010 11:44:17 +0200
Message-Id: <1274348659-15417-2-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1274348659-15417-1-git-send-regression-fweisbec@gmail.com>
References: <1274348659-15417-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Zanussi <tzanussi@gmail.com>

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
-- 
1.6.2.3

