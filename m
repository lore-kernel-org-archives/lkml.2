Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab1DZJyD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 05:54:03 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56884 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893Ab1DZJyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 05:54:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=DlWxn8Id7zy2nBv+2j9dMK+036v65Tbc5I8liVoZX5ZiNM0qXvHK4fms5Q8y2kG4AI
         MV2kzT24eh6JMbXYKJ7C2mOzJjYBqaPYY60/5HNnHZJVLfTR7wqorgYfWgMiRtRlWoOy
         4zS0u5se/OIR4BvDyZlmdptH+gB5bmfX5bLuc=
Subject: Re: [BUG] perf and kmemcheck : fatal combination
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Vegard Nossum <vegardno@ifi.uio.no>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <1303808257.3012.3.camel@edumazet-laptop>
References: <1303747731.2747.182.camel@edumazet-laptop>
	 <1303803525.20212.20.camel@twins>  <20110426080443.GA806@elte.hu>
	 <1303808257.3012.3.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Apr 2011 11:53:55 +0200
Message-ID: <1303811635.3358.21.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 26 avril 2011 à 10:57 +0200, Eric Dumazet a écrit :
> Le mardi 26 avril 2011 à 10:04 +0200, Ingo Molnar a écrit :
> 
> > Eric, does it manage to limp along if you remove the BUG_ON()?
> > 
> > That risks NMI recursion but maybe it allows you to see why things are slow, 
> > before it crashes ;-)
> > 
> 
> If I remove the BUG_ON from nmi_enter, it seems to crash very fast 
> 
> 

Before you ask, some more complete netconsole traces :



