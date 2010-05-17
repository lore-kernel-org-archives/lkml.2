Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421Ab0EQPsS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 11:48:18 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35185 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304Ab0EQPsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 11:48:10 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
       "David S. Miller" <davem@davemloft.net>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/3] perf record: Fix bug mismatch with -c option definition
Date: Mon, 17 May 2010 12:47:57 -0300
Message-Id: <1274111278-2838-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1274111278-2838-1-git-send-email-acme@infradead.org>
References: <1274111278-2838-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephane Eranian <eranian@google.com>

The -c option defines the user requested sampling period. It was implemented
using an unsigned int variable but the type of the option was OPT_LONG. Thus,
the option parser was overwriting memory belonging to other variables, namely
the mmap_pages leading to a zero page sampling buffer. The bug was exposed only
when compiling at -O0, probably because the compiler was padding variables at
higher optimization levels.

This patch fixes this problem by declaring user_interval as u64. This also
avoids wrap-around issues for large period on 32-bit systems.

Commiter note:

Made it use OPT_U64(user_interval) after implementing OPT_U64 in the
previous patch.

Cc: David S. Miller <davem@davemloft.net>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <4bf11ae9.e88cd80a.06b0.ffffa8e3@mx.google.com>
Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 0f467cf..b93573c 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -33,8 +33,8 @@ enum write_mode_t {
 
 static int			*fd[MAX_NR_CPUS][MAX_COUNTERS];
 
-static unsigned int		user_interval 			= UINT_MAX;
-static long			default_interval		=      0;
+static u64			user_interval			= ULLONG_MAX;
+static u64			default_interval		=      0;
 
 static int			nr_cpus				=      0;
 static unsigned int		page_size;
@@ -268,7 +268,7 @@ static void create_counter(int counter, int cpu)
 	 * it a weak assumption overridable by the user.
 	 */
 	if (!attr->sample_period || (user_freq != UINT_MAX &&
-				     user_interval != UINT_MAX)) {
+				     user_interval != ULLONG_MAX)) {
 		if (freq) {
 			attr->sample_type	|= PERF_SAMPLE_PERIOD;
 			attr->freq		= 1;
@@ -817,8 +817,7 @@ static const struct option options[] = {
 			    "CPU to profile on"),
 	OPT_BOOLEAN('f', "force", &force,
 			"overwrite existing data file (deprecated)"),
-	OPT_LONG('c', "count", &user_interval,
-		    "event period to sample"),
+	OPT_U64('c', "count", &user_interval, "event period to sample"),
 	OPT_STRING('o', "output", &output_name, "file",
 		    "output file name"),
 	OPT_BOOLEAN('i', "no-inherit", &no_inherit,
@@ -901,7 +900,7 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 	if (!event_array)
 		return -ENOMEM;
 
-	if (user_interval != UINT_MAX)
+	if (user_interval != ULLONG_MAX)
 		default_interval = user_interval;
 	if (user_freq != UINT_MAX)
 		freq = user_freq;
-- 
1.6.2.5

