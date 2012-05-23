Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965332Ab2EWTcx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 15:32:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43052 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965296Ab2EWTcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 15:32:52 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: eranian@google.com, gorcunov@openvz.org, tzanussi@gmail.com,
        mhiramat@redhat.com, robert.richter@amd.com, fche@redhat.com,
        linux-kernel@vger.kernel.org, masami.hiramatsu.pt@hitachi.com,
        drepper@gmail.com, asharma@fb.com, benjamin.redelings@nescent.org,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 04/16] perf: Add ability to attach user stack dump to sample
Date: Wed, 23 May 2012 21:32:03 +0200
Message-Id: <1337801535-12865-5-git-send-email-jolsa@redhat.com>
In-Reply-To: <1337801535-12865-1-git-send-email-jolsa@redhat.com>
References: <1337801535-12865-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introducing new sample_type bit PERF_SAMPLE_STACK. Once set,
the sample_stack value determines the stack which is going
to be attached.

Currently only user level stack is supported, specified by
PERF_SAMPLE_STACK_USER bit in sample_stack value. When set,
the sample_stack_user value determines the size of the
stack dump.

Beeing able to dump parts of the user stack, starting from the
stack pointer, will be useful to make a post mortem dwarf CFI
based stack unwinding.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 include/linux/perf_event.h |   20 ++++++++-
 kernel/events/core.c       |  103 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 122 insertions(+), 1 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 6942c13..dcdc97e 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -131,8 +131,9 @@ enum perf_event_sample_format {
 	PERF_SAMPLE_RAW				= 1U << 10,
 	PERF_SAMPLE_BRANCH_STACK		= 1U << 11,
 	PERF_SAMPLE_REGS			= 1U << 12,
+	PERF_SAMPLE_STACK			= 1U << 13,
 
-	PERF_SAMPLE_MAX = 1U << 13,		/* non-ABI */
+	PERF_SAMPLE_MAX = 1U << 14,		/* non-ABI */
 };
 
 /*
@@ -173,6 +174,15 @@ enum perf_sample_regs {
 };
 
 /*
+ * Values for sample_stack when PERF_SAMPLE_STACK is set.
+ * Defines stack dump to be attached to the sample.
+ */
+enum perf_sample_stack {
+	PERF_SAMPLE_STACK_USER	= 1U << 0, /* user stack */
+	PERF_SAMPLE_STACK_MAX	= 1U << 1, /* non-ABI */
+};
+
+/*
  * The format of the data returned by read() on a perf event fd,
  * as specified by attr.read_format:
  *
@@ -291,6 +301,14 @@ struct perf_event_attr {
 	 * See asm/perf_regs.h for details.
 	 */
 	__u64	sample_regs_user;
+
+	__u64	sample_stack; /* enum perf_sample_stack */
+
+	/*
+	 * Defines size of the user stack to dump on samples,
+	 * for sample_stack PERF_SAMPLE_STACK_USER settings.
+	 */
+	__u64	sample_stack_user;
 };
 
 /*
diff --git a/kernel/events/core.c b/kernel/events/core.c
index e1d9e0c..0ace2c7 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3770,6 +3770,45 @@ perf_output_sample_regs(struct perf_output_handle *handle,
 	} while (mask);
 }
 
+static void
+perf_output_sample_ustack(struct perf_output_handle *handle, u64 dump_size,
+			  struct pt_regs *regs)
+{
+	u64 size;
+
+	/* Case of a kernel thread, nothing to dump */
+	if (!regs) {
+		size = 0;
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
+		size = round_up(dump_size, sizeof(u64));
+		perf_output_put(handle, size);
+
+		sp = user_stack_pointer(regs);
+		rem = __output_copy_user(handle, (void *)sp, size);
+		dyn_size = size - rem;
+
+		/* What couldn't be dumped is zero padded */
+		while (rem--) {
+			char zero = 0;
+			perf_output_put(handle, zero);
+		}
+
+		/* Dynamic size: whole dump - padding */
+		perf_output_put(handle, dyn_size);
+	}
+}
+
 static struct pt_regs *perf_sample_regs_user(struct pt_regs *regs)
 {
 	if (!user_mode(regs)) {
@@ -4066,6 +4105,17 @@ void perf_output_sample(struct perf_output_handle *handle,
 			}
 		}
 	}
+
+	if (sample_type & PERF_SAMPLE_STACK) {
+		u64 mode = event->attr.sample_stack;
+
+		if (mode & PERF_SAMPLE_STACK_USER) {
+			u64 dump_size = event->attr.sample_stack_user;
+
+			perf_output_sample_ustack(handle, dump_size,
+						  data->regs_user);
+		}
+	}
 }
 
 void perf_prepare_sample(struct perf_event_header *header,
@@ -4135,6 +4185,39 @@ void perf_prepare_sample(struct perf_event_header *header,
 
 		header->size += size;
 	}
+
+	if (sample_type & PERF_SAMPLE_STACK) {
+		u64 mode = event->attr.sample_stack;
+		int size = 0;
+
+		if (mode & PERF_SAMPLE_STACK_USER) {
+			if (!data->regs_user)
+				data->regs_user = perf_sample_regs_user(regs);
+
+			/*
+			 * A first field that tells the _static_ size of the
+			 * dump. 0 if there is nothing to dump (ie: we are in
+			 * a kernel thread) otherwise the requested size.
+			 */
+			size += sizeof(u64);
+
+			/*
+			 * If there is something to dump, add space for the
+			 * dump itself and for the field that tells the
+			 * dynamic size, which is how many have been actually
+			 * dumped. What couldn't be dumped will be zero-padded.
+			 */
+			if (data->regs_user) {
+				u64 user_size = event->attr.sample_stack_user;
+
+				user_size = round_up(user_size, sizeof(u64));
+				size += user_size;
+				size += sizeof(u64);
+			}
+		}
+
+		header->size += size;
+	}
 }
 
 static void perf_event_output(struct perf_event *event,
@@ -6209,6 +6292,26 @@ static int perf_copy_attr(struct perf_event_attr __user *uattr,
 			return -EINVAL;
 	}
 
+	if (attr->sample_type & PERF_SAMPLE_STACK) {
+		/* Mode must be specified. */
+		if (attr->sample_stack & ~(PERF_SAMPLE_STACK_MAX-1))
+			return -EINVAL;
+
+		/* Validate registers mask for user mode. */
+		if ((attr->sample_stack & PERF_SAMPLE_STACK_USER) &&
+		    (!attr->sample_stack_user))
+			return -EINVAL;
+	} else  {
+		/*
+		 * Stack dump not required in sample, all stack
+		 * settings should be zero.
+		 */
+		if (attr->sample_stack)
+			return -EINVAL;
+		if (attr->sample_stack_user)
+			return -EINVAL;
+	}
+
 out:
 	return ret;
 
-- 
1.7.7.6

