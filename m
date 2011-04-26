Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381Ab1DZNJv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 09:09:51 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36387 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604Ab1DZNJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 09:09:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=F2c5JFoJpEBg+frAxXOih49JrUtkUImAfPZoC5yCWmC007Yr97RAaDIcHNWfdhzkXn
         J+9jOOvu7ZFCoP5uzz/0W3zKLuqmUh+uf4neyeBYY0XIlUP9OfY9qEBo9oJue8DqiE8W
         Yc00F8G6u9ZqTaSt2KvRgmIej+u8ldxKDoS4s=
Subject: Re: [BUG] perf and kmemcheck : fatal combination
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Paul Mackerras <paulus@samba.org>, Vegard Nossum <vegardno@ifi.uio.no>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <1303822603.3358.51.camel@edumazet-laptop>
References: <1303747731.2747.182.camel@edumazet-laptop>
	 <1303803525.20212.20.camel@twins> <20110426080443.GA806@elte.hu>
	 <1303808257.3012.3.camel@edumazet-laptop>
	 <1303811635.3358.21.camel@edumazet-laptop>
	 <BANLkTinOUFrJuauoxnRTkvrhZRxdYd05Mw@mail.gmail.com>
	 <1303813668.3358.22.camel@edumazet-laptop>
	 <1303820855.3358.49.camel@edumazet-laptop>
	 <1303821188.20212.264.camel@twins>
	 <1303822603.3358.51.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Apr 2011 15:09:44 +0200
Message-ID: <1303823384.3358.53.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 26 avril 2011 à 14:56 +0200, Eric Dumazet a écrit :
> Le mardi 26 avril 2011 à 14:33 +0200, Peter Zijlstra a écrit :
> > On Tue, 2011-04-26 at 14:27 +0200, Eric Dumazet wrote:
> > > Thats far from trivial, maybe because we dont have NOTRACK api for
> > > percpu allocations ? 
> > 
> > We can't use per-cpu allocations from NMI context because of the same
> > problem, per-cpu uses vmalloc and vmalloc needs faults. Hence that
> > shouldn't be a problem.
> > 
> > It looks like you covered most of it though, the buffer and the
> > callchain stuff, aside from that it should only use some static data.
> > 
> > Pekka, what does kmemcheck do for .data and .bss things?
> 
> Hmm, maybe I have a problem because of the WARN_ON in kmemcheck and my
> boot had "log_buf_len=32M", so kmemcheck was called again
> 
> 
> I am now trying to remve the line 634 from
> arch/x86/mm/kmemcheck/kmemcheck.c

Yes, its making some progress

[  328.696312] BUG: unable to handle kernel 
[  328.697078] kernel tried to execute NX-protected page - exploit attempt? (uid: 0)
[  328.698284] BUG: unable to handle kernel paging request at ffff88011fc07b58
[  328.699569] IP: [<ffff88011fc07968>] 0xffff88011fc07967
[  328.700488] PGD 1a94063 PUD 11f6f9067 PMD 11f7f8067 PTE 800000011fc07163
[  328.702327] Oops: 0011 [#1] PREEMPT SMP 
[  328.703693] last sysfs file: /sys/devices/system/cpu/online
[  328.704361] CPU 0 
[  328.704777] Modules linked in: nfsd lockd auth_rpcgss sunrpc tg3 libphy sg [last unloaded: x_tables]
[  328.708693] 
[  328.709075] Pid: 4019, comm: perf Not tainted 2.6.39-rc4-00369-g23cf772-dirty #562 HP ProLiant BL460c G6
[  328.710581] RIP: 3c4c:[<ffff88011fc07968>]  [<ffff88011fc07968>] 0xffff88011fc07967
[  328.711692] RSP: 0000:ffff88011b3cbfd8  EFLAGS: ffff88011fc0793c
[  328.712388] RAX: ffff88011b3ca000 RBX: ffff88011fc07ff8 RCX: ffff88011fc07158
[  328.713180] RDX: ffff88011fc03fc0 RSI: ffff88011fc00000 RDI: ffff88011fc07158
[  328.713959] RBP: ffff88011fc07888 R08: ffffffff81601680 R09: ffff880114278400
[  328.714738] R10: ffffffff81004ed3 R11: ffff88011fc078d8 R12: ffffffff8105eb99
[  328.715516] R13: ffff88011fc07888 R14: 0000000000000018 R15: ffff880112638238
[  328.716294] FS:  0000000000000000(0000) GS:ffff88011fc00000(0063) knlGS:00000000f77176c0


