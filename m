Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841Ab2L0IgV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 03:36:21 -0500
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:46029
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751671Ab2L0IgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 03:36:18 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(zz98dI1432Izz1de0h1202h1e76h1d1ah1d2ahzz8275dh177df4h1954cbh8275eh17326aha1495iz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Thu, 27 Dec 2012 16:36:22 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Maciej Rutecki <maciej.rutecki@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Cong Wang <xiyou.wangcong@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [REGRESSION][3.8.-rc1][ INFO: possible circular locking
 dependency detected ]
Message-ID: <20121227083618.GA9775@S2101-09.ap.freescale.net>
References: <201212221628.26640.maciej.rutecki@gmail.com>
 <20121226023435.GE25478@S2101-09.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20121226023435.GE25478@S2101-09.ap.freescale.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 26, 2012 at 10:34:39AM +0800, Shawn Guo wrote:
> It seems that I'm running into the same locking issue.  My setup is:
> 
> - i.MX28 (ARM)
> - v3.8-rc1
> - mxs_defconfig
  - The warning is seen when LCD is blanking
> 

The warning disappears after reverting patch daee779 (console: implement
lockdep support for console_lock).  Is it suggesting that the mxs
frame buffer driver (drivers/video/mxsfb.c) is doing something bad?

Shawn

> 
> [  602.229899] ======================================================
> [  602.229905] [ INFO: possible circular locking dependency detected ]
> [  602.229926] 3.8.0-rc1-00003-gde4ae7f #767 Not tainted
> [  602.229933] -------------------------------------------------------
> [  602.229951] kworker/0:1/21 is trying to acquire lock:
> [  602.230037]  ((fb_notifier_list).rwsem){.+.+.+}, at: [<c0041f34>] __blocking_notifier_call_chain+0x2c/0x60
> [  602.230047]
> [  602.230047] but task is already holding lock:
> [  602.230090]  (console_lock){+.+.+.}, at: [<c02a1d60>] console_callback+0xc/0x12c
> [  602.230098]
> [  602.230098] which lock already depends on the new lock.
> [  602.230098]
> [  602.230104]
> [  602.230104] the existing dependency chain (in reverse order) is:
> [  602.230126]
> [  602.230126] -> #1 (console_lock){+.+.+.}:
> [  602.230174]        [<c005cb20>] lock_acquire+0x9c/0x124
> [  602.230205]        [<c001dc78>] console_lock+0x58/0x6c
> [  602.230250]        [<c029ea60>] register_con_driver+0x38/0x138
> [  602.230284]        [<c02a0018>] take_over_console+0x18/0x44
> [  602.230314]        [<c027bc80>] fbcon_takeover+0x64/0xc8
> [  602.230352]        [<c0041c94>] notifier_call_chain+0x44/0x80
> [  602.230386]        [<c0041f50>] __blocking_notifier_call_chain+0x48/0x60
> [  602.230416]        [<c0041f80>] blocking_notifier_call_chain+0x18/0x20
> [  602.230459]        [<c0275efc>] register_framebuffer+0x170/0x250
> [  602.230492]        [<c02837f4>] mxsfb_probe+0x574/0x738
> [  602.230528]        [<c02b276c>] platform_drv_probe+0x14/0x18
> [  602.230556]        [<c02b14cc>] driver_probe_device+0x78/0x20c
> [  602.230583]        [<c02b16f4>] __driver_attach+0x94/0x98
> [  602.230610]        [<c02afdb4>] bus_for_each_dev+0x54/0x7c
> [  602.230636]        [<c02b0d14>] bus_add_driver+0x180/0x250
> [  602.230662]        [<c02b1bb8>] driver_register+0x78/0x144
> [  602.230690]        [<c00087c8>] do_one_initcall+0x30/0x16c
> [  602.230721]        [<c0428fcc>] kernel_init+0xf4/0x290
> [  602.230756]        [<c000e9c8>] ret_from_fork+0x14/0x2c
> [  602.230781]
> [  602.230781] -> #0 ((fb_notifier_list).rwsem){.+.+.+}:
> [  602.230825]        [<c005bfa0>] __lock_acquire+0x1354/0x19b0
> [  602.230854]        [<c005cb20>] lock_acquire+0x9c/0x124
> [  602.230895]        [<c0430148>] down_read+0x3c/0x4c
> [  602.230933]        [<c0041f34>] __blocking_notifier_call_chain+0x2c/0x60
> [  602.230962]        [<c0041f80>] blocking_notifier_call_chain+0x18/0x20
> [  602.230997]        [<c0274a78>] fb_blank+0x34/0x98
> [  602.231024]        [<c027c7b8>] fbcon_blank+0x1dc/0x27c
> [  602.231065]        [<c029f194>] do_blank_screen+0x1b0/0x268
> [  602.231093]        [<c02a1dbc>] console_callback+0x68/0x12c
> [  602.231121]        [<c00368c0>] process_one_work+0x1a8/0x560
> [  602.231145]        [<c0036fd8>] worker_thread+0x160/0x480
> [  602.231180]        [<c003c040>] kthread+0xa4/0xb0
> [  602.231210]        [<c000e9c8>] ret_from_fork+0x14/0x2c
> [  602.231218]
> [  602.231218] other info that might help us debug this:
> [  602.231218]
> [  602.231225]  Possible unsafe locking scenario:
> [  602.231225]
> [  602.231230]        CPU0                    CPU1
> [  602.231235]        ----                    ----
> [  602.231249]   lock(console_lock);
> [  602.231263]                                lock((fb_notifier_list).rwsem);
> [  602.231275]                                lock(console_lock);
> [  602.231287]   lock((fb_notifier_list).rwsem);
> [  602.231292]
> [  602.231292]  *** DEADLOCK ***
> [  602.231292]
> [  602.231305] 3 locks held by kworker/0:1/21:
> [  602.231345]  #0:  (events){.+.+.+}, at: [<c0036840>] process_one_work+0x128/0x560
> [  602.231388]  #1:  (console_work){+.+...}, at: [<c0036840>] process_one_work+0x128/0x560
> [  602.231430]  #2:  (console_lock){+.+.+.}, at: [<c02a1d60>] console_callback+0xc/0x12c
> [  602.231437]
> [  602.231437] stack backtrace:
> [  602.231491] [<c0013e58>] (unwind_backtrace+0x0/0xf0) from [<c042b0e4>] (print_circular_bug+0x254/0x2a0)
> [  602.231547] [<c042b0e4>] (print_circular_bug+0x254/0x2a0) from [<c005bfa0>] (__lock_acquire+0x1354/0x19b0)
> [  602.231596] [<c005bfa0>] (__lock_acquire+0x1354/0x19b0) from [<c005cb20>] (lock_acquire+0x9c/0x124)
> [  602.231640] [<c005cb20>] (lock_acquire+0x9c/0x124) from [<c0430148>] (down_read+0x3c/0x4c)
> [  602.231694] [<c0430148>] (down_read+0x3c/0x4c) from [<c0041f34>] (__blocking_notifier_call_chain+0x2c/0x60)
> [  602.231741] [<c0041f34>] (__blocking_notifier_call_chain+0x2c/0x60) from [<c0041f80>] (blocking_notifier_call_chain+0x18/0x20)
> [  602.231791] [<c0041f80>] (blocking_notifier_call_chain+0x18/0x20) from [<c0274a78>] (fb_blank+0x34/0x98)
> [  602.231836] [<c0274a78>] (fb_blank+0x34/0x98) from [<c027c7b8>] (fbcon_blank+0x1dc/0x27c)
> [  602.231886] [<c027c7b8>] (fbcon_blank+0x1dc/0x27c) from [<c029f194>] (do_blank_screen+0x1b0/0x268)
> [  602.231931] [<c029f194>] (do_blank_screen+0x1b0/0x268) from [<c02a1dbc>] (console_callback+0x68/0x12c)
> [  602.231970] [<c02a1dbc>] (console_callback+0x68/0x12c) from [<c00368c0>] (process_one_work+0x1a8/0x560)
> [  602.232010] [<c00368c0>] (process_one_work+0x1a8/0x560) from [<c0036fd8>] (worker_thread+0x160/0x480)
> [  602.232054] [<c0036fd8>] (worker_thread+0x160/0x480) from [<c003c040>] (kthread+0xa4/0xb0)
> [  602.232100] [<c003c040>] (kthread+0xa4/0xb0) from [<c000e9c8>] (ret_from_fork+0x14/0x2c)
> 
> 
> On Sat, Dec 22, 2012 at 04:28:26PM +0100, Maciej Rutecki wrote:
> > Got during suspend to disk:
> > 
> > [  269.784867] [ INFO: possible circular locking dependency detected ]
> > [  269.784869] 3.8.0-rc1 #1 Not tainted
> > [  269.784870] -------------------------------------------------------
> > [  269.784871] kworker/u:3/56 is trying to acquire lock:
> > [  269.784878]  ((fb_notifier_list).rwsem){.+.+.+}, at: [<ffffffff81062a1d>] 
> > __blocking_notifier_call_chain+0x49/0x80
> > [  269.784879] 
> > [  269.784879] but task is already holding lock:
> > [  269.784884]  (console_lock){+.+.+.}, at: [<ffffffff812ee4ce>] 
> > i915_drm_freeze+0x9e/0xbb
> > [  269.784884] 
> > [  269.784884] which lock already depends on the new lock.
> > [  269.784884] 
> > [  269.784885] 
> > [  269.784885] the existing dependency chain (in reverse order) is:
> > [  269.784887] 
> > [  269.784887] -> #1 (console_lock){+.+.+.}:
> > [  269.784890]        [<ffffffff810890e4>] lock_acquire+0x95/0x105
> > [  269.784893]        [<ffffffff810405a1>] console_lock+0x59/0x5b
> > [  269.784897]        [<ffffffff812ba125>] register_con_driver+0x36/0x128
> > [  269.784899]        [<ffffffff812bb27e>] take_over_console+0x1e/0x45
> > [  269.784903]        [<ffffffff81257a04>] fbcon_takeover+0x56/0x98
> > [  269.784906]        [<ffffffff8125b857>] fbcon_event_notify+0x2c1/0x5ea
> > [  269.784909]        [<ffffffff8149a211>] notifier_call_chain+0x67/0x92
> > [  269.784911]        [<ffffffff81062a33>] __blocking_notifier_call_chain+0x5f/0x80
> > [  269.784912]        [<ffffffff81062a63>] blocking_notifier_call_chain+0xf/0x11
> > [  269.784915]        [<ffffffff8124e85e>] fb_notifier_call_chain+0x16/0x18
> > [  269.784917]        [<ffffffff812505d7>] register_framebuffer+0x20a/0x26e
> > [  269.784920]        [<ffffffff812d3ca0>] 
> > drm_fb_helper_single_fb_probe+0x1ce/0x297
> > [  269.784922]        [<ffffffff812d3f40>] drm_fb_helper_initial_config+0x1d7/0x1ef
> > [  269.784924]        [<ffffffff8132cee2>] intel_fbdev_init+0x6f/0x82
> > [  269.784927]        [<ffffffff812f22f6>] i915_driver_load+0xa9e/0xc78
> > [  269.784929]        [<ffffffff812e020c>] drm_get_pci_dev+0x165/0x26d
> > [  269.784931]        [<ffffffff812ee8da>] i915_pci_probe+0x60/0x69
> > [  269.784933]        [<ffffffff8123fe8e>] local_pci_probe+0x39/0x61
> > [  269.784935]        [<ffffffff812400f5>] pci_device_probe+0xba/0xe0
> > [  269.784938]        [<ffffffff8133d3b6>] driver_probe_device+0x99/0x1c4
> > [  269.784940]        [<ffffffff8133d52f>] __driver_attach+0x4e/0x6f
> > [  269.784942]        [<ffffffff8133bae1>] bus_for_each_dev+0x52/0x84
> > [  269.784944]        [<ffffffff8133cec6>] driver_attach+0x19/0x1b
> > [  269.784946]        [<ffffffff8133cb65>] bus_add_driver+0xdf/0x203
> > [  269.784948]        [<ffffffff8133dad3>] driver_register+0x8e/0x114
> > [  269.784952]        [<ffffffff8123f581>] __pci_register_driver+0x5d/0x62
> > [  269.784953]        [<ffffffff812e0395>] drm_pci_init+0x81/0xe6
> > [  269.784957]        [<ffffffff81af7612>] i915_init+0x66/0x68
> > [  269.784959]        [<ffffffff810020b4>] do_one_initcall+0x7a/0x136
> > [  269.784962]        [<ffffffff8147ceaa>] kernel_init+0x141/0x296
> > [  269.784964]        [<ffffffff8149c7bc>] ret_from_fork+0x7c/0xb0
> > [  269.784966] 
> > [  269.784966] -> #0 ((fb_notifier_list).rwsem){.+.+.+}:
> > [  269.784967]        [<ffffffff81088955>] __lock_acquire+0xa7e/0xddd
> > [  269.784969]        [<ffffffff810890e4>] lock_acquire+0x95/0x105
> > [  269.784971]        [<ffffffff81495092>] down_read+0x34/0x43
> > [  269.784973]        [<ffffffff81062a1d>] __blocking_notifier_call_chain+0x49/0x80
> > [  269.784975]        [<ffffffff81062a63>] blocking_notifier_call_chain+0xf/0x11
> > [  269.784977]        [<ffffffff8124e85e>] fb_notifier_call_chain+0x16/0x18
> > [  269.784979]        [<ffffffff8124ec47>] fb_set_suspend+0x22/0x4d
> > [  269.784981]        [<ffffffff8132cfe3>] intel_fbdev_set_suspend+0x20/0x22
> > [  269.784983]        [<ffffffff812ee4db>] i915_drm_freeze+0xab/0xbb
> > [  269.784985]        [<ffffffff812eea82>] i915_pm_freeze+0x3d/0x41
> > [  269.784987]        [<ffffffff8123f759>] pci_pm_freeze+0x65/0x8d
> > [  269.784990]        [<ffffffff81342f20>] dpm_run_callback.isra.3+0x27/0x56
> > [  269.784993]        [<ffffffff81343085>] __device_suspend+0x136/0x1b1
> > [  269.784995]        [<ffffffff8134311a>] async_suspend+0x1a/0x58
> > [  269.784997]        [<ffffffff81063a6b>] async_run_entry_fn+0xa4/0x17c
> > [  269.785000]        [<ffffffff81058df2>] process_one_work+0x1cf/0x38e
> > [  269.785002]        [<ffffffff81059290>] worker_thread+0x12e/0x1cc
> > [  269.785004]        [<ffffffff8105d416>] kthread+0xac/0xb4
> > [  269.785006]        [<ffffffff8149c7bc>] ret_from_fork+0x7c/0xb0
> > [  269.785006] 
> > [  269.785006] other info that might help us debug this:
> > [  269.785006] 
> > [  269.785007]  Possible unsafe locking scenario:
> > [  269.785007] 
> > [  269.785008]        CPU0                    CPU1
> > [  269.785008]        ----                    ----
> > [  269.785009]   lock(console_lock);
> > [  269.785010]                                lock((fb_notifier_list).rwsem);
> > [  269.785012]                                lock(console_lock);
> > [  269.785013]   lock((fb_notifier_list).rwsem);
> > [  269.785013] 
> > [  269.785013]  *** DEADLOCK ***
> > [  269.785013] 
> > [  269.785014] 4 locks held by kworker/u:3/56:
> > [  269.785018]  #0:  (events_unbound){.+.+.+}, at: [<ffffffff81058d77>] 
> > process_one_work+0x154/0x38e
> > [  269.785021]  #1:  ((&entry->work)){+.+.+.}, at: [<ffffffff81058d77>] 
> > process_one_work+0x154/0x38e
> > [  269.785024]  #2:  (&__lockdep_no_validate__){......}, at: [<ffffffff81342d85>] 
> > device_lock+0xf/0x11
> > [  269.785027]  #3:  (console_lock){+.+.+.}, at: [<ffffffff812ee4ce>] 
> > i915_drm_freeze+0x9e/0xbb
> > [  269.785028] 
> > [  269.785028] stack backtrace:
> > [  269.785029] Pid: 56, comm: kworker/u:3 Not tainted 3.8.0-rc1 #1
> > [  269.785030] Call Trace:
> > [  269.785035]  [<ffffffff8148fcb5>] print_circular_bug+0x1f8/0x209
> > [  269.785036]  [<ffffffff81088955>] __lock_acquire+0xa7e/0xddd
> > [  269.785038]  [<ffffffff810890e4>] lock_acquire+0x95/0x105
> > [  269.785040]  [<ffffffff81062a1d>] ? __blocking_notifier_call_chain+0x49/0x80
> > [  269.785042]  [<ffffffff81495092>] down_read+0x34/0x43
> > [  269.785044]  [<ffffffff81062a1d>] ? __blocking_notifier_call_chain+0x49/0x80
> > [  269.785046]  [<ffffffff81062a1d>] __blocking_notifier_call_chain+0x49/0x80
> > [  269.785047]  [<ffffffff81062a63>] blocking_notifier_call_chain+0xf/0x11
> > [  269.785050]  [<ffffffff8124e85e>] fb_notifier_call_chain+0x16/0x18
> > [  269.785052]  [<ffffffff8124ec47>] fb_set_suspend+0x22/0x4d
> > [  269.785054]  [<ffffffff8132cfe3>] intel_fbdev_set_suspend+0x20/0x22
> > [  269.785055]  [<ffffffff812ee4db>] i915_drm_freeze+0xab/0xbb
> > [  269.785057]  [<ffffffff812eea82>] i915_pm_freeze+0x3d/0x41
> > [  269.785060]  [<ffffffff8123f759>] pci_pm_freeze+0x65/0x8d
> > [  269.785062]  [<ffffffff8123f6f4>] ? pci_pm_poweroff+0x9c/0x9c
> > [  269.785064]  [<ffffffff81342f20>] dpm_run_callback.isra.3+0x27/0x56
> > [  269.785066]  [<ffffffff81343085>] __device_suspend+0x136/0x1b1
> > [  269.785068]  [<ffffffff81089563>] ? trace_hardirqs_on_caller+0x117/0x173
> > [  269.785070]  [<ffffffff8134311a>] async_suspend+0x1a/0x58
> > [  269.785072]  [<ffffffff81063a6b>] async_run_entry_fn+0xa4/0x17c
> > [  269.785074]  [<ffffffff81058df2>] process_one_work+0x1cf/0x38e
> > [  269.785076]  [<ffffffff81058d77>] ? process_one_work+0x154/0x38e
> > [  269.785078]  [<ffffffff810639c7>] ? async_schedule+0x12/0x12
> > [  269.785080]  [<ffffffff8105679f>] ? spin_lock_irq+0x9/0xb
> > [  269.785082]  [<ffffffff81059290>] worker_thread+0x12e/0x1cc
> > [  269.785084]  [<ffffffff81059162>] ? rescuer_thread+0x187/0x187
> > [  269.785085]  [<ffffffff8105d416>] kthread+0xac/0xb4
> > [  269.785088]  [<ffffffff8105d36a>] ? __kthread_parkme+0x60/0x60
> > [  269.785090]  [<ffffffff8149c7bc>] ret_from_fork+0x7c/0xb0
> > [  269.785091]  [<ffffffff8105d36a>] ? __kthread_parkme+0x60/0x60
> > 
> > 
> > Config:
> > http://mrutecki.pl/download/kernel/3.8.0-rc1/s2disk/config-3.8.0-rc1
> > 
> > dmesg:
> > http://mrutecki.pl/download/kernel/3.8.0-rc1/s2disk/dmesg-3.8.0-rc1.txt
> > 
> > 
> > Found similar report:
> > http://marc.info/?l=linux-kernel&m=135546308908700&w=2
> > 
> > Regards
> > 
> > -- 
> > Maciej Rutecki
> > http://www.mrutecki.pl
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

