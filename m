Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933250Ab0KMAZZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 19:25:25 -0500
Received: from smtp-out.google.com ([216.239.44.51]:8784 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484Ab0KMAZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 19:25:22 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=E7M32LumKH6GmYJsp7UNpjrDMO5DoeWF0uBqfT8ksWN4lpQXhONVTsuH0o9IvVhQt
	OiEDPDDGGlt+rrZBuCnjA==
From: Todd Poynor <toddpoynor@google.com>
To: linux-kernel@vger.kernel.org
Cc: srostedt@redhat.com, Todd Poynor <toddpoynor@google.com>
Subject: [PATCH] preemptoff tracer: trace the preempt enable at preempt_schedule
Date: Fri, 12 Nov 2010 16:24:16 -0800
Message-Id: <1289607856-29995-1-git-send-email-toddpoynor@google.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

preempt_schedule() uses the _notrace versions of the preemption
disable/enable routines for setting the PREEMPT_ACTIVE flag to avoid
a race condition per commit d1f74e2.  This causes the preemptoff
trace to not be properly terminated when the preempted thread is
rescheduled.  Since the original fix only converted the preempt
re-enable to use the _notrace version for symmetry, call the tracing
version instead.  The corresponding preemptoff start will be
traced by the preempt_disable() in schedule(), although this may
be relying on a fragile state of affairs, and it may be best to also
add a direct call to trace a preempt disable after preemption is
safely disabled and the race avoided.

Signed-off-by: Todd Poynor <toddpoynor@google.com>
---
 kernel/sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index aa14a56..de83e30 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4041,7 +4041,7 @@ asmlinkage void __sched notrace preempt_schedule(void)
 	do {
 		add_preempt_count_notrace(PREEMPT_ACTIVE);
 		schedule();
-		sub_preempt_count_notrace(PREEMPT_ACTIVE);
+		sub_preempt_count(PREEMPT_ACTIVE);
 
 		/*
 		 * Check again in case we missed a preemption opportunity
-- 
1.7.3.1

