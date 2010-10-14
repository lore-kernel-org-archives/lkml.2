Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930Ab0JNTXs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 15:23:48 -0400
Received: from fmmailgate02.web.de ([217.72.192.227]:53043 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754698Ab0JNTXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 15:23:47 -0400
Message-ID: <4CB758C1.8090906@web.de>
Date: Thu, 14 Oct 2010 21:23:45 +0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-trace-users@vger.kernel.org
Subject: [PATCH] trace-view: Handle unknown events more gracefully
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19gGiBjyyNya/R4XJc7kxWV1XLMxp1OMBwCcwpf
	T7EfXZVEyONKwraYb7s4LlXxSlD/7Ef6mMzv323/uqtsWIW80t
	Z+TpzuYhQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel 2.6.35.7 generates invalid trace files due to
/sys/kernel/debug/tracing/events/scsi/scsi_dispatch_cmd_timeout/format
returning "FORMAT TOO BIG" (seems to be fixed in 2.6.36). This makes
pevent_data_event_from_type return NULL, and dereferencing of event
crashes the viewer.

Catch and report the error properly.

Signed-off-by: Jan Kiszka <jan.kiszka@web.de>
---
 trace-view-store.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/trace-view-store.c b/trace-view-store.c
index 0834df7..34f8155 100644
--- a/trace-view-store.c
+++ b/trace-view-store.c
@@ -507,12 +507,17 @@ trace_view_store_get_value (GtkTreeModel *tree_model,
 		case TRACE_VIEW_STORE_COL_INFO:
 			val = pevent_data_type(pevent, data);
 			event = pevent_data_event_from_type(pevent, val);
+			if (!event) {
+				if (column == TRACE_VIEW_STORE_COL_EVENT)
+					g_value_set_string(value, "[UNKNOWN EVENT]");
+				break;
+			}
+
 			if (column == TRACE_VIEW_STORE_COL_EVENT) {
 				g_value_set_string(value, event->name);
 				break;
 			}
 
-			
 			trace_seq_init(&s);
 			pevent_event_info(&s, event, data);
 			g_value_set_string(value, s.buffer);
-- 
1.7.1