[  306.657192] ------------[ cut here ]------------
[  306.657195] ------------[ cut here ]------------
[  306.657202] WARNING: at arch/x86/mm/kmemcheck/kmemcheck.c:634 kmemcheck_fault+0xa9/0xc0()
[  306.657204] Hardware name: ProLiant BL460c G6
[  306.657205] Modules linked in: nfsd lockd auth_rpcgss sunrpc tg3 libphy sg [last unloaded: x_tables]
[  306.657211] Pid: 3955, comm: perf Not tainted 2.6.39-rc4-00369-g23cf772-dirty #559
[  306.657212] Call Trace:
[  306.657214]  <NMI>  [<ffffffff8102ac39>] ? kmemcheck_fault+0xa9/0xc0
[  306.657221]  [<ffffffff810427db>] warn_slowpath_common+0x8b/0xc0
[  306.657223]  [<ffffffff81042825>] warn_slowpath_null+0x15/0x20
[  306.657226]  [<ffffffff8102ac39>] kmemcheck_fault+0xa9/0xc0
[  306.657229]  [<ffffffff8147ca4b>] do_page_fault+0x1fb/0x560
[  306.657234]  [<ffffffff811d0289>] ? put_dec+0x59/0x60
[  306.657237]  [<ffffffff811d0591>] ? number+0x301/0x330
[  306.657239]  [<ffffffff8147a48f>] page_fault+0x1f/0x30
[  306.657245]  [<ffffffff8124dce5>] ? vt_console_print+0x85/0x360
[  306.657247]  [<ffffffff8124dcda>] ? vt_console_print+0x7a/0x360
[  306.657250]  [<ffffffff81043159>] __call_console_drivers+0x89/0xa0
[  306.657252]  [<ffffffff810431bb>] _call_console_drivers+0x4b/0x80
[  306.657254]  [<ffffffff810432d7>] console_unlock+0xe7/0x1e0
[  306.657257]  [<ffffffff8104388e>] vprintk+0x1ee/0x4a0
[  306.657260]  [<ffffffff8102ac39>] ? kmemcheck_fault+0xa9/0xc0
[  306.657262]  [<ffffffff81043ba7>] printk+0x67/0x70
[  306.657264]  [<ffffffff8102ac39>] ? kmemcheck_fault+0xa9/0xc0
[  306.657267]  [<ffffffff81042789>] warn_slowpath_common+0x39/0xc0
[  306.657269]  [<ffffffff81042825>] warn_slowpath_null+0x15/0x20
[  306.657271]  [<ffffffff8102ac39>] kmemcheck_fault+0xa9/0xc0
[  306.657273]  [<ffffffff8147ca4b>] do_page_fault+0x1fb/0x560
[  306.657276]  [<ffffffff8101167b>] ? intel_pmu_drain_bts_buffer+0x2b/0x170
[  306.657279]  [<ffffffff8147a48f>] page_fault+0x1f/0x30
[  306.657282]  [<ffffffff8100ef42>] ? x86_perf_event_update+0x12/0x70
[  306.657284]  [<ffffffff810104b1>] ? intel_pmu_save_and_restart+0x11/0x20
[  306.657287]  [<ffffffff81012e84>] intel_pmu_handle_irq+0x1d4/0x420
[  306.657290]  [<ffffffff8147b570>] perf_event_nmi_handler+0x50/0xc0
[  306.657292]  [<ffffffff8147cfa3>] notifier_call_chain+0x53/0x80
[  306.657294]  [<ffffffff8147d018>] __atomic_notifier_call_chain+0x48/0x70
[  306.657296]  [<ffffffff8147d051>] atomic_notifier_call_chain+0x11/0x20
[  306.657298]  [<ffffffff8147d08e>] notify_die+0x2e/0x30
[  306.657300]  [<ffffffff8147a8af>] do_nmi+0x4f/0x200
[  306.657302]  [<ffffffff8147a6ea>] nmi+0x1a/0x20
[  306.657304]  [<ffffffff8100fd4d>] ? intel_pmu_enable_all+0x9d/0x110
[  306.657305]  <<EOE>>  [<ffffffff810104da>] intel_pmu_nhm_enable_all+0x1a/0x120
[  306.657309]  [<ffffffff810131d4>] x86_pmu_enable+0x104/0x260
[  306.657313]  [<ffffffff810a84e9>] perf_pmu_enable+0x39/0x50
[  306.657314]  [<ffffffff8101236c>] x86_pmu_add+0xac/0x120
[  306.657317]  [<ffffffff810aae68>] ? perf_install_in_context+0x18/0xa0
[  306.657319]  [<ffffffff8102b001>] ? kmemcheck_pte_lookup+0x11/0x40
[  306.657322]  [<ffffffff8147a48f>] ? page_fault+0x1f/0x30
[  306.657325]  [<ffffffff810acf15>] event_sched_in+0x65/0x110
[  306.657327]  [<ffffffff810afb95>] __perf_install_in_context+0x125/0x140
[  306.657330]  [<ffffffff810ab100>] ? perf_remove_from_context+0xa0/0xa0
[  306.657332]  [<ffffffff810ab159>] remote_function+0x59/0x70
[  306.657335]  [<ffffffff81075d6e>] smp_call_function_single+0x8e/0x170
[  306.657338]  [<ffffffff810a86a4>] cpu_function_call+0x34/0x40
[  306.657340]  [<ffffffff810afa70>] ? perf_tp_event+0xf0/0xf0
[  306.657342]  [<ffffffff810aaedf>] perf_install_in_context+0x8f/0xa0
[  306.657345]  [<ffffffff810b0792>] sys_perf_event_open+0x592/0x7a0
[  306.657348]  [<ffffffff814819a9>] sysenter_dispatch+0x7/0x27
[  306.657350] ---[ end trace 7333dc2d81c31e96 ]---
[  306.699715] WARNING: at arch/x86/mm/kmemcheck/kmemcheck.c:634 kmemcheck_fault+0xa9/0xc0()
[  306.700659] Hardware name: ProLiant BL460c G6
[  306.701487] Modules linked in: nfsd lockd auth_rpcgss sunrpc tg3 libphy sg [last unloaded: x_tables]
[  306.704964] Pid: 3955, comm: perf Tainted: G        W   2.6.39-rc4-00369-g23cf772-dirty #559
[  306.705922] Call Trace:
[  306.706405]  <NMI>  [<ffffffff8102ac39>] ? kmemcheck_fault+0xa9/0xc0
[  306.707439]  [<ffffffff810427db>] warn_slowpath_common+0x8b/0xc0
[  306.708173]  [<ffffffff81042825>] warn_slowpath_null+0x15/0x20
[  306.708893]  [<ffffffff8102ac39>] kmemcheck_fault+0xa9/0xc0
[  306.709597]  [<ffffffff8147ca4b>] do_page_fault+0x1fb/0x560
[  306.710301]  [<ffffffff8101167b>] ? intel_pmu_drain_bts_buffer+0x2b/0x170
[  306.711091]  [<ffffffff8147a48f>] page_fault+0x1f/0x30
[  306.711764]  [<ffffffff8100ef42>] ? x86_perf_event_update+0x12/0x70
[  306.712727]  [<ffffffff810104b1>] ? intel_pmu_save_and_restart+0x11/0x20
[  306.713509]  [<ffffffff81012e84>] intel_pmu_handle_irq+0x1d4/0x420
[  306.714254]  [<ffffffff8147b570>] perf_event_nmi_handler+0x50/0xc0
[  306.714999]  [<ffffffff8147cfa3>] notifier_call_chain+0x53/0x80
[  306.715728]  [<ffffffff8147d018>] __atomic_notifier_call_chain+0x48/0x70
[  306.716510]  [<ffffffff8147d051>] atomic_notifier_call_chain+0x11/0x20
[  306.717279]  [<ffffffff8147d08e>] notify_die+0x2e/0x30
[  306.717951]  [<ffffffff8147a8af>] do_nmi+0x4f/0x200
[  306.718605]  [<ffffffff8147a6ea>] nmi+0x1a/0x20
[  306.719237]  [<ffffffff8100fd4d>] ? intel_pmu_enable_all+0x9d/0x110
[  306.719988]  <<EOE>>  [<ffffffff810104da>] intel_pmu_nhm_enable_all+0x1a/0x120
[  306.721347]  [<ffffffff810131d4>] x86_pmu_enable+0x104/0x260
[  306.722056]  [<ffffffff810a84e9>] perf_pmu_enable+0x39/0x50
[  306.722760]  [<ffffffff8101236c>] x86_pmu_add+0xac/0x120
[  306.723445]  [<ffffffff810aae68>] ? perf_install_in_context+0x18/0xa0
[  306.724210]  [<ffffffff8102b001>] ? kmemcheck_pte_lookup+0x11/0x40
[  306.724955]  [<ffffffff8147a48f>] ? page_fault+0x1f/0x30
[  306.725640]  [<ffffffff810acf15>] event_sched_in+0x65/0x110
[  306.726345]  [<ffffffff810afb95>] __perf_install_in_context+0x125/0x140
[  306.727124]  [<ffffffff810ab100>] ? perf_remove_from_context+0xa0/0xa0
[  306.727893]  [<ffffffff810ab159>] remote_function+0x59/0x70
[  306.728597]  [<ffffffff81075d6e>] smp_call_function_single+0x8e/0x170
[  306.729363]  [<ffffffff810a86a4>] cpu_function_call+0x34/0x40
[  306.730079]  [<ffffffff810afa70>] ? perf_tp_event+0xf0/0xf0
[  306.730783]  [<ffffffff810aaedf>] perf_install_in_context+0x8f/0xa0
[  306.731535]  [<ffffffff810b0792>] sys_perf_event_open+0x592/0x7a0
[  306.732277]  [<ffffffff814819a9>] sysenter_dispatch+0x7/0x27
[  306.735272] ---[ end trace 7333dc2d81c31e97 ]---
[  306.736401] BUG: unable to handle kernel 


