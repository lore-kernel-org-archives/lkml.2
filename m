Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903Ab0DUQJW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 12:09:22 -0400
Received: from smtp-out.google.com ([216.239.44.51]:28282 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755804Ab0DUQJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 12:09:21 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:from:date:to:reply-to:cc:subject:x-system-of-record;
	b=YEmcIa0PjGq57B6mjQOcNgMOnTmJ5pQ4IOk9g3Rv17OBlIXFvgX0BB6Hm+aTaZvxk
	kJisAtzChxDHmnTP0DWBA==
Message-ID: <4bcf232b.698fd80a.6fbe.ffffb737@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Wed, 21 Apr 2010 18:06:01 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       fweisbec@gmail.com, robert.richter@amd.com, perfmon2-devel@lists.sf.net,
       eranian@gmail.com, eranian@google.com
Subject: [PATCH] perf: fix initialization bug in parse_single_tracepoint_event()
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  The parse_single_tracepoint_event() was setting some attributes
  before it validated the event was indeed a tracepoint event. This
  caused problems with other initialization routines like in the
  builtin-top.c module whereby sample_period is not set if not 0.

  Signed-off-by: Stephane Eranian <eranian@google.com>
--
 parse-events.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 3b4ec67..82b8b7f 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -418,12 +418,6 @@ parse_single_tracepoint_event(char *sys_name,
 	u64 id;
 	int fd;
 
-	attr->sample_type |= PERF_SAMPLE_RAW;
-	attr->sample_type |= PERF_SAMPLE_TIME;
-	attr->sample_type |= PERF_SAMPLE_CPU;
-
-	attr->sample_period = 1;
-
 	snprintf(evt_path, MAXPATHLEN, "%s/%s/%s/id", debugfs_path,
 		 sys_name, evt_name);
 
@@ -442,6 +436,13 @@ parse_single_tracepoint_event(char *sys_name,
 	attr->type = PERF_TYPE_TRACEPOINT;
 	*strp = evt_name + evt_length;
 
+	attr->sample_type |= PERF_SAMPLE_RAW;
+	attr->sample_type |= PERF_SAMPLE_TIME;
+	attr->sample_type |= PERF_SAMPLE_CPU;
+
+	attr->sample_period = 1;
+
+
 	return EVT_HANDLED;
 }
 
