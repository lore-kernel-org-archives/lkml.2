Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759733Ab0JVTN2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:13:28 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49359 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759674Ab0JVTNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 15:13:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=t2cO+6u0CWHFSNCVjKsWpKtA8KLs508EQ73EM9DkEbq+NHhVddLMH0jvyzvYZF5N4Q
         9whP92/mfV2RHXoao9gKUA8qjtpft1Nqq1gprEw8flSXdglnjXlLxdwyxZm5BN/wHV7W
         htWTd1wy1X16RxG8lUD+cjyjEDbLASPGYJIoc=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        Masami Hiramatsu <mhiramat@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Robert Richter <robert.richter@amd.com>,
        "Frank Ch. Eigler" <fche@redhat.com>
Subject: [RFC PATCH 03/11] perf: Add ability to dump user regs
Date: Fri, 22 Oct 2010 21:13:04 +0200
Message-Id: <1287774792-23123-4-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1287774792-23123-1-git-send-regression-fweisbec@gmail.com>
References: <1287774792-23123-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add new attr->user_regs bitmap that lets a user choose a set
of user registers to dump to the sample. The layout of this
bitmap is described in asm/perf_regs.h for archs that
support CONFIG_HAVE_PERF_REGS_DEFS, otherwise the perf
syscall will fail if attr->user_regs is non zero.

The register value here are those of the user space context as
it was before the user entered the kernel for whatever reason
(syscall, irq, exception, or a PMI happening in userspace).

This is going to be useful to bring Dwarf CFI based stack unwinding
on top of samples.

FIXME: the issue of compat regs has yet to be solved. I think we
need to split the regs bitmap in:

	attr->user_regs32
	attr->user_regs64

So that userspace doesn't need to care about beeing a compat task or
not, running on a 32 bits kernel or not, it can provide both bitmaps
and let the kernel handle that, ignore user_regs64 if it is a 32 bits
kernel, handle it otherwise and also user_regs32 for compat tasks,
etc...

Hmm?

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Frank Ch. Eigler <fche@redhat.com>
---
 include/linux/perf_event.h |   28 +++++++++++++++++++
 kernel/perf_event.c        |   63 +++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 90 insertions(+), 1 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 057bf22..28210d4 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -226,6 +226,16 @@ struct perf_event_attr {
 	__u32			bp_type;
 	__u64			bp_addr;
 	__u64			bp_len;
+
+	/* Future breakpoint fields extension */
+	__u64			__reserved_2;
+	__u64			__reserved_3;
+
+	/*
+	 * Arch specific mask that defines a set of user regs to dump on
+	 * samples. See asm/perf_regs.h for details.
+	 */
+	__u64			user_regs;
 };
 
 /*
@@ -475,6 +485,7 @@ struct perf_guest_info_callbacks {
 #include <asm/hw_breakpoint.h>
 #endif
 
+
 #include <linux/list.h>
 #include <linux/mutex.h>
 #include <linux/rculist.h>
@@ -891,6 +902,22 @@ struct perf_output_handle {
 
 #ifdef CONFIG_PERF_EVENTS
 
+#ifdef CONFIG_HAVE_PERF_REGS_DEFS
+#include <asm/perf_regs.h>
+#else
+static inline int perf_reg_value(struct pt_regs *regs, int idx) { return 0; }
+
+static inline int perf_reg_version(struct pt_regs *regs, int idx)
+{
+	return -EINVAL;
+}
+
+static inline int perf_reg_validate(u64 mask)
+{
+	return -ENOSYS;
+}
+#endif /*CONFIG_HAVE_PERF_REGS_DUMP */
+
 extern int perf_pmu_register(struct pmu *pmu);
 extern void perf_pmu_unregister(struct pmu *pmu);
 
@@ -950,6 +977,7 @@ struct perf_sample_data {
 	u64				period;
 	struct perf_callchain_entry	*callchain;
 	struct perf_raw_record		*raw;
+	struct pt_regs			*uregs;
 };
 
 static inline
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 05ecf6f..0e4ab11 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -2051,6 +2051,19 @@ exit_put:
 	return entry;
 }
 
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
+
 /*
  * Initialize the perf_event context in a task_struct:
  */
@@ -3502,6 +3515,25 @@ static void perf_output_read(struct perf_output_handle *handle,
 		perf_output_read_one(handle, event);
 }
 
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
 void perf_output_sample(struct perf_output_handle *handle,
 			struct perf_event_header *header,
 			struct perf_sample_data *data,
@@ -3570,6 +3602,22 @@ void perf_output_sample(struct perf_output_handle *handle,
 			perf_output_put(handle, raw);
 		}
 	}
+
+	if (event->attr.user_regs) {
+		u64 id;
+
+		/* If there is no regs to dump, notice it through a 0 version */
+		if (!data->uregs) {
+			id = 0;
+			perf_output_put(handle, id);
+		} else {
+
+			id = perf_reg_version();
+			perf_output_put(handle, id);
+			perf_output_sample_regs(handle, data->uregs,
+						event->attr.user_regs);
+		}
+	}
 }
 
 void perf_prepare_sample(struct perf_event_header *header,
@@ -3657,6 +3705,17 @@ void perf_prepare_sample(struct perf_event_header *header,
 		WARN_ON_ONCE(size & (sizeof(u64)-1));
 		header->size += size;
 	}
+
+	if (event->attr.user_regs) {
+		int size = sizeof(u64); /* the version size */
+
+		data->uregs = perf_sample_uregs(regs);
+		if (data->uregs)
+			/* Regs values */
+			size += hweight64(event->attr.user_regs) * sizeof(u64);
+
+		header->size += size;
+	}
 }
 
 static void perf_event_output(struct perf_event *event, int nmi,
@@ -5429,7 +5488,7 @@ static int perf_copy_attr(struct perf_event_attr __user *uattr,
 	if (attr->type >= PERF_TYPE_MAX)
 		return -EINVAL;
 
-	if (attr->__reserved_1)
+	if (attr->__reserved_1 || attr->__reserved_2 || attr->__reserved_3)
 		return -EINVAL;
 
 	if (attr->sample_type & ~(PERF_SAMPLE_MAX-1))
@@ -5438,6 +5497,8 @@ static int perf_copy_attr(struct perf_event_attr __user *uattr,
 	if (attr->read_format & ~(PERF_FORMAT_MAX-1))
 		return -EINVAL;
 
+	ret = perf_reg_validate(attr->user_regs);
+
 out:
 	return ret;
 
-- 
1.6.2.3

