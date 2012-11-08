Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238Ab2KHQCa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 11:02:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36054 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464Ab2KHQC3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 11:02:29 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH] perf tests: Move attr.py temp dir cleanup into finally section
Date: Thu,  8 Nov 2012 17:01:01 +0100
Message-Id: <1352390461-15404-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently if there's 'Unsup' exception raised, we do not clean
up the temp directory. Solving this by adding 'finally' to
make the cleanup in any case.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/attr.py | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/tools/perf/tests/attr.py b/tools/perf/tests/attr.py
index 9b25b33c..e702b82 100644
--- a/tools/perf/tests/attr.py
+++ b/tools/perf/tests/attr.py
@@ -228,24 +228,26 @@ class Test(object):
     def run(self):
         tempdir = tempfile.mkdtemp();
 
-        # run the test script
-        self.run_cmd(tempdir);
+        try:
+            # run the test script
+            self.run_cmd(tempdir);
 
-        # load events expectation for the test
-        log.info("  loading result events");
-        for f in glob.glob(tempdir + '/event*'):
-            self.load_events(f, self.result);
+            # load events expectation for the test
+            log.info("  loading result events");
+            for f in glob.glob(tempdir + '/event*'):
+                self.load_events(f, self.result);
 
-        # resolve group_fd to event names
-        self.resolve_groups(self.expect);
-        self.resolve_groups(self.result);
+            # resolve group_fd to event names
+            self.resolve_groups(self.expect);
+            self.resolve_groups(self.result);
 
-        # do the expectation - results matching - both ways
-        self.compare(self.expect, self.result)
-        self.compare(self.result, self.expect)
+            # do the expectation - results matching - both ways
+            self.compare(self.expect, self.result)
+            self.compare(self.result, self.expect)
 
-        # cleanup
-        shutil.rmtree(tempdir)
+        finally:
+            # cleanup
+            shutil.rmtree(tempdir)
 
 
 def run_tests(options):
-- 
1.7.11.7

