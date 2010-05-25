Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932557Ab0EYALh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 20:11:37 -0400
Received: from smtp-out.google.com ([74.125.121.35]:61719 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932320Ab0EYALf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 20:11:35 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:x-system-of-record;
	b=shlzLKyUSpJWR513i7YKi/KeJLKIatQgy+XGSevFmDEYOLrTtncUHjCc3r8Sd3Fg7
	uOhbtHAgXU8K9b39UtXkA==
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Paul Menage <menage@google.com>
Cc: linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>
Subject: [RFC PATCH 0/4] Finer granularity and task/cgroup irq time accounting
Date: Mon, 24 May 2010 17:11:18 -0700
Message-Id: <1274746282-21533-1-git-send-email-venki@google.com>
X-Mailer: git-send-email 1.7.0.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, the softirq and hardirq time reporting is only done at the
CPU level. There are usecases where reporting this time against task
or task groups or cgroups will be useful for user/administrator
in terms of resource planning and utilization charging. Also, as the
accoounting is already done at the CPU level, reporting the same at
the task level does not add any significant computational overhead
other than task level storage (patch 1).

The softirq/hardirq statistics commonly done based on tick based sampling.
Though some archs have CONFIG_VIRT_CPU_ACCOUNTING based fine granularity
accounting. Having similar mechanism to get fine granularity accounting
on x86 will be a major challenge, given the state of TSC reliability
on various platforms and also the overhead it may add in common paths
like syscall entry exit.

An alternative is to have a generic (sched_clock based) and configurable
fine-granularity accounting of si and hi time which can be reported
over the /proc/<pid>/stat API (patch 2).

Patch 3 and 4 are exporting this info at the cgroup level.

Does exposing this additional info to user makes sense? Any feedback on
the way it is done in this patchset?

This precise irq time based on sched_clock() provides some potential
opportunities to handle the softirq time charging in a more fair way.
Specifically cases where an unrelated task is being penalized for
irq load on that CPU.
* With network Receive Flow Steering, for example; We can potentially
do things like not charge receive softirq time to the process that is
currently running and charge it instead to the actual consumer of
the receive (in recvmsg, for example).
* We can reduce the power of the CPU to account for softirq/hardirq
load, in order to increase the scheduler fairness for tasks running on
that CPU.

Comments?

Thanks,
Venki

