Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022Ab2ISXnR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 19:43:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46893 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883Ab2ISXnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 19:43:14 -0400
Date: Wed, 19 Sep 2012 16:40:06 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Wessel <jason.wessel@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>
Cc: Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        Colin Cross <ccross@android.com>, Brian Swetland <swetland@google.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com,
        kgdb-bugreport@lists.sourceforge.net, linux-serial@vger.kernel.org
Subject: [PATCH v8 0/11] KGDB/KDB FIQ (NMI) debugger
Message-ID: <20120919234003.GA24143@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

In v8, addressed Jason's comments:

- Changed kgdb_enable_nmi() weak function to kgdb_arch callbck;
- We no longer register disable_nmi command if arch does not register
  KGDB NMI handling (i.e. not filling kgdb_arch.enable_nmi callback);
- The same is for ttyNMI: if architecure does not provide us with
  enable_nmi call, we don't need the tty device. Of course, there is no
  way to tell wether a specific serial device can be used for NMI
  debugging, as it is not serial-device specific, but specific to
  whether IRQ can be rerouted to an NMI (for most our cases, pretty
  much every IRQ can be rerouted, e.g. a hot-pluggable serial device on
  a PCI bus).
- Rebased on the latest and greatest tty-next, just in case.

These patches can be found in the following repo (based on tty-next):

	git://git.infradead.org/users/cbou/linux-nmi-kdb.git master

Old changelogs and rationale for these patches can be found here:

	v1-v5, rationale: http://lkml.org/lkml/2012/9/10/2
	v6: http://lkml.org/lkml/2012/9/10/2
	v7: http://lkml.org/lkml/2012/9/13/367

Thanks,

--
 arch/arm/Kconfig                    |  19 ++
 arch/arm/common/vic.c               |  28 +++
 arch/arm/include/asm/hardware/vic.h |   2 +
 arch/arm/include/asm/kgdb.h         |   8 +
 arch/arm/kernel/Makefile            |   1 +
 arch/arm/kernel/entry-armv.S        | 167 +------------
 arch/arm/kernel/entry-header.S      | 170 +++++++++++++
 arch/arm/kernel/kgdb_fiq.c          | 124 +++++++++
 arch/arm/kernel/kgdb_fiq_entry.S    |  87 +++++++
 arch/arm/mach-versatile/Makefile    |   1 +
 arch/arm/mach-versatile/kgdb_fiq.c  |  31 +++
 drivers/tty/serial/Kconfig          |  19 ++
 drivers/tty/serial/Makefile         |   1 +
 drivers/tty/serial/amba-pl011.c     |  73 +++++-
 drivers/tty/serial/kgdb_nmi.c       | 402 ++++++++++++++++++++++++++++++
 drivers/tty/serial/kgdboc.c         |   9 +
 drivers/tty/serial/serial_core.c    |  17 ++
 include/linux/kdb.h                 |  29 ++-
 include/linux/kgdb.h                |  13 +
 include/linux/serial_core.h         |   1 +
 kernel/debug/debug_core.c           |  14 +-
 kernel/debug/kdb/kdb_main.c         |  31 +++
 22 files changed, 1054 insertions(+), 193 deletions(-)
