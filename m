Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863Ab1I2Wx7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 18:53:59 -0400
Received: from casper.infradead.org ([85.118.1.10]:44111 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756182Ab1I2Wx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 18:53:58 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Neil Horman <nhorman@tuxdriver.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/1] perf tools: Fix raw sample reading
Date: Thu, 29 Sep 2011 19:53:47 -0300
Message-Id: <1317336827-19810-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1317336827-19810-1-git-send-email-acme@infradead.org>
References: <1317336827-19810-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Wrong pointer is being passed for raw data sanity checking, when parsing
sample event.

This ends up with invalid event and perf record being stuck in
__perf_session__process_events function during processing build IDs
(process_buildids function).

Following command hangs up in my setup:
	./perf record -e raw_syscalls:sys_enter ls

The fix is to use proper pointer to the raw data instead of the 'u'
union.

Reviewed-by: David Ahern <dsahern@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1317308709-9474-2-git-send-email-jolsa@redhat.com
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index c5748c5..e389815 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -449,6 +449,8 @@ int perf_event__parse_sample(const union perf_event *event, u64 type,
 	}
 
 	if (type & PERF_SAMPLE_RAW) {
+		const u64 *pdata;
+
 		u.val64 = *array;
 		if (WARN_ONCE(swapped,
 			      "Endianness of raw data not corrected!\n")) {
@@ -462,11 +464,12 @@ int perf_event__parse_sample(const union perf_event *event, u64 type,
 			return -EFAULT;
 
 		data->raw_size = u.val32[0];
+		pdata = (void *) array + sizeof(u32);
 
-		if (sample_overlap(event, &u.val32[1], data->raw_size))
+		if (sample_overlap(event, pdata, data->raw_size))
 			return -EFAULT;
 
-		data->raw_data = &u.val32[1];
+		data->raw_data = (void *) pdata;
 	}
 
 	return 0;
-- 
1.6.2.5

