Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363Ab1ANTri (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 14:47:38 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34139 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751490Ab1ANTrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 14:47:36 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1101132237190.9760@x980>
References: <alpine.LFD.2.02.1101132237190.9760@x980>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 14 Jan 2011 11:40:34 -0800
Message-ID: <AANLkTinXh_rgzTw8i85MKef0beTf3mszNZOvYpAUSneA@mail.gmail.com>
Subject: Re: [GIT] ACPI patches for 2.6.38-merge
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 7:50 PM, Len Brown <lenb@kernel.org> wrote:
>
> please pull from:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release

Grr. I'm bisecting now, but this seems to cause

[    1.033920] ACPI: EC: Look up EC in DSDT
[    1.033976] BUG: spinlock bad magic on CPU#0, swapper/1
[    1.034038]  lock: ffffffff824353f0, .magic: 00000000, .owner:
<none>/-1, .owner_cpu: 0
[    1.034100] Pid: 1, comm: swapper Not tainted 2.6.37-07310-gd73b388 #14
[    1.034161] Call Trace:
[    1.034216]  [<ffffffff812482a1>] ? spin_bug+0x9c/0xa3
[    1.034276]  [<ffffffff81248371>] ? do_raw_spin_lock+0x29/0x137
[    1.034337]  [<ffffffff81556af5>] ? _raw_spin_lock_irqsave+0x49/0x53
[    1.034399]  [<ffffffff812747f0>] ? acpi_os_acquire_lock+0x9/0xb
[    1.034461]  [<ffffffff8128819f>] ? acpi_ex_system_wait_mutex+0x1d/0x4e
[    1.034522]  [<ffffffff812747f0>] ? acpi_os_acquire_lock+0x9/0xb
[    1.034583]  [<ffffffff812825bd>] ? acpi_ev_acquire_global_lock+0xaf/0x12e
[    1.034645]  [<ffffffff81289b3e>] ? acpi_ex_acquire_mutex_object+0x39/0x63
[    1.034707]  [<ffffffff8128992b>] ? acpi_ex_acquire_global_lock+0x24/0x46
[    1.034769]  [<ffffffff812853ec>] ? acpi_ex_read_data_from_field+0x11c/0x160
[    1.034833]  [<ffffffff81060e70>] ? trace_hardirqs_on+0xd/0xf
[    1.034893]  [<ffffffff8128a29d>] ? acpi_ex_resolve_node_to_value+0x19d/0x22c
[    1.034956]  [<ffffffff81285db7>] ? acpi_ex_resolve_to_value+0x203/0x20c
[    1.035018]  [<ffffffff8128030e>] ? acpi_ds_evaluate_name_path+0x7b/0xf9
[    1.035079]  [<ffffffff8127eca3>] ? acpi_ds_exec_end_op+0x9b/0x3e4
[    1.035140]  [<ffffffff81291458>] ? acpi_ps_parse_loop+0x7b8/0x950
[    1.035201]  [<ffffffff81290820>] ? acpi_ps_parse_aml+0x94/0x2b8
[    1.035261]  [<ffffffff81291cae>] ? acpi_ps_execute_method+0x1c9/0x273
[    1.035322]  [<ffffffff8128d152>] ? acpi_ns_evaluate+0xda/0x1a5
[    1.035382]  [<ffffffff81294da6>] ? acpi_ut_evaluate_object+0x72/0x19b
[    1.035456]  [<ffffffff81294f34>] ? acpi_ut_execute_STA+0x21/0x50
[    1.035528]  [<ffffffff8128c998>] ? acpi_ns_get_device_callback+0x12b/0x16f
[    1.035602]  [<ffffffff81055ebd>] ? up+0x34/0x3b
[    1.035671]  [<ffffffff8128e978>] ? acpi_ns_walk_namespace+0xbb/0x17b
[    1.035744]  [<ffffffff8128c86d>] ? acpi_ns_get_device_callback+0x0/0x16f
[    1.035817]  [<ffffffff8128c856>] ? acpi_get_devices+0x61/0x78
[    1.035888]  [<ffffffff81279059>] ? ec_parse_device+0x0/0xa0
[    1.035960]  [<ffffffff81b3e188>] ? acpi_ec_ecdt_probe+0x107/0x1da
[    1.036032]  [<ffffffff81295b37>] ? acpi_enable_subsystem+0x82/0x8b
[    1.036102]  [<ffffffff81b3dce7>] ? acpi_init+0x0/0x105
[    1.036172]  [<ffffffff81b3db38>] ? acpi_bus_init+0x2e/0x1dd
[    1.036244]  [<ffffffff8123d58e>] ? kobject_create_and_add+0x37/0x68
[    1.036317]  [<ffffffff81b3dd58>] ? acpi_init+0x71/0x105
[    1.036387]  [<ffffffff810002ee>] ? do_one_initcall+0x7a/0x130
[    1.036459]  [<ffffffff81b19ccb>] ? kernel_init+0x143/0x1c7

on my sandybridge machine. I see somebody else reported it too, so
it's not just preproduction hardware.

                   Linus
