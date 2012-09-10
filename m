Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582Ab2IJQlA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 12:41:00 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51992 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265Ab2IJQka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 12:40:30 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        peterz@infradead.org
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Robert Richter <robert.richter@amd.com>,
        Gleb Natapov <gleb@redhat.com>, Avi Kivity <avi@redhat.com>
Subject: [PATCH 2/3] perf: require exclude_guest to use PEBS - kernel side enforcement
Date: Mon, 10 Sep 2012 10:40:15 -0600
Message-Id: <1347295216-1202-3-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1347295216-1202-1-git-send-email-dsahern@gmail.com>
References: <1347295216-1202-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

See https://lkml.org/lkml/2012/7/9/298

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Gleb Natapov <gleb@redhat.com>
Cc: Avi Kivity <avi@redhat.com>
---
 arch/x86/kernel/cpu/perf_event.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 915b876..4bc96c5 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -338,6 +338,9 @@ int x86_setup_perfctr(struct perf_event *event)
 		/* BTS is currently only allowed for user-mode. */
 		if (!attr->exclude_kernel)
 			return -EOPNOTSUPP;
+
+		if (!attr->exclude_guest)
+			return -EOPNOTSUPP;
 	}
 
 	hwc->config |= config;
@@ -380,6 +383,9 @@ int x86_pmu_hw_config(struct perf_event *event)
 	if (event->attr.precise_ip) {
 		int precise = 0;
 
+		if (!event->attr.exclude_guest)
+				return -EOPNOTSUPP;
+
 		/* Support for constant skid */
 		if (x86_pmu.pebs_active && !x86_pmu.pebs_broken) {
 			precise++;
-- 
1.7.10.1

