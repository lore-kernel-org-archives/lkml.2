Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757398Ab2HUPtK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:49:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60223 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121Ab2HUPtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:49:07 -0400
Date: Tue, 21 Aug 2012 08:48:24 -0700
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-5685e0ff45f5df67e79e9b052b6ffd501ff38c11@git.kernel.org>
Cc: acme@redhat.com, eranian@google.com, mingo@kernel.org, gorcunov@openvz.org,
        a.p.zijlstra@chello.nl, benjamin.redelings@nescent.org,
        jolsa@redhat.com, drepper@gmail.com, robert.richter@amd.com,
        fweisbec@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
        asharma@fb.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        fche@redhat.com, paulus@samba.org, tzanussi@gmail.com,
        masami.hiramatsu.pt@hitachi.com, mingo@elte.hu
Reply-To: mingo@kernel.org, eranian@google.com, acme@redhat.com,
        gorcunov@openvz.org, a.p.zijlstra@chello.nl,
        benjamin.redelings@nescent.org, jolsa@redhat.com, fweisbec@gmail.com,
        robert.richter@amd.com, drepper@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, asharma@fb.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, hpa@zytor.com, fche@redhat.com,
        tzanussi@gmail.com, masami.hiramatsu.pt@hitachi.com, mingo@elte.hu
In-Reply-To: <1344345647-11536-5-git-send-email-jolsa@redhat.com>
References: <1344345647-11536-5-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf:
  Add perf_output_skip function to skip bytes in sample
Git-Commit-ID: 5685e0ff45f5df67e79e9b052b6ffd501ff38c11
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 08:48:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5685e0ff45f5df67e79e9b052b6ffd501ff38c11
Gitweb:     http://git.kernel.org/tip/5685e0ff45f5df67e79e9b052b6ffd501ff38c11
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Tue, 7 Aug 2012 15:20:39 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 10 Aug 2012 12:16:22 -0300

perf: Add perf_output_skip function to skip bytes in sample

Introducing perf_output_skip function to be able to skip data within the
perf ring buffer.

When writing data into perf ring buffer we first reserve needed place in
ring buffer and then copy the actual data.

There's a possibility we won't be able to fill all the reserved size
with data, so we need a way to skip the remaining bytes.

This is going to be useful when storing the user stack dump, where we
might end up with less data than we originally requested.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Arun Sharma <asharma@fb.com>
Cc: Benjamin Redelings <benjamin.redelings@nescent.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Ulrich Drepper <drepper@gmail.com>
Link: http://lkml.kernel.org/r/1344345647-11536-5-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 include/linux/perf_event.h  |    2 ++
 kernel/events/internal.h    |    4 ++++
 kernel/events/ring_buffer.c |    6 ++++++
 3 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index d41394a..8a73f75 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1321,6 +1321,8 @@ extern int perf_output_begin(struct perf_output_handle *handle,
 extern void perf_output_end(struct perf_output_handle *handle);
 extern unsigned int perf_output_copy(struct perf_output_handle *handle,
 			     const void *buf, unsigned int len);
+extern unsigned int perf_output_skip(struct perf_output_handle *handle,
+				     unsigned int len);
 extern int perf_swevent_get_recursion_context(void);
 extern void perf_swevent_put_recursion_context(int rctx);
 extern void perf_event_enable(struct perf_event *event);
diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index 7fd5408..ce7bdfc 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -114,6 +114,10 @@ static inline int memcpy_common(void *dst, const void *src, size_t n)
 
 DEFINE_OUTPUT_COPY(__output_copy, memcpy_common)
 
+#define MEMCPY_SKIP(dst, src, n) (n)
+
+DEFINE_OUTPUT_COPY(__output_skip, MEMCPY_SKIP)
+
 #ifndef arch_perf_out_copy_user
 #define arch_perf_out_copy_user __copy_from_user_inatomic
 #endif
diff --git a/kernel/events/ring_buffer.c b/kernel/events/ring_buffer.c
index b4c2ad3..23cb34f 100644
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -188,6 +188,12 @@ unsigned int perf_output_copy(struct perf_output_handle *handle,
 	return __output_copy(handle, buf, len);
 }
 
+unsigned int perf_output_skip(struct perf_output_handle *handle,
+			      unsigned int len)
+{
+	return __output_skip(handle, NULL, len);
+}
+
 void perf_output_end(struct perf_output_handle *handle)
 {
 	perf_output_put_handle(handle);
