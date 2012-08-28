Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab2H1Lyl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 07:54:41 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:45492 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956Ab2H1Lyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 07:54:39 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, kvm@vger.kernel.org, rusty@rustcorp.com.au,
        jasowang@redhat.com, mst@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 0/5] Multiqueue virtio-scsi
Date: Tue, 28 Aug 2012 13:54:12 +0200
Message-Id: <1346154857-12487-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.7.11.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

this series adds multiqueue support to the virtio-scsi driver, based
on Jason Wang's work on virtio-net.  It uses a simple queue steering
algorithm that expects one queue per CPU.  LUNs in the same target always
use the same queue (so that commands are not reordered); queue switching
occurs when the request being queued is the only one for the target.
Also based on Jason's patches, the virtqueue affinity is set so that
each CPU is associated to one virtqueue.

I tested the patches with fio, using up to 32 virtio-scsi disks backed
by tmpfs on the host, and 1 LUN per target.

FIO configuration
-----------------
[global]
rw=read
bsrange=4k-64k
ioengine=libaio
direct=1
iodepth=4
loops=20

overall bandwidth (MB/s)
-----------------

# of targets    single-queue    multi-queue, 4 VCPUs    multi-queue, 8 VCPUs
1                  540               626                     599
2                  795               965                     925
4                  997              1376                    1500
8                 1136              2130                    2060
16                1440              2269                    2474
24                1408              2179                    2436
32                1515              1978                    2319

(These numbers for single-queue are with 4 VCPUs, but the impact of adding
more VCPUs is very limited).

avg bandwidth per LUN (MB/s)
---------------------

# of targets    single-queue    multi-queue, 4 VCPUs    multi-queue, 8 VCPUs
1                  540               626                     599
2                  397               482                     462
4                  249               344                     375
8                  142               266                     257
16                  90               141                     154
24                  58                90                     101
32                  47                61                      72

Testing this may require an irqbalance daemon that is built from git,
due to http://code.google.com/p/irqbalance/issues/detail?id=37.
Alternatively you can just set the affinity manually in /proc.

Rusty, can you please give your Acked-by to the first two patches?

Jason Wang (2):
  virtio-ring: move queue_index to vring_virtqueue
  virtio: introduce an API to set affinity for a virtqueue

Paolo Bonzini (3):
  virtio-scsi: allocate target pointers in a separate memory block
  virtio-scsi: pass struct virtio_scsi to virtqueue completion function
  virtio-scsi: introduce multiqueue support

 drivers/lguest/lguest_device.c         |    1 +
 drivers/remoteproc/remoteproc_virtio.c |    1 +
 drivers/s390/kvm/kvm_virtio.c          |    1 +
 drivers/scsi/virtio_scsi.c             |  200 ++++++++++++++++++++++++--------
 drivers/virtio/virtio_mmio.c           |   11 +-
 drivers/virtio/virtio_pci.c            |   58 ++++++++-
 drivers/virtio/virtio_ring.c           |   17 +++
 include/linux/virtio.h                 |    4 +
 include/linux/virtio_config.h          |   21 ++++
 9 files changed, 253 insertions(+), 61 deletions(-)

