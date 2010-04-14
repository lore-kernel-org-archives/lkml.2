Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807Ab0DNV6I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 17:58:08 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:54107 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753621Ab0DNV6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 17:58:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Sc5q6yqKtP2nO64tF7BG/Owe5WDBFaqa7cpNmZ/5q1+LaM/HGFHUtuh7izJy8dbuhR
         kJ0B60m0EvSVrANENGE7b7mZG6MfX+bKi6nwiqv2ROtRK9sKLBV9FJKVtQKStOGgnXSb
         hGJNWkYyu5Kv7sr62AWi6AAPOQys1iZyy1szE=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Tom Zanussi <tzanussi@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] perf: Fix dynamic field detection
Date: Wed, 14 Apr 2010 23:58:03 +0200
Message-Id: <1271282283-23721-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Checking if a tracing field is an array with a dynamic length
requires to check the field type and seek the "__data_loc" string
that prepends the actual type, as can be found in a trace event
format file:

	field:__data_loc char[] name;	offset:16;	size:4;	signed:1;

But we actually use strcmp() to check if the field type fully
matches "__data_loc", which may fail as we trip over the rest of the
type.

To fix this, use strncmp to only check if it starts with "__data_loc".

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/util/trace-event-parse.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 17d6d66..d6ef414 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -761,7 +761,7 @@ static int field_is_string(struct format_field *field)
 
 static int field_is_dynamic(struct format_field *field)
 {
-	if (!strcmp(field->type, "__data_loc"))
+	if (!strncmp(field->type, "__data_loc", 10))
 		return 1;
 
 	return 0;
-- 
1.6.2.3

