Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002Ab2L0O7C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 09:59:02 -0500
Received: from mxout2.iskon.hr ([213.191.128.81]:42451 "EHLO mxout2.iskon.hr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752785Ab2L0O7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 09:59:00 -0500
X-Remote-IP: 213.191.128.133
Date: Thu, 27 Dec 2012 15:58:51 +0100
From: Zlatko Calusic <zlatko.calusic@iskon.hr>
Organization: Iskon Internet d.d.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Icedove/17.0
MIME-Version: 1.0
To: Zhouping Liu <zliu@redhat.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Johannes Weiner <jweiner@redhat.com>,
        mgorman@suse.de, hughd@google.com,
        Andrea Arcangeli <aarcange@redhat.com>,
        Hillf Danton <dhillf@gmail.com>
References: <692539675.35132464.1356520940797.JavaMail.root@redhat.com>
In-Reply-To: <692539675.35132464.1356520940797.JavaMail.root@redhat.com>
X-Spam-Score: ##
Message-ID: <50DC622B.7000802@iskon.hr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at 0000000000000500
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45/RELEASE,
	 bases: 20121227 #8894572, check: 20121227 clean
X-SpamTest-Envelope-From: zlatko.calusic@iskon.hr
X-SpamTest-Group-ID: 00000000
X-SpamTest-Info: Profiles 40780 [Dec 27 2012]
X-SpamTest-Method: none
X-SpamTest-Rate: 0
X-SpamTest-SPF: none
X-SpamTest-Status: Not detected
X-SpamTest-Status-Extended: not_detected
X-SpamTest-Version: SMTP-Filter Version 3.0.0 [0284], KAS30/Release
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.12.2012 12:22, Zhouping Liu wrote:
> Hello everyone,
> 
> The latest mainline(637704cbc95c) would trigger the following error when the system was under
> some pressure condition(in my testing, I used oom01 case inside LTP test suite to trigger the issue):
> 
> [ 5462.920151] BUG: unable to handle kernel NULL pointer dereference at 0000000000000500
> [ 5462.927991] IP: [<ffffffff811542d9>] wait_iff_congested+0x59/0x140
> [ 5462.934176] PGD 0
> [ 5462.936191] Oops: 0000 [#2] SMP
> [ 5462.939428] Modules linked in: lockd sunrpc iptable_mangle ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter ip_tabled
> [ 5462.984261] CPU 13
> [ 5462.986184] Pid: 117, comm: kswapd3 Tainted: G      D      3.8.0-rc1+ #1 Dell Inc. PowerEdge M905/0D413F
> [ 5462.995814] RIP: 0010:[<ffffffff811542d9>]  [<ffffffff811542d9>] wait_iff_congested+0x59/0x140
> [ 5463.004411] RSP: 0018:ffff88007c97fd48  EFLAGS: 00010202
> [ 5463.009701] RAX: 0000000000000001 RBX: 0000000000000064 RCX: 0000000000000001
> [ 5463.016818] RDX: 0000000000000064 RSI: 0000000000000000 RDI: 0000000000000000
> [ 5463.023926] RBP: ffff88007c97fd98 R08: 0000000000000000 R09: ffff88022ffd9d80
> [ 5463.031033] R10: 0000000000003189 R11: 0000000000000000 R12: 00000001004ee87e
> [ 5463.038140] R13: 0000000000000002 R14: 0000000000000000 R15: ffff88022ffd9000
> [ 5463.045258] FS:  00007f3e570de740(0000) GS:ffff88022fcc0000(0000) knlGS:0000000000000000
> [ 5463.053317] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [ 5463.059041] CR2: 0000000000000500 CR3: 00000000018dc000 CR4: 00000000000007e0
> [ 5463.066157] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 5463.073276] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [ 5463.080400] Process kswapd3 (pid: 117, threadinfo ffff88007c97e000, task ffff88007c981970)
> [ 5463.088633] Stack:
> [ 5463.090646]  ffff88007c97fd98 0000000000000000 ffff88007c981970 ffffffff81086080
> [ 5463.098090]  ffff88007c97fd68 ffff88007c97fd68 ffff88022ffd9d80 0000000000000002
> [ 5463.105527]  0000000000000002 0000000000000000 ffff88007c97feb8 ffffffff8114b0e3
> [ 5463.112998] Call Trace:
> [ 5463.115446]  [<ffffffff81086080>] ? wake_up_bit+0x40/0x40
> [ 5463.120826]  [<ffffffff8114b0e3>] kswapd+0x6c3/0xa50
> [ 5463.125775]  [<ffffffff8114aa20>] ? zone_reclaim+0x270/0x270
> [ 5463.131415]  [<ffffffff81085680>] kthread+0xc0/0xd0
> [ 5463.136278]  [<ffffffff810855c0>] ? kthread_create_on_node+0x120/0x120
> [ 5463.142786]  [<ffffffff8160a0ac>] ret_from_fork+0x7c/0xb0
> [ 5463.148166]  [<ffffffff810855c0>] ? kthread_create_on_node+0x120/0x120
> [ 5463.154668] Code: 4e 6d 88 00 48 c7 45 b8 00 00 00 00 48 83 c0 18 48 c7 45 c8 80 60 08 81 48 89 45 d0 48 89 45 d8 8b 04 b5 a0 9a cd 81 85 c0 74 0f <48> 8b 87 00 05 00 00 a8 04 0f 85 98 00 00 00 e8 b3 c3
> [ 5463.174097] RIP  [<ffffffff811542d9>] wait_iff_congested+0x59/0x140
> [ 5463.180352]  RSP <ffff88007c97fd48>
> [ 5463.183824] CR2: 0000000000000500
> [ 5463.203717] ---[ end trace 9ff4ff9087c13a36 ]---
> 
> I attached the config file, hope it can make some help.
> 
> Thanks,
> Zhouping
> 

Thank you for the report Zhouping!

Would you be so kind to test the following patch and report results? Apply the patch to the latest mainline.

Thanks,

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 23291b9..e55ce55 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2564,6 +2564,7 @@ static bool prepare_kswapd_sleep(pg_data_t *pgdat, int order, long remaining,
 static unsigned long balance_pgdat(pg_data_t *pgdat, int order,
 							int *classzone_idx)
 {
+	bool pgdat_is_balanced = false;
 	struct zone *unbalanced_zone;
 	int i;
 	int end_zone = 0;	/* Inclusive.  0 = ZONE_DMA */
@@ -2638,8 +2639,11 @@ loop_again:
 				zone_clear_flag(zone, ZONE_CONGESTED);
 			}
 		}
-		if (i < 0)
+
+		if (i < 0) {
+			pgdat_is_balanced = true;
 			goto out;
+		}
 
 		for (i = 0; i <= end_zone; i++) {
 			struct zone *zone = pgdat->node_zones + i;
@@ -2766,8 +2770,11 @@ loop_again:
 				pfmemalloc_watermark_ok(pgdat))
 			wake_up(&pgdat->pfmemalloc_wait);
 
-		if (pgdat_balanced(pgdat, order, *classzone_idx))
+		if (pgdat_balanced(pgdat, order, *classzone_idx)) {
+			pgdat_is_balanced = true;
 			break;		/* kswapd: all done */
+		}
+
 		/*
 		 * OK, kswapd is getting into trouble.  Take a nap, then take
 		 * another pass across the zones.
@@ -2775,7 +2782,7 @@ loop_again:
 		if (total_scanned && (sc.priority < DEF_PRIORITY - 2)) {
 			if (has_under_min_watermark_zone)
 				count_vm_event(KSWAPD_SKIP_CONGESTION_WAIT);
-			else
+			else if (unbalanced_zone)
 				wait_iff_congested(unbalanced_zone, BLK_RW_ASYNC, HZ/10);
 		}
 
@@ -2788,9 +2795,9 @@ loop_again:
 		if (sc.nr_reclaimed >= SWAP_CLUSTER_MAX)
 			break;
 	} while (--sc.priority >= 0);
-out:
 
-	if (!pgdat_balanced(pgdat, order, *classzone_idx)) {
+out:
+	if (!pgdat_is_balanced) {
 		cond_resched();
 
 		try_to_freeze();

-- 
Zlatko
