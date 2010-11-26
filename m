Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567Ab0KZPC5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 10:02:57 -0500
Received: from hera.kernel.org ([140.211.167.34]:40253 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755329Ab0KZPCz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 10:02:55 -0500
Date: Fri, 26 Nov 2010 15:02:26 GMT
From: tip-bot for Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, heiko.carstens@de.ibm.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, heiko.carstens@de.ibm.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20101126120235.406766476@de.ibm.com>
References: <20101126120235.406766476@de.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] nohz: Fix printk_needs_cpu() return value on offline cpus
Message-ID: <tip-61ab25447ad6334a74e32f60efb135a3467223f8@git.kernel.org>
Git-Commit-ID: 61ab25447ad6334a74e32f60efb135a3467223f8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Nov 2010 15:02:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  61ab25447ad6334a74e32f60efb135a3467223f8
Gitweb:     http://git.kernel.org/tip/61ab25447ad6334a74e32f60efb135a3467223f8
Author:     Heiko Carstens <heiko.carstens@de.ibm.com>
AuthorDate: Fri, 26 Nov 2010 13:00:59 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 26 Nov 2010 15:03:12 +0100

nohz: Fix printk_needs_cpu() return value on offline cpus

This patch fixes a hang observed with 2.6.32 kernels where timers got enqueued
on offline cpus.

printk_needs_cpu() may return 1 if called on offline cpus. When a cpu gets
offlined it schedules the idle process which, before killing its own cpu, will
call tick_nohz_stop_sched_tick(). That function in turn will call
printk_needs_cpu() in order to check if the local tick can be disabled. On
offline cpus this function should naturally return 0 since regardless if the
tick gets disabled or not the cpu will be dead short after. That is besides the
fact that __cpu_disable() should already have made sure that no interrupts on
the offlined cpu will be delivered anyway.

In this case it prevents tick_nohz_stop_sched_tick() to call
select_nohz_load_balancer(). No idea if that really is a problem. However what
made me debug this is that on 2.6.32 the function get_nohz_load_balancer() is
used within __mod_timer() to select a cpu on which a timer gets enqueued. If
printk_needs_cpu() returns 1 then the nohz_load_balancer cpu doesn't get
updated when a cpu gets offlined. It may contain the cpu number of an offline
cpu. In turn timers get enqueued on an offline cpu and not very surprisingly
they never expire and cause system hangs.

This has been observed 2.6.32 kernels. On current kernels __mod_timer() uses
get_nohz_timer_target() which doesn't have that problem. However there might be
other problems because of the too early exit tick_nohz_stop_sched_tick() in
case a cpu goes offline.

Easiest way to fix this is just to test if the current cpu is offline and call
printk_tick() directly which clears the condition.

Alternatively I tried a cpu hotplug notifier which would clear the condition,
however between calling the notifier function and printk_needs_cpu() something
could have called printk() again and the problem is back again. This seems to
be the safest fix.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: stable@kernel.org
LKML-Reference: <20101126120235.406766476@de.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/printk.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index cf7588e..a23315d 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1082,6 +1082,8 @@ void printk_tick(void)
 
 int printk_needs_cpu(int cpu)
 {
+	if (unlikely(cpu_is_offline(cpu)))
+		printk_tick();
 	return per_cpu(printk_pending, cpu);
 }
 
