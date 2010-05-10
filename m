Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134Ab0EJErN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 00:47:13 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55381 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384Ab0EJErG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 00:47:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=u5Eug3GZEp5QxwWcYT/6rbnIVkUGc3IKiGYA1/6pTjrDtm900Z0HYuGQcbom1NEb3l
         nNTtbu9zHoEUQGwe0zSi1eoiOC3Yzai/YwIIpEmUrPvhjciQCZRKTsz2J07U+9rGYnYo
         LKCyy+PdZncG/hVWX00fTyn0liknduD1oW+QM=
From: Tom Zanussi <tzanussi@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fweisbec@gmail.com, acme@ghostprotocols.net
Subject: [PATCH 1/9] perf/trace/scripting: failed-syscalls script cleanup
Date: Sun,  9 May 2010 23:46:52 -0500
Message-Id: <1273466820-9330-2-git-send-email-tzanussi@gmail.com>
X-Mailer: git-send-email 1.6.4.GIT
In-Reply-To: <1273466820-9330-1-git-send-email-tzanussi@gmail.com>
References: <1273466820-9330-1-git-send-email-tzanussi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A couple small fixes for the failed syscalls script:

- The script description says it can be restricted to a specific comm,
  make it so.

- silence the match output in the shell script

Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
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
1.6.4.GIT

