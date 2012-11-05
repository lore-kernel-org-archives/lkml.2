Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667Ab2KEPu6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 10:50:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12183 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580Ab2KEPu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 10:50:56 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 4/4] perf tests: Removing 'optional' field
Date: Mon,  5 Nov 2012 16:49:39 +0100
Message-Id: <1352130579-13451-5-git-send-email-jolsa@redhat.com>
In-Reply-To: <1352130579-13451-1-git-send-email-jolsa@redhat.com>
References: <1352130579-13451-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we allow multiple values in event field assignment, there's
no need for 'optional' field.. old version removal leftover.

Adding some comments into attr.py script regarding the test
event load.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/tests/attr.c           |  2 --
 tools/perf/tests/attr.py          | 29 ++++++++++++++++++-----------
 tools/perf/tests/attr/base-record |  1 -
 tools/perf/tests/attr/base-stat   |  1 -
 4 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/tools/perf/tests/attr.c b/tools/perf/tests/attr.c
index 6fa84b7..6e2feee 100644
--- a/tools/perf/tests/attr.c
+++ b/tools/perf/tests/attr.c
@@ -126,8 +126,6 @@ static int store_event(struct perf_event_attr *attr, pid_t pid, int cpu,
 	WRITE_ASS(sample_regs_user,   "llu");
 	WRITE_ASS(sample_stack_user,  PRIu32);
 
-	__WRITE_ASS(optional, "d", 0);
-
 	fclose(file);
 	return 0;
 }
diff --git a/tools/perf/tests/attr.py b/tools/perf/tests/attr.py
index 28c0481..9b25b33c 100644
--- a/tools/perf/tests/attr.py
+++ b/tools/perf/tests/attr.py
@@ -75,6 +75,7 @@ class Event(dict):
         self.add(data)
 
     def compare_data(self, a, b):
+        # Allow multiple values in assignment separated by '|'
         a_list = a.split('|')
         b_list = b.split('|')
 
@@ -96,12 +97,17 @@ class Event(dict):
                 return False
         return True
 
-    def is_optional(self):
-        if self['optional'] == '1':
-            return True
-        else:
-            return False
-
+# Test file description needs to have following sections:
+# [config]
+#   - just single instance in file
+#   - needs to specify:
+#     'command' - perf command name
+#     'args'    - special command arguments
+#     'ret'     - expected command return value (0 by default)
+#
+# [eventX:base]
+#   - one or multiple instances in file
+#   - expected values assignments
 class Test(object):
     def __init__(self, path, options):
         parser = ConfigParser.SafeConfigParser()
@@ -135,11 +141,15 @@ class Test(object):
         parser_event = ConfigParser.SafeConfigParser()
         parser_event.read(path)
 
+        # The event record section header contains 'event' word,
+        # optionaly followed by ':' allowing to load 'parent
+        # event' first as a base
         for section in filter(self.is_event, parser_event.sections()):
 
             parser_items = parser_event.items(section);
             base_items   = {}
 
+            # Read parent event if there's any
             if (':' in section):
                 base = section[section.index(':') + 1:]
                 parser_base = ConfigParser.SafeConfigParser()
@@ -177,11 +187,10 @@ class Test(object):
                 else:
                     log.debug("    ->FAIL");
 
-            log.info("    match: [%s] optional(%d) matches %s" %
-                      (exp_name, exp_event.is_optional(), str(exp_list)))
+            log.info("    match: [%s] matches %s" % (exp_name, str(exp_list)))
 
             # we did not any matching event - fail
-            if (not exp_list) and (not exp_event.is_optional()):
+            if (not exp_list):
                 raise Fail(self, 'match failure');
 
             match[exp_name] = exp_list
@@ -194,8 +203,6 @@ class Test(object):
             if (group == ''):
                 continue
 
-            # XXX group matching does not account for
-            # optional events as above matching does
             for res_name in match[exp_name]:
                 res_group = result[res_name].group
                 if res_group not in match[group]:
diff --git a/tools/perf/tests/attr/base-record b/tools/perf/tests/attr/base-record
index 8262794..f1485d8 100644
--- a/tools/perf/tests/attr/base-record
+++ b/tools/perf/tests/attr/base-record
@@ -37,4 +37,3 @@ config2=0
 branch_sample_type=0
 sample_regs_user=0
 sample_stack_user=0
-optional=0
diff --git a/tools/perf/tests/attr/base-stat b/tools/perf/tests/attr/base-stat
index 46f8851..4bd79a8 100644
--- a/tools/perf/tests/attr/base-stat
+++ b/tools/perf/tests/attr/base-stat
@@ -37,4 +37,3 @@ config2=0
 branch_sample_type=0
 sample_regs_user=0
 sample_stack_user=0
-optional=0
-- 
1.7.11.7

