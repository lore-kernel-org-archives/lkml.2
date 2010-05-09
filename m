Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751578Ab0EIUnz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 16:43:55 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:32986 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296Ab0EIUnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 16:43:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=cOOj/+8mKCFxbmzuyxljyFxllLRq6E9dz/og5AAX4jKJ8/3REv1kfh4WXSR+C4QQ3H
         QiUXUHgv1ZMytyvYxc5xn2RWuXc27G0WQen0eVNK/7i/WIgZhpmjBgqVmgGlAFMUIIpm
         1ZKNVReO4e9ninJT//CrAwiSo6h7uorjZnv+Q=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Subject: [PATCH 03/10] perf: Humanize lock flags in perf lock
Date: Sun,  9 May 2010 22:43:31 +0200
Message-Id: <1273437818-8130-4-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1273437818-8130-1-git-send-regression-fweisbec@gmail.com>
References: <1273437818-8130-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use an enum instead of plain constants for lock flags.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
---
 tools/perf/builtin-lock.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 1e93179..3b304ed 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -397,6 +397,11 @@ enum broken_state {
 
 static int bad_hist[BROKEN_MAX];
 
+enum acquire_flags {
+	TRY_LOCK = 1,
+	READ_LOCK = 2,
+};
+
 static void
 report_lock_acquire_event(struct trace_acquire_event *acquire_event,
 			struct event *__event __used,
@@ -421,9 +426,9 @@ report_lock_acquire_event(struct trace_acquire_event *acquire_event,
 		if (!acquire_event->flag) {
 			seq->state = SEQ_STATE_ACQUIRING;
 		} else {
-			if (acquire_event->flag & 1)
+			if (acquire_event->flag & TRY_LOCK)
 				ls->nr_trylock++;
-			if (acquire_event->flag & 2)
+			if (acquire_event->flag & READ_LOCK)
 				ls->nr_readlock++;
 			seq->state = SEQ_STATE_READ_ACQUIRED;
 			seq->read_count = 1;
@@ -431,7 +436,7 @@ report_lock_acquire_event(struct trace_acquire_event *acquire_event,
 		}
 		break;
 	case SEQ_STATE_READ_ACQUIRED:
-		if (acquire_event->flag & 2) {
+		if (acquire_event->flag & READ_LOCK) {
 			seq->read_count++;
 			ls->nr_acquired++;
 			goto end;
-- 
1.6.2.3

