Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab1EVBqb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 21:46:31 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45810 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753538Ab1EVBqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 21:46:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=PcxAaNLQa+iu8dZdDnpeFkDpD7x300s3/M3RiRDprcKx8ZzY53okFo+jdXsMebSK+D
         9sg0F8iRDqCZAUTaxaId+Qg8gAKW2c3JHUa5xMLmlWwznBGBbMjTDdRRFZVe5v14Pxr4
         GpTu9AgdNgNB8E969I7HtQnWO6UeFWxwIfOZ4=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 5/6] perf tools: Robustify dynamic sample content fetch
Date: Sun, 22 May 2011 03:45:43 +0200
Message-Id: <1306028744-10603-6-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1306028744-10603-1-git-send-email-fweisbec@gmail.com>
References: <1306028744-10603-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure the size of the dynamic fields such as callchains
or raw events don't overlap the whole event boundaries.

This prevents from dereferencing junk if the given size of
the callchain goes too eager.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/util/evsel.c |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index bfce8bf..ee0fe0d 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -303,6 +303,17 @@ static int perf_event__parse_id_sample(const union perf_event *event, u64 type,
 	return 0;
 }
 
+static bool sample_overlap(const union perf_event *event,
+			   const void *offset, u64 size)
+{
+	const void *base = event;
+
+	if (offset + size > base + event->header.size)
+		return true;
+
+	return false;
+}
+
 int perf_event__parse_sample(const union perf_event *event, u64 type,
 			     int sample_size, bool sample_id_all,
 			     struct perf_sample *data)
@@ -373,14 +384,29 @@ int perf_event__parse_sample(const union perf_event *event, u64 type,
 	}
 
 	if (type & PERF_SAMPLE_CALLCHAIN) {
+		if (sample_overlap(event, array, sizeof(data->callchain->nr)))
+			return -EFAULT;
+
 		data->callchain = (struct ip_callchain *)array;
+
+		if (sample_overlap(event, array, data->callchain->nr))
+			return -EFAULT;
+
 		array += 1 + data->callchain->nr;
 	}
 
 	if (type & PERF_SAMPLE_RAW) {
 		u32 *p = (u32 *)array;
+
+		if (sample_overlap(event, array, sizeof(u32)))
+			return -EFAULT;
+
 		data->raw_size = *p;
 		p++;
+
+		if (sample_overlap(event, p, data->raw_size))
+			return -EFAULT;
+
 		data->raw_data = p;
 	}
 
-- 
1.7.3.2

