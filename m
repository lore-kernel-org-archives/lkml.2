Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470Ab0HBAPt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 20:15:49 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39282 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024Ab0HBANo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 20:13:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=FY0NzD5rSJEa3/859yRCI36GAjmiY+BNhmHw82hwpeUTsl+ogutGl7fkm4wu9k8tNl
         1REGSR/nmkByNY/GOHSIUI+fJA+xlzORKUojcv/DokCAL38dUrHn4Pf+qkXNvmJSWrhG
         SqvKY5vHRJwIeWNOC5SA+ZP6SxP74i3nA9MDo=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Nikhil Rao <ncrao@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 10/12] perf, sched migration: Librarize the GUI class
Date: Mon,  2 Aug 2010 02:13:11 +0200
Message-Id: <1280707993-6599-11-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1280707993-6599-1-git-send-regression-fweisbec@gmail.com>
References: <1280707993-6599-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export the GUI facility in the common library path. It is
going to be useful for other scheduler views.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Nikhil Rao <ncrao@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
---
 .../Perf-Trace-Util/lib/Perf/Trace/SchedGui.py     |  184 ++++++++++++++++++++
 tools/perf/scripts/python/sched-migration.py       |  180 +-------------------
 2 files changed, 189 insertions(+), 175 deletions(-)
 create mode 100644 tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/SchedGui.py

