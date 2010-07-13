Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab0GMSpV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 14:45:21 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:12740 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab0GMSpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 14:45:18 -0400
From: David Daney <ddaney@caviumnetworks.com>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, David Daney <ddaney@caviumnetworks.com>
Subject: [PATCH] trace-cmd: Don't SIGSEGV when event field format cannot be parsed.
Date: Tue, 13 Jul 2010 11:44:52 -0700
Message-Id: <1279046692-11941-1-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.6.6.1
X-OriginalArrivalTime: 13 Jul 2010 18:45:18.0023 (UTC) FILETIME=[8A087570:01CB22BB]
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

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
---
 parse-events.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/parse-events.c b/parse-events.c
index 9d5a3fa..16fff12 100644
--- a/parse-events.c
+++ b/parse-events.c
@@ -4481,6 +4481,9 @@ int pevent_get_common_field_val(struct trace_seq *s, struct event_format *event,
 {
 	struct format_field *field;
 
+	if (!event)
+		return -1;
+
 	field = pevent_find_common_field(event, name);
 
 	return get_field_val(s, field, name, record, val, err);
-- 
1.6.6.1

