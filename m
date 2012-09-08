Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217Ab2IHLlN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 07:41:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39523 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572Ab2IHLlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 07:41:10 -0400
Date: Sat, 8 Sep 2012 04:40:50 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-67ed939c9eb029c28057eb75de456a9d0e899fd4@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de
In-Reply-To: <1346986187-5170-3-git-send-email-namhyung@kernel.org>
References: <1346986187-5170-3-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent: Get rid of die()
  from pevent_register_print_function
Git-Commit-ID: 67ed939c9eb029c28057eb75de456a9d0e899fd4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 08 Sep 2012 04:40:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  67ed939c9eb029c28057eb75de456a9d0e899fd4
Gitweb:     http://git.kernel.org/tip/67ed939c9eb029c28057eb75de456a9d0e899fd4
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Fri, 7 Sep 2012 11:49:47 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 7 Sep 2012 12:15:31 -0300

tools lib traceevent: Get rid of die() from pevent_register_print_function

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
