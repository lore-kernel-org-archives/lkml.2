Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293Ab1DZM4t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 08:56:49 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55154 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694Ab1DZM4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 08:56:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=jLXceVByP3SqW6K9XA8odKdNMfHM2AkCXOnhgT8Q5E34bc6Js9jSxvqWaADV2BXLpq
         +O2EM4QzQSDBLp+W8L9ztbinjBRzgelQpfju+A0XYIsXpOreWU+qUlYcor8ruTuUV4Wa
         tueL0a/ooKrftIJPZ8zF9BBq9pTLFtG7uOVUY=
Subject: Re: [BUG] perf and kmemcheck : fatal combination
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Paul Mackerras <paulus@samba.org>, Vegard Nossum <vegardno@ifi.uio.no>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <1303821188.20212.264.camel@twins>
References: <1303747731.2747.182.camel@edumazet-laptop>
	 <1303803525.20212.20.camel@twins> <20110426080443.GA806@elte.hu>
	 <1303808257.3012.3.camel@edumazet-laptop>
	 <1303811635.3358.21.camel@edumazet-laptop>
	 <BANLkTinOUFrJuauoxnRTkvrhZRxdYd05Mw@mail.gmail.com>
	 <1303813668.3358.22.camel@edumazet-laptop>
	 <1303820855.3358.49.camel@edumazet-laptop>
	 <1303821188.20212.264.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Apr 2011 14:56:43 +0200
Message-ID: <1303822603.3358.51.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 26 avril 2011 à 14:33 +0200, Peter Zijlstra a écrit :
> On Tue, 2011-04-26 at 14:27 +0200, Eric Dumazet wrote:
> > Thats far from trivial, maybe because we dont have NOTRACK api for
> > percpu allocations ? 
> 
> We can't use per-cpu allocations from NMI context because of the same
> problem, per-cpu uses vmalloc and vmalloc needs faults. Hence that
> shouldn't be a problem.
> 
> It looks like you covered most of it though, the buffer and the
> callchain stuff, aside from that it should only use some static data.
> 
> Pekka, what does kmemcheck do for .data and .bss things?

Hmm, maybe I have a problem because of the WARN_ON in kmemcheck and my
boot had "log_buf_len=32M", so kmemcheck was called again


I am now trying to remve the line 634 from
arch/x86/mm/kmemcheck/kmemcheck.c

[ 4564.554310] WARNING: at arch/x86/mm/kmemcheck/kmemcheck.c:634 kmemcheck_fault+0xa9/0xc0()
[ 4564.554312] Hardware name: ProLiant BL460c G6
[ 4564.554313] Modules linked in: nfsd lockd auth_rpcgss sunrpc tg3 libphy sg [last unloaded: x_tables]
[ 4564.554319] Pid: 4276, comm: perf Not tainted 2.6.39-rc4-00369-g23cf772-dirty #561
[ 4564.554320] Call Trace:
[ 4564.554322]  <NMI>  [<ffffffff8102ac39>] ? kmemcheck_fault+0xa9/0xc0
[ 4564.554329]  [<ffffffff810427db>] warn_slowpath_common+0x8b/0xc0
[ 4564.554331]  [<ffffffff81042825>] warn_slowpath_null+0x15/0x20
[ 4564.554333]  [<ffffffff8102ac39>] kmemcheck_fault+0xa9/0xc0
[ 4564.554337]  [<ffffffff8147ca4b>] do_page_fault+0x1fb/0x560
[ 4564.554342]  [<ffffffff811d0289>] ? put_dec+0x59/0x60
[ 4564.554344]  [<ffffffff811d0591>] ? number+0x301/0x330
[ 4564.554347]  [<ffffffff8147a48f>] page_fault+0x1f/0x30
[ 4564.554352]  [<ffffffff8124dce5>] ? vt_console_print+0x85/0x360
[ 4564.554355]  [<ffffffff8124dcda>] ? vt_console_print+0x7a/0x360
[ 4564.554358]  [<ffffffff81043159>] __call_console_drivers+0x89/0xa0
[ 4564.554360]  [<ffffffff810431bb>] _call_console_drivers+0x4b/0x80
[ 4564.554362]  [<ffffffff810432d7>] console_unlock+0xe7/0x1e0
[ 4564.554365]  [<ffffffff8104388e>] vprintk+0x1ee/0x4a0
[ 4564.554368]  [<ffffffff8102ac39>] ? kmemcheck_fault+0xa9/0xc0
[ 4564.554370]  [<ffffffff81043ba7>] printk+0x67/0x70
[ 4564.554372]  [<ffffffff8102ac39>] ? kmemcheck_fault+0xa9/0xc0
[ 4564.554375]  [<ffffffff81042789>] warn_slowpath_common+0x39/0xc0
[ 4564.554377]  [<ffffffff81042825>] warn_slowpath_null+0x15/0x20
[ 4564.554379]  [<ffffffff8102ac39>] kmemcheck_fault+0xa9/0xc0
[ 4564.554381]  [<ffffffff8147ca4b>] do_page_fault+0x1fb/0x560
[ 4564.554384]  [<ffffffff8101167b>] ? intel_pmu_drain_bts_buffer+0x2b/0x170
[ 4564.554387]  [<ffffffff8147a48f>] page_fault+0x1f/0x30
[ 4564.554390]  [<ffffffff8100ef42>] ? x86_perf_event_update+0x12/0x70
[ 4564.554392]  [<ffffffff810104b1>] ? intel_pmu_save_and_restart+0x11/0x20
[ 4564.554394]  [<ffffffff81012e84>] intel_pmu_handle_irq+0x1d4/0x420
[ 4564.554397]  [<ffffffff8147b570>] perf_event_nmi_handler+0x50/0xc0
[ 4564.554399]  [<ffffffff8147cfa3>] notifier_call_chain+0x53/0x80
[ 4564.554401]  [<ffffffff8147d018>] __atomic_notifier_call_chain+0x48/0x70
[ 4564.554404]  [<ffffffff8147d051>] atomic_notifier_call_chain+0x11/0x20
[ 4564.554406]  [<ffffffff8147d08e>] notify_die+0x2e/0x30
[ 4564.554407]  [<ffffffff8147a8af>] do_nmi+0x4f/0x200
[ 4564.554409]  [<ffffffff8147a6ea>] nmi+0x1a/0x20
[ 4564.554411]  [<ffffffff8100fd4d>] ? intel_pmu_enable_all+0x9d/0x110



