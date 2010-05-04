Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934510Ab0EDWfA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 18:35:00 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:55106 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934482Ab0EDWex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 18:34:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg KH <gregkh@suse.de>, Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH v2 00/13] BKL conversion in tty layer
Date: Wed,  5 May 2010 00:33:39 +0200
Message-Id: <1273012433-6125-1-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.0.4
X-Provags-ID: V01U2FsdGVkX18x/nmBSd1uOWiqh6gmmCF9MvGVlFY7EHXOoTH
 KU6TIYFa5CmaWgzceL+fmF9+veOm33heHrPn/Hx6i1C1ZDiD+c
 ryrPip7goVfDwS1G9vCGg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the second attempt to get the BKL out of the
TTY code. I've updated the patches to be based on top
of Alan's series and improved a number of things.

This series still introduces a new Big TTY Mutex
that is based on the earlier implementation of the
Big Kernel Semaphore, but comes with a number of changes:

 - based on the mutex code instead of a semaphore,
   so we can use all the mutex debugging.
 - no autorelease on sleep, which is what most of the
   series is about.
 - limited to one subsystem only.
 - ability to annotate nested locking so we can eventually
   turn it into a non-recursive mutex, once all the
   recursive users stay around.

The first eight patches convert all the code using the BKL
in the TTY layer and related drivers to the new interface,
and patch 9/13 then adds the real mutex implementation
as an experimental configuration option.

When that option is disabled, the behaviour should be
basically unchanged regarding serialization against
other subsystems using the BKL.

The final four patches are new and do some real
cleanup, intended to improve the TTY locking
towards moving the BTM out. These are not required
for the big picture of the BKL removal, nothing
else depends on this. I'd still like to hear
from Alan if he thinks this part is useful for
his work on the problem or if we should just leave
it out.

Arnd Bergmann (13):
  tty: replace BKL with a new tty_lock
  tty: make atomic_write_lock release tty_lock
  tty: make tty_port->mutex nest under tty_lock
  tty: make termios mutex nest under tty_lock
  tty: make ldisc_mutex nest under tty_lock
  tty: never hold BTM while getting tty_mutex
  tty: give up BTM in acquire_console_sem
  tty: release tty lock when blocking
  tty: implement BTM as mutex instead of BKL
  tty: untangle locking of wait_until_sent
  tty: remove tty_lock_nested
  tty: remove release_tty_lock/reacquire_tty_lock
  tty: turn ldisc_mutex into a regular mutex

 drivers/char/Makefile           |    1 +
 drivers/char/amiserial.c        |   18 +++---
 drivers/char/briq_panel.c       |    6 +-
 drivers/char/cyclades.c         |    4 +-
 drivers/char/generic_serial.c   |    2 +-
 drivers/char/hvc_console.c      |    2 +-
 drivers/char/hvcs.c             |    2 +-
 drivers/char/ip2/ip2main.c      |   20 +++++-
 drivers/char/isicom.c           |    4 +-
 drivers/char/istallion.c        |   16 +++--
 drivers/char/moxa.c             |    6 +-
 drivers/char/mxser.c            |   10 ++--
 drivers/char/n_hdlc.c           |   16 ++--
 drivers/char/n_r3964.c          |   10 ++--
 drivers/char/pty.c              |   26 +++----
 drivers/char/riscom8.c          |    4 +-
 drivers/char/rocket.c           |    6 +-
 drivers/char/selection.c        |    4 +-
 drivers/char/serial167.c        |   10 ++--
 drivers/char/specialix.c        |    6 +-
 drivers/char/stallion.c         |   10 ++-
 drivers/char/sx.c               |   12 ++--
 drivers/char/synclink.c         |    8 +-
 drivers/char/synclink_gt.c      |    8 +-
 drivers/char/synclinkmp.c       |   10 ++--
 drivers/char/tty_buffer.c       |    6 ++-
 drivers/char/tty_io.c           |  146 ++++++++++++++++++++++-----------------
 drivers/char/tty_ioctl.c        |   73 ++++++++++++++-----
 drivers/char/tty_ldisc.c        |   56 ++++++++++-----
 drivers/char/tty_mutex.c        |   50 +++++++++++++
 drivers/char/tty_port.c         |    8 +-
 drivers/char/vc_screen.c        |    4 +-
 drivers/char/vt_ioctl.c         |   12 ++--
 drivers/isdn/i4l/isdn_common.c  |   20 +++---
 drivers/isdn/i4l/isdn_tty.c     |   10 ++--
 drivers/mmc/card/sdio_uart.c    |    2 +-
 drivers/net/irda/irtty-sir.c    |    5 +-
 drivers/serial/68328serial.c    |    2 +-
 drivers/serial/68360serial.c    |    5 +-
 drivers/serial/crisv10.c        |   17 +++--
 drivers/serial/pmac_zilog.c     |    4 +-
 drivers/serial/serial_core.c    |   43 +++++------
 drivers/staging/strip/strip.c   |    2 +-
 drivers/usb/class/cdc-acm.c     |    2 +-
 drivers/usb/serial/opticon.c    |    2 +-
 drivers/usb/serial/usb-serial.c |   18 +++---
 drivers/video/console/vgacon.c  |    4 +-
 include/linux/init_task.h       |    1 +
 include/linux/sched.h           |    1 +
 include/linux/tty.h             |  145 ++++++++++++++++++++++++++++++++++++++
 kernel/fork.c                   |    1 +
 kernel/printk.c                 |   14 ++++-
 lib/Kconfig.debug               |   10 +++
 net/irda/ircomm/ircomm_tty.c    |    2 +-
 54 files changed, 599 insertions(+), 287 deletions(-)
 create mode 100644 drivers/char/tty_mutex.c

