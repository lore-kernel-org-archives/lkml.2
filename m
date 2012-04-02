Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146Ab2DBMJ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 08:09:29 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:47941 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583Ab2DBLzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 07:55:01 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 00/69] TTY buffer in tty_port -- prep no. 2
Date: Mon,  2 Apr 2012 13:53:44 +0200
Message-Id: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is the second series of patches which allow tty buffers to be
moved from tty_struct (present from open to close/hangup) to tty_port
(present as long as the device). This will allow us to get rid of the
tty refcounting in the interrupt service routines and other hot paths
after we are done. This is because we won't need to handle races among
ISRs, timers, hangups and others, because tty_port lives as long as an
interrupt/timer tick may occur. Unlike tty_struct.

In this series, second batch of drivers is converted to use tty_port.
The final few pieces are to come in the next window. Read: only very
few drivers are remaining. Then the whole switch will start.

Standard x86 stuff was runtime-tested. The rest is only checked to be
compilation-errors free.

Jiri Slaby (69):
  TTY: crisv10, remove unused tmp_buf
  TTY: crisv10, initialize tty_port
  TTY: deprecate linux/generic_serial.h
  ISDN: i4l, remove cvs crap
  TTY: isdn, remove callout
  TTY: isdn, remove ISDN_ASYNC_* flags
  TTY: isdn, do not play with module refcounts
  TTY: isdn, make some functions readable
  TTY: isdn, remove unused members from modem_info
  TTY: isdn, add tty_port
  TTY: isdn, use open/close_wait from tty_port
  TTY: isdn, use counts from tty_port
  TTY: isdn, use tty from tty_port
  TTY: isdn, use xmit_buf from tty_port
  TTY: isdn, define local tty_port
  TTY: isdn, use tty_port_close_end helper
  TTY: isdn, define tty_port_operations
  TTY: isdn, use tty_port_block_til_ready helper
  TTY: hso, do not set TTY MAGIC
  TTY: hso, free tty_driver
  TTY: hso, add tty_port
  TTY: hso, remove tty NULL checks fro tty->ops
  TTY: hso, use tty from tty_port
  TTY: con3215, centralize allocation
  TTY: con3215, remove tasklet for tty_wakeup
  TTY: con3215, add tty_port
  TTY: con3215, use tty from tty_port
  TTY: sclp_tty, add tty_port
  TTY: sclp_vt220, add tty_port
  TTY: sclp_vt220, remove unused allocation
  TTY: tty3270, move initialization to allocation
  TTY: tty3270, get rid of ugly aliasing
  TTY: tty3270, push tty down to tty3270_do_write
  TTY: tty3270, add tty_port
  TTY: bfin_jtag_comm, add tty_port
  TTY: bfin_jtag_comm, use tty from tty_port
  TTY: HVC, add tty_port
  TTY: HVC, use tty from tty_port
  TTY: HVC, use count from tty_port
  TTY: hvcs, add tty_port
  TTY: hvcs, use kref from tty_port
  TTY: hvcs, use tty from tty_port
  TTY: hvsi, CLOCAL is not in tty->flags
  TTY: hvsi, add tty_port
  TTY: hvsi, sanitize uses of tty
  TTY: hvsi, use tty from tty_port
  TTY: ipwireless, use synchronous hangup
  TTY: ipwireless, move prints to appropriate places
  TTY: ipwireless, add tty_port
  TTY: ipwireless, use tty from tty_port
  TTY: 68328serial, remove serial_state and friends
  TTY: 68328serial, remove unused stuff from m68k_serial
  TTY: 68328serial, remove garbage
  TTY: 68328serial, use ulong flags for interrupts status
  TTY: 68328serial, remove 68328serial.h
  TTY: 68328serial, add tty_port
  TTY: 68328serial, use open/close_wait from tty_port
  TTY: 68328serial, use close_delay/closing_wait from tty_port
  TTY: 68328serial, use flags from tty_port
  TTY: 68328serial, propagate tty
  TTY: 68328serial, use tty from tty_port
  TTY: 68328serial, use tty_port_block_til_ready
  TTY: usb/u_serial, add tty_port
  TTY: usb/u_serial, use tty from tty_port
  TTY: usb/u_serial use close_wait from tty_port
  TTY: rfcomm/tty, add tty_port
  TTY: rfcomm/tty, use tty_port refcounting
  TTY: rfcomm/tty, remove work for tty_wakeup
  TTY: rfcomm/tty, use count from tty_port

 drivers/isdn/i4l/isdn_common.c   |    2 -
 drivers/isdn/i4l/isdn_tty.c      |  466 +++++++++++++++-----------------------
 drivers/net/usb/hso.c            |  105 ++++-----
 drivers/s390/char/con3215.c      |  148 ++++++------
 drivers/s390/char/keyboard.c     |   30 +--
 drivers/s390/char/keyboard.h     |   14 +-
 drivers/s390/char/sclp_tty.c     |   33 +--
 drivers/s390/char/sclp_vt220.c   |   33 ++-
 drivers/s390/char/tty3270.c      |  121 +++++-----
 drivers/tty/bfin_jtag_comm.c     |   44 ++--
 drivers/tty/hvc/hvc_console.c    |   93 ++++----
 drivers/tty/hvc/hvc_console.h    |    4 +-
 drivers/tty/hvc/hvcs.c           |   74 +++---
 drivers/tty/hvc/hvsi.c           |  128 +++++------
 drivers/tty/hvc/hvsi_lib.c       |    2 +-
 drivers/tty/ipwireless/tty.c     |   81 +++----
 drivers/tty/serial/68328serial.c |  383 +++++++++++++------------------
 drivers/tty/serial/68328serial.h |  186 ---------------
 drivers/tty/serial/crisv10.c     |   28 +--
 drivers/usb/gadget/u_serial.c    |   51 ++---
 include/linux/generic_serial.h   |   64 +-----
 include/linux/isdn.h             |   26 +--
 net/bluetooth/rfcomm/tty.c       |  133 +++++------
 23 files changed, 851 insertions(+), 1398 deletions(-)
 delete mode 100644 drivers/tty/serial/68328serial.h

-- 
1.7.9.2


