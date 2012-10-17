Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547Ab2JQRUI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 13:20:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:46048 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757504Ab2JQRUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 13:20:03 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Avi Kivity <avi@redhat.com>, David Ahern <dsahern@gmail.com>,
        Gleb Natapov <gleb@redhat.com>,
        Robert Richter <robert.richter@amd.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 02/11] perf: Require exclude_guest to use PEBS - kernel side enforcement
Date: Wed, 17 Oct 2012 14:19:38 -0300
Message-Id: <1350494387-10987-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1350494387-10987-1-git-send-email-acme@infradead.org>
References: <1350494387-10987-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

Intel PEBS in VT-x context uses the DS address as a guest linear
address, even though its programmed by the host as a host linear
address. This either results in guest memory corruption and or the
hardware faulting and 'crashing' the virtual machine.  Therefore we have
to disable PEBS on VT-x enter and re-enable on VT-x exit, enforcing a
strict exclude_guest.

This patch enforces exclude_guest kernel side.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Avi Kivity <avi@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Gleb Natapov <gleb@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Robert Richter <robert.richter@amd.com>
Link: http://lkml.kernel.org/r/1347569955-54626-3-git-send-email-dsahern@gmail.com
Signed-off-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 arch/x86/kernel/cpu/perf_event.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 915b876..3373f84 100644
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
+			return -EOPNOTSUPP;
+
 		/* Support for constant skid */
 		if (x86_pmu.pebs_active && !x86_pmu.pebs_broken) {
 			precise++;
-- 
1.7.1

