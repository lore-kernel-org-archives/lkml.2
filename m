Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048Ab0HBAOG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 20:14:06 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56235 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256Ab0HBANl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 20:13:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=Mu5cnQaXULfLwkCeDybF8XH8efylyoc1o8MLy/nyuoCb/yVKNXOTZmqA1XqyQM1cGB
         ENPtxcVqbSsXoZHaNEN2rM+dNq2dH2T7DnbG9Qjph+vjnnKB7ozVzyyBgtz759Yo+nab
         b0vU+CUbDjHjFLw8kJQIj0LSW5rB9a5Ui9N24=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Nikhil Rao <ncrao@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 09/12] perf, sched migration: Make the GUI class client agnostic
Date: Mon,  2 Aug 2010 02:13:10 +0200
Message-Id: <1280707993-6599-10-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1280707993-6599-1-git-send-regression-fweisbec@gmail.com>
References: <1280707993-6599-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the perf migration GUI generic so that it can be reused for
other kinds of trace painting. No more notion of CPUs or runqueue
from the GUI class, it's now used as a library by the trace parser.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Nikhil Rao <ncrao@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
---
 tools/perf/scripts/python/sched-migration.py |  177 +++++++++++++------------
 1 files changed, 92 insertions(+), 85 deletions(-)

diff --git a/tools/perf/scripts/python/sched-migration.py b/tools/perf/scripts/python/sched-migration.py
index 9d46377..6d7281a 100644
--- a/tools/perf/scripts/python/sched-migration.py
+++ b/tools/perf/scripts/python/sched-migration.py
@@ -28,11 +28,11 @@ from Core import *
 
 class RootFrame(wx.Frame):
 	Y_OFFSET = 100
-	CPU_HEIGHT = 100
-	CPU_SPACE = 50
+	RECT_HEIGHT = 100
+	RECT_SPACE = 50
 	EVENT_MARKING_WIDTH = 5
 
-	def __init__(self, timeslices, parent = None, id = -1, title = "Migration"):
+	def __init__(self, sched_tracer, title, parent = None, id = -1):
 		wx.Frame.__init__(self, parent, id, title)
 
 		(self.screen_width, self.screen_height) = wx.GetDisplaySize()
@@ -40,11 +40,12 @@ class RootFrame(wx.Frame):
 		self.screen_height -= 10
 		self.zoom = 0.5
 		self.scroll_scale = 20
-		self.timeslices = timeslices
-		(self.ts_start, self.ts_end) = timeslices.interval()
+		self.sched_tracer = sched_tracer
+		self.sched_tracer.set_root_win(self)
+		(self.ts_start, self.ts_end) = sched_tracer.interval()
 		self.update_width_virtual()
-		self.nr_cpus = timeslices.max_cpu() + 1
-		self.height_virtual = RootFrame.Y_OFFSET + (self.nr_cpus * (RootFrame.CPU_HEIGHT + RootFrame.CPU_SPACE))
+		self.nr_rects = sched_tracer.nr_rectangles() + 1
+		self.height_virtual = RootFrame.Y_OFFSET + (self.nr_rects * (RootFrame.RECT_HEIGHT + RootFrame.RECT_SPACE))
 
 		# whole window panel
 		self.panel = wx.Panel(self, size=(self.screen_width, self.screen_height))
@@ -87,69 +88,38 @@ class RootFrame(wx.Frame):
 		(x, y) = self.scroll_start()
 		return self.px_to_us(x)
 
-	def update_rectangle_cpu(self, dc, slice, cpu, offset_time):
-		rq = slice.rqs[cpu]
-
-		if slice.total_load != 0:
-			load_rate = rq.load() / float(slice.total_load)
-		else:
-			load_rate = 0
+	def paint_rectangle_zone(self, nr, color, top_color, start, end):
+		offset_px = self.us_to_px(start - self.ts_start)
+		width_px = self.us_to_px(end - self.ts_start)
 
+		offset_py = RootFrame.Y_OFFSET + (nr * (RootFrame.RECT_HEIGHT + RootFrame.RECT_SPACE))
+		width_py = RootFrame.RECT_HEIGHT
 
