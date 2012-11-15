Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993030Ab2KOIuJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 03:50:09 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:58348 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992997Ab2KOIuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 03:50:06 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 0/9] TTY: memory leaks patchset
Date: Thu, 15 Nov 2012 09:49:47 +0100
Message-Id: <1352969396-23760-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I introduced severe memory leaks by (still -next) commit "TTY: move
tty buffers to tty_port", especially in the pty driver. I did not
realize that tty_port is not destroyed as I had imagined. Most of the
drivers simply do not use the tty_port-reference-counted model.

In this series, some are converted to reference counting -- those
which already do reference counting with their own kref. The rest is
just forced to call a newly added function which properly destroys the
tty_port.

Plus there is one patch to fix isicom accessing unsafe tty pointer.

This series should go upstream regardless "TTY: move tty buffers to
tty_port" if we decide to revert that commit due to the reported
warnings I cannot reproduce and neither catch the root cause. At least
while trying to reproduce those I found the leaks fixed here.

Jiri Slaby (9):
  TTY: isicom, stop using port->tty
  TTY: pty, fix tty buffers leak
  ISDN: capi, use kref from tty_port
  MMC: sdio_uart, remove unused member from sdio_uart_port
  MMC: sdio, use kref from tty_port
  TTY: n_gsm, use kref from tty_port
  TTY: introduce tty_port_destroy
  TTY: isicom, fix tty buffers memory leak
  TTY: call tty_port_destroy in the rest of drivers

 arch/alpha/kernel/srmcons.c             |  5 ++++-
 arch/ia64/hp/sim/simserial.c            |  1 +
 arch/m68k/emu/nfcon.c                   |  6 ++++--
 arch/parisc/kernel/pdc_cons.c           |  5 +++--
 arch/um/drivers/line.c                  |  2 ++
 arch/xtensa/platforms/iss/console.c     |  1 +
 drivers/char/pcmcia/synclink_cs.c       |  5 ++++-
 drivers/char/ttyprintk.c                |  4 +++-
 drivers/isdn/capi/capi.c                | 34 ++++++++++++++++-----------------
 drivers/isdn/gigaset/common.c           | 10 ++++++----
 drivers/isdn/i4l/isdn_tty.c             |  4 ++++
 drivers/misc/pti.c                      |  7 +++++--
 drivers/mmc/card/sdio_uart.c            | 24 +++++++++++------------
 drivers/net/usb/hso.c                   |  5 +++--
 drivers/s390/char/con3215.c             |  1 +
 drivers/s390/char/sclp_tty.c            |  4 +++-
 drivers/s390/char/sclp_vt220.c          |  2 ++
 drivers/s390/char/tty3270.c             |  2 ++
 drivers/staging/ccg/u_serial.c          |  5 ++++-
 drivers/staging/dgrp/dgrp_specproc.c    |  2 ++
 drivers/staging/dgrp/dgrp_tty.c         |  4 +++-
 drivers/staging/ipack/devices/ipoctal.c |  2 ++
 drivers/tty/amiserial.c                 |  2 ++
 drivers/tty/bfin_jtag_comm.c            |  6 ++++--
 drivers/tty/cyclades.c                  |  8 +++++---
 drivers/tty/ehv_bytechan.c              |  2 ++
 drivers/tty/hvc/hvsi.c                  |  1 +
 drivers/tty/ipwireless/tty.c            |  1 +
 drivers/tty/isicom.c                    | 23 ++++++++++++----------
 drivers/tty/moxa.c                      |  4 ++++
 drivers/tty/mxser.c                     | 25 ++++++++++++++++--------
 drivers/tty/n_gsm.c                     | 11 +++++------
 drivers/tty/nozomi.c                    | 13 +++++++++----
 drivers/tty/pty.c                       |  2 +-
 drivers/tty/rocket.c                    |  2 ++
 drivers/tty/serial/68328serial.c        |  2 ++
 drivers/tty/serial/ifx6x60.c            |  5 ++++-
 drivers/tty/serial/kgdb_nmi.c           |  2 ++
 drivers/tty/serial/serial_core.c        |  6 ++++++
 drivers/tty/synclink.c                  |  1 +
 drivers/tty/synclink_gt.c               |  5 ++++-
 drivers/tty/synclinkmp.c                |  5 ++++-
 drivers/tty/tty_port.c                  | 18 +++++++++++++++--
 drivers/tty/vt/vt.c                     |  5 ++++-
 drivers/usb/gadget/u_serial.c           |  5 ++++-
 drivers/usb/serial/usb-serial.c         |  1 +
 include/linux/tty.h                     |  1 +
 net/irda/ircomm/ircomm_tty.c            |  1 +
 48 files changed, 202 insertions(+), 90 deletions(-)

-- 
1.8.0


