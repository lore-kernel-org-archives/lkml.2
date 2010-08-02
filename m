Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465Ab0HBAN5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 20:13:57 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56235 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251Ab0HBANg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 20:13:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=MxK1Q2bwLvqZRVyS1t3yaPVGY0LIWEdl+flXYw9MK8eG1Ja8GdGS0U1xTDbJnRf2oH
         2pFHZnk3MmgRhwSkHchfk9cXzjFpz4W0reiAb2B2dvEZ+ANoSR+68mdcGNWnQ2/uTYZM
         qH9seYdoz/ycZysBdU6yjDQmQDv34kV/bxQlE=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Nikhil Rao <ncrao@google.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Tom Zanussi <tzanussi@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 07/12] perf, sched migration: Parameterize cpu height and spacing
Date: Mon,  2 Aug 2010 02:13:08 +0200
Message-Id: <1280707993-6599-8-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1280707993-6599-1-git-send-regression-fweisbec@gmail.com>
References: <1280707993-6599-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nikhil Rao <ncrao@google.com>

Without vertical zoom, it is not possible to see all CPUs in a trace
taken on a larger machine. This patch parameterizes the height and
spacing of CPUs so that you can fit more cpus into the screen.

Ideally we should dynamically size/space the CPU rectangles with some
minimum threshold. Until then, this patch is a stop-gap.

Signed-off-by: Nikhil Rao <ncrao@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/scripts/python/sched-migration.py |   23 ++++++++++++++---------
 1 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/tools/perf/scripts/python/sched-migration.py b/tools/perf/scripts/python/sched-migration.py
index 8b8fb7c..d902668 100644
--- a/tools/perf/scripts/python/sched-migration.py
+++ b/tools/perf/scripts/python/sched-migration.py
@@ -27,6 +27,11 @@ from perf_trace_context import *
 from Core import *
 
 class RootFrame(wx.Frame):
+	Y_OFFSET = 100
+	CPU_HEIGHT = 100
+	CPU_SPACE = 50
+	EVENT_MARKING_WIDTH = 5
+
 	def __init__(self, timeslices, parent = None, id = -1, title = "Migration"):
 		wx.Frame.__init__(self, parent, id, title)
 
@@ -97,8 +102,8 @@ class RootFrame(wx.Frame):
 		if width_px == 0:
 			return
 
-		offset_py = 100 + (cpu * 150)
-		width_py = 100
+		offset_py = RootFrame.Y_OFFSET + (cpu * (RootFrame.CPU_HEIGHT + RootFrame.CPU_SPACE))
+		width_py = RootFrame.CPU_HEIGHT
 
 		if cpu in slice.event_cpus:
 			rgb = rq.event.color()
@@ -107,9 +112,9 @@ class RootFrame(wx.Frame):
 				color = wx.Colour(r, g, b)
 				brush = wx.Brush(color, wx.SOLID)
 				dc.SetBrush(brush)
-				dc.DrawRectangle(offset_px, offset_py, width_px, 5)
-				width_py -= 5
-				offset_py += 5
+				dc.DrawRectangle(offset_px, offset_py, width_px, RootFrame.EVENT_MARKING_WIDTH)
+				width_py -= RootFrame.EVENT_MARKING_WIDTH
+				offset_py += RootFrame.EVENT_MARKING_WIDTH
 
 		red_power = int(0xff - (0xff * load_rate))
 		color = wx.Colour(0xff, red_power, red_power)
@@ -154,11 +159,11 @@ class RootFrame(wx.Frame):
 		self.update_rectangles(dc, start, end)
 
 	def cpu_from_ypixel(self, y):
-		y -= 100
-		cpu = y / 150
-		height = y % 150
+		y -= RootFrame.Y_OFFSET
+		cpu = y / (RootFrame.CPU_HEIGHT + RootFrame.CPU_SPACE)
+		height = y % (RootFrame.CPU_HEIGHT + RootFrame.CPU_SPACE)
 
-		if cpu < 0 or cpu > self.max_cpu or height > 100:
+		if cpu < 0 or cpu > self.max_cpu or height > RootFrame.CPU_HEIGHT:
 			return -1
 
 		return cpu
-- 
1.6.2.3

