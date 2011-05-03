Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634Ab1ECR2G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 13:28:06 -0400
Received: from sentry-two.sandia.gov ([132.175.109.14]:36905 "EHLO
	sentry-two.sandia.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403Ab1ECR2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 13:28:04 -0400
X-WSS-ID: 0LKMR6Q-0B-8EW-02
X-M-MSG: 
X-Server-Uuid: AF72F651-81B1-4134-BA8C-A8E1A4E620FF
Message-ID: <4DC03B0A.50209@sandia.gov>
Date: Tue, 3 May 2011 11:27:38 -0600
From: "Jim Schutt" <jaschut@sandia.gov>
User-Agent: Thunderbird 2.0.0.24 (X11/20110128)
MIME-Version: 1.0
To: "James Bottomley" <James.Bottomley@suse.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.39-rc5+ BUG at scsi_run_queue+0x24/0xe3
References: <4DC0330F.6050906@sandia.gov>
 <1304442019.10982.7.camel@mulgrave.site>
In-Reply-To: <1304442019.10982.7.camel@mulgrave.site>
X-Originating-IP: [134.253.95.179]
X-PMX-Version: 5.6.0.2009776, Antispam-Engine: 2.7.2.376379,
 Antispam-Data: 2011.5.3.171221
X-PMX-Spam: Gauge=IIIIIIII, Probability=8%, Report=' SUPERLONG_LINE
 0.05, BODY_SIZE_6000_6999 0, BODY_SIZE_7000_LESS 0, DATE_TZ_NA 0,
 WEBMAIL_SOURCE 0, WEBMAIL_XOIP 0, WEBMAIL_X_IP_HDR 0,
 __BOUNCE_CHALLENGE_SUBJ 0, __BOUNCE_NDR_SUBJ_EXEMPT 0, __CT 0, __CTE 0,
 __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __HAS_XOIP 0, __MIME_TEXT_ONLY 0,
 __MIME_VERSION 0, __MOZILLA_MSGID 0, __RATWARE_X_MAILER_CS_B 0,
 __SANE_MSGID 0, __TO_MALFORMED_2 0, __URI_NO_PATH 0, __URI_NO_WWW 0,
 __URI_NS , __USER_AGENT 0'
X-TMWD-Spam-Summary: TS=20110503172746; ID=1; SEV=2.3.1;
 DFV=B2011050317; IFV=NA; AIF=B2011050317; RPD=5.03.0010; ENG=NA;
 RPDID=7374723D303030312E30413031303230382E34444330334231322E303037303A534346535441543838363133332C73733D312C6667733D30;
 CAT=NONE; CON=NONE; SIG=AAABAJsKIgAAAAAAAAAAAAAAAAAAAH0=
X-MMS-Spam-Filter-ID: B2011050317_5.03.0010
X-WSS-ID: 61DEE49B2TS2751636-01-01
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Content-Transfer-Encoding: 7bit
X-RSA-Inspected: yes
X-RSA-Classifications: public
X-RSA-Action: allow
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> On Tue, 2011-05-03 at 10:53 -0600, Jim Schutt wrote:
>> Please let me know if what further information you need, or if there is
>> anything I can do, to help resolve this.
> 
> I think this is the fix (already in rc-fixes):
> 
> James
> 
> ---
> From 3e85ea868dbd60a84240be5c1eebc36841b9c568 Mon Sep 17 00:00:00 2001
> From: James Bottomley <James.Bottomley@suse.de>
> Date: Sun, 1 May 2011 09:42:07 -0500
> Subject: [PATCH] [SCSI] fix oops in scsi_run_queue()
> 
> The recent commit closing the race window in device teardown:
> 
> commit 86cbfb5607d4b81b1a993ff689bbd2addd5d3a9b
> Author: James Bottomley <James.Bottomley@suse.de>
> Date:   Fri Apr 22 10:39:59 2011 -0500
> 
>     [SCSI] put stricter guards on queue dead checks
> 
> is causing a potential NULL deref in scsi_run_queue() because the
> q->queuedata may already be NULL by the time this function is called.
> Since we shouldn't be running a queue that is being torn down, simply
> add a NULL check in scsi_run_queue() to forestall this.
> 
> Signed-off-by: James Bottomley <James.Bottomley@suse.de>
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index e9901b8..03979f4 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -404,6 +404,10 @@ static void scsi_run_queue(struct request_queue *q)
>  	LIST_HEAD(starved_list);
>  	unsigned long flags;
>  
> +	/* if the device is dead, sdev will be NULL, so no queue to run */
> +	if (!sdev)
> +		return;
> +
>  	if (scsi_target(sdev)->single_lun)
>  		scsi_single_lun_run(sdev);
>  

Hmmm, with the above added, I still get BUGs.  Here's an
example:

[   17.142931] BUG: unable to handle kernel NULL pointer dereference at           (null)
[   17.143002] IP: [<ffffffffa01cf8c5>] scsi_run_queue+0x24/0xec [scsi_mod]
[   17.143002] PGD 128257067 PUD 129da5067 PMD 0
[   17.143002] Oops: 0000 [#1] SMP
[   17.143002] last sysfs file: /sys/devices/platform/pcspkr/input/input0/event0/dev
[   17.143002] CPU 1
[   17.143002] Modules linked in: megaraid_sas ide_cd_mod cdrom button ib_mthca(+) ib_mad ib_core serio_raw floppy(+) dcdbas tpm_tis ata_piix tpm tpm_bios libata i5k_amb hwmon iTCO_wdt scsi_mod iTCO_vendor_support i5000_edac ehci_hcd pcspkr edac_core uhci_hcd rtc nfs nfs_acl auth_rpcgss fscache lockd sunrpc tg3 bnx2 e1000
[   17.143002]
[   17.143002] Pid: 1751, comm: path_id Not tainted 2.6.39-rc5-00140-g6a9a2d5 #24 Dell Inc. PowerEdge 1950/0DT097
[   17.143002] RIP: 0010:[<ffffffffa01cf8c5>]  [<ffffffffa01cf8c5>] scsi_run_queue+0x24/0xec [scsi_mod]
[   17.143002] RSP: 0000:ffff88012fc43d10  EFLAGS: 00010246
[   17.143002] RAX: ffff880127393700 RBX: ffff880127393700 RCX: ffff88012f002900
[   17.143002] RDX: 0000000000000000 RSI: 0000000000000037 RDI: 0000000000000000
[   17.143002] RBP: ffff88012fc43d60 R08: 0000000000000286 R09: ffffea00040947f0
[   17.143002] R10: ffff88012f002900 R11: ffff88012fc43cf0 R12: ffff880126cdcf80
[   17.143002] R13: ffff880126d45138 R14: 0000000000000000 R15: ffff880126cdcf80
[   17.143002] FS:  0000000000000000(0000) GS:ffff88012fc40000(0000) knlGS:0000000000000000
[   17.143002] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   17.143002] CR2: 0000000000000000 CR3: 0000000126d0f000 CR4: 00000000000006e0
[   17.143002] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   17.143002] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   17.143002] Process path_id (pid: 1751, threadinfo ffff880127a10000, task ffff880129c02d20)
[   17.143002] Stack:
[   17.143002]  0000000000000282 ffff880126cdcf80 0000000000000000 ffff880126cdcf80
[   17.143002]  ffff88012fc43d60 ffff880127393700 ffff880126cdcf80 ffff880126d45138
[   17.143002]  0000000000000000 ffff880126cdcf80 ffff88012fc43d90 ffffffffa01d020e
[   17.143002] Call Trace:
[   17.143002]  <IRQ>
[   17.143002]  [<ffffffffa01d020e>] scsi_next_command+0x3b/0x4c [scsi_mod]
[   17.143002]  [<ffffffffa01d0853>] scsi_end_request+0x83/0x94 [scsi_mod]
[   17.143002]  [<ffffffffa01d0bf3>] scsi_io_completion+0x1b0/0x3fb [scsi_mod]
[   17.143002]  [<ffffffffa01cf635>] ? spin_unlock_irqrestore+0xe/0x10 [scsi_mod]
[   17.143002]  [<ffffffffa01c9159>] scsi_finish_command+0xeb/0xf4 [scsi_mod]
[   17.143002]  [<ffffffffa01d19e8>] scsi_softirq_done+0x112/0x11e [scsi_mod]
[   17.143002]  [<ffffffff811c727e>] blk_done_softirq+0x4b/0x61
[   17.143002]  [<ffffffff8104f74c>] __do_softirq+0xbf/0x16e
[   17.143002]  [<ffffffff813b354c>] call_softirq+0x1c/0x30
[   17.143002]  [<ffffffff810041a3>] do_softirq+0x3d/0x86
[   17.143002]  [<ffffffff8104f44a>] invoke_softirq+0x17/0x20
[   17.143002]  [<ffffffff8104fa19>] irq_exit+0x57/0x98
[   17.143002]  [<ffffffff813b3c81>] do_IRQ+0x91/0xa8
[   17.143002]  [<ffffffff813abc53>] common_interrupt+0x13/0x13
[   17.143002]  <EOI>
[   17.143002]  [<ffffffff811078c0>] ? kmem_cache_create+0x175/0x175
[   17.143002]  [<ffffffff810eeb06>] ? anon_vma_alloc+0x1a/0x2b
[   17.143002]  [<ffffffff810eec0a>] anon_vma_prepare+0x60/0xfe
[   17.143002]  [<ffffffff810e2f59>] __do_fault+0xc8/0x360
[   17.143002]  [<ffffffff810e3227>] do_linear_fault+0x36/0x38
[   17.143002]  [<ffffffff8102ea08>] ? pgtable_page_ctor+0x1a/0x1c
[   17.143002]  [<ffffffff810e4112>] handle_pte_fault+0x6a/0x170
[   17.143002]  [<ffffffff810e2a1e>] ? spin_lock+0xe/0x10
[   17.143002]  [<ffffffff810e56e6>] handle_mm_fault+0x15f/0x177
[   17.143002]  [<ffffffff813aebda>] do_page_fault+0x244/0x331
[   17.143002]  [<ffffffff810eb086>] ? do_mmap_pgoff+0x267/0x2cc
[   17.143002]  [<ffffffff810adeae>] ? trace_hardirqs_off_caller+0x11/0x25
[   17.143002]  [<ffffffff811dd81a>] ? trace_hardirqs_off_thunk+0x3a/0x6c
[   17.143002]  [<ffffffff813abe8f>] page_fault+0x1f/0x30
[   17.143002] Code: ff ff 5b 41 5c c9 c3 55 48 89 e5 41 57 41 56 41 55 41 54 53 48 83 ec 28 0f 1f 44 00 00 48 89 7d b8 48 8b bf 40 03 00 00 48 85 ff <4c> 8b 37 0f 84 b0 00 00 00 48 8d 5d c0 48 89 5d c0 48 89 5d c8
[   17.143002] RIP  [<ffffffffa01cf8c5>] scsi_run_queue+0x24/0xec [scsi_mod]
[   17.143002]  RSP <ffff88012fc43d10>
[   17.143002] CR2: 0000000000000000
[   17.535741] ---[ end trace 97dde672b920540a ]---

Please let me know what else I can do to help sort this out.

-- Jim

