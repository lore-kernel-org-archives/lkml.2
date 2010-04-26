Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab0DZWYw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 18:24:52 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:54223 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755253Ab0DZWYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 18:24:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@zeniv.linux.org.uk>,
       Jan Blunck <jblunck@suse.de>, Ingo Molnar <mingo@elte.hu>,
       John Kacur <jkacur@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 0/6] Push down BKL into device drivers
Date: Tue, 27 Apr 2010 00:23:59 +0200
Message-Id: <1272320645-8671-1-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <201004262112.39906.arnd@arndb.de>
References: <201004262112.39906.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/Nkdtbe4FL6NJAV/RyUsT7utk3wOg0Wyg5dfY
 ObBjSMxjTodSrZ4TkBmvCDKAFA7VCj0a+g7L3magYjurqQu9xA
 C+2IRHyGZzwos971dGmsg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is half the work of getting rid of the BKL in
the ioctl file operation, the rest in arch/ and fs/
still needs to be done, maybe two more hours of
work (for someone else than me ;-)).

Pushdown is straightforward. In many cases, it's
rather obvious that the BKL is not needed at all,
but let's not mix the removal with the pushdown.

Arnd Bergmann (6):
  dvb: push down BKL into ioctl functions
  scsi: push down BKL into ioctl functions
  isdn: push down BKL into ioctl functions
  staging: push down BKL into ioctl functions
  v4l: always use unlocked_ioctl
  drivers: push down BKL into various drivers

 drivers/block/pktcdvd.c                     |   13 ++++++--
 drivers/char/apm-emulation.c                |    8 +++--
 drivers/char/applicom.c                     |   13 +++++---
 drivers/char/ds1620.c                       |   16 ++++++++-
 drivers/char/dtlk.c                         |   15 +++++----
 drivers/char/generic_nvram.c                |   17 ++++++++--
 drivers/char/genrtc.c                       |   16 ++++++++-
 drivers/char/hpet.c                         |   14 +++++---
 drivers/char/i8k.c                          |   21 ++++++++++--
 drivers/char/ipmi/ipmi_devintf.c            |   26 +++++++++++++---
 drivers/char/ipmi/ipmi_watchdog.c           |   17 +++++++++-
 drivers/char/nvram.c                        |   10 ++++--
 drivers/char/nwflash.c                      |    7 +++-
 drivers/char/raw.c                          |   42 ++++++++++++++-----------
 drivers/hwmon/fschmd.c                      |    9 +++--
 drivers/hwmon/w83793.c                      |   10 ++++--
 drivers/input/misc/hp_sdc_rtc.c             |   34 ++++++++++++++------
 drivers/isdn/capi/capi.c                    |   17 ++++++++--
 drivers/isdn/divert/divert_procfs.c         |   19 ++++++++++--
 drivers/isdn/i4l/isdn_common.c              |   18 +++++++++--
 drivers/isdn/mISDN/timerdev.c               |   10 ++++--
 drivers/macintosh/nvram.c                   |    2 +-
 drivers/macintosh/via-pmu.c                 |   17 ++++++++--
 drivers/media/dvb/dvb-core/dmxdev.c         |   31 +++++++++++++-----
 drivers/media/dvb/dvb-core/dvb_ca_en50221.c |   17 +++++++---
 drivers/media/dvb/dvb-core/dvb_frontend.c   |   30 +++++++++---------
 drivers/media/dvb/dvb-core/dvb_net.c        |   15 +++++++--
 drivers/media/dvb/dvb-core/dvbdev.c         |   17 +++++++----
 drivers/media/dvb/dvb-core/dvbdev.h         |   11 ++----
 drivers/media/dvb/firewire/firedtv-ci.c     |    5 +--
 drivers/media/dvb/ttpci/av7110.c            |    4 +-
 drivers/media/dvb/ttpci/av7110_av.c         |    8 ++--
 drivers/media/dvb/ttpci/av7110_ca.c         |    5 +--
 drivers/media/video/v4l2-dev.c              |   17 ++++++++--
 drivers/mtd/mtdchar.c                       |   19 ++++++++---
 drivers/pcmcia/pcmcia_ioctl.c               |   17 ++++++++--
 drivers/rtc/rtc-m41t80.c                    |   16 ++++++++-
 drivers/sbus/char/openprom.c                |   44 +++++++++++++++-----------
 drivers/scsi/3w-9xxx.c                      |   10 ++++--
 drivers/scsi/3w-sas.c                       |    7 +++-
 drivers/scsi/3w-xxxx.c                      |   10 ++++--
 drivers/scsi/aacraid/linit.c                |   11 +++++--
 drivers/scsi/dpt_i2o.c                      |   20 ++++++++++--
 drivers/scsi/gdth.c                         |   20 +++++++++---
 drivers/scsi/megaraid.c                     |   20 ++++++++++--
 drivers/scsi/megaraid/megaraid_mm.c         |   22 ++++++++++---
 drivers/scsi/osst.c                         |   14 ++++++--
 drivers/scsi/sg.c                           |   17 ++++++++--
 drivers/staging/crystalhd/crystalhd_lnx.c   |   13 +++++--
 drivers/staging/dt3155/dt3155_drv.c         |   24 +++++++++++----
 drivers/staging/poch/poch.c                 |   17 +++++++++-
 drivers/staging/vme/devices/vme_user.c      |   18 +++++++++--
 drivers/usb/mon/mon_bin.c                   |   23 ++++++++++----
 drivers/usb/mon/mon_stat.c                  |    3 +-
 54 files changed, 631 insertions(+), 245 deletions(-)

