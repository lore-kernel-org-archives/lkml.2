Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114Ab1ATHFU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 02:05:20 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:51988 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430Ab1ATHFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 02:05:19 -0500
Date: Thu, 20 Jan 2011 18:05:08 +1100
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/i915: Initialise ring vfuncs for old DRI paths
Message-ID: <20110120070508.GA2345@gondor.apana.org.au>
References: <20110119032449.GA20598@gondor.apana.org.au> <1295430824-31213-1-git-send-email-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295430824-31213-1-git-send-email-chris@chris-wilson.co.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 09:53:44AM +0000, Chris Wilson wrote:
> We weren't setting up the vfunc table when initialising the old DRI
> ringbuffer, leading to such OOPSes as:

OK this fixes the original crash but adds a new one:

BUG: unable to handle kernel paging request at fffffffffffffff0
IP: [<ffffffffa041ee76>] i915_hangcheck_elapsed+0x96/0x270 [i915]
PGD 13d1067 PUD 13d2067 PMD 0
Oops: 0000 [#1] PREEMPT SMP
last sysfs file: /sys/class/net/lo/operstate
CPU 2
Modules linked in: snd_pcm_oss snd_mixer_oss vmnet parport_pc parport vmblock vmci vmmon i915 drm_kms_helper drm fb fbdev i2c_algo_bit cfbcopyarea video backlight output cfbimgblt cfbfillrect autofs4 ipv6 nfs lockd fscache nfs_acl auth_rpcgss sunrpc coretemp hwmon_vid mo]

Pid: 0, comm: kworker/0:1 Not tainted 2.6.36.2 #5 P5KPL-CM/System Product Name
RIP: 0010:[<ffffffffa041ee76>]  [<ffffffffa041ee76>] i915_hangcheck_elapsed+0x96/0x270 [i915]
RSP: 0000:ffff880001703e40  EFLAGS: 00010217
RAX: 0000000000000000 RBX: ffff880117071800 RCX: ffff880118f7c400
RDX: 000000007dffffc0 RSI: ffff880118f7c028 RDI: ffff880117071800
RBP: ffff880001703e70 R08: ffff88000170d460 R09: ffff880001712620
R10: 0000000000000000 R11: 0000000000000001 R12: ffff880118f7c000
R13: ffff880117071800 R14: 0000000000000000 R15: 000000000e41e9d8
FS:  0000000000000000(0000) GS:ffff880001700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: fffffffffffffff0 CR3: 00000000d83df000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kworker/0:1 (pid: 0, threadinfo ffff88011b6b2000, task ffff88011b67d5c0)
Stack:
 7dffffc000012600 ffff880117071800 ffff88011b6ac000 0000000000000102
<0> ffff880001703eb0 ffffffffa041ede0 ffff880001703ef0 ffffffff81046fad
<0> ffff88011b6b3fd8 ffff88011b6b3fd8 ffff88011b6adc20 ffff88011b6ad820
Call Trace:
 <IRQ>
 [<ffffffffa041ede0>] ? i915_hangcheck_elapsed+0x0/0x270 [i915]
 [<ffffffff81046fad>] run_timer_softirq+0x13d/0x260
 [<ffffffff81063657>] ? clockevents_program_event+0x57/0xa0
 [<ffffffff81041c76>] __do_softirq+0xa6/0x130
 [<ffffffff810032cc>] call_softirq+0x1c/0x30
 [<ffffffff81005375>] do_softirq+0x55/0x90
 [<ffffffff8104190d>] irq_exit+0x8d/0xb0
 [<ffffffff8101de8c>] smp_apic_timer_interrupt+0x6c/0xa0
 [<ffffffff81002d93>] apic_timer_interrupt+0x13/0x20
 <EOI>
 [<ffffffff8100b139>] ? mwait_idle+0x79/0x90
 [<ffffffff81001610>] ? enter_idle+0x20/0x30
 [<ffffffff81001689>] cpu_idle+0x69/0xc0
 [<ffffffff812cb19c>] start_secondary+0x183/0x1e7
Code: 8d 84 24 18 01 00 00 49 39 84 24 18 01 00 00 0f 84 cf 00 00 00 49 8b 85 68 03 00 00 49 8d 74 24 28 48 8b 80 20 01 00 00 4c 89 ef <8b> 58 f0 e8 42 5e 00 00 89 de 89 c7 e8 29 5e 00 00 84 c0 0f 85
RIP  [<ffffffffa041ee76>] i915_hangcheck_elapsed+0x96/0x270 [i915]
 RSP <ffff880001703e40>
CR2: fffffffffffffff0
---[ end trace a327d5ceef537f9e ]---

This is because request_list were initialised by i915_gem_load
but are now zeroed again by the new init_dri function.

I'm going to add the INIT_LIST_HEADs to init_dri now and see if
it survives longer.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
