Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598Ab0HBAOK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 20:14:10 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56235 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287Ab0HBANq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 20:13:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=lkON0YaFZTrMrRVK947O+70dSjKFa3YkletnldRAjjRVoO3kJOcHhZxLh5+TGD9IB3
         Wu01kuUZ7tjd/q3cqOi3GHwVUqYrT3gdyyx8m3mHsWmMCMp7ZQmXdNjX+HbdK4RsNsSU
         BYBpA8C+gNSSAlAos+Jf2eWNMSTcH3jO3hIw0=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Nikhil Rao <ncrao@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 11/12] perf, sched migration: Librarize task states and event headers helpers
Date: Mon,  2 Aug 2010 02:13:12 +0200
Message-Id: <1280707993-6599-12-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1280707993-6599-1-git-send-regression-fweisbec@gmail.com>
References: <1280707993-6599-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Librarize the task state and event headers helpers as they can
be generally useful.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Nikhil Rao <ncrao@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
---
 .../python/Perf-Trace-Util/lib/Perf/Trace/Core.py  |   30 ++++++++++++++++++++
 tools/perf/scripts/python/sched-migration.py       |   30 --------------------
 2 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/Core.py b/tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/Core.py
index 1dc464e..aad7525 100644
--- a/tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/Core.py
+++ b/tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/Core.py
@@ -89,3 +89,33 @@ def trace_flag_str(value):
 	    value &= ~idx
 
     return string
+
+
+def taskState(state):
+	states = {
+		0 : "R",
+		1 : "S",
+		2 : "D",
+		64: "DEAD"
+	}
+
+	if state not in states:
+		return "Unknown"
+
+	return states[state]
+
+
+class EventHeaders:
+	def __init__(self, common_cpu, common_secs, common_nsecs,
+		     common_pid, common_comm):
+		self.cpu = common_cpu
+		self.secs = common_secs
+		self.nsecs = common_nsecs
+		self.pid = common_pid
+		self.comm = common_comm
+
+	def ts(self):
+		return (self.secs * (10 ** 9)) + self.nsecs
+
+	def ts_format(self):
+		return "%d.%d" % (self.secs, int(self.nsecs / 1000))
diff --git a/tools/perf/scripts/python/sched-migration.py b/tools/perf/scripts/python/sched-migration.py
index 9834630..b934383 100644
--- a/tools/perf/scripts/python/sched-migration.py
+++ b/tools/perf/scripts/python/sched-migration.py
@@ -31,36 +31,6 @@ threads = { 0 : "idle"}
 def thread_name(pid):
 	return "%s:%d" % (threads[pid], pid)
 
-class EventHeaders:
-	def __init__(self, common_cpu, common_secs, common_nsecs,
-		     common_pid, common_comm):
-		self.cpu = common_cpu
-		self.secs = common_secs
-		self.nsecs = common_nsecs
-		self.pid = common_pid
-		self.comm = common_comm
-
-	def ts(self):
-		return (self.secs * (10 ** 9)) + self.nsecs
-
-	def ts_format(self):
-		return "%d.%d" % (self.secs, int(self.nsecs / 1000))
-
-
-def taskState(state):
-	states = {
-		0 : "R",
-		1 : "S",
-		2 : "D",
-		64: "DEAD"
-	}
-
-	if state not in states:
-		return "Unknown"
-
-	return states[state]
-
-
 class RunqueueEventUnknown:
 	@staticmethod
 	def color():
-- 
1.6.2.3

