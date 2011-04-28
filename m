Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757117Ab1D1Ifc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 04:35:32 -0400
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:56638 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755707Ab1D1If2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 04:35:28 -0400
Date: Thu, 28 Apr 2011 10:35:25 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [BUG 2.6.38] unlocked spinlock detected in hrtimer code
Message-ID: <20110428083525.GB2431@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

while performing excessive cpu hotplug tests within a guest where the host was
completly overloaded (opening all possible race windows) I got this one:

Apr 27 14:11:33 h0529m4 kernel: BUG: spinlock already unlocked on CPU#0, kworker/4:2/43553
Apr 27 14:11:33 h0529m4 kernel: lock: 0000000088325f00, .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
Apr 27 14:11:33 h0529m4 kernel: CPU: 0 Not tainted 2.6.38 #16
Apr 27 14:11:33 h0529m4 kernel: Process kworker/4:2 (pid: 43553, task: 000000007ca18838, ksp: 00000000669dfc48)
Apr 27 14:11:33 h0529m4 kernel: 0000000000000000 00000000669dfca0 0000000000000002 0000000000000000 
Apr 27 14:11:33 h0529m4 kernel:       00000000669dfd40 00000000669dfcb8 00000000669dfcb8 00000000005275c6 
Apr 27 14:11:33 h0529m4 kernel:       0000000000000000 0000000000000000 0000000000000000 000000000000000b 
Apr 27 14:11:33 h0529m4 kernel:       000000000000000c 00000000669dfd00 0000000000000000 0000000000000000 
Apr 27 14:11:33 h0529m4 kernel:       0000000000565740 00000000001008f0 00000000669dfca0 00000000669dfce8 
Apr 27 14:11:33 h0529m4 kernel: Call Trace:
Apr 27 14:11:33 h0529m4 kernel: ([<00000000001007f6>] show_trace+0xee/0x144)
Apr 27 14:11:33 h0529m4 kernel: [<0000000000348632>] do_raw_spin_unlock+0xbe/0xc4
Apr 27 14:11:33 h0529m4 kernel: [<0000000000530c2c>] _raw_spin_unlock_irqrestore+0x40/0xa4
Apr 27 14:11:33 h0529m4 kernel: [<00000000001722aa>] hrtimer_try_to_cancel+0x62/0xe0
Apr 27 14:11:33 h0529m4 kernel: [<0000000000172352>] hrtimer_cancel+0x2a/0x58
Apr 27 14:11:33 h0529m4 kernel: [<000000000014f50a>] do_exit+0x5ca/0x7d4
Apr 27 14:11:33 h0529m4 kernel: [<000000000016d3c4>] kthread+0x9c/0xac
Apr 27 14:11:33 h0529m4 kernel: [<000000000053166a>] kernel_thread_starter+0x6/0xc
Apr 27 14:11:33 h0529m4 kernel: [<0000000000531664>] kernel_thread_starter+0x0/0xc
Apr 27 14:11:33 h0529m4 kernel: INFO: lockdep is turned off.

I didn't look any further into it and it doesn't look like it is reproducible.
