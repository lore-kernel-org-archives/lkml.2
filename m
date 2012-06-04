Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760139Ab2FDLk1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 07:40:27 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:44996 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103Ab2FDLfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 07:35:44 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 00/25] TTY buffer in tty_port -- prep no. 3
Date: Mon,  4 Jun 2012 13:35:14 +0200
Message-Id: <1338809738-18967-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.10.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is the third series of patches which allow tty buffers to be
moved from tty_struct (present from open to close/hangup) to tty_port
(present as long as the device). This will allow us to get rid of the
tty refcounting in the interrupt service routines and other hot paths
after we are done. This is because we won't need to handle races among
ISRs, timers, hangups and others, because tty_port lives as long as an
interrupt/timer tick may occur. Unlike tty_struct.

In this series, the third batch of drivers is converted to use
tty_port.  Read: all drivers now have a tty_port. Second, we start
assigning tty_port to tty_struct->port in this series. So the TTY
layer now finally has an access to a tty_port in most of the drivers.
This means not every driver uses the new shiny interfaces creating
tty_struct => tty_port links automatically. I ran out of time (I had
to do other things) to convert them all... The rest is going to be
converted later.

Standard x86 stuff was runtime-tested. The rest is only checked to be
compilation-errors free.

Jiri Slaby (25):
  TTY: ircomm, add tty_port
  TTY: ircomm, use close times from tty_port
  TTY: ircomm, use open counts from tty_port
  TTY: ircomm, use flags from tty_port
  TTY: ircomm, revamp locking
  TTY: ircomm, use tty from tty_port
  TTY: ircomm, define local tty_port
  TTY: ircomm, define carrier routines
  TTY: ircomm, use tty_port_close_end helper
  TTY: ircomm, use tty_port_close_start helper
  TTY: um/line, add tty_port
  TTY: um/line, use tty from tty_port
  PTY: remove one empty ops->remove
  PTY: merge pty_install implementations
  PTY: add tty_port
  TTY: vt, remove con_schedule_flip
  TTY: provide drivers with tty_port_install
  TTY: serial_core, add ->install
  TTY: vt, add ->install
  TTY: usb-serial, use tty_port_install
  TTY: centralize fail paths in tty_register_driver
  TTY: add ports array to tty_driver
  TTY: add tty_port_register_device helper
  TTY: cyclades, add local pointer for card
  TTY: use tty_port_register_device

 arch/um/drivers/chan_kern.c         |    4 +-
 arch/um/drivers/line.c              |   35 +++--
 arch/um/drivers/line.h              |    3 +-
 drivers/isdn/capi/capi.c            |    3 +-
 drivers/isdn/gigaset/interface.c    |    3 +-
 drivers/mmc/card/sdio_uart.c        |    4 +-
 drivers/net/usb/hso.c               |    7 +-
 drivers/tty/cyclades.c              |   79 +++++-----
 drivers/tty/ehv_bytechan.c          |    9 +-
 drivers/tty/ipwireless/tty.c        |    2 +-
 drivers/tty/isicom.c                |    3 +-
 drivers/tty/mxser.c                 |    6 +-
 drivers/tty/nozomi.c                |    4 +-
 drivers/tty/pty.c                   |  141 +++++++++---------
 drivers/tty/rocket.c                |    4 +-
 drivers/tty/serial/ifx6x60.c        |    4 +-
 drivers/tty/serial/msm_smd_tty.c    |    8 +-
 drivers/tty/serial/serial_core.c    |   28 ++--
 drivers/tty/synclink_gt.c           |    7 +-
 drivers/tty/tty_io.c                |   34 +++--
 drivers/tty/tty_port.c              |   17 +++
 drivers/tty/vt/keyboard.c           |    6 +-
 drivers/tty/vt/vt.c                 |   62 ++++----
 drivers/usb/class/cdc-acm.c         |    3 +-
 drivers/usb/gadget/u_serial.c       |    3 +-
 drivers/usb/serial/usb-serial.c     |    2 +-
 include/linux/kbd_kern.h            |   12 --
 include/linux/tty.h                 |    5 +
 include/linux/tty_driver.h          |    1 +
 include/net/irda/ircomm_tty.h       |   17 +--
 net/bluetooth/rfcomm/tty.c          |    4 +-
 net/irda/ircomm/ircomm_param.c      |    5 -
 net/irda/ircomm/ircomm_tty.c        |  271 ++++++++++++++++-------------------
 net/irda/ircomm/ircomm_tty_attach.c |   40 ++++--
 net/irda/ircomm/ircomm_tty_ioctl.c  |   25 ++--
 35 files changed, 450 insertions(+), 411 deletions(-)

-- 
1.7.10.3


