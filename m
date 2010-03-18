Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374Ab0CRUha (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 16:37:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45979 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752095Ab0CRUhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 16:37:25 -0400
Date: Thu, 18 Mar 2010 13:36:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Valdis.Kletnieks@vt.edu
Cc: Len Brown <lenb@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, Greg KH <greg@kroah.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.33-mmotm0304 - lockdep warning in ACPI code
Message-Id: <20100318133658.80a15736.akpm@linux-foundation.org>
In-Reply-To: <5057.1268124370@localhost>
References: <5057.1268124370@localhost>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 09 Mar 2010 03:46:10 -0500
Valdis.Kletnieks@vt.edu wrote:

> Seen in my dmesg.  Appears to have started in 2.6.33-rc7-mmotm0210, I can't
> remember if I reported it before or not...
> 
> [    0.212297] ACPI: Using IOAPIC for interrupt routing
> [    0.340075] 
> [    0.340076] =============================================
> [    0.340241] [ INFO: possible recursive locking detected ]
> [    0.340330] 2.6.33-mmotm0304 #5
> [    0.340415] ---------------------------------------------
> [    0.340504] swapper/1 is trying to acquire lock:
> [    0.340591]  (&dev->mutex){+.+...}, at: [<ffffffff812fddfd>] __driver_attach+0x47/0x80
> [    0.340926] 
> [    0.340927] but task is already holding lock:
> [    0.340999]  (&dev->mutex){+.+...}, at: [<ffffffff812fddef>] __driver_attach+0x39/0x80
> [    0.340999] 
> [    0.340999] other info that might help us debug this:
> [    0.340999] 1 lock held by swapper/1:
> [    0.340999]  #0:  (&dev->mutex){+.+...}, at: [<ffffffff812fddef>] __driver_attach+0x39/0x80
> [    0.340999] 
> [    0.340999] stack backtrace:
> [    0.340999] Pid: 1, comm: swapper Not tainted 2.6.33-mmotm0304 #5
> [    0.340999] Call Trace:
> [    0.340999]  [<ffffffff810645e7>] __lock_acquire+0xc74/0xceb
> [    0.340999]  [<ffffffff81062a4f>] ? mark_lock+0x2d/0x22c
> [    0.340999]  [<ffffffff812fddfd>] ? __driver_attach+0x47/0x80
> [    0.340999]  [<ffffffff81064753>] lock_acquire+0xf5/0x112
> [    0.340999]  [<ffffffff812fddfd>] ? __driver_attach+0x47/0x80
> [    0.340999]  [<ffffffff81062ca0>] ? mark_held_locks+0x52/0x70
> [    0.340999]  [<ffffffff81581bb5>] __mutex_lock_common+0x5c/0x5aa
> [    0.340999]  [<ffffffff812fddfd>] ? __driver_attach+0x47/0x80
> [    0.340999]  [<ffffffff81571004>] ? klist_next+0x24/0xd7
> [    0.340999]  [<ffffffff812fddfd>] ? __driver_attach+0x47/0x80
> [    0.340999]  [<ffffffff812fddb6>] ? __driver_attach+0x0/0x80
> [    0.340999]  [<ffffffff815821a9>] mutex_lock_nested+0x34/0x39
> [    0.340999]  [<ffffffff812fddfd>] __driver_attach+0x47/0x80
> [    0.340999]  [<ffffffff812fddb6>] ? __driver_attach+0x0/0x80
> [    0.340999]  [<ffffffff812fddb6>] ? __driver_attach+0x0/0x80
> [    0.340999]  [<ffffffff812fd31f>] bus_for_each_dev+0x54/0x89
> [    0.340999]  [<ffffffff812fdb66>] driver_attach+0x19/0x1b
> [    0.340999]  [<ffffffff812fd7b1>] bus_add_driver+0xb4/0x203
> [    0.340999]  [<ffffffff812fe10f>] driver_register+0xb8/0x129
> [    0.340999]  [<ffffffff8123af12>] acpi_bus_register_driver+0x3e/0x40
> [    0.340999]  [<ffffffff81b4aaa4>] acpi_ec_init+0x37/0x55
> [    0.340999]  [<ffffffff81b4a920>] acpi_init+0x101/0x116
> [    0.340999]  [<ffffffff81b4a81f>] ? acpi_init+0x0/0x116
> [    0.340999]  [<ffffffff810001ef>] do_one_initcall+0x59/0x14e
> [    0.340999]  [<ffffffff81b2c687>] kernel_init+0x14d/0x1d7
> [    0.340999]  [<ffffffff810033d4>] kernel_thread_helper+0x4/0x10
> [    0.340999]  [<ffffffff81584040>] ? restore_args+0x0/0x30
> [    0.340999]  [<ffffffff81b2c53a>] ? kernel_init+0x0/0x1d7
> [    0.340999]  [<ffffffff810033d0>] ? kernel_thread_helper+0x0/0x10
> [    0.341046] ACPI: EC: GPE = 0x11, I/O: command/status = 0x934, data = 0x930
> 

<looks at mainline's 8e9394ce2412254ec69fd2a4f3e44a66eade2297>

    In the future, we are going to be changing the lock type for struct
    device (once we get the lockdep infrastructure properly worked out)

<looks at linux-next's "drivers/base: Convert dev->sem to mutex">

Seems that the latter patch (from Greg and Thomas) went and did the
mutex conversion before "we got the lockdep infrastructure properly
worked out".

