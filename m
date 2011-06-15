Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225Ab1FOTEu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 15:04:50 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:28936 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842Ab1FOTEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 15:04:46 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, davej@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        cpufreq@vger.kernel.org
Subject: [PATCH] cpufreq bug fixes (stable/cpufreq.bugfixes) for 3.0 (or 3.1).
Date: Wed, 15 Jun 2011 15:01:58 -0400
Message-Id: <1308164520-14145-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090209.4DF901BC.00CA:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The two patches attached make the cpufreq and powernowk8 driver more robust on
badly behaving machines (or hypervisors not passing through proper rmsdr calls).

Specifically during the testing of v3.0-rc2, Tobias found a peculiar issue with
his AMD machine: http://mid.gmane.org/20110613202622.GC20616@yumi.tdiedrich.de

It looks as the Xen hypervisor lacks passthrough RDMSR entries for the PowerNow K8
voltage settings (MSR_FIDVID_STATUS and MSR_FIDVID_CTL) resulting in the writes/reads
giving the value zero. The end result being that the cpufreq stats code BUG()s on
incorrect index of the freq table.

The patches are also located at:

git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/cpufreq.bugfixes

The crash looks as follow:

powernow-k8: Found 1 AMD Athlon(tm) 64 Processor 3700+ (1 cpu cores) (version 2.20.00)
powernow-k8: fid 0x2 (1000 MHz), vid 0x12
powernow-k8: fid 0xa (1800 MHz), vid 0xa
powernow-k8: fid 0xc (2000 MHz), vid 0x8
powernow-k8: fid 0xe (2200 MHz), vid 0x8
Marking TSC unstable due to cpufreq changes
powernow-k8: fid trans failed, fid 0x2, curr 0x0
BUG: unable to handle kernel paging request at ffff880807e07b78
IP: [<ffffffff81479163>] cpufreq_stats_update+0x46/0x5b
.. snip..
Pid: 1, comm: swapper Not tainted 3.0.0-rc2 #45 MICRO-STAR INTERNATIONAL CO., LTD MS-7094/MS-7094
..snip..
Call Trace:
 [<ffffffff81479248>] cpufreq_stat_notifier_trans+0x48/0x7c
 [<ffffffff81095d68>] notifier_call_chain+0x32/0x5e
 [<ffffffff81095e6b>] __srcu_notifier_call_chain+0x47/0x63
 [<ffffffff81095e96>] srcu_notifier_call_chain+0xf/0x11
 [<ffffffff81477e7a>] cpufreq_notify_transition+0x111/0x134
 [<ffffffff8147b0d4>] powernowk8_target+0x53b/0x617
 [<ffffffff8147723a>] __cpufreq_driver_target+0x2e/0x30
 [<ffffffff8147a127>] cpufreq_governor_dbs+0x339/0x356
 [<ffffffff81477394>] __cpufreq_governor+0xa8/0xe9
 [<ffffffff81477525>] __cpufreq_set_policy+0x132/0x13e
 [<ffffffff8147848d>] cpufreq_add_dev_interface+0x272/0x28c


Konrad Rzeszutek Wilk (2):
      [CPUFREQ] powernow-k8: Don't notify of successful transition if we failed.
      [CPUFREQ]: Don't set stat->last_index to -1 if the pol->cur has incorrect value.

 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |    7 ++++++-
 drivers/cpufreq/cpufreq_stats.c           |    8 +++++---
 2 files changed, 11 insertions(+), 4 deletions(-)
