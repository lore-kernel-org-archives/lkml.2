Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752Ab0CRN62 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 09:58:28 -0400
Received: from smtp-out.google.com ([74.125.121.35]:56607 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690Ab0CRN61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 09:58:27 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:from:date:to:reply-to:cc:subject:x-system-of-record;
	b=HRNKh5aE2NiMRbmXubTCmeoLytCbykuUenmZFy2Oi8l1+s1qbLK97j4BE1/6nrS3a
	BJmXNogBqb9J8Q04GSBdw==
Message-ID: <4ba2317a.8109cc0a.2858.ffffcd0c@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Thu, 18 Mar 2010 14:42:01 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       fweisbec@gmail.com, robert.richter@amd.com, perfmon2-devel@lists.sf.net,
       eranian@gmail.com, eranian@google.com
Subject: [PATCH] perf_events: fix ordering bug in perf_output_sample()
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	In order to parse a sample correctly based on the information
	requested via sample_type, the kernel needs to save each component
	in a known order. There is no type value saved with each component.
	The current convention is that each component is saved according to
	the order in enum perf_event_sample_format. But perf_output_sample()
	was not completely following this convention, thereby making samples
	impossible to parse without internal kernel knowledge.

	This patch puts things in the right order.

	Signed-off-by: Stephane Eranian <eranian@google.com>

--
 perf_event.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 455393e..b35df1d 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -3167,18 +3167,6 @@ void perf_output_sample(struct perf_output_handle *handle,
 	if (sample_type & PERF_SAMPLE_ADDR)
 		perf_output_put(handle, data->addr);
 
-	if (sample_type & PERF_SAMPLE_ID)
-		perf_output_put(handle, data->id);
-
-	if (sample_type & PERF_SAMPLE_STREAM_ID)
-		perf_output_put(handle, data->stream_id);
-
-	if (sample_type & PERF_SAMPLE_CPU)
-		perf_output_put(handle, data->cpu_entry);
-
-	if (sample_type & PERF_SAMPLE_PERIOD)
-		perf_output_put(handle, data->period);
-
 	if (sample_type & PERF_SAMPLE_READ)
 		perf_output_read(handle, event);
 
@@ -3198,6 +3186,18 @@ void perf_output_sample(struct perf_output_handle *handle,
 		}
 	}
 
+	if (sample_type & PERF_SAMPLE_ID)
+		perf_output_put(handle, data->id);
+
+	if (sample_type & PERF_SAMPLE_CPU)
+		perf_output_put(handle, data->cpu_entry);
+
+	if (sample_type & PERF_SAMPLE_STREAM_ID)
+		perf_output_put(handle, data->stream_id);
+
+	if (sample_type & PERF_SAMPLE_PERIOD)
+		perf_output_put(handle, data->period);
+
 	if (sample_type & PERF_SAMPLE_RAW) {
 		if (data->raw) {
 			perf_output_put(handle, data->raw->size);
