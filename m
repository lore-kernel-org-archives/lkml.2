Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520Ab3ACOy4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 09:54:56 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:60975 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047Ab3ACOxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 09:53:17 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, jirislaby@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH 00/10] TTY: switch flipping functions to tty_port
Date: Thu,  3 Jan 2013 15:53:00 +0100
Message-Id: <1357224789-2853-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In this series we get rid of the tty_port_tty_get in most hot paths as
all the flipping functions needs to know is in tty_port already. This
simplifies the code at some places a lot.

Two fixes for coverity issues are included.

Jiri Slaby (10):
  TTY: switch tty_buffer_request_room to tty_port
  TTY: convert more flipping functions
  TTY: switch tty_insert_flip_char
  TTY: switch tty_insert_flip_string
  TTY: move low_latency to tty_port
  TTY: switch tty_flip_buffer_push
  TTY: switch tty_schedule_flip
  cyclades: push down tty_port_tty_get
  TTY: synclink, remove unneeded tests
  TTY: nozomi, remove dead code

 arch/alpha/kernel/srmcons.c                 |  18 +-
 arch/ia64/hp/sim/simserial.c                |  21 +-
 arch/mn10300/kernel/mn10300-serial.c        |  20 +-
 arch/parisc/kernel/pdc_cons.c               |  10 +-
 arch/um/drivers/chan.h                      |   3 +-
 arch/um/drivers/chan_kern.c                 |  25 +--
 arch/um/drivers/line.c                      |   7 +-
 arch/xtensa/platforms/iss/console.c         |  10 +-
 drivers/char/pcmcia/synclink_cs.c           |  24 +--
 drivers/ipack/devices/ipoctal.c             |  19 +-
 drivers/isdn/gigaset/interface.c            |  14 +-
 drivers/isdn/i4l/isdn_common.c              |  14 +-
 drivers/isdn/i4l/isdn_common.h              |   2 +-
 drivers/isdn/i4l/isdn_tty.c                 |  59 +++---
 drivers/mmc/card/sdio_uart.c                |  13 +-
 drivers/net/caif/caif_serial.c              |   2 +-
 drivers/net/irda/irtty-sir.c                |   2 +-
 drivers/net/usb/hso.c                       |  32 ++-
 drivers/s390/char/con3215.c                 |  12 +-
 drivers/s390/char/keyboard.h                |  16 +-
 drivers/s390/char/sclp_tty.c                |  14 +-
 drivers/s390/char/sclp_vt220.c              |  12 +-
 drivers/s390/char/tty3270.c                 |   4 +-
 drivers/staging/ccg/u_serial.c              |  13 +-
 drivers/staging/dgrp/dgrp_net_ops.c         |  12 +-
 drivers/staging/fwserial/fwserial.c         |  51 ++---
 drivers/staging/serqt_usb2/serqt_usb2.c     |  41 ++--
 drivers/tty/amiserial.c                     |  13 +-
 drivers/tty/bfin_jtag_comm.c                |  22 +--
 drivers/tty/cyclades.c                      | 297 +++++++++++++---------------
 drivers/tty/ehv_bytechan.c                  |  13 +-
 drivers/tty/hvc/hvc_console.c               |   6 +-
 drivers/tty/hvc/hvcs.c                      |   6 +-
 drivers/tty/hvc/hvsi.c                      |  28 ++-
 drivers/tty/ipwireless/tty.c                |  12 +-
 drivers/tty/isicom.c                        |  12 +-
 drivers/tty/moxa.c                          |  10 +-
 drivers/tty/mxser.c                         |   8 +-
 drivers/tty/n_gsm.c                         |  78 ++++----
 drivers/tty/nozomi.c                        |  37 ++--
 drivers/tty/pty.c                           |   4 +-
 drivers/tty/rocket.c                        |  30 ++-
 drivers/tty/serial/21285.c                  |   3 +-
 drivers/tty/serial/68328serial.c            |  17 +-
 drivers/tty/serial/8250/8250.c              |   3 +-
 drivers/tty/serial/altera_jtaguart.c        |   2 +-
 drivers/tty/serial/altera_uart.c            |   2 +-
 drivers/tty/serial/amba-pl010.c             |   3 +-
 drivers/tty/serial/amba-pl011.c             |  11 +-
 drivers/tty/serial/apbuart.c                |   3 +-
 drivers/tty/serial/ar933x_uart.c            |  15 +-
 drivers/tty/serial/arc_uart.c               |   8 +-
 drivers/tty/serial/atmel_serial.c           |   9 +-
 drivers/tty/serial/bcm63xx_uart.c           |   9 +-
 drivers/tty/serial/bfin_sport_uart.c        |  12 +-
 drivers/tty/serial/bfin_uart.c              |  10 +-
 drivers/tty/serial/clps711x.c               |   8 +-
 drivers/tty/serial/cpm_uart/cpm_uart_core.c |  10 +-
 drivers/tty/serial/crisv10.c                |  33 +---
 drivers/tty/serial/dz.c                     |   4 +-
 drivers/tty/serial/efm32-uart.c             |  21 +-
 drivers/tty/serial/icom.c                   |  10 +-
 drivers/tty/serial/ifx6x60.c                |  10 +-
 drivers/tty/serial/imx.c                    |   6 +-
 drivers/tty/serial/ioc3_serial.c            |  11 +-
 drivers/tty/serial/ioc4_serial.c            |  12 +-
 drivers/tty/serial/jsm/jsm_tty.c            |  18 +-
 drivers/tty/serial/kgdb_nmi.c               |  12 +-
 drivers/tty/serial/lantiq.c                 |  20 +-
 drivers/tty/serial/lpc32xx_hs.c             |  30 +--
 drivers/tty/serial/m32r_sio.c               |   8 +-
 drivers/tty/serial/max3100.c                |  10 +-
 drivers/tty/serial/max310x.c                |   8 +-
 drivers/tty/serial/mcf.c                    |   2 +-
 drivers/tty/serial/mfd.c                    |  15 +-
 drivers/tty/serial/mpc52xx_uart.c           |   8 +-
 drivers/tty/serial/mpsc.c                   |  15 +-
 drivers/tty/serial/mrst_max3110.c           |  19 +-
 drivers/tty/serial/msm_serial.c             |  16 +-
 drivers/tty/serial/msm_serial_hs.c          |  19 +-
 drivers/tty/serial/msm_smd_tty.c            |   4 +-
 drivers/tty/serial/mux.c                    |   9 +-
 drivers/tty/serial/mxs-auart.c              |   9 +-
 drivers/tty/serial/netx-serial.c            |   4 +-
 drivers/tty/serial/nwpserial.c              |   6 +-
 drivers/tty/serial/omap-serial.c            |   3 +-
 drivers/tty/serial/pch_uart.c               |  32 +--
 drivers/tty/serial/pmac_zilog.c             |  36 ++--
 drivers/tty/serial/pnx8xxx_uart.c           |   3 +-
 drivers/tty/serial/pxa.c                    |   3 +-
 drivers/tty/serial/sa1100.c                 |   3 +-
 drivers/tty/serial/samsung.c                |   3 +-
 drivers/tty/serial/sb1250-duart.c           |   2 +-
 drivers/tty/serial/sc26xx.c                 |  29 +--
 drivers/tty/serial/sccnxp.c                 |   8 +-
 drivers/tty/serial/serial_core.c            |  13 +-
 drivers/tty/serial/serial_ks8695.c          |   3 +-
 drivers/tty/serial/serial_txx9.c            |   3 +-
 drivers/tty/serial/sh-sci.c                 |  52 +++--
 drivers/tty/serial/sirfsoc_uart.c           |   8 +-
 drivers/tty/serial/sn_console.c             |  16 +-
 drivers/tty/serial/sunhv.c                  |  33 ++--
 drivers/tty/serial/sunsab.c                 |  28 ++-
 drivers/tty/serial/sunsu.c                  |  18 +-
 drivers/tty/serial/sunzilog.c               |  39 ++--
 drivers/tty/serial/timbuart.c               |   6 +-
 drivers/tty/serial/uartlite.c               |  10 +-
 drivers/tty/serial/ucc_uart.c               |  10 +-
 drivers/tty/serial/vr41xx_siu.c             |   4 +-
 drivers/tty/serial/vt8500_serial.c          |  17 +-
 drivers/tty/serial/xilinx_uartps.c          |  14 +-
 drivers/tty/serial/zs.c                     |   2 +-
 drivers/tty/synclink.c                      |  11 +-
 drivers/tty/synclink_gt.c                   |  17 +-
 drivers/tty/synclinkmp.c                    |  51 ++---
 drivers/tty/tty_buffer.c                    |  58 +++---
 drivers/tty/vt/keyboard.c                   |  25 +--
 drivers/tty/vt/vt.c                         |  16 +-
 drivers/usb/class/cdc-acm.c                 |  13 +-
 drivers/usb/gadget/u_serial.c               |  15 +-
 drivers/usb/serial/aircable.c               |  17 +-
 drivers/usb/serial/ark3116.c                |  12 +-
 drivers/usb/serial/belkin_sa.c              |  12 +-
 drivers/usb/serial/cyberjack.c              |  11 +-
 drivers/usb/serial/cypress_m8.c             |   6 +-
 drivers/usb/serial/digi_acceleport.c        |  14 +-
 drivers/usb/serial/f81232.c                 |  15 +-
 drivers/usb/serial/ftdi_sio.c               |  21 +-
 drivers/usb/serial/garmin_gps.c             |   9 +-
 drivers/usb/serial/generic.c                |  12 +-
 drivers/usb/serial/io_edgeport.c            |  39 ++--
 drivers/usb/serial/io_ti.c                  |  32 ++-
 drivers/usb/serial/ir-usb.c                 |   9 +-
 drivers/usb/serial/iuu_phoenix.c            |   9 +-
 drivers/usb/serial/keyspan.c                |  60 +++---
 drivers/usb/serial/keyspan_pda.c            |   9 +-
 drivers/usb/serial/kl5kusb105.c             |  10 +-
 drivers/usb/serial/kobil_sct.c              |   9 +-
 drivers/usb/serial/mct_u232.c               |  11 +-
 drivers/usb/serial/metro-usb.c              |   9 +-
 drivers/usb/serial/mos7720.c                |   9 +-
 drivers/usb/serial/mos7840.c                |  10 +-
 drivers/usb/serial/navman.c                 |   9 +-
 drivers/usb/serial/omninet.c                |  10 +-
 drivers/usb/serial/opticon.c                |  11 +-
 drivers/usb/serial/oti6858.c                |   9 +-
 drivers/usb/serial/pl2303.c                 |  15 +-
 drivers/usb/serial/quatech2.c               |  29 +--
 drivers/usb/serial/safe_serial.c            |  15 +-
 drivers/usb/serial/sierra.c                 |  17 +-
 drivers/usb/serial/spcp8x5.c                |  24 +--
 drivers/usb/serial/ssu100.c                 |  31 +--
 drivers/usb/serial/symbolserial.c           |   9 +-
 drivers/usb/serial/ti_usb_3410_5052.c       |  44 ++---
 drivers/usb/serial/usb_wwan.c               |  17 +-
 include/linux/tty.h                         |   6 +-
 include/linux/tty_flip.h                    |  28 +--
 net/bluetooth/rfcomm/tty.c                  |  21 +-
 net/irda/ircomm/ircomm_tty.c                |   8 +-
 159 files changed, 1093 insertions(+), 1669 deletions(-)

-- 
1.8.1


