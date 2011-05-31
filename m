Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567Ab1EaEtO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 00:49:14 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59833 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978Ab1EaEtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 00:49:13 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DE4733F.3030207@jp.fujitsu.com>
Date: Tue, 31 May 2011 13:49:03 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: caiqian@redhat.com
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, rientjes@google.com, hughd@google.com,
        kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, oleg@redhat.com
Subject: Re: [PATCH v2 0/5] Fix oom killer doesn't work at all if system have
 > gigabytes memory  (aka CAI founded issue)
References: <1582158305.317043.1306815272554.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
In-Reply-To: <1582158305.317043.1306815272554.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> OK, there was also a panic at the end. Is that expected?
> 
> BUG: unable to handle kernel NULL pointer dereference at 00000000000002a8
> IP: [<ffffffff811227d4>] get_mm_counter+0x14/0x30
> PGD 0 
> Oops: 0000 [#1] SMP 
> CPU 7 
> Modules linked in: autofs4 sunrpc cpufreq_ondemand acpi_cpufreq freq_table mperf ipv6 dm_mirror dm_region_hash dm_log microcode serio_raw pcspkr cdc_ether usbnet mii i2c_i801 i2c_core iTCO_wdt iTCO_vendor_support sg shpchp ioatdma dca i7core_edac edac_core bnx2 ext4 mbcache jbd2 sd_mod crc_t10dif pata_acpi ata_generic ata_piix mptsas mptscsih mptbase scsi_transport_sas dm_mod [last unloaded: scsi_wait_scan]

My fault. my [1/5] has a bug. please apply following incremental patch.


index 9c7f149..f0e34d4 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -448,8 +448,8 @@ static void dump_tasks(const struct mem_cgroup *mem, const nodemask_t *no
                        task_tgid_nr(task), task_tgid_nr(task->real_parent),
                        task_uid(task),
                        task->mm->total_vm,
-                       get_mm_rss(task->mm) + p->mm->nr_ptes,
-                       get_mm_counter(p->mm, MM_SWAPENTS),
+                       get_mm_rss(task->mm) + task->mm->nr_ptes,
+                       get_mm_counter(task->mm, MM_SWAPENTS),
                        task->signal->oom_score_adj,
                        task->comm);
                task_unlock(task);


