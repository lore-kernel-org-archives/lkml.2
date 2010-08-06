Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759503Ab0HFOZl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 10:25:41 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:40121 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757385Ab0HFOZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 10:25:36 -0400
From: Borislav Petkov <bp@amd64.org>
To: <acme@infradead.org>, <fweisbec@gmail.com>, <mingo@elte.hu>,
        <peterz@infradead.org>, <rostedt@goodmis.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [RFC PATCH 00/9] RAS daemon prototype, v2
Date: Fri,  6 Aug 2010 16:25:04 +0200
Message-Id: <1281104713-23141-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Hi,

I finally found some time for a second take at the ras daemon.
This one is based on Steven's trace-cmd integration into perf:

git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git, branch tip/perf/parse-events

which is still alpha, as are those patches too, btw. I'm sending them
now as a RFC/FYI type-thing only, work on them continues.

I've tried to incorporate and accomodate all comments from the last
round. Using debugfs files for mmaping the perf buffers makes the code
much simpler and introduces a lot less changes to the perf tool wrt to
exporting stuff into the library for external use.

The are still unresolved issues like the VM_SHARED check in perf_mmap()
which fails for read-only files in debugfs. Peter, what is your take at
this, do we want to relax that for persistent read-only events?

Also, I need this hunk otherwise I'm oopsing on exit:

---
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 8ff5292..8edb400 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -2665,7 +2665,9 @@ static void perf_mmap_close(struct vm_area_struct *vma)
                struct user_struct *user = event->mmap_user;
                struct perf_buffer *buffer = event->buffer;
 
-               atomic_long_sub((size >> PAGE_SHIFT) + 1, &user->locked_vm);
+               if (user)
+                       atomic_long_sub((size >> PAGE_SHIFT) + 1, &user->locked_vm);
+
                vma->vm_mm->locked_vm -= event->mmap_locked;
                rcu_assign_pointer(event->buffer, NULL);
                mutex_unlock(&event->mmap_mutex);
--

and I'll add it as an additional patch to the series if there are no
objections. See, we add the current user when we mmap but on already
allocated event buffers we skip that by exiting early so this change
should be fine for events with preallocated buffers, right?

@Arnaldo: I think this version should take care of the build issues you
had last time.

To the individual patches:

#1-2: added for completeness here, already upstream
#3: export perf funcs for mce
#4: initialize persistence mce event and allocate buffers
#5: move Steven's trace-cmd stuff to tools/lib/trace
#6-8: needed by the ras daemon and others maybe
#9: rough ras daemon skeleton, will flesh out later

Thanks for all your comments last time.

--

Changelog:

V1:

here's the first rough version of all the jerky code that attempts to
implement a RAS daemon listening for MCEs using perf. This is a preview
code only, I still need to figure out how to do the sample parsing
the easiest and flesh out the daemon functionality a bit more. Also,
I wanted to reuse as much code as possible therefore a lot had to be
reengineered with the perf tool and all its library-like compilation
units.

With this, you can do

make perf

or

make ras

and build the respective tool.

Even though I tried to split the patchset for easier review, please bear
in mind that there are some fat guys there (241K is the biggest one).
However, they don't do anything special except moving code around. As
such, they might not appear on lkml due to vger size constraints so I've
upped the whole patchset also at

git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git perf-v1

The patchset is based on tip/perf/core from last week. Here are some
more details to some of the patches individually:

2: enables the mce tracepoint unconditionally. I had a problem with
perf_event_attr.sample_period which is checked in perf_swevent_add().
Currently, I'm setting it to ULLONG_MAX but this is icky. I'd much
rather have the check do something like

	if (event->type != PERF_EVENT_TYPE_PERSISTENT)
		if (!hwc->sample_period)
			return;

or similar.

4: sys_perf_event_open needs to know about already allocated and
enabled events.

5-10: carves out a bunch of generic perf compilation units into a common
lib. Split into 5 patches for easier review.

12-14: those are pulled in when exporting parse_events.c for external use.

16: lib/perf/misc.c contains functions and global variables like
pager_in_use() or perf_guest or usage_with_options() which are used in
generic utilities but are strictly perf-specific. Long term we should
strive in making the library self-contained and getting rid of those.

19-20: those are only needed for testing, they'll go in over the edac
tree in the next merge window. Added for completeness here.

21: only bare-bones implementation, needs a lot of fleshing out

Anyways, please have a look and let me know either way :)

Thanks,
Boris.
