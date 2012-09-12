Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760974Ab2ILSBb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 14:01:31 -0400
Received: from kaini.schwarzvogel.de ([178.63.25.207]:46167 "EHLO
	mail.schwarzvogel.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525Ab2ILSB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 14:01:27 -0400
Date: Wed, 12 Sep 2012 20:01:25 +0200
From: Tobias Klausmann <klausman@schwarzvogel.de>
To: LKML <linux-kernel@vger.kernel.org>, alpha <linux-alpha@vger.kernel.org>
Subject: Re: [PATCH 00/11] rcu: Add missing RCU idle APIs on idle loop v2
Message-ID: <20120912180125.GA32692@kaini.schwarzvogel.de>
Mail-Followup-To: LKML <linux-kernel@vger.kernel.org>,
	alpha <linux-alpha@vger.kernel.org>
References: <1345733915-20040-1-git-send-email-fweisbec@gmail.com>
 <20120824212647.GU2472@linux.vnet.ibm.com>
 <1345857554.4840.43.camel@deadeye.wl.decadent.org.uk>
 <20120825035047.GB3436@linux.vnet.ibm.com>
 <20120825131647.GA1994@somewhere>
 <20120825161806.GD3436@linux.vnet.ibm.com>
 <5039406F.9040604@orcon.net.nz>
 <20120826001233.GH3436@linux.vnet.ibm.com>
 <20120826092137.GA50543@kaini.schwarzvogel.de>
 <20120910215244.GD21277@somewhere.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120910215244.GD21277@somewhere.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi! 

On Mon, 10 Sep 2012, Frederic Weisbecker wrote:
> > AFAICT, schedule_preempt_disabled() was only introduced in 3.4
> > and thus needs to be backported for 3.3.
> 
> Please try with this instead:
> 
> 	preempt_enable_no_resched();
> 	schedule();
> 	preempt_disable();
> 
> Thanks.

While it does compile, it hits the usual Alpha snag (3.3 onwards)
on boot:

PCI host bridge to bus 0000:00
pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
pci_bus 0000:00: root bus resource [mem 0x00000000-0xffffffffffffffff]
pci 0000:00:11.0: quirk: [io  0x4000-0x403f] claimed by ali7101 ACPI
pci 0000:00:11.0: quirk: [io  0x5000-0x501f] claimed by ali7101 SMB
Unable to handle kernel paging request at virtual address 0000000000000000
swapper(1): Oops 1
pc = [<fffffc00008667bc>]  ra = [<fffffc0000866794>]  ps = 0000    Not tainted
pc is at nautilus_init_pci+0xd4/0x218
ra is at nautilus_init_pci+0xac/0x218
v0 = 0000000000000001  t0 = 0000000000000000  t1 = 000000000000ffff
t2 = 00000000ffffffff  t3 = fffffc0000896810  t4 = 0000000001000000
t5 = 0000000000080000  t6 = 000000000fffffff  t7 = fffffc00bf890000
s0 = fffffc00bf8b4800  s1 = 0000000000ffffff  s2 = 000000000007fffa
s3 = 0000000000000000  s4 = 0000000000000000  s5 = 0000000000002ab5
s6 = 5800000000000701
a0 = fffffc0000896b88  a1 = 0000000000000000  a2 = 0000000000000000
a3 = 000000000e000000  a4 = 0000000002000000  a5 = 0000000000000001
t8 = 0000000000000000  t9 = 0000000000000000  t10= 0000000000000001
t11= 0000000000000000  pv = fffffc000032bdc0  at = 000000000d0e4600
gp = fffffc00008e34a8  sp = fffffc00bf893e28
Disabling lock debugging due to kernel taint
Trace:
[<fffffc0000310088>] do_one_initcall+0x38/0x200
[<fffffc0000311338>] kernel_thread+0x28/0x90

This is not an RCU problem, though. AFAICT.

I tried the patches with 3.2.28 (the latest vanilla kernel that
works on this machine _at all_) but those don't have an RCU
implementation and thus, the compile fails:

  CC      arch/alpha/kernel/process.o
arch/alpha/kernel/process.c: In function 'cpu_idle':
arch/alpha/kernel/process.c:59: error: implicit declaration of function 'rcu_idle_enter'
arch/alpha/kernel/process.c:63: error: implicit declaration of function 'rcu_idle_exit'
make[1]: *** [arch/alpha/kernel/process.o] Error 1
make: *** [arch/alpha/kernel] Error 2


Regards,
Tobias
