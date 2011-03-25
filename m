Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757201Ab1CYLwm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 07:52:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:38354 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752576Ab1CYLwk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 07:52:40 -0400
Date: Fri, 25 Mar 2011 11:52:09 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@redhat.com, eric.dumazet@gmail.com, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, efault@gmx.de, fweisbec@gmail.com,
        rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, efault@gmx.de,
        fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf, x86: Complain louder about BIOSen corrupting CPU/PMU state and continue
Message-ID: <tip-45daae575e08bbf7405c5a3633e956fa364d1b4f@git.kernel.org>
Git-Commit-ID: 45daae575e08bbf7405c5a3633e956fa364d1b4f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 25 Mar 2011 11:52:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  45daae575e08bbf7405c5a3633e956fa364d1b4f
Gitweb:     http://git.kernel.org/tip/45daae575e08bbf7405c5a3633e956fa364d1b4f
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Fri, 25 Mar 2011 10:24:23 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 25 Mar 2011 11:23:41 +0100

perf, x86: Complain louder about BIOSen corrupting CPU/PMU state and continue

Eric Dumazet reported that hardware PMU events do not work on his
system, due to the BIOS corrupting PMU state:

    Performance Events: PEBS fmt0+, Core2 events, Broken BIOS detected, using software events only.
    [Firmware Bug]: the BIOS has corrupted hw-PMU resources (MSR 186 is 43003c)

Linus suggested that we continue in the face of such BIOS-induced CPU
state corruption:

   http://lkml.org/lkml/2011/3/24/608

Such BIOSes will have to be fixed - Linux developers rely on a working and
fully capable PMU and the BIOS interfering with the CPU's PMU state is simply
not acceptable.

So this patch changes perf to continue when it detects such BIOS
interaction, some hardware events may be unreliable due to the BIOS
writing and re-writing them - there's not much the kernel can do
about that but to detect the corruption and report it.

Reported-and-tested-by: Eric Dumazet <eric.dumazet@gmail.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index ec46eea..eb00677 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -500,12 +500,17 @@ static bool check_hw_exists(void)
 	return true;
 
 bios_fail:
-	printk(KERN_CONT "Broken BIOS detected, using software events only.\n");
+	/*
+	 * We still allow the PMU driver to operate:
+	 */
+	printk(KERN_CONT "Broken BIOS detected, complain to your hardware vendor.\n");
 	printk(KERN_ERR FW_BUG "the BIOS has corrupted hw-PMU resources (MSR %x is %Lx)\n", reg, val);
-	return false;
+
+	return true;
 
 msr_fail:
 	printk(KERN_CONT "Broken PMU hardware detected, using software events only.\n");
+
 	return false;
 }
 
