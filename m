Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757000Ab1KQL6Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 06:58:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57237 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756896Ab1KQL6P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 06:58:15 -0500
From: Amit Shah <amit.shah@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Virtualization List <virtualization@lists.linux-foundation.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, levinsasha928@gmail.com,
        linux-kernel@vger.kernel.org, Amit Shah <amit.shah@redhat.com>
Subject: [PATCH v3 00/11] virtio: S4 support
Date: Thu, 17 Nov 2011 17:27:31 +0530
Message-Id: <cover.1321530505.git.amit.shah@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

These patches add support for S4 to virtio (pci) and all drivers.

For each driver, all vqs are removed before hibernation, and then
re-created after restore.  Some driver-specific uninit and init work
is also done in the freeze and restore functions.

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

* virtio-net: ping remains active across S4.

* virtio-balloon: Works fine before and after.  Forgets the ballooned
  value across S4.  If it's desirable to maintain the ballooned value,
  a new config option can be created to do this.

All of these tests are run in parallel.

I have some more tests lined up on similar lines above.  I'll reply
here if something breaks.

Please review and apply if appropriate,

v3:
 - Reset vqs before deleting them (Sasha Levin)
 - Flush block queue before freeze (Rusty)
 - Detach netdev before freeze (Michael S. Tsirkin)

v2:
 - fix checkpatch errors/warnings

Amit Shah (11):
  virtio: pci: switch to new PM API
  virtio: pci: add PM notification handlers for restore, freeze, thaw,
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

 drivers/block/virtio_blk.c      |   55 +++++++++++++++--
 drivers/char/virtio_console.c   |  126 ++++++++++++++++++++++++++++++---------
 drivers/net/virtio_net.c        |   99 ++++++++++++++++++++++--------
 drivers/virtio/virtio_balloon.c |   68 +++++++++++++++------
 drivers/virtio/virtio_pci.c     |   66 +++++++++++++++++++-
 include/linux/virtio.h          |    4 +
 6 files changed, 336 insertions(+), 82 deletions(-)

-- 
1.7.7.1