-		offset_px = self.us_to_px(slice.start - offset_time)
-		width_px = self.us_to_px(slice.end - slice.start)
-		(x, y) = self.scroll_start()
+		dc = self.dc
 
-		if width_px == 0:
-			return
+		if top_color is not None:
+			(r, g, b) = top_color
+			top_color = wx.Colour(r, g, b)
+			brush = wx.Brush(top_color, wx.SOLID)
+			dc.SetBrush(brush)
+			dc.DrawRectangle(offset_px, offset_py, width_px, RootFrame.EVENT_MARKING_WIDTH)
+			width_py -= RootFrame.EVENT_MARKING_WIDTH
+			offset_py += RootFrame.EVENT_MARKING_WIDTH
 
-		offset_py = RootFrame.Y_OFFSET + (cpu * (RootFrame.CPU_HEIGHT + RootFrame.CPU_SPACE))
-		width_py = RootFrame.CPU_HEIGHT
-
-		if cpu in slice.event_cpus:
-			rgb = rq.event.color()
-			if rgb is not None:
-				(r, g, b) = rgb
-				color = wx.Colour(r, g, b)
-				brush = wx.Brush(color, wx.SOLID)
-				dc.SetBrush(brush)
-				dc.DrawRectangle(offset_px, offset_py, width_px, RootFrame.EVENT_MARKING_WIDTH)
-				width_py -= RootFrame.EVENT_MARKING_WIDTH
-				offset_py += RootFrame.EVENT_MARKING_WIDTH
-
-		red_power = int(0xff - (0xff * load_rate))
-		color = wx.Colour(0xff, red_power, red_power)
+		(r ,g, b) = color
+		color = wx.Colour(r, g, b)
 		brush = wx.Brush(color, wx.SOLID)
 		dc.SetBrush(brush)
 		dc.DrawRectangle(offset_px, offset_py, width_px, width_py)
 
 	def update_rectangles(self, dc, start, end):
-		if len(self.timeslices) == 0:
-			return
-		start += self.timeslices[0].start
-		end += self.timeslices[0].start
-
-		color = wx.Colour(0, 0, 0)
-		brush = wx.Brush(color, wx.SOLID)
-		dc.SetBrush(brush)
-
-		i = self.timeslices.find_time_slice(start)
-		if i == -1:
-			return
-
-		for i in xrange(i, len(self.timeslices)):
-			timeslice = self.timeslices[i]
-			if timeslice.start > end:
-				return
-
-			for cpu in timeslice.rqs:
-				self.update_rectangle_cpu(dc, timeslice, cpu, self.timeslices[0].start)
+		start += self.ts_start
+		end += self.ts_start
+		self.sched_tracer.fill_zone(start, end)
 
 	def on_paint(self, event):
-		color = wx.Colour(0xff, 0xff, 0xff)
-		brush = wx.Brush(color, wx.SOLID)
 		dc = wx.PaintDC(self.scroll_panel)
-		dc.SetBrush(brush)
+		self.dc = dc
 
 		width = min(self.width_virtual, self.screen_width)
 		(x, y) = self.scroll_start()
@@ -157,45 +127,31 @@ class RootFrame(wx.Frame):
 		end = self.px_to_us(x + width)
 		self.update_rectangles(dc, start, end)
 
-	def cpu_from_ypixel(self, y):
+	def rect_from_ypixel(self, y):
 		y -= RootFrame.Y_OFFSET
-		cpu = y / (RootFrame.CPU_HEIGHT + RootFrame.CPU_SPACE)
-		height = y % (RootFrame.CPU_HEIGHT + RootFrame.CPU_SPACE)
+		rect = y / (RootFrame.RECT_HEIGHT + RootFrame.RECT_SPACE)
+		height = y % (RootFrame.RECT_HEIGHT + RootFrame.RECT_SPACE)
 
-		if cpu < 0 or cpu > self.nr_cpus - 1 or height > RootFrame.CPU_HEIGHT:
+		if rect < 0 or rect > self.nr_rects - 1 or height > RootFrame.RECT_HEIGHT:
 			return -1
 
