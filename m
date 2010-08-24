Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489Ab0HXJBu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 05:01:50 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55086
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752220Ab0HXJBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 05:01:49 -0400
Date: Tue, 24 Aug 2010 02:02:07 -0700 (PDT)
Message-Id: <20100824.020207.71104293.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A few sparc64 bug fixes and proper 64-bit rwsem support as you
suggested.

1) Fetching large device properties from openfirmware spams all
   over the kernel data section, based upon a report by Meelis
   Roos.  The fix is to just use the caller's buffers directly
   instead of this unnecessary 3k bounce buffer business.

2) The atomic64_t interface 'long' cases I missed.

3) Lock loop backoff didn't really NOP out correctly on UP.

4) Perf control register writes would write the register
   twice by mistake due to a missing delay slot nop.  Fix
   from Mikulas Patocka.

Please pull, thanks a lot!

The following changes since commit d1b113bb028999e82a8528e1484be8c23fb5a7d9:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6 (2010-08-23 18:30:30 -0700)

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

David S. Miller (4):
      sparc64: Really fix atomic64_t interface types.
      sparc64: Make rwsems 64-bit.
      sparc64: Make lock backoff really a NOP on UP builds.
      sparc64: Get rid of indirect p1275 PROM call buffer.

Mikulas Patocka (2):
      sparc64: simple microoptimizations for atomic functions
      sparc64: Fill a missing delay slot.

 arch/sparc/include/asm/atomic_64.h   |    8 +-
 arch/sparc/include/asm/backoff.h     |   11 +-
 arch/sparc/include/asm/oplib_64.h    |   27 +---
 arch/sparc/include/asm/rwsem-const.h |   12 --
 arch/sparc/include/asm/rwsem.h       |  120 +++++++++++--
 arch/sparc/include/asm/system_64.h   |    1 +
 arch/sparc/lib/Makefile              |    2 +-
 arch/sparc/lib/atomic_64.S           |   36 ++---
 arch/sparc/lib/bitops.S              |   12 +-
 arch/sparc/lib/rwsem_64.S            |  163 ------------------
 arch/sparc/prom/cif.S                |   16 +-
 arch/sparc/prom/console_64.c         |   48 ++++--
 arch/sparc/prom/devops_64.c          |   36 ++++-
 arch/sparc/prom/misc_64.c            |  314 ++++++++++++++++++++++++----------
 arch/sparc/prom/p1275.c              |  102 +-----------
 arch/sparc/prom/tree_64.c            |  210 +++++++++++++++++------
 16 files changed, 595 insertions(+), 523 deletions(-)
 delete mode 100644 arch/sparc/include/asm/rwsem-const.h
 delete mode 100644 arch/sparc/lib/rwsem_64.S
