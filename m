Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450Ab2AQXyA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 18:54:00 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60328 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849Ab2AQXx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 18:53:59 -0500
From: Karsten Wiese <fzuuzf@googlemail.com>
To: John Kacur <jkacur@redhat.com>
Subject: Re: rt-kernel 3.0.14-rt31: BUG: sleeping function called from invalid context
Date: Wed, 18 Jan 2012 00:53:51 +0100
User-Agent: KMail/1.13.7 (Linux/2.6.35.14-106.fc14.x86_64; KDE/4.6.5; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
References: <CAONaPpFjfGiKKGAzrQNk+MF4k50nRf+wMU8H9491NgHyJrUkyw@mail.gmail.com>
In-Reply-To: <CAONaPpFjfGiKKGAzrQNk+MF4k50nRf+wMU8H9491NgHyJrUkyw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201180053.52617.fzuuzf@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 18 Januar 2012 schrieb John Kacur:
> I got a whole bunch of these in 3.0.14-rt31 that basically look alike.
> Will try to drill deeper down. In the meantime, I'm happy to provide
> more information if anyone would like.
> Thanks, John
> 
> [ 4251.928097] BUG: sleeping function called from invalid context at
> /home/jkacur/rt.linux.git/kernel/rtmutex.c:645
> [ 4251.928100] in_atomic(): 1, irqs_disabled(): 1, pid: 168, name: irq/9-acpi
> [ 4251.928102] INFO: lockdep is turned off.
> [ 4251.928103] irq event stamp: 5888
> [ 4251.928104] hardirqs last  enabled at (5887): [<ffffffff810b2a69>]
> rcu_preempt_note_context_switch+0x1c8/0x1d9
> [ 4251.928109] hardirqs last disabled at (5888): [<ffffffff813e4326>]
> _raw_spin_lock_irq+0x19/0x79
> [ 4251.928113] softirqs last  enabled at (0): [<ffffffff81041c88>]
> copy_process+0x517/0xfbd
> [ 4251.928116] softirqs last disabled at (0): [<          (null)>]
>       (null)
> [ 4251.928119] Pid: 168, comm: irq/9-acpi Not tainted
> 3.0.14-rt31-debug-00322-g6aaac97b #1
> [ 4251.928121] Call Trace:
> [ 4251.928125]  [<ffffffff81037b06>] __might_sleep+0xf4/0xf9
> [ 4251.928128]  [<ffffffff8107e4f5>] rt_spin_lock_fastlock.clone.0+0x24/0x31
> [ 4251.928130]  [<ffffffff813e3b33>] rt_spin_lock+0x16/0x40
> [ 4251.928133]  [<ffffffff8103eb60>] __wake_up+0x28/0x50
> [ 4251.928136]  [<ffffffff8122ca51>] acpi_ec_gpe_handler+0x72/0xc4
> [ 4251.928145]  [<ffffffff81238443>] acpi_ev_gpe_dispatch+0xbd/0x12e
> [ 4251.928147]  [<ffffffff81238727>] acpi_ev_gpe_detect+0xbb/0x110

The bug happens because acpi_ev_gpe_detect does
raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags) before it calls
acpi_ev_gpe_dispatch.
