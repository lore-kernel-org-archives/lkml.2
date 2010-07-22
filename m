Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004Ab0GVVFR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 17:05:17 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:10343 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115Ab0GVVFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 17:05:13 -0400
From: David Daney <ddaney@caviumnetworks.com>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, David Daney <ddaney@caviumnetworks.com>
Subject: [PATCH] trace-cmd: Don't SIGSEGV when event field format cannot be parsed (v2).
Date: Thu, 22 Jul 2010 14:05:05 -0700
Message-Id: <1279832705-14219-1-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1279829325.3319.27.camel@gandalf.stny.rr.com>
References: <1279829325.3319.27.camel@gandalf.stny.rr.com>
X-OriginalArrivalTime: 22 Jul 2010 21:05:13.0223 (UTC) FILETIME=[93AE1170:01CB29E1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From the MIPS kernel we get things like:

print fmt: "page=%p pfn=%lu order=%d migratetype=%d", REC->page, ({ struct page *__pg = (REC->page); int __sec = page_to_section(__pg); (unsigned long)(__pg - __section_mem_map_addr(__nr_to_section(__sec))); }), REC->order, REC->migratetype

This cannot be parsed, leading to a NULL struct event_format* being
passed to pevent_get_common_field_val, which produces a SIGSEGV.  It
would be good to get a parsable format from the kernel, but to
remediate the problem for legacy kernels, we can just return an error
indicator in this case.  This allows some output from trace-cmd
report, although perhaps with some missing data.  But this is better
than crashing.

(v2): Do the check in all pevent_get_*

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
---
 parse-events.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/parse-events.c b/parse-events.c
index 1e854e2..595ba90 100644
--- a/parse-events.c
+++ b/parse-events.c
@@ -4464,6 +4464,9 @@ int pevent_get_field_val(struct trace_seq *s, struct event_format *event,
 {
 	struct format_field *field;
 
+	if (!event)
+		return -1;
+
 	field = pevent_find_field(event, name);
 
 	return get_field_val(s, field, name, record, val, err);
@@ -4486,6 +4489,9 @@ int pevent_get_common_field_val(struct trace_seq *s, struct event_format *event,
 {
 	struct format_field *field;
 
+	if (!event)
+		return -1;
+
 	field = pevent_find_common_field(event, name);
 
 	return get_field_val(s, field, name, record, val, err);
@@ -4508,6 +4514,9 @@ int pevent_get_any_field_val(struct trace_seq *s, struct event_format *event,
 {
 	struct format_field *field;
 
+	if (!event)
+		return -1;
+
 	field = pevent_find_any_field(event, name);
 
 	return get_field_val(s, field, name, record, val, err);
-- 
1.7.1.1

