Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173Ab0HBANx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 20:13:53 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56235 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152Ab0HBAN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 20:13:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=BTQdUVErmuesYSwNd/vVGE+ml2Wr7FA/68CNbuZ4NHpxrRP6+bb91C6I5vLOXhxWEB
         g8Sy8giU70WLOaYt/cTpp2yms0zRZN709Jw/EzMx6TVoO+Omvby1/JxmYcOgFf/DeCnB
         xfD7QiCFYdxGCbzi6pwNiCvIok6uxQevTKysU=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
        Tom Zanussi <tzanussi@gmail.com>, Mike Galbraith <efault@gmx.de>,
        Venkatesh Pallipadi <venki@google.com>,
        Pierre Tardy <tardyp@gmail.com>, Nikhil Rao <ncrao@google.com>
Subject: [PATCH 03/12] perf: New migration tool overview
Date: Mon,  2 Aug 2010 02:13:04 +0200
Message-Id: <1280707993-6599-4-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1280707993-6599-1-git-send-regression-fweisbec@gmail.com>
References: <1280707993-6599-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This brings a GUI tool that displays an overview of the load
of tasks proportion in each CPUs.

The CPUs forward progress is cut in timeslices. A new timeslice
is created for every runqueue event: a task gets pushed out or
pulled in the runqueue.

For each timeslice, every CPUs rectangle is colored with a red
power that describes the local load against the total load.
This more red is the rectangle, the higher is the given CPU load.
This load is the number of tasks running on the CPU, without
any distinction against the scheduler policy of the tasks, for
now.

Also for each timeslice, the event origin is depicted on the
CPUs that triggered it using a thin colored line on top of the
rectangle timeslice.

These events are:

* sleep: a task went to sleep and has then been pulled out the
  runqueue. The origin color in the thin line is dark blue.

* wake up: a task woke up and has then been pushed in the
  runqueue. The origin color is yellow.

* wake up new: a new task woke up and has then been pushed in the
  runqueue. The origin color is green.

* migrate in: a task migrated in the runqueue due to a load
  balancing operation. The origin color is violet.

* migrate out: reverse of the previous one. Migrate in events
  usually have paired migrate out events in another runqueue.
  The origin color is light blue.

Clicking on a timeslice provides the runqueue event details
and the runqueue state.

The CPU rectangles can be navigated using the usual arrow
controls. Horizontal zooming in/out is possible with the
"+" and "-" buttons.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Venkatesh Pallipadi <venki@google.com>
Cc: Pierre Tardy <tardyp@gmail.com>
Cc: Nikhil Rao <ncrao@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
---
 .../perf/scripts/python/bin/sched-migration-record |    2 +
 .../perf/scripts/python/bin/sched-migration-report |    3 +
 tools/perf/scripts/python/sched-migration.py       |  634 ++++++++++++++++++++
 3 files changed, 639 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/scripts/python/bin/sched-migration-record
 create mode 100644 tools/perf/scripts/python/bin/sched-migration-report
 create mode 100644 tools/perf/scripts/python/sched-migration.py

