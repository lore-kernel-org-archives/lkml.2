Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978Ab0HRXq1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 19:46:27 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60078 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525Ab0HRXqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 19:46:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=mOA81DZpquZjqEAUcJ8ktH8EO7f8GzNK3Kxv9/8ZvrOvb72wylA+ejC4W6LzbybmaS
         GzxHJIIJRuZzbMkko19eaNgrGqZJj1aD/WQxIeQT7aXXdT0k3E6wLEB59W3U9NhK5Amt
         ZGZtBSfwOhAecHvy1M5N0MeG59YJ4yV70lAxQ=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>, Will Deacon <will.deacon@arm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        David Miller <davem@davemloft.net>, Paul Mundt <lethal@linux-sh.org>,
        Borislav Petkov <bp@amd64.org>
Subject: [PATCH 1/7] perf: Drop unappropriate tests on arch callchains
Date: Thu, 19 Aug 2010 01:46:10 +0200
Message-Id: <1282175176-6363-2-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1282175176-6363-1-git-send-regression-fweisbec@gmail.com>
References: <1282175176-6363-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drop the TASK_RUNNING test on user tasks for callchains as
this check doesn't seem to make any sense.

Also remove the tests for !current that is not supposed to
happen and current->pid as this should be handled at the
generic level, with exclude_idle attribute.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Tested-by: Will Deacon <will.deacon@arm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: David Miller <davem@davemloft.net>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Borislav Petkov <bp@amd64.org>
---
 arch/arm/kernel/perf_event.c     |    6 ------
 arch/sh/kernel/perf_callchain.c  |    3 ---
 arch/x86/kernel/cpu/perf_event.c |    3 ---
 3 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
index 417c392..fdcb0be 100644
--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -3107,12 +3107,6 @@ perf_do_callchain(struct pt_regs *regs,
 
 	is_user = user_mode(regs);
 
-	if (!current || !current->pid)
-		return;
-
-	if (is_user && current->state != TASK_RUNNING)
-		return;
-
 	if (!is_user)
 		perf_callchain_kernel(regs, entry);
 
diff --git a/arch/sh/kernel/perf_callchain.c b/arch/sh/kernel/perf_callchain.c
index a9dd3ab..1d6dbce 100644
--- a/arch/sh/kernel/perf_callchain.c
+++ b/arch/sh/kernel/perf_callchain.c
@@ -68,9 +68,6 @@ perf_do_callchain(struct pt_regs *regs, struct perf_callchain_entry *entry)
 
 	is_user = user_mode(regs);
 
-	if (is_user && current->state != TASK_RUNNING)
-		return;
-
 	/*
 	 * Only the kernel side is implemented for now.
 	 */
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index f2da20f..4a4d191 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1703,9 +1703,6 @@ perf_do_callchain(struct pt_regs *regs, struct perf_callchain_entry *entry)
 
 	is_user = user_mode(regs);
 
-	if (is_user && current->state != TASK_RUNNING)
-		return;
-
 	if (!is_user)
 		perf_callchain_kernel(regs, entry);
 
-- 
1.6.2.3

