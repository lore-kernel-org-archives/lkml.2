Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495Ab0HBAN7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 20:13:59 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39282 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148Ab0HBAN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 20:13:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=HarKz8FZ45wxen0dDD1X+IuBmJlwhjjGEELmQiQ2VXU58yJV9W+/vP3cBkhY6nfwuG
         YBm2tZQwn56QV4qFssqWJ6yUBmMcXd177RjrxNjCJuJDPF4c58wbFR3HIkRgjwqgAWl8
         5BVPcCTlQvGcUycdIRpYVVfJpZXe6wxpiy6zY=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Nikhil Rao <ncrao@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 04/12] perf, sched migration: Handle ignored migrate out events
Date: Mon,  2 Aug 2010 02:13:05 +0200
Message-Id: <1280707993-6599-5-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1280707993-6599-1-git-send-regression-fweisbec@gmail.com>
References: <1280707993-6599-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Migrate out events may happen on tasks that are not in the
runqueue, for example this is the case for tasks that are
sleeping. In this case, we don't want to log the migrate out
event in the source runqueue because the task is not eventually
in the runqueue and we have already logged its sleep event.

This fixes timeslices that spuriously propagate a sleep event
from the previous timeslice.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Nikhil Rao <ncrao@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
---
 tools/perf/scripts/python/sched-migration.py |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/tools/perf/scripts/python/sched-migration.py b/tools/perf/scripts/python/sched-migration.py
index f73e1c7..7304d86 100644
--- a/tools/perf/scripts/python/sched-migration.py
+++ b/tools/perf/scripts/python/sched-migration.py
@@ -435,7 +435,10 @@ class TimeSlice:
 		self.__update_total_load(new_rq, in_rq)
 
 		ts_list.append(self)
-		self.event_cpus = [old_cpu, new_cpu]
+
+		if old_rq is not out_rq:
+			self.event_cpus.append(old_cpu)
+		self.event_cpus.append(new_cpu)
 
 	def wake_up(self, ts_list, pid, cpu, fork):
 		old_rq = self.prev.rqs[cpu]
-- 
1.6.2.3

