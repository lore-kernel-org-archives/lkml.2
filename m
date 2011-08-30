Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310Ab1H3HH0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 03:07:26 -0400
Received: from mail.skyhub.de ([78.46.96.112]:51536 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752245Ab1H3HHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 03:07:21 -0400
Date: Tue, 30 Aug 2011 09:07:15 +0200
From: Borislav Petkov <bp@alien8.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.1-rc4
Message-ID: <20110830070715.GA15134@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <CA+55aFwwtfLpmNS+Wm4DXgJsipPS8siF6Dur4rMDum7Zs=KqKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+55aFwwtfLpmNS+Wm4DXgJsipPS8siF6Dur4rMDum7Zs=KqKw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 28, 2011 at 09:52:43PM -0700, Linus Torvalds wrote:
> We're back on track on weekly -rc releases.

Peter,

I get the following lockdep splat on -rc4, it looks like load balancing
something.

[ 5183.478132] ------------[ cut here ]------------
[ 5183.478155] WARNING: at kernel/lockdep.c:690 __lock_acquire+0x189/0x916()
[ 5183.478164] Hardware name: System Product Name
[ 5183.478171] Modules linked in: tun cpufreq_powersave cpufreq_userspace cpufreq_conservative powernow_k8 mperf cpufreq_stats binfmt_misc fuse ipv6 kvm_amd kvm vfat fat radeon ttm drm_kms_helper cfbcopyarea cfbimgblt cfbfillrect 8250_pnp edac_core 8250 serial_core k10temp
[ 5183.478256] Pid: 0, comm: kworker/0:1 Not tainted 3.1.0-rc4 #37
[ 5183.478263] Call Trace:
[ 5183.478270]  <IRQ>  [<ffffffff813d1dee>] ? _raw_spin_unlock_irqrestore+0x38/0x69
[ 5183.478297]  [<ffffffff81038dc2>] warn_slowpath_common+0x85/0x9d
[ 5183.478310]  [<ffffffff81038df4>] warn_slowpath_null+0x1a/0x1c
[ 5183.478321]  [<ffffffff8106e535>] __lock_acquire+0x189/0x916
[ 5183.478332]  [<ffffffff8106ec5e>] ? __lock_acquire+0x8b2/0x916
[ 5183.478344]  [<ffffffff8102ca4a>] ? double_rq_lock+0x4f/0x54
[ 5183.478355]  [<ffffffff8106f32d>] lock_acquire+0x14e/0x193
[ 5183.478364]  [<ffffffff8102ca4a>] ? double_rq_lock+0x4f/0x54
[ 5183.478375]  [<ffffffff81069ba8>] ? put_lock_stats+0xe/0x29
[ 5183.478387]  [<ffffffff813d11ee>] _raw_spin_lock_nested+0x44/0x79
[ 5183.478396]  [<ffffffff8102ca4a>] ? double_rq_lock+0x4f/0x54
[ 5183.478406]  [<ffffffff813d128f>] ? _raw_spin_lock+0x6c/0x73
[ 5183.478416]  [<ffffffff8102ca2b>] ? double_rq_lock+0x30/0x54
[ 5183.478425]  [<ffffffff8102ca4a>] double_rq_lock+0x4f/0x54
[ 5183.478437]  [<ffffffff810334dc>] load_balance+0x1ca/0x4cb
[ 5183.478447]  [<ffffffff810337dd>] ? load_balance+0x4cb/0x4cb
[ 5183.478460]  [<ffffffff81033942>] rebalance_domains+0x165/0x1f4
[ 5183.478470]  [<ffffffff810337dd>] ? load_balance+0x4cb/0x4cb
[ 5183.478481]  [<ffffffff81033a9a>] run_rebalance_domains+0xc9/0x136
[ 5183.478493]  [<ffffffff8103fd3a>] __do_softirq+0x172/0x2f2
[ 5183.478507]  [<ffffffff810037e8>] ? do_softirq+0x2c/0x85
[ 5183.478519]  [<ffffffff813d3d2c>] call_softirq+0x1c/0x30
[ 5183.478530]  [<ffffffff810037f9>] do_softirq+0x3d/0x85
[ 5183.478539]  [<ffffffff8103f928>] irq_exit+0x53/0xbd
[ 5183.478552]  [<ffffffff81018bdc>] smp_call_function_single_interrupt+0x34/0x36
[ 5183.478564]  [<ffffffff813d37b0>] call_function_single_interrupt+0x70/0x80
[ 5183.478571]  <EOI>  [<ffffffff813d20a1>] ? retint_restore_args+0xe/0xe
[ 5183.478591]  [<ffffffff81009402>] ? default_idle+0xef/0x1f5
[ 5183.478602]  [<ffffffff81009400>] ? default_idle+0xed/0x1f5
[ 5183.478612]  [<ffffffff81009651>] amd_e400_idle+0xcf/0xf6
[ 5183.478624]  [<ffffffff810014de>] cpu_idle+0x6f/0xc2
[ 5183.478636]  [<ffffffff813ca25c>] start_secondary+0x1ad/0x1b2
[ 5183.478646] ---[ end trace 2434d22bc511873d ]---

Thanks.

-- 
Regards/Gruss,
    Boris.
