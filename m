Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610Ab1HKUYp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 16:24:45 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:34604 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440Ab1HKUYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 16:24:44 -0400
From: Daniel Lezcano <daniel.lezcano@free.fr>
To: akpm@linux-foundation.org
Cc: oleg@tv-sign.ru, bonbons@linux-vserver.org,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        serge@hallyn.com
Subject: [PATCH 0/2] Send a SIGCHLD to the init's pid namespace parent when reboot
Date: Thu, 11 Aug 2011 22:23:59 +0200
Message-Id: <1313094241-3674-1-git-send-email-daniel.lezcano@free.fr>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Lezcano <dlezcano@fr.ibm.com>

In the case of a VPS, when we shutdown/halt/reboot the container, the
reboot utility will invoke the sys_reboot syscall which has the bad
effect to reboot the host. The way to fix that is to drop the
CAP_SYS_REBOOT capability in the container.

In this case, the container shutdowns correctly but, at the end, the
init process is waiting indefinitely and we have the containers stuck
with one process (the init process).

In order to fix that, we used a hypervisor process, parent of the
container's init process, watching for the container's utmp file and
detecting when the runlevel changes. When this runlevel change is
detected we wait for the container to have one process left and then we
kill the container's init.

That works well if we modify the distro configuration files, we make
/var/run to not be a tmpfs and we remove all the files inside this
directory when the container boots. *But* as soon as we upgrade the
container distro, all the tweaks are lost. So this method works but at
the cost of tweaking the containers configuration files again and again,
each time there is an update, which is not tolerable in a production
environment.

This patchset solves the problem by send a SIGCHLD signal to the process
parent of the init process of the child pid namespace. By this way, we know
when a pid namespace wanted to reboot/halt/shutdown and we can take advantage
of that to kill, restart or suspend the container.

Daniel Lezcano (2):
  add SA_CLDREBOOT flag
  Notify container-init parent a 'reboot' occured

 arch/alpha/include/asm/signal.h   |    2 +
 arch/arm/include/asm/signal.h     |    2 +
 arch/avr32/include/asm/signal.h   |    2 +
 arch/cris/include/asm/signal.h    |    2 +
 arch/h8300/include/asm/signal.h   |    2 +
 arch/ia64/include/asm/signal.h    |    2 +
 arch/m32r/include/asm/signal.h    |    2 +
 arch/m68k/include/asm/signal.h    |    2 +
 arch/mips/include/asm/signal.h    |    2 +
 arch/mn10300/include/asm/signal.h |    2 +
 arch/parisc/include/asm/signal.h  |    2 +
 arch/powerpc/include/asm/signal.h |    2 +
 arch/s390/include/asm/signal.h    |    2 +
 arch/sparc/include/asm/signal.h   |    2 +-
 arch/x86/include/asm/signal.h     |    2 +
 arch/xtensa/include/asm/signal.h  |    2 +
 include/asm-generic/siginfo.h     |    3 +-
 include/asm-generic/signal.h      |    2 +
 include/linux/sched.h             |    1 +
 kernel/signal.c                   |   40 +++++++++++++++++++++++++++++++++++++
 kernel/sys.c                      |   20 ++++++++++++++++-
 21 files changed, 94 insertions(+), 4 deletions(-)

-- 
1.7.4.1

