Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133Ab2INGSI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 02:18:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49012 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084Ab2INGSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 02:18:06 -0400
Date: Thu, 13 Sep 2012 23:17:51 -0700
From: tip-bot for Robert Richter <robert.richter@amd.com>
Message-ID: <tip-bad9ac2d7f878a31cf1ae8c1ee3768077d222bcb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        robert.richter@amd.com, a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        robert.richter@amd.com, a.p.zijlstra@chello.nl, tglx@linutronix.de
In-Reply-To: <20120910093018.GO8285@erda.amd.com>
References: <20120910093018.GO8285@erda.amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/x86/ibs: Check syscall attribute flags
Git-Commit-ID: bad9ac2d7f878a31cf1ae8c1ee3768077d222bcb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 13 Sep 2012 23:17:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bad9ac2d7f878a31cf1ae8c1ee3768077d222bcb
Gitweb:     http://git.kernel.org/tip/bad9ac2d7f878a31cf1ae8c1ee3768077d222bcb
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Wed, 25 Jul 2012 19:12:45 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 13 Sep 2012 16:59:48 +0200

perf/x86/ibs: Check syscall attribute flags

Current implementation simply ignores attribute flags. Thus, there is
no notification to userland of unsupported features. Check syscall's
attribute flags to let userland know if a feature is supported by the
kernel. This is also needed to distinguish between future kernels what
might support a feature.

Cc: <stable@vger.kernel.org> v3.5..
Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20120910093018.GO8285@erda.amd.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_amd_ibs.c |   12 ++++++++++++
 include/linux/perf_event.h               |    2 ++
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd_ibs.c b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
index 7bfb5be..eebd5ff 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
@@ -209,6 +209,15 @@ static int perf_ibs_precise_event(struct perf_event *event, u64 *config)
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
@@ -229,6 +238,9 @@ static int perf_ibs_init(struct perf_event *event)
 	if (event->pmu != &perf_ibs->pmu)
 		return -ENOENT;
 
+	if (perf_flags(&event->attr) & perf_flags(&ibs_notsupp))
+		return -EINVAL;
+
 	if (config & ~perf_ibs->config_mask)
 		return -EINVAL;
 
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 33ed9d6..bdb4161 100644
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
