Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932593Ab0JDUZK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 16:25:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:39673 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932085Ab0JDUZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 16:25:08 -0400
Date: Mon, 4 Oct 2010 20:24:39 GMT
From: tip-bot for Robert Richter <robert.richter@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        robert.richter@amd.com, will.deacon@arm.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        robert.richter@amd.com, will.deacon@arm.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20100929145225.GJ13563@erda.amd.com>
References: <20100929145225.GJ13563@erda.amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] oprofile, ARM: Release resources on failure
Message-ID: <tip-98d943b02f6f1b57787ff1aa6f34d019a407e3ee@git.kernel.org>
Git-Commit-ID: 98d943b02f6f1b57787ff1aa6f34d019a407e3ee
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 04 Oct 2010 20:24:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  98d943b02f6f1b57787ff1aa6f34d019a407e3ee
Gitweb:     http://git.kernel.org/tip/98d943b02f6f1b57787ff1aa6f34d019a407e3ee
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Wed, 29 Sep 2010 16:52:25 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 30 Sep 2010 09:14:25 +0200

oprofile, ARM: Release resources on failure

This patch fixes a resource leak on failure, where the
oprofilefs and some counters may not released properly.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: <stable@kernel.org> # .35.x
LKML-Reference: <20100929145225.GJ13563@erda.amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/arm/oprofile/common.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/arm/oprofile/common.c b/arch/arm/oprofile/common.c
index 0691176..72e09eb 100644
--- a/arch/arm/oprofile/common.c
+++ b/arch/arm/oprofile/common.c
@@ -102,6 +102,7 @@ static int op_create_counter(int cpu, int event)
 	if (IS_ERR(pevent)) {
 		ret = PTR_ERR(pevent);
 	} else if (pevent->state != PERF_EVENT_STATE_ACTIVE) {
+		perf_event_release_kernel(pevent);
 		pr_warning("oprofile: failed to enable event %d "
 				"on CPU %d\n", event, cpu);
 		ret = -EBUSY;
@@ -365,6 +366,7 @@ int __init oprofile_arch_init(struct oprofile_operations *ops)
 	ret = init_driverfs();
 	if (ret) {
 		kfree(counter_config);
+		counter_config = NULL;
 		return ret;
 	}
 
@@ -402,7 +404,6 @@ void oprofile_arch_exit(void)
 	struct perf_event *event;
 
 	if (*perf_events) {
-		exit_driverfs();
 		for_each_possible_cpu(cpu) {
 			for (id = 0; id < perf_num_counters; ++id) {
 				event = perf_events[cpu][id];
@@ -413,8 +414,10 @@ void oprofile_arch_exit(void)
 		}
 	}
 
-	if (counter_config)
+	if (counter_config) {
 		kfree(counter_config);
+		exit_driverfs();
+	}
 }
 #else
 int __init oprofile_arch_init(struct oprofile_operations *ops)
