Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531Ab0HBAOC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 20:14:02 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39282 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab0HBANl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 20:13:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=GTK1ILehvk0jt6g1cKWowXaBLAqEr50hcu2Efk3ggUl88cfukiWpGtcimKO+nq8emO
         PjyF6nGyDS8PdILTceVXHXZ/95pI3C+qULzPYMAo4Y+ogujqRlfE0rM6NNpELvTN6clZ
         FFukIkeApalVQ5WLx6sOpF+o/aTZz4w+s+DTo=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Nikhil Rao <ncrao@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 08/12] perf, sched migration: Make it vertically scrollable
Date: Mon,  2 Aug 2010 02:13:09 +0200
Message-Id: <1280707993-6599-9-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1280707993-6599-1-git-send-regression-fweisbec@gmail.com>
References: <1280707993-6599-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With scheduler traces covering more than two cpus, rectangles
of the CPUs 3 and more are not visibles.

This makes the vertical navigation scrollable so that all of the
CPUs rectangles are available.

We also want to be able to zoom vertically, so that we can fit at
best the screen with CPU rectangles, but that's for later.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Nikhil Rao <ncrao@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
---
 tools/perf/scripts/python/sched-migration.py |   29 +++++++++++++++++--------
 1 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/tools/perf/scripts/python/sched-migration.py b/tools/perf/scripts/python/sched-migration.py
index d902668..9d46377 100644
--- a/tools/perf/scripts/python/sched-migration.py
+++ b/tools/perf/scripts/python/sched-migration.py
@@ -43,18 +43,20 @@ class RootFrame(wx.Frame):
 		self.timeslices = timeslices
 		(self.ts_start, self.ts_end) = timeslices.interval()
 		self.update_width_virtual()
+		self.nr_cpus = timeslices.max_cpu() + 1
+		self.height_virtual = RootFrame.Y_OFFSET + (self.nr_cpus * (RootFrame.CPU_HEIGHT + RootFrame.CPU_SPACE))
 
 		# whole window panel
 		self.panel = wx.Panel(self, size=(self.screen_width, self.screen_height))
 
 		# scrollable container
 		self.scroll = wx.ScrolledWindow(self.panel)
-		self.scroll.SetScrollbars(self.scroll_scale, self.scroll_scale, self.width_virtual / self.scroll_scale, 100 / 10)
+		self.scroll.SetScrollbars(self.scroll_scale, self.scroll_scale, self.width_virtual / self.scroll_scale, self.height_virtual / self.scroll_scale)
 		self.scroll.EnableScrolling(True, True)
 		self.scroll.SetFocus()
 
 		# scrollable drawing area
-		self.scroll_panel = wx.Panel(self.scroll, size=(self.screen_width, self.screen_height / 2))
+		self.scroll_panel = wx.Panel(self.scroll, size=(self.screen_width - 15, self.screen_height / 2))
 		self.scroll_panel.Bind(wx.EVT_PAINT, self.on_paint)
 		self.scroll_panel.Bind(wx.EVT_KEY_DOWN, self.on_key_press)
 		self.scroll_panel.Bind(wx.EVT_LEFT_DOWN, self.on_mouse_down)
@@ -65,9 +67,8 @@ class RootFrame(wx.Frame):
 		self.scroll.Fit()
 		self.Fit()
 
-		self.scroll_panel.SetDimensions(-1, -1, self.width_virtual, -1, wx.SIZE_USE_EXISTING)
+		self.scroll_panel.SetDimensions(-1, -1, self.width_virtual, self.height_virtual, wx.SIZE_USE_EXISTING)
 
-		self.max_cpu = -1
 		self.txt = None
 
 		self.Show(True)
@@ -143,8 +144,6 @@ class RootFrame(wx.Frame):
 
 			for cpu in timeslice.rqs:
 				self.update_rectangle_cpu(dc, timeslice, cpu, self.timeslices[0].start)
-				if cpu > self.max_cpu:
-					self.max_cpu = cpu
 
 	def on_paint(self, event):
 		color = wx.Colour(0xff, 0xff, 0xff)
@@ -163,7 +162,7 @@ class RootFrame(wx.Frame):
 		cpu = y / (RootFrame.CPU_HEIGHT + RootFrame.CPU_SPACE)
 		height = y % (RootFrame.CPU_HEIGHT + RootFrame.CPU_SPACE)
 
-		if cpu < 0 or cpu > self.max_cpu or height > RootFrame.CPU_HEIGHT:
+		if cpu < 0 or cpu > self.nr_cpus - 1 or height > RootFrame.CPU_HEIGHT:
 			return -1
 
 		return cpu
@@ -206,7 +205,7 @@ class RootFrame(wx.Frame):
 		self.update_width_virtual()
 		(xpos, ypos) = self.scroll.GetViewStart()
 		xpos = self.us_to_px(x) / self.scroll_scale
-		self.scroll.SetScrollbars(self.scroll_scale, self.scroll_scale, self.width_virtual / self.scroll_scale, 100 / 10, xpos, ypos)
+		self.scroll.SetScrollbars(self.scroll_scale, self.scroll_scale, self.width_virtual / self.scroll_scale, self.height_virtual / self.scroll_scale, xpos, ypos)
 		self.Refresh()
 
 	def zoom_in(self):
@@ -234,7 +233,11 @@ class RootFrame(wx.Frame):
 		if key == wx.WXK_RIGHT:
 			self.scroll.Scroll(x + 1, y)
 		elif key == wx.WXK_LEFT:
-			self.scroll.Scroll(x -1, y)
+			self.scroll.Scroll(x - 1, y)
+		elif key == wx.WXK_DOWN:
+			self.scroll.Scroll(x, y + 1)
+		elif key == wx.WXK_UP:
+			self.scroll.Scroll(x, y - 1)
 
 
 threads = { 0 : "idle"}
@@ -504,6 +507,14 @@ class TimeSliceList(UserList):
 
 		return (self.data[0].start, self.data[-1].end)
 
+	def max_cpu(self):
+		last_ts = self.data[-1]
+		max_cpu = 0
+		for cpu in last_ts.rqs:
+			if cpu > max_cpu:
+				max_cpu = cpu
+		return max_cpu
+
 
 class SchedEventProxy:
 	def __init__(self):
-- 
1.6.2.3

