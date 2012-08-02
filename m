Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab2HBRNH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 13:13:07 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:47491 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754513Ab2HBRNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 13:13:04 -0400
MIME-Version: 1.0
Date: Fri, 3 Aug 2012 01:13:03 +0800
Message-ID: <CAM16m2koNcqMNMSW9r8bjS4SLBzNzh8P03npe0f6d3qr9ifzcA@mail.gmail.com>
Subject: In function cpu_stop_cpu_callback, BUG_ON(stopper->thread ||
 stopper->enabled || !list_empty(&stopper->works)) is triggered while
 restarting sometimes.
From: chpoph <chpoph@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In function cpu_stop_cpu_callback, BUG_ON(stopper->thread ||
stopper->enabled || !list_empty(&stopper->works)) is triggered
sometimes.
/* manage stopper for a cpu, mostly lifted from sched migration thread mgmt */
static int __cpuinit cpu_stop_cpu_callback(struct notifier_block *nfb,
                                           unsigned long action, void *hcpu)
{
        ..................................
        switch (action & ~CPU_TASKS_FROZEN) {
        case CPU_UP_PREPARE:
                BUG_ON(stopper->thread || stopper->enabled ||
                       !list_empty(&stopper->works));
         .................................
}

Before actually hardware restarting, machine_restart(cmd) will be called.

void machine_restart(char *cmd)
{
        machine_shutdown();
        arm_pm_restart(reboot_mode, cmd);
        ......................
}

after machine_shutdown(), all other cpus are set offline only by
settting the cpumask. if userspace software which regulators cpu are
running before arm_pm_restart(), it may set set another cpu online and
cpu_up(cpu) is called. At this situation, BUG_ON(stopper->thread ||
stopper->enabled || !list_empty(&stopper->works)) is triggered in
cpu_stop_cpu_callback.

Is it needed to preempt disable before calling machine_shutdown()?
