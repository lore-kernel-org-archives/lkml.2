Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485Ab1FCOG5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 10:06:57 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59831 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471Ab1FCOGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 10:06:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=OavU/fwbs1GEBrJmhusOPXiiaG5Gk5KDBsxyRC8fvmlN4c2ff5rqJH9835xC8EcCYS
         UMDul6mUWvg0zxRgAlpDDb/kHFrwKpdGQxby7UYDSOdIAkrytXNqT2HjeAq3zlZZeh6H
         2K3g3onN+HJJg8p3r2rZhMB8LkxPhGyqkyEVA=
MIME-Version: 1.0
Date: Fri, 3 Jun 2011 22:06:54 +0800
Message-ID: <BANLkTinmZ1tSpbwV7448usb1nshw=FJXXA@mail.gmail.com>
Subject: [PATCH] sched: select eligible run-queue for RT task
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Mike Galbraith <efault@gmx.de>,
        Yong Zhang <yong.zhang0@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When selecting run-queue for a given task, eligible run-queue should be
returned by checking the CPU affinity of task.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---
 kernel/sched_rt.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 88725c9..45b3e0a 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1006,7 +1006,8 @@ select_task_rq_rt(struct task_struct *p, int
sd_flag, int flags)
 	int cpu;

 	if (sd_flag != SD_BALANCE_WAKE)
-		return smp_processor_id();
+		return cpumask_test_cpu(smp_processor_id(), &p->cpus_allowed) ?
+			smp_processor_id() : task_cpu(p);

 	cpu = task_cpu(p);
 	rq = cpu_rq(cpu);