diff --git a/tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/SchedGui.py b/tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/SchedGui.py
new file mode 100644
index 0000000..ae9a56e
--- /dev/null
+++ b/tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/SchedGui.py
@@ -0,0 +1,184 @@
+# SchedGui.py - Python extension for perf trace, basic GUI code for
+#		traces drawing and overview.
+#
+# Copyright (C) 2010 by Frederic Weisbecker <fweisbec@gmail.com>
+#
+# This software is distributed under the terms of the GNU General
+# Public License ("GPL") version 2 as published by the Free Software
+# Foundation.
+
+
+try:
+	import wx
+except ImportError:
+	raise ImportError, "You need to install the wxpython lib for this script"
+
+
+class RootFrame(wx.Frame):
+	Y_OFFSET = 100
+	RECT_HEIGHT = 100
+	RECT_SPACE = 50
+	EVENT_MARKING_WIDTH = 5
+
+	def __init__(self, sched_tracer, title, parent = None, id = -1):
+		wx.Frame.__init__(self, parent, id, title)
+
+		(self.screen_width, self.screen_height) = wx.GetDisplaySize()
+		self.screen_width -= 10
+		self.screen_height -= 10
+		self.zoom = 0.5
+		self.scroll_scale = 20
+		self.sched_tracer = sched_tracer
+		self.sched_tracer.set_root_win(self)
+		(self.ts_start, self.ts_end) = sched_tracer.interval()
+		self.update_width_virtual()
+		self.nr_rects = sched_tracer.nr_rectangles() + 1
+		self.height_virtual = RootFrame.Y_OFFSET + (self.nr_rects * (RootFrame.RECT_HEIGHT + RootFrame.RECT_SPACE))
+
+		# whole window panel
+		self.panel = wx.Panel(self, size=(self.screen_width, self.screen_height))
+
+		# scrollable container
+		self.scroll = wx.ScrolledWindow(self.panel)
+		self.scroll.SetScrollbars(self.scroll_scale, self.scroll_scale, self.width_virtual / self.scroll_scale, self.height_virtual / self.scroll_scale)
+		self.scroll.EnableScrolling(True, True)
+		self.scroll.SetFocus()
+
+		# scrollable drawing area
+		self.scroll_panel = wx.Panel(self.scroll, size=(self.screen_width - 15, self.screen_height / 2))
+		self.scroll_panel.Bind(wx.EVT_PAINT, self.on_paint)
+		self.scroll_panel.Bind(wx.EVT_KEY_DOWN, self.on_key_press)
+		self.scroll_panel.Bind(wx.EVT_LEFT_DOWN, self.on_mouse_down)
+		self.scroll.Bind(wx.EVT_PAINT, self.on_paint)
+		self.scroll.Bind(wx.EVT_KEY_DOWN, self.on_key_press)
+		self.scroll.Bind(wx.EVT_LEFT_DOWN, self.on_mouse_down)
+
+		self.scroll.Fit()
+		self.Fit()
+
+		self.scroll_panel.SetDimensions(-1, -1, self.width_virtual, self.height_virtual, wx.SIZE_USE_EXISTING)
+
+		self.txt = None
+
+		self.Show(True)
+
+	def us_to_px(self, val):
+		return val / (10 ** 3) * self.zoom
+
+	def px_to_us(self, val):
+		return (val / self.zoom) * (10 ** 3)
+
+	def scroll_start(self):
+		(x, y) = self.scroll.GetViewStart()
+		return (x * self.scroll_scale, y * self.scroll_scale)
+
+	def scroll_start_us(self):
+		(x, y) = self.scroll_start()
+		return self.px_to_us(x)
+
+	def paint_rectangle_zone(self, nr, color, top_color, start, end):
+		offset_px = self.us_to_px(start - self.ts_start)
+		width_px = self.us_to_px(end - self.ts_start)
+
+		offset_py = RootFrame.Y_OFFSET + (nr * (RootFrame.RECT_HEIGHT + RootFrame.RECT_SPACE))
+		width_py = RootFrame.RECT_HEIGHT
+
+		dc = self.dc
+
+		if top_color is not None:
+			(r, g, b) = top_color
+			top_color = wx.Colour(r, g, b)
+			brush = wx.Brush(top_color, wx.SOLID)
+			dc.SetBrush(brush)
+			dc.DrawRectangle(offset_px, offset_py, width_px, RootFrame.EVENT_MARKING_WIDTH)
+			width_py -= RootFrame.EVENT_MARKING_WIDTH
+			offset_py += RootFrame.EVENT_MARKING_WIDTH
+
+		(r ,g, b) = color
+		color = wx.Colour(r, g, b)
+		brush = wx.Brush(color, wx.SOLID)
+		dc.SetBrush(brush)
+		dc.DrawRectangle(offset_px, offset_py, width_px, width_py)
+
+	def update_rectangles(self, dc, start, end):
+		start += self.ts_start
+		end += self.ts_start
+		self.sched_tracer.fill_zone(start, end)
+
+	def on_paint(self, event):
+		dc = wx.PaintDC(self.scroll_panel)
+		self.dc = dc
+
+		width = min(self.width_virtual, self.screen_width)
+		(x, y) = self.scroll_start()
+		start = self.px_to_us(x)
+		end = self.px_to_us(x + width)
+		self.update_rectangles(dc, start, end)
+
+	def rect_from_ypixel(self, y):
+		y -= RootFrame.Y_OFFSET
+		rect = y / (RootFrame.RECT_HEIGHT + RootFrame.RECT_SPACE)
+		height = y % (RootFrame.RECT_HEIGHT + RootFrame.RECT_SPACE)
+
+		if rect < 0 or rect > self.nr_rects - 1 or height > RootFrame.RECT_HEIGHT:
+			return -1
+
+		return rect
+
+	def update_summary(self, txt):
+		if self.txt:
+			self.txt.Destroy()
+		self.txt = wx.StaticText(self.panel, -1, txt, (0, (self.screen_height / 2) + 50))
+
+
+	def on_mouse_down(self, event):
+		(x, y) = event.GetPositionTuple()
+		rect = self.rect_from_ypixel(y)
+		if rect == -1:
+			return
+
+		t = self.px_to_us(x) + self.ts_start
+
+		self.sched_tracer.mouse_down(rect, t)
+
+
+	def update_width_virtual(self):
+		self.width_virtual = self.us_to_px(self.ts_end - self.ts_start)
+
+	def __zoom(self, x):
+		self.update_width_virtual()
+		(xpos, ypos) = self.scroll.GetViewStart()
+		xpos = self.us_to_px(x) / self.scroll_scale
+		self.scroll.SetScrollbars(self.scroll_scale, self.scroll_scale, self.width_virtual / self.scroll_scale, self.height_virtual / self.scroll_scale, xpos, ypos)
+		self.Refresh()
+
+	def zoom_in(self):
+		x = self.scroll_start_us()
+		self.zoom *= 2
+		self.__zoom(x)
+
+	def zoom_out(self):
+		x = self.scroll_start_us()
+		self.zoom /= 2
+		self.__zoom(x)
+
+
+	def on_key_press(self, event):
+		key = event.GetRawKeyCode()
+		if key == ord("+"):
+			self.zoom_in()
+			return
+		if key == ord("-"):
+			self.zoom_out()
+			return
+
+		key = event.GetKeyCode()
+		(x, y) = self.scroll.GetViewStart()
+		if key == wx.WXK_RIGHT:
+			self.scroll.Scroll(x + 1, y)
+		elif key == wx.WXK_LEFT:
+			self.scroll.Scroll(x - 1, y)
+		elif key == wx.WXK_DOWN:
+			self.scroll.Scroll(x, y + 1)
+		elif key == wx.WXK_UP:
+			self.scroll.Scroll(x, y - 1)
diff --git a/tools/perf/scripts/python/sched-migration.py b/tools/perf/scripts/python/sched-migration.py
index 6d7281a..9834630 100644
--- a/tools/perf/scripts/python/sched-migration.py
+++ b/tools/perf/scripts/python/sched-migration.py
@@ -6,14 +6,11 @@
 #
 # perf trace event handlers have been generated by perf trace -g python
 #
