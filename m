Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722Ab1ASIj2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 03:39:28 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60700 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753191Ab1ASIj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 03:39:26 -0500
Date: Wed, 19 Jan 2011 09:39:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Alexander Gordeev <lasaine@lvk.cs.msu.su>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: PPS parport boot lockup: INFO: HARDIRQ-READ-safe ->
 HARDIRQ-READ-unsafe lock order detected
Message-ID: <20110119083916.GA2166@elte.hu>
References: <AANLkTimajU0x1v6y3rH2+jr-bZ=tNLs1S_agXdGGAa3S@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimajU0x1v6y3rH2+jr-bZ=tNLs1S_agXdGGAa3S@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


.38-rc1 allyes64 bootup locks up soft, but first produces this lockdep splat:

[   73.524088] pps_ldisc: PPS line discipline registered
[   73.529156] initcall pps_tty_init+0x0/0xa4 returned 0 after 4950 usecs
[   73.535691] calling  pps_parport_init+0x0/0x60 @ 1
[   73.540491] pps_parport: parallel port PPS client
[   73.545219] 
[   73.545220] ======================================================
[   73.549198] [ INFO: HARDIRQ-READ-safe -> HARDIRQ-READ-unsafe lock order detected ]
[   73.549198] 2.6.38-rc1-tip-01889-g7ca14ab-dirty #86514
[   73.549198] ------------------------------------------------------
[   73.549198] swapper/1 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
[   73.549198]  (&(&tmp->waitlist_lock)->rlock){+.+...}, at: [<ffffffff818f7ef4>] parport_claim+0x1c3/0x22f
[   73.549198] 
[   73.549198] and this task is already holding:
[   73.549198]  (&tmp->cad_lock){.-....}, at: [<ffffffff818f7d86>] parport_claim+0x55/0x22f
[   73.549198] which would create a new lock dependency:
[   73.549198]  (&tmp->cad_lock){.-....} -> (&(&tmp->waitlist_lock)->rlock){+.+...}
[   73.549198] 
[   73.549198] but this new dependency connects a HARDIRQ-READ-irq-safe lock:
[   73.549198]  (&tmp->cad_lock){.-....}
[   73.549198] ... which became HARDIRQ-READ-irq-safe at:
[   73.549198]   [<ffffffff810cef78>] __lock_acquire+0x2b9/0xdcf
[   73.549198]   [<ffffffff810cffb3>] lock_acquire+0xcf/0xf9
[   73.549198]   [<ffffffff82dc602a>] _raw_read_lock+0x39/0x6e
[   73.549198]   [<ffffffff818f7d07>] parport_irq_handler+0x26/0x50
[   73.549198]   [<ffffffff81104158>] handle_IRQ_event+0x61/0x13d
[   73.549198]   [<ffffffff81106426>] handle_edge_irq+0xe3/0x12f
[   73.549198]   [<ffffffff810423b9>] handle_irq+0x88/0x90
[   73.549198]   [<ffffffff82dccbdd>] do_IRQ+0x4d/0xa5
[   73.549198]   [<ffffffff82dc6493>] ret_from_intr+0x0/0x1a
[   73.549198]   [<ffffffff81b43553>] ppa_d_pulse+0x2d/0x52
[   73.549198]   [<ffffffff81b43c04>] ppa_disconnect.clone.1+0x1a/0x43
[   73.549198]   [<ffffffff81b44115>] __ppa_attach+0x238/0x64d
[   73.549198]   [<ffffffff81b44538>] ppa_attach+0xe/0x10
[   73.549198]   [<ffffffff818f8474>] parport_register_driver+0x3e/0x86
[   73.549198]   [<ffffffff849e7a80>] ppa_driver_init+0x25/0x27
[   73.549198]   [<ffffffff810021ef>] do_one_initcall+0x57/0x13c
[   73.549198]   [<ffffffff84989e5e>] kernel_init+0x199/0x222
[   73.549198]   [<ffffffff81040b44>] kernel_thread_helper+0x4/0x10
[   73.549198] 
[   73.549198] to a HARDIRQ-READ-irq-unsafe lock:
[   73.549198]  (&(&tmp->waitlist_lock)->rlock){+.+...}
[   73.549198] ... which became HARDIRQ-READ-irq-unsafe at:
[   73.549198] ...  [<ffffffff810cf02a>] __lock_acquire+0x36b/0xdcf
[   73.549198]   [<ffffffff810cffb3>] lock_acquire+0xcf/0xf9
[   73.549198]   [<ffffffff82dc57c3>] _raw_spin_lock+0x36/0x69
[   73.549198]   [<ffffffff818f8916>] parport_unregister_device+0xc7/0x154
[   73.549198]   [<ffffffff818fb7a3>] parport_close+0xe/0x10
[   73.549198]   [<ffffffff818fc34f>] parport_device_id+0x713/0x728
[   73.549198]   [<ffffffff818fbb6a>] parport_daisy_init+0x3b0/0x42b
[   73.549198]   [<ffffffff818f8358>] parport_announce_port+0x16/0xf4
[   73.549198]   [<ffffffff818fdb77>] parport_pc_probe_port+0xb27/0xbaf
[   73.549198]   [<ffffffff818fdf90>] parport_pc_pnp_probe+0x17f/0x1a7
[   73.549198]   [<ffffffff817927f2>] pnp_device_probe+0x81/0xab
[   73.549198]   [<ffffffff819037bf>] driver_probe_device+0x11d/0x1e5
[   73.549198]   [<ffffffff819038d6>] __driver_attach+0x4f/0x70
[   73.549198]   [<ffffffff8190282e>] bus_for_each_dev+0x5c/0x88
[   73.549198]   [<ffffffff819033e4>] driver_attach+0x1e/0x20
[   73.549198]   [<ffffffff81902fdd>] bus_add_driver+0xc7/0x21e
[   73.549198]   [<ffffffff81903b39>] driver_register+0x9b/0x108
[   73.549198]   [<ffffffff8179256b>] pnp_register_driver+0x21/0x23
[   73.549198]   [<ffffffff849dcf49>] parport_pc_init+0x282/0x311
[   73.549198]   [<ffffffff810021ef>] do_one_initcall+0x57/0x13c
[   73.549198]   [<ffffffff84989e5e>] kernel_init+0x199/0x222
[   73.549198]   [<ffffffff81040b44>] kernel_thread_helper+0x4/0x10
[   73.549198] 
[   73.549198] other info that might help us debug this:
[   73.549198] 
[   73.549198] 2 locks held by swapper/1:
[   73.549198]  #0:  (registration_lock){+.+.+.}, at: [<ffffffff818f8465>] parport_register_driver+0x2f/0x86
[   73.549198]  #1:  (&tmp->cad_lock){.-....}, at: [<ffffffff818f7d86>] parport_claim+0x55/0x22f
[   73.549198] 
[   73.549198] the dependencies between HARDIRQ-READ-irq-safe lock and the holding lock:
[   73.549198] -> (&tmp->cad_lock){.-....} ops: 11 {
[   73.549198]    IN-HARDIRQ-R at:
[   73.549198]                                        [<ffffffff810cef78>] __lock_acquire+0x2b9/0xdcf
[   73.549198]                                        [<ffffffff810cffb3>] lock_acquire+0xcf/0xf9
[   73.549198]                                        [<ffffffff82dc602a>] _raw_read_lock+0x39/0x6e
[   73.549198]                                        [<ffffffff818f7d07>] parport_irq_handler+0x26/0x50
[   73.549198]                                        [<ffffffff81104158>] handle_IRQ_event+0x61/0x13d
[   73.549198]                                        [<ffffffff81106426>] handle_edge_irq+0xe3/0x12f
[   73.549198]                                        [<ffffffff810423b9>] handle_irq+0x88/0x90
[   73.549198]                                        [<ffffffff82dccbdd>] do_IRQ+0x4d/0xa5
[   73.549198]                                        [<ffffffff82dc6493>] ret_from_intr+0x0/0x1a
[   73.549198]                                        [<ffffffff81b43553>] ppa_d_pulse+0x2d/0x52
[   73.549198]                                        [<ffffffff81b43c04>] ppa_disconnect.clone.1+0x1a/0x43
[   73.549198]                                        [<ffffffff81b44115>] __ppa_attach+0x238/0x64d
[   73.549198]                                        [<ffffffff81b44538>] ppa_attach+0xe/0x10
[   73.549198]                                        [<ffffffff818f8474>] parport_register_driver+0x3e/0x86
[   73.549198]                                        [<ffffffff849e7a80>] ppa_driver_init+0x25/0x27
[   73.549198]                                        [<ffffffff810021ef>] do_one_initcall+0x57/0x13c
[   73.549198]                                        [<ffffffff84989e5e>] kernel_init+0x199/0x222
[   73.549198]                                        [<ffffffff81040b44>] kernel_thread_helper+0x4/0x10
[   73.549198]    INITIAL USE at:
[   73.549198]                                       [<ffffffff810cf0ab>] __lock_acquire+0x3ec/0xdcf
[   73.549198]                                       [<ffffffff810cffb3>] lock_acquire+0xcf/0xf9
[   73.549198]                                       [<ffffffff82dc5ca0>] _raw_write_lock_irqsave+0x45/0x7f
[   73.549198]                                       [<ffffffff818f7d86>] parport_claim+0x55/0x22f
[   73.549198]                                       [<ffffffff818f80ed>] parport_claim_or_block+0x21/0x6a
[   73.549198]                                       [<ffffffff818fbc83>] parport_device_id+0x47/0x728
[   73.549198]                                       [<ffffffff818fbb6a>] parport_daisy_init+0x3b0/0x42b
[   73.549198]                                       [<ffffffff818f8358>] parport_announce_port+0x16/0xf4
[   73.549198]                                       [<ffffffff818fdb77>] parport_pc_probe_port+0xb27/0xbaf
[   73.549198]                                       [<ffffffff818fdf90>] parport_pc_pnp_probe+0x17f/0x1a7
[   73.549198]                                       [<ffffffff817927f2>] pnp_device_probe+0x81/0xab
[   73.549198]                                       [<ffffffff819037bf>] driver_probe_device+0x11d/0x1e5
[   73.549198]                                       [<ffffffff819038d6>] __driver_attach+0x4f/0x70
[   73.549198]                                       [<ffffffff8190282e>] bus_for_each_dev+0x5c/0x88
[   73.549198]                                       [<ffffffff819033e4>] driver_attach+0x1e/0x20
[   73.549198]                                       [<ffffffff81902fdd>] bus_add_driver+0xc7/0x21e
[   73.549198]                                       [<ffffffff81903b39>] driver_register+0x9b/0x108
[   73.549198]                                       [<ffffffff8179256b>] pnp_register_driver+0x21/0x23
[   73.549198]                                       [<ffffffff849dcf49>] parport_pc_init+0x282/0x311
[   73.549198]                                       [<ffffffff810021ef>] do_one_initcall+0x57/0x13c
[   73.549198]                                       [<ffffffff84989e5e>] kernel_init+0x199/0x222
[   73.549198]                                       [<ffffffff81040b44>] kernel_thread_helper+0x4/0x10
[   73.549198]  }
[   73.549198]  ... key      at: [<ffffffff85a1eed8>] __key.21525+0x0/0x8
[   73.549198]  ... acquired at:
[   73.549198]    [<ffffffff810cd0f8>] check_irq_usage+0x78/0x89
[   73.549198]    [<ffffffff810cf79c>] __lock_acquire+0xadd/0xdcf
[   73.549198]    [<ffffffff810cffb3>] lock_acquire+0xcf/0xf9
[   73.549198]    [<ffffffff82dc57c3>] _raw_spin_lock+0x36/0x69
[   73.549198]    [<ffffffff818f7ef4>] parport_claim+0x1c3/0x22f
[   73.549198]    [<ffffffff818f80ed>] parport_claim_or_block+0x21/0x6a
[   73.549198]    [<ffffffff824b8857>] parport_attach+0xd4/0x173
[   73.549198]    [<ffffffff818f8474>] parport_register_driver+0x3e/0x86
[   73.549198]    [<ffffffff84a06125>] pps_parport_init+0x46/0x60
[   73.549198]    [<ffffffff810021ef>] do_one_initcall+0x57/0x13c
[   73.549198]    [<ffffffff84989e5e>] kernel_init+0x199/0x222
[   73.549198]    [<ffffffff81040b44>] kernel_thread_helper+0x4/0x10
[   73.549198] 
[   73.549198] 
[   73.549198] the dependencies between the lock to be acquired and HARDIRQ-READ-irq-unsafe lock:
[   73.549198] -> (&(&tmp->waitlist_lock)->rlock){+.+...} ops: 5 {
[   73.549198]    HARDIRQ-ON-W at:
[   73.549198]                                        [<ffffffff810cf02a>] __lock_acquire+0x36b/0xdcf
[   73.549198]                                        [<ffffffff810cffb3>] lock_acquire+0xcf/0xf9
[   73.549198]                                        [<ffffffff82dc57c3>] _raw_spin_lock+0x36/0x69
[   73.549198]                                        [<ffffffff818f8916>] parport_unregister_device+0xc7/0x154
[   73.549198]                                        [<ffffffff818fb7a3>] parport_close+0xe/0x10
[   73.549198]                                        [<ffffffff818fc34f>] parport_device_id+0x713/0x728
[   73.549198]                                        [<ffffffff818fbb6a>] parport_daisy_init+0x3b0/0x42b
[   73.549198]                                        [<ffffffff818f8358>] parport_announce_port+0x16/0xf4
[   73.549198]                                        [<ffffffff818fdb77>] parport_pc_probe_port+0xb27/0xbaf
[   73.549198]                                        [<ffffffff818fdf90>] parport_pc_pnp_probe+0x17f/0x1a7
[   73.549198]                                        [<ffffffff817927f2>] pnp_device_probe+0x81/0xab
[   73.549198]                                        [<ffffffff819037bf>] driver_probe_device+0x11d/0x1e5
[   73.549198]                                        [<ffffffff819038d6>] __driver_attach+0x4f/0x70
[   73.549198]                                        [<ffffffff8190282e>] bus_for_each_dev+0x5c/0x88
[   73.549198]                                        [<ffffffff819033e4>] driver_attach+0x1e/0x20
[   73.549198]                                        [<ffffffff81902fdd>] bus_add_driver+0xc7/0x21e
[   73.549198]                                        [<ffffffff81903b39>] driver_register+0x9b/0x108
[   73.549198]                                        [<ffffffff8179256b>] pnp_register_driver+0x21/0x23
[   73.549198]                                        [<ffffffff849dcf49>] parport_pc_init+0x282/0x311
[   73.549198]                                        [<ffffffff810021ef>] do_one_initcall+0x57/0x13c
[   73.549198]                                        [<ffffffff84989e5e>] kernel_init+0x199/0x222
[   73.549198]                                        [<ffffffff81040b44>] kernel_thread_helper+0x4/0x10
[   73.549198]    SOFTIRQ-ON-W at:
[   73.549198]                                        [<ffffffff810cf04e>] __lock_acquire+0x38f/0xdcf
[   73.549198]                                        [<ffffffff810cffb3>] lock_acquire+0xcf/0xf9
[   73.549198]                                        [<ffffffff82dc57c3>] _raw_spin_lock+0x36/0x69
[   73.549198]                                        [<ffffffff818f8916>] parport_unregister_device+0xc7/0x154
[   73.549198]                                        [<ffffffff818fb7a3>] parport_close+0xe/0x10
[   73.549198]                                        [<ffffffff818fc34f>] parport_device_id+0x713/0x728
[   73.549198]                                        [<ffffffff818fbb6a>] parport_daisy_init+0x3b0/0x42b
[   73.549198]                                        [<ffffffff818f8358>] parport_announce_port+0x16/0xf4
[   73.549198]                                        [<ffffffff818fdb77>] parport_pc_probe_port+0xb27/0xbaf
[   73.549198]                                        [<ffffffff818fdf90>] parport_pc_pnp_probe+0x17f/0x1a7
[   73.549198]                                        [<ffffffff817927f2>] pnp_device_probe+0x81/0xab
[   73.549198]                                        [<ffffffff819037bf>] driver_probe_device+0x11d/0x1e5
[   73.549198]                                        [<ffffffff819038d6>] __driver_attach+0x4f/0x70
[   73.549198]                                        [<ffffffff8190282e>] bus_for_each_dev+0x5c/0x88
[   73.549198]                                        [<ffffffff819033e4>] driver_attach+0x1e/0x20
[   73.549198]                                        [<ffffffff81902fdd>] bus_add_driver+0xc7/0x21e
[   73.549198]                                        [<ffffffff81903b39>] driver_register+0x9b/0x108
[   73.549198]                                        [<ffffffff8179256b>] pnp_register_driver+0x21/0x23
[   73.549198]                                        [<ffffffff849dcf49>] parport_pc_init+0x282/0x311
[   73.549198]                                        [<ffffffff810021ef>] do_one_initcall+0x57/0x13c
[   73.549198]                                        [<ffffffff84989e5e>] kernel_init+0x199/0x222
[   73.549198]                                        [<ffffffff81040b44>] kernel_thread_helper+0x4/0x10
[   73.549198]    INITIAL USE at:
[   73.549198]                                       [<ffffffff810cf0ab>] __lock_acquire+0x3ec/0xdcf
[   73.549198]                                       [<ffffffff810cffb3>] lock_acquire+0xcf/0xf9
[   73.549198]                                       [<ffffffff82dc57c3>] _raw_spin_lock+0x36/0x69
[   73.549198]                                       [<ffffffff818f8916>] parport_unregister_device+0xc7/0x154
[   73.549198]                                       [<ffffffff818fb7a3>] parport_close+0xe/0x10
[   73.549198]                                       [<ffffffff818fc34f>] parport_device_id+0x713/0x728
[   73.549198]                                       [<ffffffff818fbb6a>] parport_daisy_init+0x3b0/0x42b
[   73.549198]                                       [<ffffffff818f8358>] parport_announce_port+0x16/0xf4
[   73.549198]                                       [<ffffffff818fdb77>] parport_pc_probe_port+0xb27/0xbaf
[   73.549198]                                       [<ffffffff818fdf90>] parport_pc_pnp_probe+0x17f/0x1a7
[   73.549198]                                       [<ffffffff817927f2>] pnp_device_probe+0x81/0xab
[   73.549198]                                       [<ffffffff819037bf>] driver_probe_device+0x11d/0x1e5
[   73.549198]                                       [<ffffffff819038d6>] __driver_attach+0x4f/0x70
[   73.549198]                                       [<ffffffff8190282e>] bus_for_each_dev+0x5c/0x88
[   73.549198]                                       [<ffffffff819033e4>] driver_attach+0x1e/0x20
[   73.549198]                                       [<ffffffff81902fdd>] bus_add_driver+0xc7/0x21e
[   73.549198]                                       [<ffffffff81903b39>] driver_register+0x9b/0x108
[   73.549198]                                       [<ffffffff8179256b>] pnp_register_driver+0x21/0x23
[   73.549198]                                       [<ffffffff849dcf49>] parport_pc_init+0x282/0x311
[   73.549198]                                       [<ffffffff810021ef>] do_one_initcall+0x57/0x13c
[   73.549198]                                       [<ffffffff84989e5e>] kernel_init+0x199/0x222
[   73.549198]                                       [<ffffffff81040b44>] kernel_thread_helper+0x4/0x10
[   73.549198]  }
[   73.549198]  ... key      at: [<ffffffff85a1eed0>] __key.21526+0x0/0x8
[   73.549198]  ... acquired at:
[   73.549198]    [<ffffffff810cd0f8>] check_irq_usage+0x78/0x89
[   73.549198]    [<ffffffff810cf79c>] __lock_acquire+0xadd/0xdcf
[   73.549198]    [<ffffffff810cffb3>] lock_acquire+0xcf/0xf9
[   73.549198]    [<ffffffff82dc57c3>] _raw_spin_lock+0x36/0x69
[   73.549198]    [<ffffffff818f7ef4>] parport_claim+0x1c3/0x22f
[   73.549198]    [<ffffffff818f80ed>] parport_claim_or_block+0x21/0x6a
[   73.549198]    [<ffffffff824b8857>] parport_attach+0xd4/0x173
[   73.549198]    [<ffffffff818f8474>] parport_register_driver+0x3e/0x86
[   73.549198]    [<ffffffff84a06125>] pps_parport_init+0x46/0x60
[   73.549198]    [<ffffffff810021ef>] do_one_initcall+0x57/0x13c
[   73.549198]    [<ffffffff84989e5e>] kernel_init+0x199/0x222
[   73.549198]    [<ffffffff81040b44>] kernel_thread_helper+0x4/0x10
[   73.549198] 
[   73.549198] 
[   73.549198] stack backtrace:
[   73.549198] Pid: 1, comm: swapper Not tainted 2.6.38-rc1-tip-01889-g7ca14ab-dirty #86514
[   73.549198] Call Trace:
[   73.549198]  [<ffffffff810cd06b>] ? check_usage+0x337/0x34c
[   73.549198]  [<ffffffff84a06000>] ? pps_ktimer_init+0x63/0x9e
[   73.549198]  [<ffffffff810c0ec0>] ? local_clock+0x36/0x4d
[   73.549198]  [<ffffffff810cd0f8>] ? check_irq_usage+0x78/0x89
[   73.549198]  [<ffffffff810cf79c>] ? __lock_acquire+0xadd/0xdcf
[   73.549198]  [<ffffffff818f7ef4>] ? parport_claim+0x1c3/0x22f
[   73.549198]  [<ffffffff810cffb3>] ? lock_acquire+0xcf/0xf9
[   73.549198]  [<ffffffff818f7ef4>] ? parport_claim+0x1c3/0x22f
[   73.549198]  [<ffffffff82dc57c3>] ? _raw_spin_lock+0x36/0x69
[   73.549198]  [<ffffffff818f7ef4>] ? parport_claim+0x1c3/0x22f
[   73.549198]  [<ffffffff818f7ef4>] ? parport_claim+0x1c3/0x22f
[   73.549198]  [<ffffffff818f80ed>] ? parport_claim_or_block+0x21/0x6a
[   73.549198]  [<ffffffff824b8857>] ? parport_attach+0xd4/0x173
[   73.549198]  [<ffffffff824b8ab5>] ? pps_echo+0x0/0x47
[   73.549198]  [<ffffffff818f8474>] ? parport_register_driver+0x3e/0x86
[   73.549198]  [<ffffffff84a060df>] ? pps_parport_init+0x0/0x60
[   73.549198]  [<ffffffff84a06125>] ? pps_parport_init+0x46/0x60
[   73.549198]  [<ffffffff84a060df>] ? pps_parport_init+0x0/0x60
[   73.549198]  [<ffffffff810021ef>] ? do_one_initcall+0x57/0x13c
[   73.549198]  [<ffffffff84989e5e>] ? kernel_init+0x199/0x222
[   73.549198]  [<ffffffff81040b44>] ? kernel_thread_helper+0x4/0x10
[   73.549198]  [<ffffffff82dc6554>] ? restore_args+0x0/0x30
[   73.549198]  [<ffffffff84989cc5>] ? kernel_init+0x0/0x222
[   73.549198]  [<ffffffff81040b40>] ? kernel_thread_helper+0x0/0x10
[   75.227429] pps pps0: PPS event at 4294911102
[   75.231795] pps pps0: PPS event at 1295471376.227427654
[   75.237028] pps pps0: capture assert seq #1
[   76.240020] pps pps0: PPS event at 4294911356
[   76.244380] pps pps0: PPS event at 1295471377.240018362
[   76.249608] pps pps0: capture assert seq #2
[   77.252019] pps pps0: PPS event at 4294911609
[   77.256379] pps pps0: PPS event at 1295471378.252017372
[   77.261604] pps pps0: capture assert seq #3
[   78.264021] pps pps0: PPS event at 4294911862
[   78.268387] pps pps0: PPS event at 1295471379.264018619
[   78.273621] pps pps0: capture assert seq #4
[   79.276018] pps pps0: PPS event at 4294912115
[   79.280384] pps pps0: PPS event at 1295471380.276016791
[   79.285619] pps pps0: capture assert seq #5
[   80.288020] pps pps0: PPS event at 4294912368
[   80.292382] pps pps0: PPS event at 1295471381.288018317
[   80.297608] pps pps0: capture assert seq #6
[   81.300023] pps pps0: PPS event at 4294912621
[   81.304390] pps pps0: PPS event at 1295471382.300021518

That's probably one of these commits:

 563558b2c735: pps: add parallel port PPS signal generator
 46b402a0e5e4: pps: add parallel port PPS signal generator
 a10203c691ea: pps: add parallel port PPS client

Plus CONFIG_PPS_CLIENT_PARPORT=y.

This feature seems rather untested - this is a plain whitebox PC with a parallel 
port.

Btw., why does 46b402a0e5e4 and 563558b2c735 have the same title?

Thanks,

	Ingo
