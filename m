Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758301Ab0EEU2I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 16:28:08 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47676 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758049Ab0EEU2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 16:28:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version;
        b=x+M+j6GV93Q3FQDVwnjHhTfyE0YZnQjSqWxBE8XQQggW7LAT2vQLZhyQE9z12cHrux
         KnqZE/eYf6L1u2q9GGTN4vB3L68b2DHejSptXOGK5ydMR0vOcPro3qqxs+PuWfOQkfrz
         PEDpw8bMtXxULNisGF2QXJiBh4uEOwrI6/Sns=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH] perf: Fix static strings treated like dynamic ones
Date: Wed,  5 May 2010 22:27:59 +0200
Message-Id: <1273091279-14891-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The raw_field_ptr() helper, used to retrieve the address of a field
inside a trace event, treats every strings as if they were dynamic
ie: having a secondary level of indirection to retrieve their
contents.

FIELD_IS_STRING doesn't mean FIELD_IS_DYNAMIC, we only need to
compute the secondary dereference for the latter case.

This fixes perf sched segfaults, bad cmdline report and may be
some other bugs.

Reported-by: Jason Baron <jbaron@redhat.com>
Reported-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
---
 tools/perf/util/trace-event-parse.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 069f261..73a0222 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -1937,7 +1937,7 @@ void *raw_field_ptr(struct event *event, const char *name, void *data)
 	if (!field)
 		return NULL;
 
-	if (field->flags & FIELD_IS_STRING) {
+	if (field->flags & FIELD_IS_DYNAMIC) {
 		int offset;
 
 		offset = *(int *)(data + field->offset);
-- 
1.6.2.3

