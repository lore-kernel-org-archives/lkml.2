Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751160Ab0EHEpN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 00:45:13 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35839 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab0EHEpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 00:45:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version;
        b=KTKfQOjS9x0yQyacaRVKVA0mUZ2NAbue18f+QcOBY6axji36VdLX+Gw7N888B9WQln
         1gA2p1voXjt8E3e7Xu6T2sOqh3knkgf/w4hM4OeZZN5ZD7dJ8zoK8lvXTuPvitaLYLEG
         79ECsAvRLAs/hDy1lOLgZFR/J2yyuuA2uFMC4=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jason Baron <jbaron@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Tom Zanussi <tzanussi@gmail.com>
Subject: [GIT PULL] perf fixlet for 2.6.34
Date: Sat,  8 May 2010 06:45:09 +0200
Message-Id: <1273293909-21288-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Please pull the perf/urgent branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	perf/urgent

Thanks,
	Frederic
---

Frederic Weisbecker (1):
      perf: Fix static strings treated like dynamic ones


 tools/perf/util/trace-event-parse.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

---
commit c236e02b1c5adba76022e349ceff9dd60a00a2b8
Author: Frederic Weisbecker <fweisbec@gmail.com>
Date:   Wed May 5 22:07:39 2010 +0200

    perf: Fix static strings treated like dynamic ones
    
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

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 9b3c20f..613c9cc 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -1925,7 +1925,7 @@ void *raw_field_ptr(struct event *event, const char *name, void *data)
 	if (!field)
 		return NULL;
 
-	if (field->flags & FIELD_IS_STRING) {
+	if (field->flags & FIELD_IS_DYNAMIC) {
 		int offset;
 
 		offset = *(int *)(data + field->offset);
