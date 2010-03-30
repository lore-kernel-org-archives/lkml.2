Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036Ab0C3U55 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 16:57:57 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:52413 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756220Ab0C3U5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 16:57:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@suse.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>, Arnd Bergmann <arnd@arndb.de>
Subject: [RFC 0/9] BKL conversion in TTY drivers
Date: Tue, 30 Mar 2010 22:56:11 +0200
Message-Id: <1269982580-9361-1-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.0
X-Provags-ID: V01U2FsdGVkX19ia+sJtSv9vQ7Z1lhypzJx9WZRlTonsp5lMpB
 cZxR7lcnSbzd+knRvEK5aULuYXCh5Sx2BhNvezuS0rag/0gln2
 FkzzKJvHq6mvSGuLbBSkQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is one of the tricker bits in the BKL removal series,
so let's discuss it here. In order to build a kernel without
the BKL, it's obviously necessary to do something about
the TTY code. This series introduces a new Big TTY Mutex
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
while the final patch adds the real mutex implementation
as an experimental configuration option.

When that option is disabled, the behaviour should be
basically unchanged regarding serialization against
other subsystems using the BKL.

Together with the patches removing the BKL from block,
procfs, init, usb and VFS, it then becomes realistic to
build a kernel that does not contain the BKL at all,
while disabling all code that still uses it.
This means we are still safe, because there is no code
left that the new BTM fails to serialize with.

This smaller series is taken from my bkl-removal tree,
ported to 2.6.34-rc3 and with the last patch changed to
make the new implementation optional.

	Arnd 
---

Arnd Bergmann (9):
  tty: replace BKL with a new tty_lock
  tty: make atomic_write_lock release tty_lock
  tty: make tty_port->mutex nest under tty_lock
  tty: make termios mutex nest under tty_lock
  tty: make ldisc_mutex nest under tty_lock
  tty: never hold tty_lock() while getting tty_mutex
  ppp: use big tty mutex
  tty: release tty lock when blocking
  tty: implement BTM as mutex instead of BKL

 drivers/char/Makefile           |    1 +
 drivers/char/amiserial.c        |   16 ++--
 drivers/char/briq_panel.c       |    6 +-
 drivers/char/cyclades.c         |   20 ++--
 drivers/char/epca.c             |    4 +-
 drivers/char/isicom.c           |   10 +-
 drivers/char/istallion.c        |   20 ++--
 drivers/char/mxser.c            |   10 +-
 drivers/char/n_hdlc.c           |   16 ++--
 drivers/char/n_r3964.c          |   10 +-
 drivers/char/pty.c              |    8 +-
 drivers/char/riscom8.c          |    8 +-
 drivers/char/rocket.c           |    8 +-
 drivers/char/serial167.c        |    4 +-
 drivers/char/specialix.c        |   10 +-
 drivers/char/stallion.c         |   12 ++--
 drivers/char/sx.c               |   12 ++--
 drivers/char/synclink.c         |   10 ++-
 drivers/char/synclink_gt.c      |    8 +-
 drivers/char/synclinkmp.c       |   12 ++--
 drivers/char/tty_buffer.c       |    2 +-
 drivers/char/tty_io.c           |  123 ++++++++++++++-----------
 drivers/char/tty_ioctl.c        |   36 ++++----
 drivers/char/tty_ldisc.c        |   53 +++++++-----
 drivers/char/tty_port.c         |    6 +-
 drivers/char/vc_screen.c        |    4 +-
 drivers/char/vt.c               |    4 +-
 drivers/char/vt_ioctl.c         |   12 ++--
 drivers/isdn/i4l/isdn_common.c  |   20 ++--
 drivers/isdn/i4l/isdn_tty.c     |    8 +-
 drivers/net/irda/irtty-sir.c    |    5 +-
 drivers/net/ppp_generic.c       |   29 +++---
 drivers/serial/68360serial.c    |    4 +-
 drivers/serial/crisv10.c        |    8 +-
 drivers/serial/serial_core.c    |   42 +++++-----
 drivers/staging/strip/strip.c   |    2 +-
 drivers/usb/class/cdc-acm.c     |    2 +-
 drivers/usb/serial/usb-serial.c |   18 ++--
 drivers/video/console/vgacon.c  |    4 +-
 include/linux/init_task.h       |    1 +
 include/linux/sched.h           |    1 +
 include/linux/tty.h             |  188 +++++++++++++++++++++++++++++++++++++++
 kernel/fork.c                   |    1 +
 lib/Kconfig.debug               |   10 ++
 44 files changed, 510 insertions(+), 278 deletions(-)

