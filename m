Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859Ab1CHBbd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 20:31:33 -0500
Received: from smtp-out.google.com ([74.125.121.67]:38129 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756781Ab1CHBbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 20:31:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=B0c74PDvTa+DsWEe2JWFJJsDUOaA2V4xccKxqHIR1iPfBSlD8VT7RSQV+WHIp+47bP
         ZRE3XA/CLiUCJQWCrr3Q==
MIME-Version: 1.0
Date: Mon, 7 Mar 2011 17:31:28 -0800
Message-ID: <AANLkTikupmQqgVd5Y6Tg0Cj-0TGUvzko8-VPs6_n_pKE@mail.gmail.com>
Subject: mce.c related WARNING: at kernel/timer.c:983 del_timer_sync
From: Venkatesh Pallipadi <venki@google.com>
To: Andi Kleen <andi@firstfloor.org>, Yong Zhang <yong.zhang@windriver.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With latest git kernel, I see the below WARN_ON at boot, once for each CPU.

[   26.806429] ------------[ cut here ]------------
[   26.806434] WARNING: at kernel/timer.c:983 del_timer_sync+0x39/0x4d()
[   26.806437] Hardware name: MCP55
[   26.806438] Modules linked in: tg3 forcedeth sata_mv powernow_k8
freq_table processor mperf msr cpuid ipv6 genrtc
[   26.806447] Pid: 0, comm: swapper Tainted: G        W
2.6.38-smp-linus.22280 #23
[   26.806449] Call Trace:
[   26.806450]  <IRQ>  [<ffffffff8106e8ea>] ? warn_slowpath_common+0x85/0x9d
[   26.806456]  [<ffffffff8106e91c>] ? warn_slowpath_null+0x1a/0x1c
[   26.806459]  [<ffffffff8107ac48>] ? del_timer_sync+0x39/0x4d
[   26.806462]  [<ffffffff81047a44>] ? mce_cpu_restart+0x1e/0x54
[   26.806466]  [<ffffffff81099b22>] ?
generic_smp_call_function_single_interrupt+0xd1/0xf3
[   26.806469]  [<ffffffff8104c188>] ?
smp_call_function_single_interrupt+0x18/0x27
[   26.806473]  [<ffffffff810375f3>] ? call_function_single_interrupt+0x13/0x20
[   26.806475]  <EOI>  [<ffffffff8103da93>] ? default_idle+0x4d/0x7f
[   26.806479]  [<ffffffff8103da73>] ? default_idle+0x2d/0x7f
[   26.806482]  [<ffffffff8103dbad>] ? c1e_idle+0xe8/0xef
[   26.806485]  [<ffffffff8145bc62>] ? atomic_notifier_call_chain+0x18/0x1a
[   26.806488]  [<ffffffff81035cc7>] ? cpu_idle+0x5f/0x96
[   26.806491]  [<ffffffff8144af7e>] ? rest_init+0x72/0x74
[   26.806495]  [<ffffffff818edcfe>] ? start_kernel+0x37b/0x386
[   26.806498]  [<ffffffff818ed2a4>] ? x86_64_start_reservations+0xb4/0xb8
[   26.806502]  [<ffffffff818ed39a>] ? x86_64_start_kernel+0xf2/0xf9
[   26.806504] ---[ end trace 69a4de56993e518a ]---

Looks like WARN_ON was after this change
commit 466bd3030973910118ca601da8072be97a1e2209
Author: Yong Zhang <yong.zhang@windriver.com>
Date:   Wed Oct 20 15:57:33 2010 -0700

    timer: Warn when del_timer_sync() is called in hardirq context

But, the actual reason is likely some MCE parameter change at boot causing
mce_restart() which in turn calls on_each_cpu mce_cpu_restart() which calls
del_timer_sync().

Thanks,
Venki
