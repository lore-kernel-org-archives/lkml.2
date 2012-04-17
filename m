Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723Ab2DQLSR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 07:18:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16885 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755661Ab2DQLSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 07:18:15 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: eranian@google.com, gorcunov@openvz.org, tzanussi@gmail.com,
        mhiramat@redhat.com, rostedt@goodmis.org, robert.richter@amd.com,
        fche@redhat.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, drepper@gmail.com,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 03/16] perf: Add ability to dump user regs
Date: Tue, 17 Apr 2012 13:17:08 +0200
Message-Id: <1334661441-4420-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1334661441-4420-1-git-send-email-jolsa@redhat.com>
References: <1334661441-4420-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add new attr->user_regs bitmap that lets a user choose a set
of user registers to dump to the sample. The layout of this
bitmap is described in asm/perf_regs.h for archs that
support register dump.

The perf syscall will fail if attr->user_regs is non zero.

The register value here are those of the user space context as
it was before the user entered the kernel for whatever reason
(syscall, irq, exception, or a PMI happening in userspace).

This is going to be useful to bring Dwarf CFI based stack unwinding
on top of samples.

TODO handle compat tasks

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 include/linux/perf_event.h |    8 +++++
 kernel/events/core.c       |   63 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 71 insertions(+), 0 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index ddbb6a9..c63b807 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -272,6 +272,12 @@ struct perf_event_attr {
 		__u64		config2; /* extension of config1 */
 	};
 	__u64	branch_sample_type; /* enum branch_sample_type */
+
+	/*
+	 * Arch specific mask that defines a set of user regs to dump on
+	 * samples. See asm/perf_regs.h for details.
+	 */
+	__u64			user_regs;
 };
 
 /*
@@ -608,6 +614,7 @@ struct perf_guest_info_callbacks {
 #include <linux/atomic.h>
 #include <linux/sysfs.h>
 #include <asm/local.h>
+#include <asm/perf_regs.h>
 
 #define PERF_MAX_STACK_DEPTH		255
 
@@ -1130,6 +1137,7 @@ struct perf_sample_data {
 	struct perf_callchain_entry	*callchain;
 	struct perf_raw_record		*raw;
 	struct perf_branch_stack	*br_stack;
+	struct pt_regs			*uregs;
 };
 
 static inline void perf_sample_data_init(struct perf_sample_data *data, u64 addr)
diff --git a/kernel/events/core.c b/kernel/events/core.c
index a6a9ec4..9f29fc3 100644
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
+static struct pt_regs *perf_sample_uregs(struct pt_regs *regs)
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
@@ -4011,6 +4042,21 @@ void perf_output_sample(struct perf_output_handle *handle,
 			perf_output_put(handle, nr);
 		}
 	}
+
+	if (event->attr.user_regs) {
+		u64 id;
+
+		/*
+		 * If there are no regs to dump, notice it through a
+		 * PERF_REGS_VERSION_NONE version.
+		 */
+		id = data->uregs ? perf_reg_version() : PERF_REGS_VERSION_NONE;
+		perf_output_put(handle, id);
+
+		if (id)
+			perf_output_sample_regs(handle, data->uregs,
+						event->attr.user_regs);
+	}
 }
 
 void perf_prepare_sample(struct perf_event_header *header,
@@ -4062,6 +4108,16 @@ void perf_prepare_sample(struct perf_event_header *header,
 		}
 		header->size += size;
 	}
+
+	if (event->attr.user_regs) {
+		int size = sizeof(u64); /* the version size */
+
+		data->uregs = perf_sample_uregs(regs);
+		if (data->uregs)
+			size += hweight64(event->attr.user_regs) * sizeof(u64);
+
+		header->size += size;
+	}
 }
 
 static void perf_event_output(struct perf_event *event,
@@ -6112,6 +6168,13 @@ static int perf_copy_attr(struct perf_event_attr __user *uattr,
 			attr->branch_sample_type = mask;
 		}
 	}
+
+	/*
+	 * Don't let throught invalid register mask (i.e. the architecture
+	 * does not support register dump at all).
+	 */
+	ret = perf_reg_validate(attr->user_regs);
+
 out:
 	return ret;
 
-- 
1.7.7.6

