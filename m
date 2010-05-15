Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703Ab0EOVBz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 17:01:55 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:60069 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744Ab0EOVAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 17:00:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg KH <gregkh@suse.de>, Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH v3 00/10] BKL conversion in tty layer
Date: Sat, 15 May 2010 22:59:46 +0200
Message-Id: <1273957196-13768-1-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.0.4
X-Provags-ID: V01U2FsdGVkX1+Tvugpw6K0ObyZg/NeWGRE6SAWuGHP3mvH/F+
 cRvEZLYME9cFLcDOgtBC6cwcNEzw5XJk/gOkyXZJryyJOmRVSU
 CCCUBruWrvBlamOdDqGCw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the third attempt to get the BKL out of the
TTY code. This version goes much further than the
previous one, and eliminates most of the code I
had introduced there.
 
What remains of the series are changes to the existing
BKL usage in the TTY layer to avoid depending on
the autorelease-during-sleep or the recursive
behavior. The final patch simply adds the option
to replace the BKL with a plain mutex.

The series is available as a git tree in the bkl/tty branch of
git://git.kernel.org/pub/scm/linux/kernel/git/arnd/playground.git
There is also a bkl/tty-history branch with a much
more detailed series that I used to get to this point.
Both series are bisectable.

Arnd Bergmann (10):
  tty: replace BKL with a new tty_lock
  tty: never hold BTM while getting tty_mutex
  tty: fix console_sem lock order
  cdc-acm: remove dead code
  tty: introduce wait_event_interruptible_tty
  tty: annotate tty_write_lock
  tty: reorder ldisc locking
  tty: untangle locking of wait_until_sent
  tty: remove tty_lock_nested
  tty: implement BTM as mutex instead of BKL

 drivers/char/Makefile          |    1 +
 drivers/char/amiserial.c       |   23 ++++--
 drivers/char/briq_panel.c      |    6 +-
 drivers/char/cyclades.c        |    2 +-
 drivers/char/istallion.c       |   12 ++-
 drivers/char/n_hdlc.c          |   16 ++--
 drivers/char/n_r3964.c         |   10 ++--
 drivers/char/pty.c             |   24 +++----
 drivers/char/selection.c       |   13 +++-
 drivers/char/serial167.c       |    4 +-
 drivers/char/stallion.c        |    2 +
 drivers/char/sx.c              |   12 ++--
 drivers/char/tty_io.c          |  138 ++++++++++++++++++++++-----------------
 drivers/char/tty_ldisc.c       |   43 +++++++++----
 drivers/char/tty_mutex.c       |   47 ++++++++++++++
 drivers/char/tty_port.c        |    2 +-
 drivers/char/vc_screen.c       |    4 +-
 drivers/char/vt_ioctl.c        |   12 ++--
 drivers/serial/68360serial.c   |    2 -
 drivers/serial/crisv10.c       |    6 +-
 drivers/serial/serial_core.c   |   39 ++++++++----
 drivers/usb/class/cdc-acm.c    |   12 +---
 drivers/video/console/vgacon.c |    2 -
 include/linux/tty.h            |   64 ++++++++++++++++++
 lib/Kconfig.debug              |   10 +++
 25 files changed, 338 insertions(+), 168 deletions(-)
 create mode 100644 drivers/char/tty_mutex.c

