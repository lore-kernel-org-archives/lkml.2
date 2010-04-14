Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743Ab0DNXkg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 19:40:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:51108 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755573Ab0DNXkd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 19:40:33 -0400
Date: Wed, 14 Apr 2010 23:39:59 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
       a.p.zijlstra@chello.nl, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, tzanussi@gmail.com,
       a.p.zijlstra@chello.nl, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1271282283-23721-1-git-send-regression-fweisbec@gmail.com>
References: <1271282283-23721-1-git-send-regression-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Fix dynamic field detection
Message-ID: <tip-a1e2f60e3efc812bf66a2be0d8530ee175003f6d@git.kernel.org>
Git-Commit-ID: a1e2f60e3efc812bf66a2be0d8530ee175003f6d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 14 Apr 2010 23:39:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a1e2f60e3efc812bf66a2be0d8530ee175003f6d
Gitweb:     http://git.kernel.org/tip/a1e2f60e3efc812bf66a2be0d8530ee175003f6d
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 14 Apr 2010 23:58:03 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 15 Apr 2010 01:34:46 +0200

perf: Fix dynamic field detection

Checking if a tracing field is an array with a dynamic length
requires to check the field type and seek the "__data_loc"
string that prepends the actual type, as can be found in a trace
event format file:

	field:__data_loc char[] name;	offset:16;	size:4;	signed:1;

But we actually use strcmp() to check if the field type fully
matches "__data_loc", which may fail as we trip over the rest of
the type.

To fix this, use strncmp to only check if it starts with
"__data_loc".

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <1271282283-23721-1-git-send-regression-fweisbec@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