-		return cpu
-
-	def update_summary(self, cpu, t):
-		idx = self.timeslices.find_time_slice(t)
-		if idx == -1:
-			return
-
-		ts = self.timeslices[idx]
-		rq = ts.rqs[cpu]
-		raw = "CPU: %d\n" % cpu
-		raw += "Last event : %s\n" % rq.event.__repr__()
-		raw += "Timestamp : %d.%06d\n" % (ts.start / (10 ** 9), (ts.start % (10 ** 9)) / 1000)
-		raw += "Duration : %6d us\n" % ((ts.end - ts.start) / (10 ** 6))
-		raw += "Load = %d\n" % rq.load()
-		for t in rq.tasks:
-			raw += "%s \n" % thread_name(t)
+		return rect
 
+	def update_summary(self, txt):
 		if self.txt:
 			self.txt.Destroy()
-		self.txt = wx.StaticText(self.panel, -1, raw, (0, (self.screen_height / 2) + 50))
+		self.txt = wx.StaticText(self.panel, -1, txt, (0, (self.screen_height / 2) + 50))
 
 
 	def on_mouse_down(self, event):
 		(x, y) = event.GetPositionTuple()
-		cpu = self.cpu_from_ypixel(y)
-		if cpu == -1:
+		rect = self.rect_from_ypixel(y)
+		if rect == -1:
 			return
 
-		t = self.px_to_us(x) + self.timeslices[0].start
+		t = self.px_to_us(x) + self.ts_start
 
-		self.update_summary(cpu, t)
+		self.sched_tracer.mouse_down(rect, t)
 
 
 	def update_width_virtual(self):
@@ -501,13 +457,64 @@ class TimeSliceList(UserList):
 
 		return found
 
+	def set_root_win(self, win):
+		self.root_win = win
+
+	def mouse_down(self, cpu, t):
+		idx = self.find_time_slice(t)
+		if idx == -1:
+			return
+
+		ts = self[idx]
+		rq = ts.rqs[cpu]
+		raw = "CPU: %d\n" % cpu
+		raw += "Last event : %s\n" % rq.event.__repr__()
+		raw += "Timestamp : %d.%06d\n" % (ts.start / (10 ** 9), (ts.start % (10 ** 9)) / 1000)
+		raw += "Duration : %6d us\n" % ((ts.end - ts.start) / (10 ** 6))
+		raw += "Load = %d\n" % rq.load()
+		for t in rq.tasks:
+			raw += "%s \n" % thread_name(t)
+
+		self.root_win.update_summary(raw)
+
+	def update_rectangle_cpu(self, slice, cpu):
+		rq = slice.rqs[cpu]
+
+		if slice.total_load != 0:
+			load_rate = rq.load() / float(slice.total_load)
+		else:
+			load_rate = 0
+
+		red_power = int(0xff - (0xff * load_rate))
+		color = (0xff, red_power, red_power)
+
+		top_color = None
+
+		if cpu in slice.event_cpus:
+			top_color = rq.event.color()
+
+		self.root_win.paint_rectangle_zone(cpu, color, top_color, slice.start, slice.end)
+
+	def fill_zone(self, start, end):
+		i = self.find_time_slice(start)
+		if i == -1:
+			return
+
+		for i in xrange(i, len(self.data)):
+			timeslice = self.data[i]
+			if timeslice.start > end:
+				return
+
+			for cpu in timeslice.rqs:
+				self.update_rectangle_cpu(timeslice, cpu)
+
 	def interval(self):
 		if len(self.data) == 0:
 			return (0, 0)
 
 		return (self.data[0].start, self.data[-1].end)
 
-	def max_cpu(self):
+	def nr_rectangles(self):
 		last_ts = self.data[-1]
 		max_cpu = 0
 		for cpu in last_ts.rqs:
@@ -557,7 +564,7 @@ def trace_begin():
 def trace_end():
 	app = wx.App(False)
 	timeslices = parser.timeslices
-	frame = RootFrame(timeslices)
+	frame = RootFrame(timeslices, "Migration")
 	app.MainLoop()
 
 def sched__sched_stat_runtime(event_name, context, common_cpu,
-- 
1.6.2.3

