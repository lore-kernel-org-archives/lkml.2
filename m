Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965288Ab2EWTcu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 15:32:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40085 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933929Ab2EWTcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 15:32:46 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: eranian@google.com, gorcunov@openvz.org, tzanussi@gmail.com,
        mhiramat@redhat.com, robert.richter@amd.com, fche@redhat.com,
        linux-kernel@vger.kernel.org, masami.hiramatsu.pt@hitachi.com,
        drepper@gmail.com, asharma@fb.com, benjamin.redelings@nescent.org,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 02/16] perf: Add ability to attach registers dump to sample
Date: Wed, 23 May 2012 21:32:01 +0200
Message-Id: <1337801535-12865-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1337801535-12865-1-git-send-email-jolsa@redhat.com>
References: <1337801535-12865-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introducing new sample_type bit PERF_SAMPLE_REGS. Once set,
the sample_regs value determines the kind of registers going
to be attached to the sample.

Currently only user level registers are supported, specified by
PERF_SAMPLE_REGS_USER sample_regs value. Meaning the register
values of the user space context as it was before the user entered
the kernel for whatever reason (syscall, irq, exception, or a PMI
happening in userspace).

When PERF_SAMPLE_REGS and PERF_SAMPLE_REGS_USER are set, the
sample_regs_user bitmap lets a user choose a set of registers
to dump for the sample. The layout of this bitmap is described
in asm/perf_regs.h for archs that support register dump.

This is going to be useful to bring Dwarf CFI based stack
unwinding on top of samples.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 include/linux/perf_event.h |   25 ++++++++++-
 kernel/events/core.c       |   98 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 121 insertions(+), 2 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index f325786..06f4b04 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -130,8 +130,9 @@ enum perf_event_sample_format {
 	PERF_SAMPLE_STREAM_ID			= 1U << 9,
 	PERF_SAMPLE_RAW				= 1U << 10,
 	PERF_SAMPLE_BRANCH_STACK		= 1U << 11,
+	PERF_SAMPLE_REGS			= 1U << 12,
 
-	PERF_SAMPLE_MAX = 1U << 12,		/* non-ABI */
+	PERF_SAMPLE_MAX = 1U << 13,		/* non-ABI */
 };
 
 /*
@@ -163,6 +164,15 @@ enum perf_branch_sample_type {
 	 PERF_SAMPLE_BRANCH_HV)
 
 /*
+ * Values for sample_regs when PERF_SAMPLE_REGS is set.
+ * Defines register set to be attached to the sample.
+ */
+enum perf_sample_regs {
+	PERF_SAMPLE_REGS_USER	= 1U << 0, /* user registers */
+	PERF_SAMPLE_REGS_MAX	= 1U << 1, /* non-ABI */
+};
+
+/*
  * The format of the data returned by read() on a perf event fd,
  * as specified by attr.read_format:
  *
@@ -271,7 +281,16 @@ struct perf_event_attr {
 		__u64		bp_len;
 		__u64		config2; /* extension of config1 */
 	};
-	__u64	branch_sample_type; /* enum branch_sample_type */
+	__u64	branch_sample_type; /* enum perf_branch_sample_type */
+
+	__u64	sample_regs; /* enum perf_sample_regs */
+
+	/*
+	 * Arch specific mask for PERF_SAMPLE_REGS_USER setup.
+	 * Defines set of user regs to dump on samples.
+	 * See asm/perf_regs.h for details.
+	 */
+	__u64	sample_regs_user;
 };
 
 /*
@@ -607,6 +626,7 @@ struct perf_guest_info_callbacks {
 #include <linux/static_key.h>
 #include <linux/atomic.h>
 #include <linux/sysfs.h>
+#include <linux/perf_regs.h>
 #include <asm/local.h>
 
 #define PERF_MAX_STACK_DEPTH		255
@@ -1130,6 +1150,7 @@ struct perf_sample_data {
 	struct perf_callchain_entry	*callchain;
 	struct perf_raw_record		*raw;
 	struct perf_branch_stack	*br_stack;
+	struct pt_regs			*regs_user;
 };
 
 static inline void perf_sample_data_init(struct perf_sample_data *data,
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 5b06cbb..e1d9e0c 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3751,6 +3751,37 @@ int perf_unregister_guest_info_callbacks(struct perf_guest_info_callbacks *cbs)
 }
 EXPORT_SYMBOL_GPL(perf_unregister_guest_info_callbacks);
 
+static void
+perf_output_sample_regs(struct perf_output_handle *handle,
+			struct pt_regs *regs, u64 mask)
+{
+	int i = 0;
+
+	do {
+		u64 val;
+
+		if (mask & 1) {
+			val = perf_reg_value(regs, i);
+			perf_output_put(handle, val);
+		}
+
+		mask >>= 1;
+		i++;
+	} while (mask);
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
@@ -4011,6 +4042,30 @@ void perf_output_sample(struct perf_output_handle *handle,
 			perf_output_put(handle, nr);
 		}
 	}
+
+	if (sample_type & PERF_SAMPLE_REGS) {
+		u64 mode = event->attr.sample_regs;
+
+		if (mode & PERF_SAMPLE_REGS_USER) {
+			u64 id = PERF_REGS_ABI_NONE;
+
+			/*
+			 * If there are no regs to dump, notice it through
+			 * PERF_REGS_ABI_NONE id.
+			 */
+			if (data->regs_user)
+				id = perf_reg_version();
+
+			perf_output_put(handle, id);
+
+			if (id) {
+				u64 mask = event->attr.sample_regs_user;
+				perf_output_sample_regs(handle,
+							data->regs_user,
+							mask);
+			}
+		}
+	}
 }
 
 void perf_prepare_sample(struct perf_event_header *header,
@@ -4062,6 +4117,24 @@ void perf_prepare_sample(struct perf_event_header *header,
 		}
 		header->size += size;
 	}
+
+	if (sample_type & PERF_SAMPLE_REGS) {
+		u64 mode = event->attr.sample_regs;
+		int size = 0;
+
+		if (mode & PERF_SAMPLE_REGS_USER) {
+			/* regs ID size */
+			size += sizeof(u64);
+
+			data->regs_user = perf_sample_regs_user(regs);
+			if (data->regs_user) {
+				u64 mask = event->attr.sample_regs_user;
+				size += hweight64(mask) * sizeof(u64);
+			}
+		}
+
+		header->size += size;
+	}
 }
 
 static void perf_event_output(struct perf_event *event,
@@ -6111,6 +6184,31 @@ static int perf_copy_attr(struct perf_event_attr __user *uattr,
 			attr->branch_sample_type = mask;
 		}
 	}
+
+	if (attr->sample_type & PERF_SAMPLE_REGS) {
+		/* Mode must be specified. */
+		if (attr->sample_regs & ~(PERF_SAMPLE_REGS_MAX-1))
+			return -EINVAL;
+
+		/* Validate registers mask for user mode. */
+		if (attr->sample_regs & PERF_SAMPLE_REGS_USER)
+			ret = perf_reg_validate(attr->sample_regs_user);
+		else if (attr->sample_regs_user)
+			return -EINVAL;
+
+		if (ret)
+			return ret;
+	} else  {
+		/*
+		 * Registers are not required in sample, all regs
+		 * settings should be zero.
+		 */
+		if (attr->sample_regs)
+			return -EINVAL;
+		if (attr->sample_regs_user)
+			return -EINVAL;
+	}
+
 out:
 	return ret;
 
-- 
1.7.7.6