-# The whole is licensed under the terms of the GNU GPL License version 2
+# This software is distributed under the terms of the GNU General
+# Public License ("GPL") version 2 as published by the Free Software
+# Foundation.
 
 
-try:
-	import wx
-except ImportError:
-	raise ImportError, "You need to install the wxpython lib for this script"
-
 import os
 import sys
 
@@ -22,178 +19,11 @@ from UserList import UserList
 
 sys.path.append(os.environ['PERF_EXEC_PATH'] + \
 	'/scripts/python/Perf-Trace-Util/lib/Perf/Trace')
+sys.path.append('scripts/python/Perf-Trace-Util/lib/Perf/Trace')
 
 from perf_trace_context import *
 from Core import *
-
-class RootFrame(wx.Frame):
-	Y_OFFSET = 100
-	RECT_HEIGHT = 100
-	RECT_SPACE = 50
-	EVENT_MARKING_WIDTH = 5
-
-	def __init__(self, sched_tracer, title, parent = None, id = -1):
-		wx.Frame.__init__(self, parent, id, title)
-
-		(self.screen_width, self.screen_height) = wx.GetDisplaySize()
-		self.screen_width -= 10
-		self.screen_height -= 10
-		self.zoom = 0.5
-		self.scroll_scale = 20
-		self.sched_tracer = sched_tracer
-		self.sched_tracer.set_root_win(self)
-		(self.ts_start, self.ts_end) = sched_tracer.interval()
-		self.update_width_virtual()
-		self.nr_rects = sched_tracer.nr_rectangles() + 1
-		self.height_virtual = RootFrame.Y_OFFSET + (self.nr_rects * (RootFrame.RECT_HEIGHT + RootFrame.RECT_SPACE))
-
-		# whole window panel
-		self.panel = wx.Panel(self, size=(self.screen_width, self.screen_height))
-
-		# scrollable container
-		self.scroll = wx.ScrolledWindow(self.panel)
-		self.scroll.SetScrollbars(self.scroll_scale, self.scroll_scale, self.width_virtual / self.scroll_scale, self.height_virtual / self.scroll_scale)
-		self.scroll.EnableScrolling(True, True)
-		self.scroll.SetFocus()
-
-		# scrollable drawing area
-		self.scroll_panel = wx.Panel(self.scroll, size=(self.screen_width - 15, self.screen_height / 2))
-		self.scroll_panel.Bind(wx.EVT_PAINT, self.on_paint)
-		self.scroll_panel.Bind(wx.EVT_KEY_DOWN, self.on_key_press)
-		self.scroll_panel.Bind(wx.EVT_LEFT_DOWN, self.on_mouse_down)
-		self.scroll.Bind(wx.EVT_PAINT, self.on_paint)
-		self.scroll.Bind(wx.EVT_KEY_DOWN, self.on_key_press)
-		self.scroll.Bind(wx.EVT_LEFT_DOWN, self.on_mouse_down)
-
-		self.scroll.Fit()
-		self.Fit()
-
-		self.scroll_panel.SetDimensions(-1, -1, self.width_virtual, self.height_virtual, wx.SIZE_USE_EXISTING)
-
-		self.txt = None
-
-		self.Show(True)
-
-	def us_to_px(self, val):
-		return val / (10 ** 3) * self.zoom
-
-	def px_to_us(self, val):
-		return (val / self.zoom) * (10 ** 3)
-
-	def scroll_start(self):
-		(x, y) = self.scroll.GetViewStart()
-		return (x * self.scroll_scale, y * self.scroll_scale)
-
-	def scroll_start_us(self):
-		(x, y) = self.scroll_start()
-		return self.px_to_us(x)
-
-	def paint_rectangle_zone(self, nr, color, top_color, start, end):
-		offset_px = self.us_to_px(start - self.ts_start)
-		width_px = self.us_to_px(end - self.ts_start)
-
-		offset_py = RootFrame.Y_OFFSET + (nr * (RootFrame.RECT_HEIGHT + RootFrame.RECT_SPACE))
-		width_py = RootFrame.RECT_HEIGHT
-
-		dc = self.dc
-
-		if top_color is not None:
-			(r, g, b) = top_color
-			top_color = wx.Colour(r, g, b)
-			brush = wx.Brush(top_color, wx.SOLID)
-			dc.SetBrush(brush)
-			dc.DrawRectangle(offset_px, offset_py, width_px, RootFrame.EVENT_MARKING_WIDTH)
-			width_py -= RootFrame.EVENT_MARKING_WIDTH
-			offset_py += RootFrame.EVENT_MARKING_WIDTH
-
-		(r ,g, b) = color
-		color = wx.Colour(r, g, b)
-		brush = wx.Brush(color, wx.SOLID)
-		dc.SetBrush(brush)
-		dc.DrawRectangle(offset_px, offset_py, width_px, width_py)
-
-	def update_rectangles(self, dc, start, end):
-		start += self.ts_start
-		end += self.ts_start
-		self.sched_tracer.fill_zone(start, end)
-
-	def on_paint(self, event):
-		dc = wx.PaintDC(self.scroll_panel)
-		self.dc = dc
-
-		width = min(self.width_virtual, self.screen_width)
-		(x, y) = self.scroll_start()
-		start = self.px_to_us(x)
-		end = self.px_to_us(x + width)
-		self.update_rectangles(dc, start, end)
-
-	def rect_from_ypixel(self, y):
-		y -= RootFrame.Y_OFFSET
-		rect = y / (RootFrame.RECT_HEIGHT + RootFrame.RECT_SPACE)
-		height = y % (RootFrame.RECT_HEIGHT + RootFrame.RECT_SPACE)
-
-		if rect < 0 or rect > self.nr_rects - 1 or height > RootFrame.RECT_HEIGHT:
-			return -1
-
-		return rect
-
-	def update_summary(self, txt):
-		if self.txt:
-			self.txt.Destroy()
-		self.txt = wx.StaticText(self.panel, -1, txt, (0, (self.screen_height / 2) + 50))
-
-
-	def on_mouse_down(self, event):
-		(x, y) = event.GetPositionTuple()
-		rect = self.rect_from_ypixel(y)
-		if rect == -1:
-			return
-
-		t = self.px_to_us(x) + self.ts_start
-
-		self.sched_tracer.mouse_down(rect, t)
-
-
-	def update_width_virtual(self):
-		self.width_virtual = self.us_to_px(self.ts_end - self.ts_start)
-
-	def __zoom(self, x):
-		self.update_width_virtual()
-		(xpos, ypos) = self.scroll.GetViewStart()
-		xpos = self.us_to_px(x) / self.scroll_scale
-		self.scroll.SetScrollbars(self.scroll_scale, self.scroll_scale, self.width_virtual / self.scroll_scale, self.height_virtual / self.scroll_scale, xpos, ypos)
-		self.Refresh()
-
-	def zoom_in(self):
-		x = self.scroll_start_us()
-		self.zoom *= 2
-		self.__zoom(x)
-
-	def zoom_out(self):
-		x = self.scroll_start_us()
-		self.zoom /= 2
-		self.__zoom(x)
-
-
-	def on_key_press(self, event):
-		key = event.GetRawKeyCode()
-		if key == ord("+"):
-			self.zoom_in()
-			return
-		if key == ord("-"):
-			self.zoom_out()
-			return
-
-		key = event.GetKeyCode()
-		(x, y) = self.scroll.GetViewStart()
-		if key == wx.WXK_RIGHT:
-			self.scroll.Scroll(x + 1, y)
-		elif key == wx.WXK_LEFT:
-			self.scroll.Scroll(x - 1, y)
-		elif key == wx.WXK_DOWN:
-			self.scroll.Scroll(x, y + 1)
-		elif key == wx.WXK_UP:
-			self.scroll.Scroll(x, y - 1)
+from SchedGui import *
 
 
 threads = { 0 : "idle"}
-- 
1.6.2.3

