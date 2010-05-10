Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932663Ab0EJXZu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:25:50 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40570 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932583Ab0EJWxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:53:12 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Tom Zanussi <tzanussi@gmail.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 02/10] perf/trace/scripting: failed-syscalls script cleanup
Date: Mon, 10 May 2010 19:53:00 -0300
Message-Id: <1273531987-28956-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1273531987-28956-1-git-send-email-acme@infradead.org>
References: <1273531987-28956-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Zanussi <tzanussi@gmail.com>

A couple small fixes for the failed syscalls script:

- The script description says it can be restricted to a specific comm,
  make it so.

- silence the match output in the shell script

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
LKML-Reference: <1273466820-9330-2-git-send-email-tzanussi@gmail.com>
Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/scripts/perl/bin/failed-syscalls-report |    2 +-
 tools/perf/scripts/perl/failed-syscalls.pl         |    6 +++++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/perf/scripts/perl/bin/failed-syscalls-report b/tools/perf/scripts/perl/bin/failed-syscalls-report
index f634608..e3a5e55 100644
--- a/tools/perf/scripts/perl/bin/failed-syscalls-report
+++ b/tools/perf/scripts/perl/bin/failed-syscalls-report
@@ -2,7 +2,7 @@
 # description: system-wide failed syscalls
 # args: [comm]
 if [ $# -gt 0 ] ; then
-    if ! expr match "$1" "-" ; then
+    if ! expr match "$1" "-" > /dev/null ; then
 	comm=$1
 	shift
     fi
diff --git a/tools/perf/scripts/perl/failed-syscalls.pl b/tools/perf/scripts/perl/failed-syscalls.pl
index c18e7e2..94bc25a 100644
--- a/tools/perf/scripts/perl/failed-syscalls.pl
+++ b/tools/perf/scripts/perl/failed-syscalls.pl
@@ -11,6 +11,8 @@ use Perf::Trace::Core;
 use Perf::Trace::Context;
 use Perf::Trace::Util;
 
+my $for_comm = shift;
+
 my %failed_syscalls;
 
 sub raw_syscalls::sys_exit
@@ -33,6 +35,8 @@ sub trace_end
 
     foreach my $comm (sort {$failed_syscalls{$b} <=> $failed_syscalls{$a}}
 		      keys %failed_syscalls) {
-	    printf("%-20s  %10s\n", $comm, $failed_syscalls{$comm});
+	next if ($for_comm && $comm ne $for_comm);
+
+	printf("%-20s  %10s\n", $comm, $failed_syscalls{$comm});
     }
 }
-- 
1.6.2.5

