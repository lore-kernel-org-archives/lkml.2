Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757695Ab0ESBou (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 21:44:50 -0400
Received: from mail.windriver.com ([147.11.1.11]:41197 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756764Ab0ESBkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 21:40:17 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net
Subject: [GIT PULL] kdb / early debug (2 of 2) for 2.6.35
Date: Tue, 18 May 2010 20:39:55 -0500
Message-Id: <1274233202-3734-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
X-OriginalArrivalTime: 19 May 2010 01:40:05.0407 (UTC) FILETIME=[34EFE2F0:01CAF6F4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus please pull the dbg-early-merge tree which merges in the
capability for early debugging for the x86 architecture.

git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git dbg-early-merge

--- Notes for Linus ---

I did not receive acks or feedback from any x86 maintainers at this
point for the early trap changes.  These changes came from the
archives from 2+ years back, before the time the mainline kernel I/O
drivers supported early debugger access.

I did not receive acks or feedback on the changes to
arch/x86/kernel/cpu/common.c which covers the initial setup of the
debug registers.  This change is a fix vs a feature.

--- End Notes for Linus ---

There have been zero changes to this patch set vs the pull request
from 2.6.34.

This patch set stacks on top of the kgdb / kdb patches and focuses on
allowing the kernel debugger to activate at the same time earlyprintk
becomes available.  Right now early debugging is only available on
x86, but the API in the debug core is generic.  The only thing lacking
for other architecture support is appropriate atomic safe polled I/O
drivers.

The first few patches address the problems in kdb and the architecture
specific x86 kgdb implementation which rely on services which are not
available before the kernel memory allocators are setup.

The patch set includes early debug support for vga + non-USB keyboard
and dbgp devices.  For the vga case, it only works with kdb. For
example, you could boot your kernel and optionally include kgdbwait as
follows:

     earlyprintk=vga ekgboc=kbd kgdbwait

That will stop the kernel somewhere inside setup_arch() and you can
plant breakpoints, modify memory and backtrace.  If you omit the
kgdbwait, the kgdb shell prompt will appear on the vga console only if
there is a kernel fault.

The final 2 patches in the series add support for the EHCI usb debug
port when using a dbgp device.  You have the choice of using
earlyprintk= or using only the kernel debugger on the debug port.  You
can also use either kgdb or kdb with this connection.  Here are two
example kernel boot argument lines:

1) Used in conjunction with earlyprintk on usb debug port 1

   	earlyprintk=dbgp1,keep kgdbdbgp=1 kgdbwait

2) Allow for the capability to break into the kernel with control-c on
   usb debug port 0

        kgdbdbp=0,1 kgdbwait

A patch to add formal documentation to the kgdb docbook for these new
features will be available for the 2.6.34 cycle, because there are a
number of other ways you can make use of these features not described
here.

Thanks,
Jason.

---

The following changes since commit f862c96b15ebc65a94c9c747449ddb07008037ac:
  Jason Wessel (1):
        kdb,debug_core: Allow the debug core to receive a panic notification

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git dbg-early-merge

Jan Kiszka (1):
      x86, kgdb: early trap init for early debug

Jason Wessel (6):
      x86, kgdb, init: Add early and late debug states
      x86,kgdb: Implement early hardware breakpoint debugging
      x86,early dr regs,kgdb: Allow kernel debugger early dr register access
      kgdboc: Add ekgdboc for early use of the kernel debugger
      earlyprintk,vga,kdb: Fix \b and \r for earlyprintk=vga with kdb
      echi-dbgp: Add kernel debugger support for the usb debug port

 Documentation/kernel-parameters.txt |   17 +++++
 arch/x86/include/asm/processor.h    |    2 +
 arch/x86/kernel/cpu/common.c        |   29 +++++----
 arch/x86/kernel/early_printk.c      |    8 +++
 arch/x86/kernel/kgdb.c              |   47 +++++++++++---
 arch/x86/kernel/setup.c             |    1 +
 arch/x86/kernel/traps.c             |   14 +++-
 drivers/serial/kgdboc.c             |   19 ++++++
 drivers/usb/early/ehci-dbgp.c       |  120 ++++++++++++++++++++++++++++++++---
 include/linux/kgdb.h                |   14 ++++
 init/main.c                         |    4 +-
 kernel/debug/debug_core.c           |   16 +++++
 12 files changed, 255 insertions(+), 36 deletions(-)
