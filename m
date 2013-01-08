Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564Ab3AHO5O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 09:57:14 -0500
Received: from mga03.intel.com ([143.182.124.21]:18527 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756455Ab3AHO5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 09:57:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,430,1355126400"; 
   d="scan'208";a="188870167"
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Stefani Seibold <stefani@seibold.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        iscsi list <open-iscsi@googlegroups.com>,
        Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 0/5] kfifo cleanup and log based kfifo API
Date: Tue,  8 Jan 2013 22:57:48 +0800
Message-Id: <1357657073-27352-1-git-send-email-yuanhan.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current kfifo API take the kfifo size as input, while it rounds
_down_ the size to power of 2 at __kfifo_alloc/init. This may introduce
several potential issues.

First, the kfifo size is not what we want. Say, if we want to
allocate a kfifo with size of 127 elements. Then in the end, we can
only hold 64 elements. Here is a similar example at
drivers/hid/hid-logitech-dj.c:

	if (kfifo_alloc(&djrcv_dev->notif_fifo,
                       DJ_MAX_NUMBER_NOTIFICATIONS * sizeof(struct dj_report),
                       GFP_KERNEL)) {

Where, DJ_MAX_NUMBER_NOTIFICATIONS is 8, and sizeo of(struct dj_report)
is 15.

Which means it wants to allocate a kfifo buffer which can store 8
dj_report entries at once. The expected kfifo buffer size would be
8 * 15 = 120 then. While, in the end, __kfifo_alloc will turn the
size to rounddown_power_of_2(120) =  64, and then allocate a buf
with 64 bytes, which I don't think this is the original author want.

With the new log API, we can do something like following:

	int kfifo_size_order = order_base_2(DJ_MAX_NUMBER_NOTIFICATIONS *
					    sizeof(struct dj_report));

	if (kfifo_alloc(&djrcv_dev->notif_fifo, kfifo_size_order, GFP_KERNEL)) {

This make sure we will allocate enough kfifo buffer for holding
DJ_MAX_NUMBER_NOTIFICATIONS dj_report entries.


Second, kfifo_init used a pre-allocated buffer, and the actual
buffer size is determined in caller side, while the actual kfifo
buffer size is maintained in kfifo_init, which will be rounded down
power of 2 without notifying to caller. Take the example of code at
drivers/scsi/libiscsi.c:
        /* If the user passed an items pointer, he wants a copy of
         * the array. */
        if (items)
                num_arrays++;
        q->pool = kzalloc(num_arrays * max * sizeof(void*), GFP_KERNEL);
        if (q->pool == NULL)
                return -ENOMEM;

        kfifo_init(&q->queue, (void*)q->pool, max * sizeof(void*));

        for (i = 0; i < max; i++) {
                q->pool[i] = kzalloc(item_size, GFP_KERNEL);
                if (q->pool[i] == NULL) {
                        q->max = i;
                        goto enomem;
                }
                kfifo_in(&q->queue, (void*)&q->pool[i], sizeof(void*));
        }

Assume max is not power of 2, this piece of code will not work! As
it assumes the kfifo will hold max elements, but actually it can
only hold rounddown_power_of_2(max).

My proposal is to replace kfifo_init with kfifo_alloc, where it
allocate buffer and maintain fifo size inside kfifo. Then we can
remove buggy kfifo_init.

After we change the kfifo_alloc to be a log API, all above issue
will be gone as said by Stefani.

Here is the patch summary:
patch 1 is a cleanup patch to cleanup the unneeded type check.
patch 2 and 3 turn the only 2 users of kfifo_init to kfifo_alloc
patch 4 remove kfifo_init
patch 5 log based kfifo API


Thanks!

	--yliu

Cc: Stefani Seibold <stefani@seibold.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: James E.J. Bottomley <JBottomley@parallels.com>
Cc: iscsi list <open-iscsi@googlegroups.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>
---
Yuanhan Liu (5):
  kfifo: remove unnecessary type check
  libsrp: replace kfifo_init with kfifo_alloc
  libiscsi: replace kfifo_init with kfifo_alloc
  kfifo: remove kfifo_init
  kfifo: log based kfifo API

 arch/arm/plat-omap/Kconfig                  |    2 +-
 arch/arm/plat-omap/mailbox.c                |    6 +-
 arch/powerpc/sysdev/fsl_rmu.c               |    2 +-
 drivers/char/sonypi.c                       |    9 ++-
 drivers/hid/hid-logitech-dj.c               |    7 +-
 drivers/iio/industrialio-event.c            |    2 +-
 drivers/iio/kfifo_buf.c                     |    3 +-
 drivers/infiniband/hw/cxgb3/cxio_resource.c |    8 ++-
 drivers/media/i2c/cx25840/cx25840-ir.c      |    9 ++-
 drivers/media/pci/cx23885/cx23888-ir.c      |    9 ++-
 drivers/media/pci/meye/meye.c               |    6 +-
 drivers/media/pci/meye/meye.h               |    2 +
 drivers/media/rc/ir-raw.c                   |    7 +-
 drivers/memstick/host/r592.h                |    2 +-
 drivers/mmc/card/sdio_uart.c                |    4 +-
 drivers/mtd/sm_ftl.c                        |    5 +-
 drivers/net/wireless/libertas/main.c        |    4 +-
 drivers/net/wireless/rt2x00/rt2x00dev.c     |    5 +-
 drivers/pci/pcie/aer/aerdrv_core.c          |    3 +-
 drivers/platform/x86/fujitsu-laptop.c       |    5 +-
 drivers/platform/x86/sony-laptop.c          |    6 +-
 drivers/rapidio/devices/tsi721.c            |    5 +-
 drivers/scsi/libiscsi.c                     |   59 ++++++++--------
 drivers/scsi/libiscsi_tcp.c                 |    6 +-
 drivers/scsi/libsrp.c                       |   22 +++---
 drivers/staging/omapdrm/omap_plane.c        |    5 +-
 drivers/tty/n_gsm.c                         |    4 +-
 drivers/tty/nozomi.c                        |    5 +-
 drivers/tty/serial/ifx6x60.c                |    2 +-
 drivers/tty/serial/ifx6x60.h                |    3 +-
 drivers/tty/serial/kgdb_nmi.c               |    7 +-
 drivers/usb/host/fhci.h                     |    4 +-
 drivers/usb/serial/cypress_m8.c             |    4 +-
 drivers/usb/serial/io_ti.c                  |    4 +-
 drivers/usb/serial/ti_usb_3410_5052.c       |    7 +-
 drivers/usb/serial/usb-serial.c             |    2 +-
 include/linux/kfifo.h                       |   98 +++++++--------------------
 include/linux/rio.h                         |    1 +
 include/media/lirc_dev.h                    |    4 +-
 include/scsi/libiscsi.h                     |    4 +-
 include/scsi/libsrp.h                       |    1 -
 kernel/kfifo.c                              |   32 +--------
 mm/memory-failure.c                         |    3 +-
 net/dccp/probe.c                            |    6 +-
 net/sctp/probe.c                            |    6 +-
 samples/kfifo/bytestream-example.c          |    8 +-
 samples/kfifo/dma-example.c                 |    5 +-
 samples/kfifo/inttype-example.c             |    7 +-
 samples/kfifo/record-example.c              |    6 +-
 49 files changed, 195 insertions(+), 231 deletions(-)

-- 
1.7.7.6

