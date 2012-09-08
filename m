Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760393Ab2IHCHb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 22:07:31 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41323 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759215Ab2IHCHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 22:07:25 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 04/13] tools lib traceevent: Get rid of die() from pevent_register_print_function
Date: Fri,  7 Sep 2012 23:07:03 -0300
Message-Id: <1347070032-4161-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1347070032-4161-1-git-send-email-acme@infradead.org>
References: <1347070032-4161-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

If memory allocation for handler fails or argument type is not match,
return gracefully instead of calling die().  Also add an new error code
for the later case.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1346986187-5170-3-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c |   26 ++++++++++++++++++++------
 tools/lib/traceevent/event-parse.h |    3 ++-
 2 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 17fd01d..4595aeb 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -5080,6 +5080,7 @@ int pevent_register_print_function(struct pevent *pevent,
 	struct pevent_func_params *param;
 	enum pevent_func_arg_type type;
 	va_list ap;
+	int ret;
 
 	func_handle = find_func_handler(pevent, name);
 	if (func_handle) {
@@ -5092,14 +5093,21 @@ int pevent_register_print_function(struct pevent *pevent,
 		remove_func_handler(pevent, name);
 	}
 
-	func_handle = malloc_or_die(sizeof(*func_handle));
+	func_handle = malloc(sizeof(*func_handle));
+	if (!func_handle) {
+		do_warning("Failed to allocate function handler");
+		return PEVENT_ERRNO__MEM_ALLOC_FAILED;
+	}
 	memset(func_handle, 0, sizeof(*func_handle));
 
 	func_handle->ret_type = ret_type;
 	func_handle->name = strdup(name);
 	func_handle->func = func;
-	if (!func_handle->name)
-		die("Failed to allocate function name");
+	if (!func_handle->name) {
+		do_warning("Failed to allocate function name");
+		free(func_handle);
+		return PEVENT_ERRNO__MEM_ALLOC_FAILED;
+	}
 
 	next_param = &(func_handle->params);
 	va_start(ap, name);
@@ -5109,11 +5117,17 @@ int pevent_register_print_function(struct pevent *pevent,
 			break;
 
 		if (type < 0 || type >= PEVENT_FUNC_ARG_MAX_TYPES) {
-			warning("Invalid argument type %d", type);
+			do_warning("Invalid argument type %d", type);
+			ret = PEVENT_ERRNO__INVALID_ARG_TYPE;
 			goto out_free;
 		}
 
-		param = malloc_or_die(sizeof(*param));
+		param = malloc(sizeof(*param));
+		if (!param) {
+			do_warning("Failed to allocate function param");
+			ret = PEVENT_ERRNO__MEM_ALLOC_FAILED;
+			goto out_free;
+		}
 		param->type = type;
 		param->next = NULL;
 
@@ -5131,7 +5145,7 @@ int pevent_register_print_function(struct pevent *pevent,
  out_free:
 	va_end(ap);
 	free_func_handle(func_handle);
-	return -1;
+	return ret;
 }
 
 /**
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 863a0bb..3318963 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -351,7 +351,8 @@ enum pevent_flag {
 	_PE(READ_ID_FAILED,	"failed to read event id"),		      \
 	_PE(READ_FORMAT_FAILED,	"failed to read event format"),		      \
 	_PE(READ_PRINT_FAILED,	"failed to read event print fmt"), 	      \
-	_PE(OLD_FTRACE_ARG_FAILED,"failed to allocate field name for ftrace")
+	_PE(OLD_FTRACE_ARG_FAILED,"failed to allocate field name for ftrace"),\
+	_PE(INVALID_ARG_TYPE,	"invalid argument type")
 
 #undef _PE
 #define _PE(__code, __str) PEVENT_ERRNO__ ## __code
-- 
1.7.9.2.358.g22243

