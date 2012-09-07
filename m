Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932928Ab2IGC5L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 22:57:11 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:57681 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932565Ab2IGC5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 22:57:10 -0400
X-AuditID: 9c930179-b7cc4ae00000134d-ff-5049628087ed
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 3/3] tools lib traceevent: Get rid of die() from pevent_register_print_function
Date: Fri,  7 Sep 2012 11:49:47 +0900
Message-Id: <1346986187-5170-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1346986187-5170-1-git-send-email-namhyung@kernel.org>
References: <1346986187-5170-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

If memory allocation for handler fails or argument type is not match,
return gracefully instead of calling die().  Also add an new error
code for the later case.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/event-parse.c | 26 ++++++++++++++++++++------
 tools/lib/traceevent/event-parse.h |  3 ++-
 2 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 17fd01d46e60..4595aeb3c432 100644
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
index 863a0bbda7f1..3318963f1c98 100644
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
1.7.11.4

