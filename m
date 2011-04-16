Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400Ab1DPD2U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 23:28:20 -0400
Received: from smtp-out.google.com ([216.239.44.51]:4716 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923Ab1DPD2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 23:28:19 -0400
From: Sonny Rao <sonnyrao@chromium.org>
To: Jamie Iles <jamie@jamieiles.com>
Cc: olofj@chromium.org, Sonny Rao <sonnyrao@chromium.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>, Jamie Iles <jamie@jamieiles.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Fix infinite loop in ARM user perf_event backtrace code
Date: Fri, 15 Apr 2011 20:27:25 -0700
Message-Id: <1302924445-18557-1-git-send-email-sonnyrao@chromium.org>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ARM user backtrace code can get into an infinite loop if it
runs into an invalid stack frame which points back to itself.
This situation has been observed in practice.  Fix it by capping
the number of entries in the backtrace.  This is also what other
architectures do in their backtrace code.

Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
---
 arch/arm/kernel/perf_event.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
index 69cfee0..1e61d60 100644
--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -746,7 +746,8 @@ perf_callchain_user(struct perf_callchain_entry *entry, struct pt_regs *regs)
 
 	tail = (struct frame_tail __user *)regs->ARM_fp - 1;
 
-	while (tail && !((unsigned long)tail & 0x3))
+	while ((entry->nr < PERF_MAX_STACK_DEPTH) &&
+	       tail && !((unsigned long)tail & 0x3))
 		tail = user_backtrace(tail, entry);
 }
 
-- 
1.7.3.1

