Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778Ab1I2P0X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 11:26:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7199 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756470Ab1I2P0W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 11:26:22 -0400
From: Amit Shah <amit.shah@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Amit Shah <amit.shah@redhat.com>
Subject: [PATCH 00/11] virtio: Support for hibernation (S4)
Date: Thu, 29 Sep 2011 20:55:56 +0530
Message-Id: <cover.1317309123.git.amit.shah@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

These patches add support for S4 to virtio (pci) and all drivers.  The
patches are based on the virtio-console patch series in Rusty's queue.

For each driver, all vqs are removed before hibernation, and then
re-created after restore.

All the drivers in testing work fine:

* virtio-blk is used for the only disk in the VM, IO works fine before
  and after.

* virtio-console: port IO keeps working fine before and after.
  * If a port is waiting for data from the host (blocking read(2)
    call), this works fine in both the cases: host-side connection is
    available or unavailable after resume.  In case the host-side
    connection isn't available, the blocking call is terminated.  If
    it is available, the call continues to remain in blocked state
    till further data arrives.

* virtio-net: ping remains active across S4.  One packet is lost.
  (Current qemu.git has a regression in slirp code causing qemu
  segfault, commit 1ab74cea060 is the offender).

* virtio-balloon: Works fine before and after.  Forgets the ballooned
  value across S4.  If it's desirable to maintain the ballooned value,
  a new config option can be created to do this.

All in all, this looks pretty good.

Please review and apply.


Amit Shah (11):
  virtio: pci: switch to new PM API
  virtio-pci: add PM notification handlers for restore, freeze, thaw,
    poweroff
  virtio: console: Move out vq and vq buf removal into separate
    functions
  virtio: console: Add freeze and restore handlers to support S4
  virtio: blk: Move out vq initialization to separate function
  virtio: blk: Add freeze, restore handlers to support S4
  virtio: net: Move out vq initialization into separate function
  virtio: net: Move out vq and vq buf removal into separate function
  virtio: net: Add freeze, restore handlers to support S4
  virtio: balloon: Move out vq initialization into separate function
  virtio: balloon: Add freeze, restore handlers to support S4

 drivers/block/virtio_blk.c      |   36 ++++++++++--
 drivers/char/virtio_console.c   |  124 ++++++++++++++++++++++++++++++---------
 drivers/net/virtio_net.c        |   98 ++++++++++++++++++++++---------
 drivers/virtio/virtio_balloon.c |   65 +++++++++++++++------
 drivers/virtio/virtio_pci.c     |   57 +++++++++++++++++-
 include/linux/virtio.h          |    4 +
 6 files changed, 301 insertions(+), 83 deletions(-)

-- 
1.7.6.2

