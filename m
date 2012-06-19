Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585Ab2FSPtU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 11:49:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34979 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754021Ab2FSPtQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 11:49:16 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: eranian@google.com, gorcunov@openvz.org, tzanussi@gmail.com,
        mhiramat@redhat.com, robert.richter@amd.com, fche@redhat.com,
        linux-kernel@vger.kernel.org, masami.hiramatsu.pt@hitachi.com,
        drepper@gmail.com, asharma@fb.com, benjamin.redelings@nescent.org,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 03/23] perf: Add ability to attach user level registers dump to sample
Date: Tue, 19 Jun 2012 17:47:54 +0200
Message-Id: <1340120894-9465-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1340120894-9465-1-git-send-email-jolsa@redhat.com>
References: <1340120894-9465-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introducing PERF_SAMPLE_REGS_USER sample type bit to trigger
the dump of user level registers on sample. Registers we want
to dump are specified by sample_regs_user bitmask.

Only user level registers are dump at the moment. Meaning the
register values of the user space context as it was before the
user entered the kernel for whatever reason (syscall, irq,
exception, or a PMI happening in userspace).

The layout of the sample_regs_user bitmap is described in
asm/perf_regs.h for archs that support register dump.

This is going to be useful to bring Dwarf CFI based stack
unwinding on top of samples.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 include/linux/perf_event.h |   20 ++++++++++++--
 kernel/events/core.c       |   61 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 78 insertions(+), 3 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 1ce887a..969ee0b 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -130,8 +130,9 @@ enum perf_event_sample_format {
 	PERF_SAMPLE_STREAM_ID			= 1U << 9,
 	PERF_SAMPLE_RAW				= 1U << 10,
 	PERF_SAMPLE_BRANCH_STACK		= 1U << 11,
+	PERF_SAMPLE_REGS_USER			= 1U << 12,
 
-	PERF_SAMPLE_MAX = 1U << 12,		/* non-ABI */
+	PERF_SAMPLE_MAX = 1U << 13,		/* non-ABI */
 };
 
 /*
@@ -194,6 +195,7 @@ enum perf_event_read_format {
 #define PERF_ATTR_SIZE_VER0	64	/* sizeof first published struct */
 #define PERF_ATTR_SIZE_VER1	72	/* add: config2 */
 #define PERF_ATTR_SIZE_VER2	80	/* add: branch_sample_type */
+#define PERF_ATTR_SIZE_VER3	88	/* add: sample_regs_user */
 
 /*
  * Hardware event_id to monitor via a performance monitoring event:
@@ -271,7 +273,13 @@ struct perf_event_attr {
 		__u64		bp_len;
 		__u64		config2; /* extension of config1 */
 	};
-	__u64	branch_sample_type; /* enum branch_sample_type */
+	__u64	branch_sample_type; /* enum perf_branch_sample_type */
+
+	/*
+	 * Defines set of user regs to dump on samples.
+	 * See asm/perf_regs.h for details.
+	 */
+	__u64	sample_regs_user;
 };
 
 /*
@@ -548,6 +556,9 @@ enum perf_event_type {
 	 *	  char                  data[size];}&& PERF_SAMPLE_RAW
 	 *
 	 *	{ u64 from, to, flags } lbr[nr];} && PERF_SAMPLE_BRANCH_STACK
+	 *
+	 * 	{ u64			available;
+	 * 	  u64			regs[weight(mask)]; } && PERF_SAMPLE_REGS_USER
 	 * };
 	 */
 	PERF_RECORD_SAMPLE			= 9,
@@ -609,6 +620,7 @@ struct perf_guest_info_callbacks {
 #include <linux/static_key.h>
 #include <linux/atomic.h>
 #include <linux/sysfs.h>
+#include <linux/perf_regs.h>
 #include <asm/local.h>
 
 struct perf_callchain_entry {
@@ -1131,6 +1143,7 @@ struct perf_sample_data {
 	struct perf_callchain_entry	*callchain;
 	struct perf_raw_record		*raw;
 	struct perf_branch_stack	*br_stack;
+	struct pt_regs			*regs_user;
 };
 
 static inline void perf_sample_data_init(struct perf_sample_data *data,
@@ -1140,7 +1153,8 @@ static inline void perf_sample_data_init(struct perf_sample_data *data,
 	data->addr = addr;
 	data->raw  = NULL;
 	data->br_stack = NULL;
-	data->period	= period;
+	data->period = period;
+	data->regs_user = NULL;
 }
 
 extern void perf_output_sample(struct perf_output_handle *handle,
diff --git a/kernel/events/core.c b/kernel/events/core.c
index f85c015..7df37e0 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3750,6 +3750,33 @@ int perf_unregister_guest_info_callbacks(struct perf_guest_info_callbacks *cbs)
 }
 EXPORT_SYMBOL_GPL(perf_unregister_guest_info_callbacks);
 
+static void
+perf_output_sample_regs(struct perf_output_handle *handle,
+			struct pt_regs *regs, u64 mask)
+{
+	int bit;
+
+	for_each_set_bit(bit, (const unsigned long *) &mask,
+			 sizeof(mask) * BITS_PER_BYTE) {
+		u64 val;
+
+		val = perf_reg_value(regs, bit);
+		perf_output_put(handle, val);
+	}
+}
+
+static struct pt_regs *perf_sample_regs_user(struct pt_regs *regs)
+{
+	if (!user_mode(regs)) {
+		if (current->mm)
+			regs = task_pt_regs(current);
+		else
+			regs = NULL;
+	}
+
+	return regs;
+}
+
 static void __perf_event_header__init_id(struct perf_event_header *header,
 					 struct perf_sample_data *data,
 					 struct perf_event *event)
@@ -4010,6 +4037,23 @@ void perf_output_sample(struct perf_output_handle *handle,
 			perf_output_put(handle, nr);
 		}
 	}
+
+	if (sample_type & PERF_SAMPLE_REGS_USER) {
+		u64 avail = (data->regs_user != NULL);
+
+		/*
+		 * If there are no regs to dump, notice it through
+		 * first u64 being zero.
+		 */
+		perf_output_put(handle, avail);
+
+		if (avail) {
+			u64 mask = event->attr.sample_regs_user;
+			perf_output_sample_regs(handle,
+						data->regs_user,
+						mask);
+		}
+	}
 }
 
 void perf_prepare_sample(struct perf_event_header *header,
@@ -4061,6 +4105,19 @@ void perf_prepare_sample(struct perf_event_header *header,
 		}
 		header->size += size;
 	}
+
+	if (sample_type & PERF_SAMPLE_REGS_USER) {
+		/* regs dump available bool */
+		int size = sizeof(u64);
+
+		data->regs_user = perf_sample_regs_user(regs);
+		if (data->regs_user) {
+			u64 mask = event->attr.sample_regs_user;
+			size += hweight64(mask) * sizeof(u64);
+		}
+
+		header->size += size;
+	}
 }
 
 static void perf_event_output(struct perf_event *event,
@@ -6110,6 +6167,10 @@ static int perf_copy_attr(struct perf_event_attr __user *uattr,
 			attr->branch_sample_type = mask;
 		}
 	}
+
+	if (attr->sample_type & PERF_SAMPLE_REGS_USER)
+		ret = perf_reg_validate(attr->sample_regs_user);
+
 out:
 	return ret;
 
-- 
1.7.7.6

