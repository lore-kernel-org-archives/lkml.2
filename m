Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436Ab0JMFHO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 01:07:14 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35732 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab0JMFHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 01:07:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=GXGJ2sWh5urL4141Seo6+VxHFqI+BZK4NLUSR7SZJrWjQdhKY7fuH63qiJd0GfW59e
         vyWGOZq7LZwdjsH9uNxI70P1563xeVHXd5e05BI8rMbqJzsiOXUUGZ0tKRmqdkorMK5+
         4mFRB591HCSOcX30tiNSVFUMXMf1ANINVtHEI=
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
        Robert Richter <robert.richter@amd.com>
Subject: [RFC PATCH 2/9] perf: Add ability to dump user regs
Date: Wed, 13 Oct 2010 07:06:54 +0200
Message-Id: <1286946421-32202-3-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1286946421-32202-1-git-send-regression-fweisbec@gmail.com>
References: <1286946421-32202-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add new PERF_SAMPLE_UREGS to perf sample type. This will dump the
user space context as it was before the user entered the kernel for
whatever reason.

This is going to be useful to bring Dwarf CFI based stack unwinding
on top of samples.

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
Cc: Stephane Eranian <eranian@google.com>
Cc: Robert Richter <robert.richter@amd.com>
---
 include/linux/perf_event.h |    4 +++-
 kernel/perf_event.c        |   42 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 45 insertions(+), 1 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 61b1e2d..71b108b 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -125,8 +125,9 @@ enum perf_event_sample_format {
 	PERF_SAMPLE_PERIOD			= 1U << 8,
 	PERF_SAMPLE_STREAM_ID			= 1U << 9,
 	PERF_SAMPLE_RAW				= 1U << 10,
+	PERF_SAMPLE_UREGS			= 1U << 11,
 
-	PERF_SAMPLE_MAX = 1U << 11,		/* non-ABI */
+	PERF_SAMPLE_MAX = 1U << 12,		/* non-ABI */
 };
 
 /*
@@ -932,6 +933,7 @@ struct perf_sample_data {
 	u64				period;
 	struct perf_callchain_entry	*callchain;
 	struct perf_raw_record		*raw;
+	struct pt_regs			*uregs;
 };
 
 static inline
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 64507ea..f1c0d72 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1993,6 +1993,19 @@ exit_put:
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
@@ -3607,6 +3620,25 @@ void perf_output_sample(struct perf_output_handle *handle,
 			perf_output_put(handle, raw);
 		}
 	}
+
+	if (sample_type & PERF_SAMPLE_UREGS) {
+		u64 size;
+
+		if (data->uregs) {
+			size = round_up(sizeof(*data->uregs), sizeof(u64));
+			perf_output_put(handle, size);
+			perf_output_copy(handle, data->uregs, sizeof(*data->uregs));
+
+			if (sizeof(*data->uregs) < size) {
+				u64 pad = 0;
+				int pad_size = size - sizeof(*data->uregs);
+				perf_output_copy(handle, &pad, pad_size);
+			}
+		} else {
+			size = 0;
+			perf_output_put(handle, size);
+		}
+	}
 }
 
 void perf_prepare_sample(struct perf_event_header *header,
@@ -3694,6 +3726,16 @@ void perf_prepare_sample(struct perf_event_header *header,
 		WARN_ON_ONCE(size & (sizeof(u64)-1));
 		header->size += size;
 	}
+
+	if (sample_type & PERF_SAMPLE_UREGS) {
+		int size = sizeof(u64);
+
+		data->uregs = perf_sample_uregs(regs);
+		if (data->uregs)
+			size += round_up(sizeof(*data->uregs), sizeof(u64));
+
+		header->size += size;
+	}
 }
 
 static void perf_event_output(struct perf_event *event, int nmi,
-- 
1.6.2.3

