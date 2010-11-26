Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551Ab0KZPCm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 10:02:42 -0500
Received: from hera.kernel.org ([140.211.167.34]:40239 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755530Ab0KZPCk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 10:02:40 -0500
Date: Fri, 26 Nov 2010 15:02:06 GMT
From: tip-bot for Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        eric.dumazet@gmail.com, a.p.zijlstra@chello.nl,
        heiko.carstens@de.ibm.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com, a.p.zijlstra@chello.nl,
        heiko.carstens@de.ibm.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20101126124247.GC7023@osiris.boeblingen.de.ibm.com>
References: <20101126124247.GC7023@osiris.boeblingen.de.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] printk: Fix wake_up_klogd() vs cpu hotplug
Message-ID: <tip-49f4138346b3cec2706adff02658fe27ceb1e46f@git.kernel.org>
Git-Commit-ID: 49f4138346b3cec2706adff02658fe27ceb1e46f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Nov 2010 15:02:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  49f4138346b3cec2706adff02658fe27ceb1e46f
Gitweb:     http://git.kernel.org/tip/49f4138346b3cec2706adff02658fe27ceb1e46f
Author:     Heiko Carstens <heiko.carstens@de.ibm.com>
AuthorDate: Fri, 26 Nov 2010 13:42:47 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 26 Nov 2010 15:03:11 +0100

printk: Fix wake_up_klogd() vs cpu hotplug

wake_up_klogd() may get called from preemptible context but uses
__raw_get_cpu_var() to write to a per cpu variable. If it gets preempted
between getting the address and writing to it, the cpu in question could be
offline if the process gets scheduled back and hence writes to the per cpu data
of an offline cpu.

This buggy behaviour was introduced with fa33507a "printk: robustify
printk, fix #2" which was supposed to fix a "using smp_processor_id() in
preemptible" warning.

Let's use this_cpu_write() instead which disables preemption and makes sure
that the outlined scenario cannot happen.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20101126124247.GC7023@osiris.boeblingen.de.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/printk.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 9a2264f..cf7588e 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1088,7 +1088,7 @@ int printk_needs_cpu(int cpu)
 void wake_up_klogd(void)
 {
 	if (waitqueue_active(&log_wait))
-		__raw_get_cpu_var(printk_pending) = 1;
+		this_cpu_write(printk_pending, 1);
 }
 
 /**
