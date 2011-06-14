Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063Ab1FNSCP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 14:02:15 -0400
Received: from rcsinet14.oracle.com ([148.87.113.126]:21132 "EHLO
	rcsinet14.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101Ab1FNSCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 14:02:13 -0400
Date: Tue, 14 Jun 2011 13:59:41 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Tobias Diedrich <ranma+xen@tdiedrich.de>, xen-users@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: Re: 3.0.0-rc2: Xen: powernow-k8: Kernel panic - not syncing:
 Attempted to kill init!
Message-ID: <20110614175940.GA22859@dumpdata.com>
References: <20110613202622.GC20616@yumi.tdiedrich.de>
 <20110613215123.GA19117@dumpdata.com>
 <20110613235221.GA7417@yumi.tdiedrich.de>
 <20110614001333.GC7417@yumi.tdiedrich.de>
 <20110614013457.GB414@dumpdata.com>
 <20110614134634.GD7417@yumi.tdiedrich.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110614134634.GD7417@yumi.tdiedrich.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4DF7A1B0.00B0:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 14, 2011 at 03:46:34PM +0200, Tobias Diedrich wrote:
> Konrad Rzeszutek Wilk wrote:
> > On Tue, Jun 14, 2011 at 02:13:33AM +0200, Tobias Diedrich wrote:
> > > Tobias Diedrich wrote:
> > > > Konrad Rzeszutek Wilk wrote:
> > > > > > [    5.523199] rtc_cmos 00:05: setting system clock to 2011-06-13 20:20:00 UTC (1307996400)
> > > > > > [    5.523400] powernow-k8: Found 1 AMD Athlon(tm) 64 Processor 3700+ (1 cpu cores) (version 2.20.00)
> > > > > > [    5.530956] powernow-k8: fid 0x2 (1000 MHz), vid 0x12
> > > > > > [    5.531072] powernow-k8: fid 0xa (1800 MHz), vid 0xa
> > > > > > [    5.531187] powernow-k8: fid 0xc (2000 MHz), vid 0x8
> > > > > > [    5.531301] powernow-k8: fid 0xe (2200 MHz), vid 0x8
> > > > > > [    5.531460] Marking TSC unstable due to cpufreq changes
> > > > > > [    5.531680] powernow-k8: fid trans failed, fid 0x2, curr 0x0
> > > > > > [    5.531802] BUG: unable to handle kernel paging request at ffff880807e07b78
> > > > > > [    5.531982] IP: [<ffffffff81479163>] cpufreq_stats_update+0x46/0x5b
> > > > > 
> > > > > For this one, you will have to fire out gdb and disassemble the code to
> > > > > figure out where it failed. Look for 'gdb vmlinux' and 'disassembly' on this
> > > > > mailing list - that should provide some hints.
> > > > 
> > > > Probably because of the 'fid trans failed' stat->last_index is -1
> > > 
> > > It's set to -1 in cpufreq_stats_create_table(), the second call to
> > > freq_table_get_index() doesn't check against -1 (expecting the call
> > > to always succeed):
> > > 
> > > 	stat->last_time = get_jiffies_64();
> > > 	stat->last_index = freq_table_get_index(stat, policy->cur);
> > 
> > What is policy->cur? Is is 800000 ? If so, does this fix your problem:
> 
> Yes, it is 800000, but while the patch is probably the right thing
> to do it doesn't help for cpufreq_stats_create_table:
> [    5.740826] powernow-k8: fid 0x2 (1000 MHz), vid 0x12
> [    5.740941] powernow-k8: fid 0xa (1800 MHz), vid 0xa
> [    5.741057] powernow-k8: fid 0xc (2000 MHz), vid 0x8
> [    5.741170] powernow-k8: fid 0xe (2200 MHz), vid 0x8
> [    5.741304] cpufreq_stats_create_table: policy->cur is 800000
> [    5.741475] last_index set to -1 in cpufreq_stats_create_table!
> 
> I think policy->cur used here probably set in powernowk8_cpu_init.

Yup, and there is not much that can be done there. Lets try this patch

diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index 2368e38..7e4a664 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -1079,8 +1079,10 @@ static int transition_frequency_fidvid(struct powernow_k8_data *data,
 	}
 
 	res = transition_fid_vid(data, fid, vid);
-	freqs.new = find_khz_freq_from_fid(data->currfid);
+	if (res)
+		return res;
 
+	freqs.new = find_khz_freq_from_fid(data->currfid);
 	for_each_cpu(i, data->available_cores) {
 		freqs.cpu = i;
 		cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
@@ -1112,6 +1114,9 @@ static int transition_frequency_pstate(struct powernow_k8_data *data,
 	}
 
 	res = transition_pstate(data, pstate);
+	if (res)
+		return res;
+
 	freqs.new = find_khz_freq_from_pstate(data->powernow_table, pstate);
 
 	for_each_cpu(i, data->available_cores) {
diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
index 4f1b8de..0ecb1e2 100644
--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -298,11 +298,13 @@ static int cpufreq_stat_notifier_trans(struct notifier_block *nb,
 	old_index = stat->last_index;
 	new_index = freq_table_get_index(stat, freq->new);
 
-	cpufreq_stats_update(freq->cpu);
-	if (old_index == new_index)
+	/* We can't do stat->time_in_state[-1]= .. */
+	if (old_index == -1 || new_index == -1)
 		return 0;
 
-	if (old_index == -1 || new_index == -1)
+	cpufreq_stats_update(freq->cpu);
+
+	if (old_index == new_index)
 		return 0;
 
 	spin_lock(&cpufreq_stats_lock);
