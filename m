Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751637Ab0K2QUV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 11:20:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58683 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776Ab0K2QUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 11:20:20 -0500
From: Avi Kivity <avi@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-trace-users@vger.kernel.org
Subject: [PATCH] Don't spam trace report about missing fields
Date: Mon, 29 Nov 2010 18:20:01 +0200
Message-Id: <1291047601-13879-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of spamming the output with complaints about missing fields, simply
return an error to the caller, which can print something out or do something
more intelligent about them.

Fixes kvm plugin tracing older kernels.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 parse-events.c |   15 +++------------
 1 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/parse-events.c b/parse-events.c
index f0b0324..7a4c3a6 100644
--- a/parse-events.c
+++ b/parse-events.c
@@ -4446,17 +4446,11 @@ int get_field_val(struct trace_seq *s, struct format_field *field,
 		  const char *name, struct record *record,
 		  unsigned long long *val, int err)
 {
-	if (!field) {
-		if (err)
-			trace_seq_printf(s, "<CANT FIND FIELD %s>", name);
+	if (!field)
 		return -1;
-	}
 
-	if (pevent_read_number_field(field, record->data, val)) {
-		if (err)
-			trace_seq_printf(s, " %s=INVALID", name);
+	if (pevent_read_number_field(field, record->data, val))
 		return -1;
-	}
 
 	return 0;
 }
@@ -4489,11 +4483,8 @@ void *pevent_get_field_raw(struct trace_seq *s, struct event_format *event,
 
 	field = pevent_find_field(event, name);
 
-	if (!field) {
-		if (err)
-			trace_seq_printf(s, "<CANT FIND FIELD %s>", name);
+	if (!field)
 		return NULL;
-	}
 
 	/* Allow @len to be NULL */
 	if (!len)
-- 
1.7.1

