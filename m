Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024Ab1GOSeS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 14:34:18 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34815 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548Ab1GOSeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 14:34:17 -0400
From: David Ahern <dsahern@gmail.com>
To: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: acme@ghostprotocols.net, mingo@elte.hu, peterz@infradead.org,
        fweisbec@gmail.com, paulus@samba.org, David Ahern <dsahern@gmail.com>
Subject: [PATCH v2] perf tools: fix endian conversion reading event attr from file header
Date: Fri, 15 Jul 2011 12:34:09 -0600
Message-Id: <1310754849-12474-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The perf_event_attr struct has 2 __u32's at the top and need to
be swapped individually. With this change I was able to analyze
a perf.data collected in a 32-bit PPC VM on an x86 system. I
tested both 32-bit and 64-bit binaries for the Intel analysis
side; both read the PPC perf.data file correctly.

v1 -> v2:
- changed the existing perf_event__attr_swap to swap only elements
  of perf_event_attr and exported it for use in swapping the
  attributes in the file header
- updated swap_ops used for processing events

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 tools/perf/util/header.c  |    5 ++++-
 tools/perf/util/session.c |   30 ++++++++++++++++++------------
 tools/perf/util/session.h |    1 +
 3 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index afb0849..cb2959a 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -877,9 +877,12 @@ int perf_session__read_header(struct perf_session *session, int fd)
 		struct perf_evsel *evsel;
 		off_t tmp;
 
-		if (perf_header__getbuffer64(header, fd, &f_attr, sizeof(f_attr)))
+		if (readn(fd, &f_attr, sizeof(f_attr)) <= 0)
 			goto out_errno;
 
+		if (header->needs_swap)
+			perf_event__attr_swap(&f_attr.attr);
+
 		tmp = lseek(fd, 0, SEEK_CUR);
 		evsel = perf_evsel__new(&f_attr.attr, i);
 
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 080e533..a3c13bc 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -413,20 +413,26 @@ static void perf_event__read_swap(union perf_event *event)
 	event->read.id		 = bswap_64(event->read.id);
 }
 
-static void perf_event__attr_swap(union perf_event *event)
+/* exported for swapping attributes in file header */
+void perf_event__attr_swap(struct perf_event_attr *attr)
+{
+	attr->type		= bswap_32(attr->type);
+	attr->size		= bswap_32(attr->size);
+	attr->config		= bswap_64(attr->config);
+	attr->sample_period	= bswap_64(attr->sample_period);
+	attr->sample_type	= bswap_64(attr->sample_type);
+	attr->read_format	= bswap_64(attr->read_format);
+	attr->wakeup_events	= bswap_32(attr->wakeup_events);
+	attr->bp_type		= bswap_32(attr->bp_type);
+	attr->bp_addr		= bswap_64(attr->bp_addr);
+	attr->bp_len		= bswap_64(attr->bp_len);
+}
+
+static void perf_event__hdr_attr_swap(union perf_event *event)
 {
 	size_t size;
 
-	event->attr.attr.type		= bswap_32(event->attr.attr.type);
-	event->attr.attr.size		= bswap_32(event->attr.attr.size);
-	event->attr.attr.config		= bswap_64(event->attr.attr.config);
-	event->attr.attr.sample_period	= bswap_64(event->attr.attr.sample_period);
-	event->attr.attr.sample_type	= bswap_64(event->attr.attr.sample_type);
-	event->attr.attr.read_format	= bswap_64(event->attr.attr.read_format);
-	event->attr.attr.wakeup_events	= bswap_32(event->attr.attr.wakeup_events);
-	event->attr.attr.bp_type	= bswap_32(event->attr.attr.bp_type);
-	event->attr.attr.bp_addr	= bswap_64(event->attr.attr.bp_addr);
-	event->attr.attr.bp_len		= bswap_64(event->attr.attr.bp_len);
+	perf_event__attr_swap(&event->attr.attr);
 
 	size = event->header.size;
 	size -= (void *)&event->attr.id - (void *)event;
@@ -454,7 +460,7 @@ static perf_event__swap_op perf_event__swap_ops[] = {
 	[PERF_RECORD_LOST]		  = perf_event__all64_swap,
 	[PERF_RECORD_READ]		  = perf_event__read_swap,
 	[PERF_RECORD_SAMPLE]		  = perf_event__all64_swap,
-	[PERF_RECORD_HEADER_ATTR]	  = perf_event__attr_swap,
+	[PERF_RECORD_HEADER_ATTR]	  = perf_event__hdr_attr_swap,
 	[PERF_RECORD_HEADER_EVENT_TYPE]	  = perf_event__event_type_swap,
 	[PERF_RECORD_HEADER_TRACING_DATA] = perf_event__tracing_data_swap,
 	[PERF_RECORD_HEADER_BUILD_ID]	  = NULL,
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 5de754f..170601e 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -112,6 +112,7 @@ int perf_session__set_kallsyms_ref_reloc_sym(struct map **maps,
 					     u64 addr);
 
 void mem_bswap_64(void *src, int byte_size);
+void perf_event__attr_swap(struct perf_event_attr *attr);
 
 int perf_session__create_kernel_maps(struct perf_session *self);
 
-- 
1.7.6

