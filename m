Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab0EQKbM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 06:31:12 -0400
Received: from smtp-out.google.com ([74.125.121.35]:23072 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175Ab0EQKbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 06:31:10 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:from:date:to:reply-to:cc:subject:x-system-of-record;
	b=TRp1bsyPOFQKj3nwE5xWqwceD51wwHiqiPjvh9GsLdyTnfca3wwOinu55Xi5P3NV7
	nUguJXPry2B/PUpsjjsjg==
Message-ID: <4bf11ae9.e88cd80a.06b0.ffffa8e3@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Mon, 17 May 2010 12:04:01 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       fweisbec@gmail.com, acme@infradead.org, perfmon2-devel@lists.sf.net,
       eranian@gmail.com, eranian@google.com
Subject: [PATCH] perf: fix bug mismatch with -c option definition
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  The -c option defines the user requested sampling period. It was implemented
  using an unsigned int variable but the type of the option was OPT_LONG. Thus,
  the option parser was overwriting memory belonging to other variables, namely
  the mmap_pages leading to a zero page sampling buffer. The bug was exposed
  only when compiling at -O0, probably because the compiler was padding
  variables at higher optimization levels.

  This patch fixes this problem by declaring user_interval as u64. This also
  avoids wrap-around issues for large period on 32-bit systems.
 
  Signed-off-by: Stephane Eranian <eranian@google.com>
--
 tools/perf/builtin-record.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 0f467cf..78f64cc 100644
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
@@ -901,7 +901,7 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 	if (!event_array)
 		return -ENOMEM;
 
-	if (user_interval != UINT_MAX)
+	if (user_interval != ULLONG_MAX)
 		default_interval = user_interval;
 	if (user_freq != UINT_MAX)
 		freq = user_freq;