diff --git a/tools/perf/scripts/python/bin/sched-migration-record b/tools/perf/scripts/python/bin/sched-migration-record
new file mode 100644
index 0000000..17a3e9b
--- /dev/null
+++ b/tools/perf/scripts/python/bin/sched-migration-record
@@ -0,0 +1,2 @@
+#!/bin/bash
+perf record -m 16384 -a -e sched:sched_wakeup -e sched:sched_wakeup_new -e sched:sched_switch -e sched:sched_migrate_task $@
diff --git a/tools/perf/scripts/python/bin/sched-migration-report b/tools/perf/scripts/python/bin/sched-migration-report
new file mode 100644
index 0000000..61d05f7
--- /dev/null
+++ b/tools/perf/scripts/python/bin/sched-migration-report
@@ -0,0 +1,3 @@
+#!/bin/bash
+# description: sched migration overview
+perf trace $@ -s ~/libexec/perf-core/scripts/python/sched-migration.py
diff --git a/tools/perf/scripts/python/sched-migration.py b/tools/perf/scripts/python/sched-migration.py
new file mode 100644
index 0000000..f73e1c7
--- /dev/null
+++ b/tools/perf/scripts/python/sched-migration.py
@@ -0,0 +1,634 @@
+#!/usr/bin/python
+#
+# Cpu task migration overview toy
+#
+# Copyright (C) 2010 Frederic Weisbecker <fweisbec@gmail.com>
+#
+# perf trace event handlers have been generated by perf trace -g python
+#
+# The whole is licensed under the terms of the GNU GPL License version 2
+
+
+try:
+	import wx
+except ImportError:
+	raise ImportError, "You need to install the wxpython lib for this script"
+
+import os
+import sys
+
+from collections import defaultdict
+from UserList import UserList
+
+sys.path.append(os.environ['PERF_EXEC_PATH'] + \
+	'/scripts/python/Perf-Trace-Util/lib/Perf/Trace')
+
+from perf_trace_context import *
+from Core import *
+
+class RootFrame(wx.Frame):
+	def __init__(self, timeslices, parent = None, id = -1, title = "Migration"):
+		wx.Frame.__init__(self, parent, id, title)
+
+		(self.screen_width, self.screen_height) = wx.GetDisplaySize()
+		self.screen_width -= 10
+		self.screen_height -= 10
+		self.zoom = 0.5
+		self.scroll_scale = 20
+		self.timeslices = timeslices
+		(self.ts_start, self.ts_end) = timeslices.interval()
+		self.update_width_virtual()
+
+		# whole window panel
+		self.panel = wx.Panel(self, size=(self.screen_width, self.screen_height))
+
+		# scrollable container
+		self.scroll = wx.ScrolledWindow(self.panel)
+		self.scroll.SetScrollbars(self.scroll_scale, self.scroll_scale, self.width_virtual / self.scroll_scale, 100 / 10)
+		self.scroll.EnableScrolling(True, True)
+		self.scroll.SetFocus()
+
+		# scrollable drawing area
+		self.scroll_panel = wx.Panel(self.scroll, size=(self.screen_width, self.screen_height / 2))
+		self.scroll_panel.Bind(wx.EVT_PAINT, self.on_paint)
+		self.scroll_panel.Bind(wx.EVT_KEY_DOWN, self.on_key_press)
+		self.scroll_panel.Bind(wx.EVT_LEFT_DOWN, self.on_mouse_down)
+		self.scroll.Bind(wx.EVT_PAINT, self.on_paint)
+
+		self.scroll.Fit()
+		self.Fit()
+
+		self.scroll_panel.SetDimensions(-1, -1, self.width_virtual, -1, wx.SIZE_USE_EXISTING)
+
+		self.max_cpu = -1
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
+	def update_rectangle_cpu(self, dc, slice, cpu, offset_time):
+		rq = slice.rqs[cpu]
+
+		if slice.total_load != 0:
+			load_rate = rq.load() / float(slice.total_load)
+		else:
+			load_rate = 0
+
+
+		offset_px = self.us_to_px(slice.start - offset_time)
+		width_px = self.us_to_px(slice.end - slice.start)
+		(x, y) = self.scroll_start()
+
+		if width_px == 0:
+			return
+
+		offset_py = 100 + (cpu * 150)
+		width_py = 100
+
+		if cpu in slice.event_cpus:
+			rgb = rq.event.color()
+			if rgb is not None:
+				(r, g, b) = rgb
+				color = wx.Colour(r, g, b)
+				brush = wx.Brush(color, wx.SOLID)
+				dc.SetBrush(brush)
+				dc.DrawRectangle(offset_px, offset_py, width_px, 5)
+				width_py -= 5
+				offset_py += 5
+
+		red_power = int(0xff - (0xff * load_rate))
+		color = wx.Colour(0xff, red_power, red_power)
+		brush = wx.Brush(color, wx.SOLID)
+		dc.SetBrush(brush)
+		dc.DrawRectangle(offset_px, offset_py, width_px, width_py)
+
+	def update_rectangles(self, dc, start, end):
+		if len(self.timeslices) == 0:
+			return
+		start += self.timeslices[0].start
+		end += self.timeslices[0].start
+
+		color = wx.Colour(0, 0, 0)
+		brush = wx.Brush(color, wx.SOLID)
+		dc.SetBrush(brush)
+
+		i = self.timeslices.find_time_slice(start)
+		if i == -1:
+			return
+
+		for i in xrange(i, len(self.timeslices)):
+			timeslice = self.timeslices[i]
+			if timeslice.start > end:
+				return
+
+			for cpu in timeslice.rqs:
+				self.update_rectangle_cpu(dc, timeslice, cpu, self.timeslices[0].start)
+				if cpu > self.max_cpu:
+					self.max_cpu = cpu
+
+	def on_paint(self, event):
+		color = wx.Colour(0xff, 0xff, 0xff)
+		brush = wx.Brush(color, wx.SOLID)
+		dc = wx.PaintDC(self.scroll_panel)
+		dc.SetBrush(brush)
+
+		width = min(self.width_virtual, self.screen_width)
+		(x, y) = self.scroll_start()
+		start = self.px_to_us(x)
+		end = self.px_to_us(x + width)
+		self.update_rectangles(dc, start, end)
+
+	def cpu_from_ypixel(self, y):
+		y -= 100
+		cpu = y / 150
+		height = y % 150
+
+		if cpu < 0 or cpu > self.max_cpu or height > 100:
+			return -1
+
+		return cpu
+
+	def update_summary(self, cpu, t):
+		idx = self.timeslices.find_time_slice(t)
+		if idx == -1:
+			return
+
+		ts = self.timeslices[idx]
+		rq = ts.rqs[cpu]
+		raw = "CPU: %d\n" % cpu
+		raw += "Last event : %s\n" % rq.event.__repr__()
+		raw += "Timestamp : %d.%06d\n" % (ts.start / (10 ** 9), (ts.start % (10 ** 9)) / 1000)
+		raw += "Duration : %6d us\n" % ((ts.end - ts.start) / (10 ** 6))
+		raw += "Load = %d\n" % rq.load()
+		for t in rq.tasks:
+			raw += "%s \n" % thread_name(t)
+
+		if self.txt:
+			self.txt.Destroy()
+		self.txt = wx.StaticText(self.panel, -1, raw, (0, (self.screen_height / 2) + 50))
+
+
+	def on_mouse_down(self, event):
+		(x, y) = event.GetPositionTuple()
+		cpu = self.cpu_from_ypixel(y)
+		if cpu == -1:
+			return
+
+		t = self.px_to_us(x) + self.timeslices[0].start
+
+		self.update_summary(cpu, t)
+
+
+	def update_width_virtual(self):
+		self.width_virtual = self.us_to_px(self.ts_end - self.ts_start)
+
+	def __zoom(self, x):
+		self.update_width_virtual()
+		(xpos, ypos) = self.scroll.GetViewStart()
+		xpos = self.us_to_px(x) / self.scroll_scale
+		self.scroll.SetScrollbars(self.scroll_scale, self.scroll_scale, self.width_virtual / self.scroll_scale, 100 / 10, xpos, ypos)
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
+			self.scroll.Scroll(x -1, y)
+
+
+threads = { 0 : "idle"}
+
+def thread_name(pid):
+	return "%s:%d" % (threads[pid], pid)
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
+		print "Unhandled task state %d" % state
+		return ""
+
+	return states[state]
+
+
+class RunqueueEventUnknown:
+	@staticmethod
+	def color():
+		return None
+
+	def __repr__(self):
+		return "unknown"
+
+class RunqueueEventSleep:
+	@staticmethod
+	def color():
+		return (0, 0, 0xff)
+
+	def __init__(self, sleeper):
+		self.sleeper = sleeper
+
+	def __repr__(self):
+		return "%s gone to sleep" % thread_name(self.sleeper)
+
+class RunqueueEventWakeup:
+	@staticmethod
+	def color():
+		return (0xff, 0xff, 0)
+
+	def __init__(self, wakee):
+		self.wakee = wakee
+
+	def __repr__(self):
+		return "%s woke up" % thread_name(self.wakee)
+
+class RunqueueEventFork:
+	@staticmethod
+	def color():
+		return (0, 0xff, 0)
+
+	def __init__(self, child):
+		self.child = child
+
+	def __repr__(self):
+		return "new forked task %s" % thread_name(self.child)
+
+class RunqueueMigrateIn:
+	@staticmethod
+	def color():
+		return (0, 0xf0, 0xff)
+
+	def __init__(self, new):
+		self.new = new
+
+	def __repr__(self):
+		return "task migrated in %s" % thread_name(self.new)
+
+class RunqueueMigrateOut:
+	@staticmethod
+	def color():
+		return (0xff, 0, 0xff)
+
+	def __init__(self, old):
+		self.old = old
+
+	def __repr__(self):
+		return "task migrated out %s" % thread_name(self.old)
+
+class RunqueueSnapshot:
+	def __init__(self, tasks = [0], event = RunqueueEventUnknown()):
+		self.tasks = tuple(tasks)
+		self.event = event
+
+	def sched_switch(self, prev, prev_state, next):
+		event = RunqueueEventUnknown()
+
+		if taskState(prev_state) == "R" and next in self.tasks \
+			and prev in self.tasks:
+			return self
+
+		if taskState(prev_state) != "R":
+			event = RunqueueEventSleep(prev)
+
+		next_tasks = list(self.tasks[:])
+		if prev in self.tasks:
+			if taskState(prev_state) != "R":
+				next_tasks.remove(prev)
+		elif taskState(prev_state) == "R":
+			next_tasks.append(prev)
+
+		if next not in next_tasks:
+			next_tasks.append(next)
+
+		return RunqueueSnapshot(next_tasks, event)
+
+	def migrate_out(self, old):
+		if old not in self.tasks:
+			return self
+		next_tasks = [task for task in self.tasks if task != old]
+
+		return RunqueueSnapshot(next_tasks, RunqueueMigrateOut(old))
+
+	def __migrate_in(self, new, event):
+		if new in self.tasks:
+			self.event = event
+			return self
+		next_tasks = self.tasks[:] + tuple([new])
+
+		return RunqueueSnapshot(next_tasks, event)
+
+	def migrate_in(self, new):
+		return self.__migrate_in(new, RunqueueMigrateIn(new))
+
+	def wake_up(self, new):
+		return self.__migrate_in(new, RunqueueEventWakeup(new))
+
+	def wake_up_new(self, new):
+		return self.__migrate_in(new, RunqueueEventFork(new))
+
+	def load(self):
+		""" Provide the number of tasks on the runqueue.
+		    Don't count idle"""
+		return len(self.tasks) - 1
+
+	def __repr__(self):
+		ret = self.tasks.__repr__()
+		ret += self.origin_tostring()
+
+		return ret
+
+class TimeSlice:
+	def __init__(self, start, prev):
+		self.start = start
+		self.prev = prev
+		self.end = start
+		# cpus that triggered the event
+		self.event_cpus = []
+		if prev is not None:
+			self.total_load = prev.total_load
+			self.rqs = prev.rqs.copy()
+		else:
+			self.rqs = defaultdict(RunqueueSnapshot)
+			self.total_load = 0
+
+	def __update_total_load(self, old_rq, new_rq):
+		diff = new_rq.load() - old_rq.load()
+		self.total_load += diff
+
+	def sched_switch(self, ts_list, prev, prev_state, next, cpu):
+		old_rq = self.prev.rqs[cpu]
+		new_rq = old_rq.sched_switch(prev, prev_state, next)
+
+		if old_rq is new_rq:
+			return
+
+		self.rqs[cpu] = new_rq
+		self.__update_total_load(old_rq, new_rq)
+		ts_list.append(self)
+		self.event_cpus = [cpu]
+
+	def migrate(self, ts_list, new, old_cpu, new_cpu):
+		if old_cpu == new_cpu:
+			return
+		old_rq = self.prev.rqs[old_cpu]
+		out_rq = old_rq.migrate_out(new)
+		self.rqs[old_cpu] = out_rq
+		self.__update_total_load(old_rq, out_rq)
+
+		new_rq = self.prev.rqs[new_cpu]
+		in_rq = new_rq.migrate_in(new)
+		self.rqs[new_cpu] = in_rq
+		self.__update_total_load(new_rq, in_rq)
+
+		ts_list.append(self)
+		self.event_cpus = [old_cpu, new_cpu]
+
+	def wake_up(self, ts_list, pid, cpu, fork):
+		old_rq = self.prev.rqs[cpu]
+		if fork:
+			new_rq = old_rq.wake_up_new(pid)
+		else:
+			new_rq = old_rq.wake_up(pid)
+
+		if new_rq is old_rq:
+			return
+		self.rqs[cpu] = new_rq
+		self.__update_total_load(old_rq, new_rq)
+		ts_list.append(self)
+		self.event_cpus = [cpu]
+
+	def next(self, t):
+		self.end = t
+		return TimeSlice(t, self)
+
+class TimeSliceList(UserList):
+	def __init__(self, arg = []):
+		self.data = arg
+
+	def get_time_slice(self, ts):
+		if len(self.data) == 0:
+			slice = TimeSlice(ts, TimeSlice(-1, None))
+		else:
+			slice = self.data[-1].next(ts)
+		return slice
+
+	def find_time_slice(self, ts):
+		start = 0
+		end = len(self.data)
+		found = -1
+		searching = True
+		while searching:
+			if start == end or start == end - 1:
+				searching = False
+
+			i = (end + start) / 2
+			if self.data[i].start <= ts and self.data[i].end >= ts:
+				found = i
+				end = i
+				continue
+
+			if self.data[i].end < ts:
+				start = i
+
+			elif self.data[i].start > ts:
+				end = i
+
+		return found
+
+	def interval(self):
+		if len(self.data) == 0:
+			return (0, 0)
+
+		return (self.data[0].start, self.data[-1].end)
+
+
+class SchedEventProxy:
+	def __init__(self):
+		self.current_tsk = defaultdict(lambda : -1)
+		self.timeslices = TimeSliceList()
+
+	def sched_switch(self, headers, prev_comm, prev_pid, prev_prio, prev_state,
+			 next_comm, next_pid, next_prio):
+		""" Ensure the task we sched out this cpu is really the one
+		    we logged. Otherwise we may have missed traces """
+
+		on_cpu_task = self.current_tsk[headers.cpu]
+
+		if on_cpu_task != -1 and on_cpu_task != prev_pid:
+			print "Sched switch event rejected ts: %s cpu: %d prev: %s(%d) next: %s(%d)" % \
+				(headers.ts_format(), headers.cpu, prev_comm, prev_pid, next_comm, next_pid)
+
+		threads[prev_pid] = prev_comm
+		threads[next_pid] = next_comm
+		self.current_tsk[headers.cpu] = next_pid
+
+		ts = self.timeslices.get_time_slice(headers.ts())
+		ts.sched_switch(self.timeslices, prev_pid, prev_state, next_pid, headers.cpu)
+
+	def migrate(self, headers, pid, prio, orig_cpu, dest_cpu):
+		ts = self.timeslices.get_time_slice(headers.ts())
+		ts.migrate(self.timeslices, pid, orig_cpu, dest_cpu)
+
+	def wake_up(self, headers, comm, pid, success, target_cpu, fork):
+		if success == 0:
+			return
+		ts = self.timeslices.get_time_slice(headers.ts())
+		ts.wake_up(self.timeslices, pid, target_cpu, fork)
+
+
+def trace_begin():
+	global parser
+	parser = SchedEventProxy()
+
+def trace_end():
+	app = wx.App(False)
+	timeslices = parser.timeslices
+	frame = RootFrame(timeslices)
+	app.MainLoop()
+
+def sched__sched_stat_runtime(event_name, context, common_cpu,
+	common_secs, common_nsecs, common_pid, common_comm,
+	comm, pid, runtime, vruntime):
+	pass
+
+def sched__sched_stat_iowait(event_name, context, common_cpu,
+	common_secs, common_nsecs, common_pid, common_comm,
+	comm, pid, delay):
+	pass
+
+def sched__sched_stat_sleep(event_name, context, common_cpu,
+	common_secs, common_nsecs, common_pid, common_comm,
+	comm, pid, delay):
+	pass
+
+def sched__sched_stat_wait(event_name, context, common_cpu,
+	common_secs, common_nsecs, common_pid, common_comm,
+	comm, pid, delay):
+	pass
+
+def sched__sched_process_fork(event_name, context, common_cpu,
+	common_secs, common_nsecs, common_pid, common_comm,
+	parent_comm, parent_pid, child_comm, child_pid):
+	pass
+
+def sched__sched_process_wait(event_name, context, common_cpu,
+	common_secs, common_nsecs, common_pid, common_comm,
+	comm, pid, prio):
+	pass
+
+def sched__sched_process_exit(event_name, context, common_cpu,
+	common_secs, common_nsecs, common_pid, common_comm,
+	comm, pid, prio):
+	pass
+
+def sched__sched_process_free(event_name, context, common_cpu,
+	common_secs, common_nsecs, common_pid, common_comm,
+	comm, pid, prio):
+	pass
+
+def sched__sched_migrate_task(event_name, context, common_cpu,
+	common_secs, common_nsecs, common_pid, common_comm,
+	comm, pid, prio, orig_cpu,
+	dest_cpu):
+	headers = EventHeaders(common_cpu, common_secs, common_nsecs,
+				common_pid, common_comm)
+	parser.migrate(headers, pid, prio, orig_cpu, dest_cpu)
+
+def sched__sched_switch(event_name, context, common_cpu,
+	common_secs, common_nsecs, common_pid, common_comm,
+	prev_comm, prev_pid, prev_prio, prev_state,
+	next_comm, next_pid, next_prio):
+
+	headers = EventHeaders(common_cpu, common_secs, common_nsecs,
+				common_pid, common_comm)
+	parser.sched_switch(headers, prev_comm, prev_pid, prev_prio, prev_state,
+			 next_comm, next_pid, next_prio)
+
+def sched__sched_wakeup_new(event_name, context, common_cpu,
+	common_secs, common_nsecs, common_pid, common_comm,
+	comm, pid, prio, success,
+	target_cpu):
+	headers = EventHeaders(common_cpu, common_secs, common_nsecs,
+				common_pid, common_comm)
+	parser.wake_up(headers, comm, pid, success, target_cpu, 1)
+
+def sched__sched_wakeup(event_name, context, common_cpu,
+	common_secs, common_nsecs, common_pid, common_comm,
+	comm, pid, prio, success,
+	target_cpu):
+	headers = EventHeaders(common_cpu, common_secs, common_nsecs,
+				common_pid, common_comm)
+	parser.wake_up(headers, comm, pid, success, target_cpu, 0)
+
+def sched__sched_wait_task(event_name, context, common_cpu,
+	common_secs, common_nsecs, common_pid, common_comm,
+	comm, pid, prio):
+	pass
+
+def sched__sched_kthread_stop_ret(event_name, context, common_cpu,
+	common_secs, common_nsecs, common_pid, common_comm,
+	ret):
+	pass
+
+def sched__sched_kthread_stop(event_name, context, common_cpu,
+	common_secs, common_nsecs, common_pid, common_comm,
+	comm, pid):
+	pass
+
+def trace_unhandled(event_name, context, common_cpu, common_secs, common_nsecs,
+		common_pid, common_comm):
+	pass
-- 
1.6.2.3

