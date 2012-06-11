Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460Ab2FKNVI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 09:21:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21428 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754254Ab2FKNVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 09:21:04 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: eranian@google.com, gorcunov@openvz.org, tzanussi@gmail.com,
        mhiramat@redhat.com, robert.richter@amd.com, fche@redhat.com,
        linux-kernel@vger.kernel.org, masami.hiramatsu.pt@hitachi.com,
        drepper@gmail.com, asharma@fb.com, benjamin.redelings@nescent.org,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 06/19] perf: Add ability to attach user stack dump to sample
Date: Mon, 11 Jun 2012 15:20:01 +0200
Message-Id: <1339420814-7379-7-git-send-email-jolsa@redhat.com>
In-Reply-To: <1339420814-7379-1-git-send-email-jolsa@redhat.com>
References: <1339420814-7379-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introducing sample_stack_user value into the perf_event_attr
struct to define the size of the user stack dump to be attached
to the sample. The dump itself is triggered once the
sample_stack_user is not zero.

Beeing able to dump parts of the user stack, starting from the
stack pointer, will be useful to make a post mortem dwarf CFI
based stack unwinding.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 include/linux/perf_event.h |    5 +++
 kernel/events/core.c       |   66 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 71 insertions(+), 0 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 8960968..8db1655 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -278,6 +278,11 @@ struct perf_event_attr {
 	 * See asm/perf_regs.h for details.
 	 */
 	__u64	sample_regs_user;
+
+	/*
+	 * Defines size of the user stack to dump on samples.
+	 */
+	__u64	sample_stack_user;
 };
 
 /*
diff --git a/kernel/events/core.c b/kernel/events/core.c
index e4df59d..c1062a1 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3765,6 +3765,38 @@ perf_output_sample_regs(struct perf_output_handle *handle,
 	}
 }
 
+static void
+perf_output_sample_ustack(struct perf_output_handle *handle, u64 dump_size,
+			  struct pt_regs *regs)
+{
+	/* Case of a kernel thread, nothing to dump */
+	if (!regs) {
+		u64 size = 0;
+		perf_output_put(handle, size);
+	} else {
+		unsigned long sp;
+		unsigned int rem;
+		u64 dyn_size;
+
+		/*
+		 * Static size: we always dump the size
+		 * requested by the user because most of the
+		 * time, the top of the user stack is not
+		 * paged out.
+		 */
+		perf_output_put(handle, dump_size);
+
+		sp = user_stack_pointer(regs);
+		rem = __output_copy_user(handle, (void *) sp, dump_size);
+		dyn_size = dump_size - rem;
+
+		perf_output_skip(handle, rem);
+
+		/* Dynamic size: whole dump - padding. */
+		perf_output_put(handle, dyn_size);
+	}
+}
+
 static struct pt_regs *perf_sample_regs_user(struct pt_regs *regs)
 {
 	if (!user_mode(regs)) {
@@ -4054,6 +4086,11 @@ void perf_output_sample(struct perf_output_handle *handle,
 						mask);
 		}
 	}
+
+	if (event->attr.sample_stack_user)
+		perf_output_sample_ustack(handle,
+					  event->attr.sample_stack_user,
+					  data->regs_user);
 }
 
 void perf_prepare_sample(struct perf_event_header *header,
@@ -4118,6 +4155,31 @@ void perf_prepare_sample(struct perf_event_header *header,
 
 		header->size += size;
 	}
+
+	if (event->attr.sample_stack_user) {
+		/*
+		 * A first field that tells the _static_ size of the
+		 * dump. 0 if there is nothing to dump (ie: we are in
+		 * a kernel thread) otherwise the requested size.
+		 */
+		int size = sizeof(u64);
+
+		if (!data->regs_user)
+			data->regs_user = perf_sample_regs_user(regs);
+
+		/*
+		 * If there is something to dump, add space for the
+		 * dump itself and for the field that tells the
+		 * dynamic size, which is how many have been actually
+		 * dumped.
+		 */
+		if (data->regs_user) {
+			size += event->attr.sample_stack_user;
+			size += sizeof(u64);
+		}
+
+		header->size += size;
+	}
 }
 
 static void perf_event_output(struct perf_event *event,
@@ -6171,6 +6233,10 @@ static int perf_copy_attr(struct perf_event_attr __user *uattr,
 	if (attr->sample_regs_user)
 		ret = perf_reg_validate(attr->sample_regs_user);
 
+	if (attr->sample_stack_user)
+		attr->sample_stack_user = round_up(attr->sample_stack_user,
+						   sizeof(u64));
+
 out:
 	return ret;
 
-- 
1.7.7.6

