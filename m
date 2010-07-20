Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758459Ab0GTMLO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 08:11:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13935 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014Ab0GTMLK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 08:11:10 -0400
From: Xiaotian Feng <dfeng@redhat.com>
To: cpufreq@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Xiaotian Feng <dfeng@redhat.com>,
        Dave Jones <davej@redhat.com>, Thomas Renninger <trenn@suse.de>,
        Prarit Bhargava <prarit@redhat.com>
Subject: [PATCH] cpufreq: fix memory leak in cpufreq_add_dev
Date: Tue, 20 Jul 2010 20:11:02 +0800
Message-Id: <1279627862-4107-1-git-send-email-dfeng@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We didn't free policy->related_cpus in error path err_unlock_policy.
This is catched by following kmemleak report:

unreferenced object 0xffff88022a0b96d0 (size 512):
  comm "modprobe", pid 886, jiffies 4294689177 (age 780.694s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff8111ebe5>] create_object+0x186/0x281
    [<ffffffff814fad4f>] kmemleak_alloc+0x60/0xa7
    [<ffffffff8111127a>] kmem_cache_alloc_node_notrace+0x120/0x142
    [<ffffffff81262e4f>] alloc_cpumask_var_node+0x2c/0xd7
    [<ffffffff81262f0b>] alloc_cpumask_var+0x11/0x13
    [<ffffffff81262f1c>] zalloc_cpumask_var+0xf/0x11
    [<ffffffff8140fac0>] cpufreq_add_dev+0x11f/0x547
    [<ffffffff81334bda>] sysdev_driver_register+0xc2/0x11d
    [<ffffffff8140e334>] cpufreq_register_driver+0xcb/0x1b8
    [<ffffffffa032e040>] 0xffffffffa032e040
    [<ffffffff810021ba>] do_one_initcall+0x5e/0x15c
    [<ffffffff81087f94>] sys_init_module+0xa6/0x1e6
    [<ffffffff81009bc2>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Prarit Bhargava <prarit@redhat.com>
---
 drivers/cpufreq/cpufreq.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 063b218..12263b4 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1077,6 +1077,7 @@ err_out_unregister:
 
 err_unlock_policy:
 	unlock_policy_rwsem_write(cpu);
+	free_cpumask_var(policy->related_cpus);
 err_free_cpumask:
 	free_cpumask_var(policy->cpus);
 err_free_policy:
-- 
1.7.1.1

