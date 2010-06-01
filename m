Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757388Ab0FAUxf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 16:53:35 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:61388 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757338Ab0FAUx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 16:53:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       John Kacur <jkacur@redhat.com>
Subject: [PATCH 00/31] tty: BKL removal
Date: Tue,  1 Jun 2010 22:52:40 +0200
Message-Id: <1275425591-8803-1-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.0.4
X-Provags-ID: V01U2FsdGVkX19wznGEHAH9zwn0fPWhxGe07lhgHf60mmu78P1
 dH0u8/Cw2CHDLsjjzym8KESW+wBfGkyfcQbFdkBcRgGKgn9tcA
 EiHqgwjo8Ik602b6ToVlA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

As promised, here is a resend of the patches from
both Alan and myself, making the BKL optional
in the TTY layer. Please apply to your tty-next
tree.

	Arnd

--

Alan Cox (20):
  stallion: prune lock_kernel calls
  istallion: use bit ops for the board flags
  riscom8: kill use of lock_kernel
  isicom: kill off the BKL
  rocket: kill BKL
  synclink: kill the big kernel lock
  cyclades: Kill off BKL usage
  epca: Kill the big kernel lock
  specialix; Kill the BKL
  synclink: reworking locking a bit
  tty: serial - fix various misuses/mishandlings of port->tty
  tty: serial - fix tty back references in termios
  tty: serial - fix tty referencing in set_ldisc
  vc: Locking clean up
  tty: Make vt's have a tty_port
  tty: Move the vt_tty field from the vc_data into the standard
    tty_port
  serial: Change the wait for carrier locking
  serial: add port helpers
  serial: trim locking on the helpers
  serial: Use block_til_ready helper

Arnd Bergmann (11):
  tty: replace BKL with a new tty_lock
  tty: never hold BTM while getting tty_mutex
  tty: fix console_sem lock order
  cdc-acm: remove dead code
  tty: introduce wait_event_interruptible_tty
  tty: reorder ldisc locking
  tty: untangle locking of wait_until_sent
  tty: remove tty_lock_nested
  tty: implement BTM as mutex instead of BKL
  tty: release BTM while sleeping in block_til_ready
  8250: fix set_ldisc operation

 drivers/char/Makefile          |    1 +
 drivers/char/amiserial.c       |   25 +++-
 drivers/char/briq_panel.c      |    6 +-
 drivers/char/cyclades.c        |   22 ++--
 drivers/char/epca.c            |    4 +-
 drivers/char/ip2/ip2main.c     |    4 +
 drivers/char/isicom.c          |   13 +-
 drivers/char/istallion.c       |   68 ++++++-----
 drivers/char/keyboard.c        |   10 +-
 drivers/char/n_hdlc.c          |   16 +-
 drivers/char/n_r3964.c         |   10 +-
 drivers/char/pty.c             |   26 ++--
 drivers/char/riscom8.c         |   14 +-
 drivers/char/rocket.c          |   28 +++--
 drivers/char/selection.c       |   13 ++-
 drivers/char/serial167.c       |    8 +-
 drivers/char/specialix.c       |   13 +-
 drivers/char/stallion.c        |   20 ++-
 drivers/char/sx.c              |   12 +-
 drivers/char/synclink.c        |   21 ++--
 drivers/char/synclink_gt.c     |   92 +++++++-------
 drivers/char/synclinkmp.c      |   43 +++---
 drivers/char/tty_io.c          |  134 +++++++++++---------
 drivers/char/tty_ldisc.c       |   43 +++++--
 drivers/char/tty_mutex.c       |   47 +++++++
 drivers/char/tty_port.c        |    4 +-
 drivers/char/vc_screen.c       |    4 +-
 drivers/char/vt.c              |   19 ++-
 drivers/char/vt_ioctl.c        |   14 +-
 drivers/serial/21285.c         |   10 +-
 drivers/serial/68328serial.c   |    2 +
 drivers/serial/68360serial.c   |    4 +-
 drivers/serial/8250.c          |    9 +-
 drivers/serial/bfin_5xx.c      |    7 +-
 drivers/serial/crisv10.c       |    8 +-
 drivers/serial/imx.c           |   10 +-
 drivers/serial/ioc3_serial.c   |    9 +-
 drivers/serial/ioc4_serial.c   |    9 +-
 drivers/serial/max3100.c       |    7 +-
 drivers/serial/serial_core.c   |  281 +++++++++++++++++++---------------------
 drivers/usb/class/cdc-acm.c    |   12 +--
 drivers/video/console/vgacon.c |    2 -
 include/linux/console_struct.h |    3 +-
 include/linux/istallion.h      |    2 +-
 include/linux/serial_core.h    |    2 +-
 include/linux/tty.h            |   67 ++++++++++
 lib/Kconfig.debug              |   10 ++
 47 files changed, 679 insertions(+), 509 deletions(-)
 create mode 100644 drivers/char/tty_mutex.c

