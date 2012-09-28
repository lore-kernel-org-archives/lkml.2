Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965415Ab2I1TgY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:36:24 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51579 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965353Ab2I1TAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:00:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Robert Richter <robert.richter@amd.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>
Subject: [ 136/262] perf/x86/ibs: Check syscall attribute flags
Date: Fri, 28 Sep 2012 11:51:05 -0700
Message-Id: <20120928183014.071305234@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robert Richter <robert.richter@amd.com>

commit bad9ac2d7f878a31cf1ae8c1ee3768077d222bcb upstream.

Current implementation simply ignores attribute flags. Thus, there is
no notification to userland of unsupported features. Check syscall's
attribute flags to let userland know if a feature is supported by the
kernel. This is also needed to distinguish between future kernels what
might support a feature.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20120910093018.GO8285@erda.amd.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/cpu/perf_event_amd_ibs.c |   12 ++++++++++++
 include/linux/perf_event.h               |    2 ++
 2 files changed, 14 insertions(+)

--- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
@@ -207,6 +207,15 @@ static int perf_ibs_precise_event(struct
 	return -EOPNOTSUPP;
 }
 
+static const struct perf_event_attr ibs_notsupp = {
+	.exclude_user	= 1,
+	.exclude_kernel	= 1,
+	.exclude_hv	= 1,
+	.exclude_idle	= 1,
+	.exclude_host	= 1,
+	.exclude_guest	= 1,
+};
+
 static int perf_ibs_init(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
@@ -227,6 +236,9 @@ static int perf_ibs_init(struct perf_eve
 	if (event->pmu != &perf_ibs->pmu)
 		return -ENOENT;
 
+	if (perf_flags(&event->attr) & perf_flags(&ibs_notsupp))
+		return -EINVAL;
+
 	if (config & ~perf_ibs->config_mask)
 		return -EINVAL;
 
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -274,6 +274,8 @@ struct perf_event_attr {
 	__u64	branch_sample_type; /* enum branch_sample_type */
 };
 
+#define perf_flags(attr)	(*(&(attr)->read_format + 1))
+
 /*
  * Ioctls that can be done on a perf event fd:
  */


