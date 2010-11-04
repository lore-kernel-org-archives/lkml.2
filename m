Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681Ab0KDPiy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 11:38:54 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:41896 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811Ab0KDPis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 11:38:48 -0400
From: Borislav Petkov <bp@amd64.org>
To: <acme@infradead.org>, <fweisbec@gmail.com>, <mingo@elte.hu>,
        <peterz@infradead.org>, <rostedt@goodmis.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [RFC PATCH 00/20] RAS daemon v3
Date: Thu,  4 Nov 2010 16:36:36 +0100
Message-Id: <1288885016-18295-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.3.1.50.g1e633
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Hi all,

I finally had some time to work on this thing again. This time it can
parse the MCE tracepoint and should be conceptually almost done. What
needs to be done now is fleshing out a bunch of details here and there.
I'm sending it early so that I can collect some more feedback.

So the patchset is ontop of 2.6.36 + Steven's trace_cmd restructuring
set from

git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git tip/perf/parse-events

I'm adding his patches too here, for completeness (although they need
some more work).

I've also cherry-picked the bunch of EDAC's MCE injection stuff for
testing.

So, in the end of the day, if you do

echo 0x9c00410000010016 > /sys/devices/system/edac/mce/status

(0x9c.. is the MCE signature of a data cache L2 TLB multimatch, for
example)

echo 0 > /sys/devices/system/edac/mce/bank

(0 means bank 0, i.e. data cache errors)

after having loaded the mce_amd_inj injection testing module, the RAS
daemon get's the status signature in userspace:

...
DBG main: Read some mmapped data
DBG main: MCE status: 0x9c00410000010016

All of the remaining fields can be postprocessed in arbitrary manner
after that. The MCE decoding in the kernel can then be simplified by
sharing it with the daemon, if needed. But that's another story.

To the patches, individually:

#1. Start splitting perf_event.c as we talked last time. The remaining
units could be carved out from there based on functionality.

#2. persistent events registration

#3. ... and their first user.

#4,5: Steven's stuff. Btw, Steven, feel free to pick up any of the later
patches if it makes your life easier, like #6 for example.

#6: could go with the above

#7-#19: Export all the shared stuff to the different libraries. I've
splitted them to as small units as possible for easier review.

#20: Adds the daemon. Still full of debugging code since
work-in-progress.

Also, in order to make this work, I needed the following hunk:

diff --git a/drivers/edac/mce_amd.c b/drivers/edac/mce_amd.c
index 5eb8042..58d7ed3 100644
--- a/drivers/edac/mce_amd.c
+++ b/drivers/edac/mce_amd.c
@@ -1,4 +1,5 @@
 #include <linux/module.h>
+#include <trace/events/mce.h>
 #include "mce_amd.h"
 
 static bool report_gart_errors;
@@ -376,6 +377,8 @@ int amd_decode_mce(struct notifier_block *nb, unsigned long val, void *data)
 
 	amd_decode_err_code(m->status & 0xffff);
 
+	trace_mce_record(m);
+
 	return NOTIFY_STOP;


This is needed just for testing the code by easily injecting MCEs as
described above.



diff --git a/kernel/events/core.c b/kernel/events/core.c
index 8d2cfd3..83830b0 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2682,7 +2682,9 @@ static void perf_mmap_close(struct vm_area_struct *vma)
 		struct user_struct *user = event->mmap_user;
 		struct perf_buffer *buffer = event->buffer;
 
-		atomic_long_sub((size >> PAGE_SHIFT) + 1, &user->locked_vm);
+		if (user)
+			atomic_long_sub((size >> PAGE_SHIFT) + 1, &user->locked_vm);
+


event->mmap_user doesn't get initialized in perf_mmap() since we have
preallocated buffers and exit early. Which means that perf has to know
about persistent events somehow or PeterZ has a better idea...



@@ -2719,8 +2721,10 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 	if (event->cpu == -1 && event->attr.inherit)
 		return -EINVAL;
 
+#if 0
 	if (!(vma->vm_flags & VM_SHARED))
 		return -EINVAL;
+#endif



Obviously, when mmaping the persistent buffers over debugfs, our vma is
not shared. Uncommented for now until a figure out a sensible solution.


diff --git a/tools/lib/perf/mmap.c b/tools/lib/perf/mmap.c
index b154ccc..cc50892 100644
--- a/tools/lib/perf/mmap.c
+++ b/tools/lib/perf/mmap.c
@@ -13,6 +13,7 @@ unsigned long mmap_read_head(struct mmap_data *md)
 	return head;
 }
 
+#if 0
 static void mmap_write_tail(struct mmap_data *md, unsigned long tail)
 {
 	struct perf_event_mmap_page *pc = md->base;
@@ -23,6 +24,7 @@ static void mmap_write_tail(struct mmap_data *md, unsigned long tail)
 	/* mb(); */
 	pc->data_tail = tail;
 }
+#endif

 static unsigned long mmap_read(struct mmap_data *md,
 			       void (*write_output)(void *, size_t))
@@ -70,12 +72,13 @@ static unsigned long mmap_read(struct mmap_data *md,
 
 	buf = &data[old & md->mask];
 	size = head - old;
+
 	old += size;
 
 	write_output(buf, size);
 
 	md->prev = old;
-	mmap_write_tail(md, old);
+/* 	mmap_write_tail(md, old); */
 
 	return samples;
 }


This has to do with the previous change because mmap_write_tail() tries
to write to RO mapping and there we segfault.

So anyway, here it is, it is still work in progress. Please take a look
and let me know.

Thanks.
