Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759483Ab2JTA46 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 20:56:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36136 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755709Ab2JTA4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 20:56:55 -0400
Date: Fri, 19 Oct 2012 17:56:36 -0700
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
Message-ID: <tip-20b279ddb38ca42f8863cec07b4d45ec24589f13@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, gleb@redhat.com,
        robert.richter@amd.com, dsahern@gmail.com, tglx@linutronix.de,
        avi@redhat.com
Reply-To: gleb@redhat.com, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, robert.richter@amd.com,
        peterz@infradead.org, dsahern@gmail.com, tglx@linutronix.de,
        avi@redhat.com
In-Reply-To: <1347569955-54626-3-git-send-email-dsahern@gmail.com>
References: <1347569955-54626-3-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf:
  Require exclude_guest to use PEBS - kernel side enforcement
Git-Commit-ID: 20b279ddb38ca42f8863cec07b4d45ec24589f13
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 19 Oct 2012 17:56:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  20b279ddb38ca42f8863cec07b4d45ec24589f13
Gitweb:     http://git.kernel.org/tip/20b279ddb38ca42f8863cec07b4d45ec24589f13
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 13 Sep 2012 14:59:14 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 16 Oct 2012 12:43:58 -0300

perf: Require exclude_guest to use PEBS - kernel side enforcement

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
