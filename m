Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379Ab1HCXnQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 19:43:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33528 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755977Ab1HCX0v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 19:26:51 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Aug  3 15:12:47 2011
Message-Id: <20110803221247.801359538@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 03 Aug 2011 15:00:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, acme@ghostprotocols.net,
        peterz@infradead.org, paulus@samba.org, Ingo Molnar <mingo@elte.hu>
Subject: [038/102] perf tools: Fix endian conversion reading event attr from file header
In-Reply-To: <20110803221345.GA10346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Ahern <dsahern@gmail.com>

commit eda3913bb70ecebac13adccffe1e7f96e93cee02 upstream.

The perf_event_attr struct has two __u32's at the top and
they need to be swapped individually.

With this change I was able to analyze a perf.data collected in a
32-bit PPC VM on an x86 system. I tested both 32-bit and 64-bit
binaries for the Intel analysis side; both read the PPC perf.data
file correctly.

-v2:
 - changed the existing perf_event__attr_swap() to swap only elements
   of perf_event_attr and exported it for use in swapping the
   attributes in the file header
 - updated swap_ops used for processing events

Signed-off-by: David Ahern <dsahern@gmail.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: acme@ghostprotocols.net
Cc: peterz@infradead.org
Cc: paulus@samba.org
Link: http://lkml.kernel.org/r/1310754849-12474-1-git-send-email-dsahern@gmail.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 tools/perf/util/header.c  |    5 ++++-
 tools/perf/util/session.c |   30 ++++++++++++++++++------------
 tools/perf/util/session.h |    1 +
 3 files changed, 23 insertions(+), 13 deletions(-)

--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -877,9 +877,12 @@ int perf_session__read_header(struct per
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
 
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -407,20 +407,26 @@ static void perf_event__read_swap(union
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
@@ -448,7 +454,7 @@ static perf_event__swap_op perf_event__s
 	[PERF_RECORD_LOST]		  = perf_event__all64_swap,
 	[PERF_RECORD_READ]		  = perf_event__read_swap,
 	[PERF_RECORD_SAMPLE]		  = perf_event__all64_swap,
-	[PERF_RECORD_HEADER_ATTR]	  = perf_event__attr_swap,
+	[PERF_RECORD_HEADER_ATTR]	  = perf_event__hdr_attr_swap,
 	[PERF_RECORD_HEADER_EVENT_TYPE]	  = perf_event__event_type_swap,
 	[PERF_RECORD_HEADER_TRACING_DATA] = perf_event__tracing_data_swap,
 	[PERF_RECORD_HEADER_BUILD_ID]	  = NULL,
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -112,6 +112,7 @@ int perf_session__set_kallsyms_ref_reloc
 					     u64 addr);
 
 void mem_bswap_64(void *src, int byte_size);
+void perf_event__attr_swap(struct perf_event_attr *attr);
 
 int perf_session__create_kernel_maps(struct perf_session *self);
 


