Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933091Ab1FQULp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 16:11:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28806 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756437Ab1FQULn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 16:11:43 -0400
Date: Fri, 17 Jun 2011 16:11:11 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Another cpufreq pull request for 3.0
Message-ID: <20110617201111.GA3496@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from ..
master.kernel.org:/pub/scm/linux/kernel/git/davej/cpufreq.git/ fixes

 drivers/cpufreq/cpufreq_stats.c |    8 +++++---
 drivers/cpufreq/powernow-k8.c   |    6 +++++-
 2 files changed, 10 insertions(+), 4 deletions(-)

commit fbb5b89eabea5ae7d621b7861863159560d8faa4
Author: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date:   Thu Jun 16 15:36:40 2011 -0400

    [CPUFREQ] powernow-k8: Don't try to transition if the pstate is incorrect
    
    This patch augments the pstate transition code to error out
    (instead of returning 0) when an incorrect pstate is provided.
    
    Suggested-by: Borislav Petkov <bp@alien8.de>
    CC: andre.przywara@amd.com
    CC: Mark.Langsdorf@amd.com
    Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    Signed-off-by: Dave Jones <davej@redhat.com>

commit a9d3d2068064b7a6395871a49616d3784f802d50
Author: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date:   Thu Jun 16 15:36:39 2011 -0400

    [CPUFREQ] powernow-k8: Don't notify of successful transition if we failed (vid case).
    
    Before this patch if we failed the vid transition would still try to
    submit the "new" frequencies to cpufreq.
    That is incorrect - also we could submit a non-existing frequency value
    which would cause cpufreq to crash. The ultimate fix is in cpufreq
    to deal with incorrect values, but this patch improves the error
    recovery in the AMD powernowk8 driver.
    
    The failure that was reported was as follows:
    
    powernow-k8: Found 1 AMD Athlon(tm) 64 Processor 3700+ (1 cpu cores) (version 2.20.00)
    powernow-k8: fid 0x2 (1000 MHz), vid 0x12
    powernow-k8: fid 0xa (1800 MHz), vid 0xa
    powernow-k8: fid 0xc (2000 MHz), vid 0x8
    powernow-k8: fid 0xe (2200 MHz), vid 0x8
    Marking TSC unstable due to cpufreq changes
    powernow-k8: fid trans failed, fid 0x2, curr 0x0
    BUG: unable to handle kernel paging request at ffff880807e07b78
    IP: [<ffffffff81479163>] cpufreq_stats_update+0x46/0x5b
    ...
    
    And transition fails and data->currfid ends up with 0. Since
    the machine does not support 800Mhz value when the calculation is
    done ('find_khz_freq_from_fid(data->currfid);') it reports the
    new frequency as 800000 which is bogus. This patch fixes
    the issue during target setting.
    
    The patch however does not fix the issue in 'powernowk8_cpu_init'
    where the pol->cur can also be set with the 800000 value:
    
              pol->cur = find_khz_freq_from_fid(data->currfid);
      dprintk("policy current frequency %d kHz\n", pol->cur);
    
      /* min/max the cpu is capable of */
      if (cpufreq_frequency_table_cpuinfo(pol, data->powernow_table)) {
    
    The fix for that looks to update cpufreq_frequency_table_cpuinfo to
    check pol->cur.... but that would cause an regression in how the
    acpi-cpufreq driver works (it sets cpu->cur after calling
    cpufreq_frequency_table_cpuinfo). Instead the fix will be to let
    cpufreq gracefully handle bogus data (another patch).
    
    Acked-by: Borislav Petkov <bp@alien8.de>
    CC: andre.przywara@amd.com
    CC: Mark.Langsdorf@amd.com
    Reported-by: Tobias Diedrich <ranma+xen@tdiedrich.de>
    Tested-by: Tobias Diedrich <ranma+xen@tdiedrich.de>
    [v1: Rebased on v3.0-rc2, reduced patch to deal with vid case]
    Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    Signed-off-by: Dave Jones <davej@redhat.com>

commit 46a310b80bc2c9ccc019649c9da91194cbc10944
Author: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date:   Thu Jun 16 15:36:38 2011 -0400

    [CPUFREQ] Don't set stat->last_index to -1 if the pol->cur has incorrect value.
    
    If the driver submitted an non-existing pol>cur value (say it
    used the default initialized value of zero), when the cpufreq
    stats tries to setup its initial values it incorrectly sets
    stat->last_index to -1 (or 0xfffff...). And cpufreq_stats_update
    tries to update at that index location and fails.
    
    This can be caused by:
    
    stat->last_index = freq_table_get_index(stat, policy->cur);
    
    not finding the appropiate frequency in the table (b/c the policy->cur
    is wrong) and we end up crashing. The fix however is
    concentrated in the 'cpufreq_stats_update' as the last_index
    (and old_index) are updated there. Which means it can reset
    the last_index to -1 again and on the next iteration cause a crash.
    
    Without this patch, the following crash is observed:
    
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
    
    Reported-by: Tobias Diedrich <ranma+xen@tdiedrich.de>
    Tested-by: Tobias Diedrich <ranma+xen@tdiedrich.de>
    Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
    Signed-off-by: Dave Jones <davej@redhat.com>
