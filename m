Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965202Ab2CEOIy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 09:08:54 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:34636 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932340Ab2CENxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:53:09 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 00/68] TTY buffer in tty_port -- prep no. 1
Date: Mon,  5 Mar 2012 14:51:47 +0100
Message-Id: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
								      
this is the first series of patches which allow tty buffers to be
moved from tty_struct (present from open to close/hangup) to tty_port
(present as long as the device). This will allow us to get rid of the
tty refcounting in the interrupt service routines and other hot paths
after we are done. This is because we won't need to handle races among
ISRs, timers, hangups and others, because tty_port lives as long as an
interrupt/timer tick may occur. Unlike tty_struct.

In this series, only first few drivers are converted to use
tty_port. The rest is to come later.

The first few patches are simple fixes/cleanups which emerged during
the code investigation here and there. Further serialP header removal
happens there. Finally, some drivers are forced to use tty_port, which
will become a necessity in the future.

Simserial (ia64) and standard x86 stuff were runtime-tested. The rest
is only checked to be compilation-errors free.

Final remark: simserial stuff depends on 4 patches sent to Tony Luck
last week. They are in hist tree and -next already.

Jiri Slaby (68):
  USB: cdc-acm, use tty_standard_install
  TTY: tty_io, remove buffer re-assignments
  TTY: let alloc_tty_driver deduce the owner automatically
  TTY: remove minor_num from tty_driver
  TTY: remove re-assignments to tty_driver members
  TTY: simplify tty_driver_lookup_tty a bit
  TTY: remove tty driver re-set from tty_reopen
  TTY: serial, simplify ASYNC_USR_MASK
  TTY: tty_driver, document tty->ops->shutdown limitation
  ALPHA: srmcons, use timer functions
  ALPHA: srmcons, fix racy singleton structure
  TTY: srmcons, convert to use tty_port
  TTY: serialP, remove DECLARE_WAITQUEUE check
  TTY: remove unneeded tty->index checks
  TTY: ipwireless, fix tty->index handling
  NET: pc300, do not zero global variables
  NET: pc300, show version info from module init
  XTENSA: iss/console, use setup_timer
  XTENSA: iss/console, fix potential deadlock
  TTY: iss/console, use tty_port
  TTY: serial, use atomic_inc_return in ioc4_serial
  TTY: serial, include pci.h in m32r_sio
  TTY: remove serialP.h inclusion from some files
  TTY: speakup, do not use serialP
  TTY: serialP, remove unused material
  TTY: amiserial, remove tasklet for tty_wakeup
  TTY: amiserial, use only one copy of async flags
  TTY: simserial, use only one copy of async flags
  TTY: simserial/amiserial, use one instance of other members
  TTY: simserial, remove support of shared interrupts
  TTY: simserial, remove IRQ_T
  TTY: amiserial, remove IRQ_ports
  TTY: serialP, merge serial_state and async_struct
  TTY: amiserial, simplify set_serial_info
  TTY: amiserial, pass tty down to functions
  TTY: simserial, pass tty down to functions
  TTY: amiserial/simserial, use tty_port
  TTY: amiserial/simserial, use close delays from tty_port
  TTY: amiserial/simserial, use count from tty_port
  TTY: amiserial/simserial, use flags from tty_port
  TTY: simserial, remove static initialization
  TTY: simserial, remove tmp_buf
  TTY: simserial, stop using serial_state->{line,icount}
  TTY: simserial no longer needs serialP
  TTY: simserial, define local tty_port pointer
  TTY: simserial, remove some tty ops
  TTY: simserial, use tty_port_close_end
  TTY: simserial, use tty_port_close_start
  TTY: simserial, properly refcount tty_port->tty
  TTY: simserial, use tty_port_open
  TTY: simserial, use tty_port_hangup
  TTY: simserial, remove useless comments
  TTY: simserial, fix includes
  TTY: simserial, reindent some code
  TTY: simserial, final cleanup
  TTY: amiserial, define local tty_port pointer
  TTY: amiserial, stop using serial_state->{irq,type,line}
  TTY: amiserial no longer needs serialP
  TTY: amiserial, provide carrier helpers
  TTY: amiserial, use tty_port_block_til_ready
  TTY: amiserial, use tty_port_close_end
  TTY: amiserial, use tty_port_close_start
  TTY: pdc_cons, fix racy tty test
  TTY: pdc_cons, fix open vs timer race
  TTY: pdc_cons, fix open vs pdc_console_tty_driver race
  TTY: pdc_cons, use tty_port
  TTY: isdn/gigaset, do not set tty->driver_data to NULL
  TTY: isdn/gigaset, use tty_port

 arch/alpha/kernel/srmcons.c         |   78 ++--
 arch/ia64/hp/sim/simserial.c        |  687 +++++++-------------------------
 arch/m68k/emu/nfcon.c               |    1 -
 arch/parisc/kernel/pdc_cons.c       |   59 ++-
 arch/xtensa/platforms/iss/console.c |   22 +-
 drivers/char/pcmcia/synclink_cs.c   |    3 +-
 drivers/char/ttyprintk.c            |    2 -
 drivers/isdn/capi/capi.c            |    4 +-
 drivers/isdn/gigaset/common.c       |    5 +-
 drivers/isdn/gigaset/gigaset.h      |    3 +-
 drivers/isdn/gigaset/interface.c    |  158 ++------
 drivers/isdn/i4l/isdn_tty.c         |    7 +-
 drivers/misc/pti.c                  |    6 +-
 drivers/mmc/card/sdio_uart.c        |    1 -
 drivers/net/usb/hso.c               |    2 -
 drivers/net/wan/pc300_drv.c         |   13 +-
 drivers/net/wan/pc300_tty.c         |   18 -
 drivers/s390/char/con3215.c         |    9 +-
 drivers/s390/char/sclp_tty.c        |    1 -
 drivers/s390/char/sclp_vt220.c      |    1 -
 drivers/s390/char/tty3270.c         |    1 -
 drivers/staging/speakup/serialio.c  |   11 +-
 drivers/staging/speakup/serialio.h  |   13 +-
 drivers/staging/speakup/spk_priv.h  |    2 +-
 drivers/staging/speakup/synth.c     |    2 +-
 drivers/tty/amiserial.c             |  730 +++++++++++------------------------
 drivers/tty/bfin_jtag_comm.c        |    1 -
 drivers/tty/cyclades.c              |    7 +-
 drivers/tty/ehv_bytechan.c          |    1 -
 drivers/tty/hvc/hvc_console.c       |    1 -
 drivers/tty/hvc/hvcs.c              |   26 +-
 drivers/tty/hvc/hvsi.c              |    6 +-
 drivers/tty/ipwireless/tty.c        |   37 +-
 drivers/tty/isicom.c                |    3 -
 drivers/tty/moxa.c                  |    1 -
 drivers/tty/mxser.c                 |    5 -
 drivers/tty/n_gsm.c                 |    1 -
 drivers/tty/nozomi.c                |    1 -
 drivers/tty/pty.c                   |    4 -
 drivers/tty/rocket.c                |    7 +-
 drivers/tty/serial/68328serial.c    |    9 +-
 drivers/tty/serial/crisv10.c        |   15 +-
 drivers/tty/serial/ifx6x60.c        |    3 -
 drivers/tty/serial/ioc4_serial.c    |    3 +-
 drivers/tty/serial/m32r_sio.c       |    1 -
 drivers/tty/serial/m32r_sio.h       |    1 +
 drivers/tty/serial/msm_smd_tty.c    |    1 -
 drivers/tty/serial/serial_core.c    |    1 -
 drivers/tty/synclink.c              |    3 +-
 drivers/tty/synclink_gt.c           |    3 +-
 drivers/tty/synclinkmp.c            |    3 +-
 drivers/tty/tty_io.c                |   12 +-
 drivers/tty/vt/vt.c                 |    2 +-
 drivers/usb/class/cdc-acm.c         |    8 +-
 drivers/usb/gadget/u_serial.c       |    4 -
 drivers/usb/serial/usb-serial.c     |    1 -
 include/linux/serial.h              |    4 +-
 include/linux/serialP.h             |  142 -------
 include/linux/tty_driver.h          |    8 +-
 net/bluetooth/rfcomm/tty.c          |    1 -
 net/irda/ircomm/ircomm_tty.c        |    7 +-
 61 files changed, 542 insertions(+), 1630 deletions(-)
 delete mode 100644 include/linux/serialP.h

-- 
1.7.9.2


