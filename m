Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100Ab2DRP0H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 11:26:07 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:47781 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422Ab2DRP0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 11:26:05 -0400
Date: Wed, 18 Apr 2012 17:25:49 +0200
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>
Subject: Re: [EDAC PATCH v13 5/7] edac: rewrite edac_align_ptr()
Message-ID: <20120418152549.GG20813@aftab>
References: <1333039546-5590-1-git-send-email-mchehab@redhat.com>
 <1334607133-30039-1-git-send-email-mchehab@redhat.com>
 <1334607133-30039-6-git-send-email-mchehab@redhat.com>
 <20120418140640.GF20813@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120418140640.GF20813@aftab>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 04:06:40PM +0200, Borislav Petkov wrote:
> Why increment *p here too - we're returning ptr below? Or are we keeping
> the alignment in the original pointer too? Why can't we pass the aligned
> pointer from the previous pass? I.e., do
> 
> 	p = NULL;
> 	dev_ctl = edac_align_ptr(&p, sizeof(*dev_ctl), 1);
> 
> and then do
> 
> 	dev_inst = edac_align_ptr(&dev_ctl, sizeof(*dev_inst), nr_instances);
> 
> In any case, this is not trivial so the function needs a bunch of comments.

And broken it is too:

[    8.813572] BUG: unable to handle kernel NULL pointer dereference at 0000000000000740
[    8.817562] IP: [<ffffffffa0001084>] edac_align_ptr+0x9/0x5d [edac_core]
[    8.817562] PGD 4238d4067 PUD 4238d6067 PMD 0 
[    8.817562] Oops: 0000 [#1] SMP 
[    8.817562] CPU 0 
[    8.817562] Modules linked in: radeon(+) ttm amd64_edac_mod(+) drm_kms_helper e1000e hwmon backlight ohci_hcd cfbcopyarea cfbimgblt cfbfillrect ehci_hcd edac_core
[    8.817562] 
[    8.817562] Pid: 1557, comm: work_for_cpu Not tainted 3.3.0+ #6 AMD
[    8.817562] RIP: 0010:[<ffffffffa0001084>]  [<ffffffffa0001084>] edac_align_ptr+0x9/0x5d [edac_core]
[    8.817562] RSP: 0018:ffff880425213d60  EFLAGS: 00010246
[    8.817562] RAX: 00000000000005c0 RBX: 0000000000000002 RCX: 00000000000005c0
[    8.817562] RDX: 0000000000000010 RSI: 0000000000000044 RDI: 0000000000000740
[    8.817562] RBP: ffff880425213d60 R08: 0000000000000008 R09: 0000000000000740
[    8.817562] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000008
[    8.817562] R13: 0000000000000000 R14: ffff880425213d98 R15: 0000000000000010
[    8.817562] FS:  00007f0f12ed2740(0000) GS:ffff880427c00000(0000) knlGS:0000000000000000
[    8.817562] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    8.817562] CR2: 0000000000000740 CR3: 00000004238d1000 CR4: 00000000000006f0
[    8.817562] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    8.817562] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    8.817562] Process work_for_cpu (pid: 1557, threadinfo ffff880425212000, task ffff880425bed9c0)
[    8.817562] Stack:
[    8.817562]  ffff880425213dd0 ffffffffa0001157 ffff880425213d80 ffffffff00000000
[    8.817562]  00000000000005c0 00000000000001c0 0000000000000088 0000000000000740
[    8.817562]  0000000000000000 ffff880425d91000 0000000000000170 ffff880425ef2c90
[    8.817562] Call Trace:
[    8.817562]  [<ffffffffa0001157>] edac_mc_alloc+0x7f/0x1b9 [edac_core]
[    8.817562]  [<ffffffffa005bdef>] amd64_probe_one_instance+0xf8b/0x149a [amd64_edac_mod]
[    8.817562]  [<ffffffff811e7aac>] local_pci_probe+0x4d/0x96
[    8.817562]  [<ffffffff81042ecf>] ? cwq_dec_nr_in_flight+0x7b/0x7b
[    8.817562]  [<ffffffff81042ee7>] do_work_for_cpu+0x18/0x2a
[    8.817562]  [<ffffffff81048d0d>] kthread+0x89/0x91
[    8.817562]  [<ffffffff8144ca64>] kernel_thread_helper+0x4/0x10
[    8.817562]  [<ffffffff81444f4a>] ? retint_restore_args+0xe/0xe
[    8.817562]  [<ffffffff81048c84>] ? kthread_freezable_should_stop+0x57/0x57
[    8.817562]  [<ffffffff8144ca60>] ? gs_change+0xb/0xb
[    8.817562] Code: 5e 00 a0 31 c0 48 89 d6 e8 36 12 44 e1 48 89 df e8 c5 1a 00 00 48 89 df e8 fb cd 0e e1 41 59 5b c9 c3 55 48 89 e5 66 66 66 66 90 <48> 8b 0f 41 b8 08 00 00 00 41 89 d1 44 0f af ce 83 fe 08 4e 8d 
[    8.817562] RIP  [<ffffffffa0001084>] edac_align_ptr+0x9/0x5d [edac_core]
[    8.817562]  RSP <ffff880425213d60>
[    8.817562] CR2: 0000000000000740
[    9.099191] ---[ end trace 8214e97f27078aee ]---

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
