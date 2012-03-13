Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759211Ab2CMFmn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 01:42:43 -0400
Received: from mail-ey0-f202.google.com ([209.85.215.202]:40802 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757840Ab2CMFml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 01:42:41 -0400
From: Avery Pennarun <apenwarr@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, "David S. Miller" <davem@davemloft.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Fabio M. Di Nitto" <fdinitto@redhat.com>,
        Avery Pennarun <apenwarr@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Olaf Hering <olaf@aepfle.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Tejun Heo <tj@kernel.org>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Yinghai LU <yinghai@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH 0/5] Persist printk buffer across reboots.
Date: Tue, 13 Mar 2012 01:36:36 -0400
Message-Id: <1331617001-20906-1-git-send-email-apenwarr@gmail.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The last patch in this series implements a new CONFIG_PRINTK_PERSIST option
that, when enabled, puts the printk buffer in a well-defined memory location
so that we can keep appending to it after a reboot.  The upshot is that,
even after a kernel panic or non-panic hard lockup, on the next boot
userspace will be able to grab the kernel messages leading up to it.  It
could then upload the messages to a server (for example) to keep crash
statistics.

The preceding patches in the series are mostly just things I fixed up while
working on that patch.

Some notes:

- I'm not totally sure of the locking or portability issues when calling
  memblock or bootmem.  This all happens really early, and I *think*
  interrupts are still disabled at that time, so it's probably okay.

- Tested this version on x86 (kvm) and it works with soft reboot (ie. reboot
  -f).  Since some BIOSes wipe the memory during boot, you might not have
  any luck.  It should be great on many embedded systems, though, including
  the MIPS system I've tested a variant of this patch on.  (Our MIPS build
  is based on a slightly older kernel so it's not 100% the same, but I think
  this should behave identically.)
  
- The way we choose a well-defined memory location is slightly suspicious
  (we just count down from the top of the address space) but I've tested it
  pretty carefully, and it seems to be okay.

- In printk.c with CONFIG_PRINTK_PERSIST set, we're #defining words like
  log_end.  It might be cleaner to replace all instances of log_end with
  LOG_END to make this more clear.  This is also the reason the struct
  logbits members start with _: because otherwise they conflict with the
  macro.  Suggestions welcome.

Patch generated against v3.3-rc7.

Avery Pennarun (5):
  mm: bootmem: BUG() if you try to allocate bootmem too late.
  mm: bootmem: it's okay to reserve_bootmem an invalid address.
  mm: nobootmem: implement reserve_bootmem() in terms of memblock.
  printk: use alloc_bootmem() instead of memblock_alloc().
  printk: CONFIG_PRINTK_PERSIST: persist printk buffer across reboots.

 init/Kconfig    |   12 ++++++
 kernel/printk.c |  117 +++++++++++++++++++++++++++++++++++++++++++++---------
 mm/bootmem.c    |   10 ++++-
 mm/nobootmem.c  |   23 +++++++++++
 4 files changed, 140 insertions(+), 22 deletions(-)

-- 
1.7.7.3

