Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932494Ab2AJRk7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 12:40:59 -0500
Received: from mail-fx0-f74.google.com ([209.85.161.74]:42362 "EHLO
	mail-fx0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756511Ab2AJRk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 12:40:58 -0500
Subject: [PATCH v2 0/3] virtio_net: Better low memory handling.
To: Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>
From: Mike Waychison <mikew@google.com>
Cc: netdev@vger.kernel.org, earhart@google.com,
        virtualization@lists.linux-foundation.org, digitaleric@google.com,
        linux-kernel@vger.kernel.org
Date: Tue, 10 Jan 2012 09:40:54 -0800
Message-ID: <20120110174052.4505.66514.stgit@mike2.sea.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series applies to net-next.

The following series changes the low memory paths in virtio_net to not
disable NAPI while waiting in the allocator in the slow path.

It attempts to rectify some performance problems we've seen where the
network performance drops significantly when memory is low.  The working
theory is that the disabling of NAPI while allocations are occuring in
the slow refill_work() path can in turn cause significant delays in
processing of the receive queue.

The observed situation on an unmodified kernel is that a system with low
memory will in turn quickly stop being being able to refill the rx queue
with buffers, in turn causing packets to be dropped by the host OS (as
NAPI polling is disabled) while the driver wait for memory to be
reclaimed.  The way the process-context refill loop works, the memory
subsystem is effectively polled every half second when things look
bleak, leading to significant packet loss and congestion window
collapse.

The first patch prepares for a batched refill path by splitting the
receive buffer allocation and enqueue bits into separate functions.

The second patch introduces the batched refill path itself.  As
implemented, it still disables NAPI completely for the whole refill.

The third patch then pushed the disabling and enabling of NAPI down into
the refill loop so that it only covers the actual enqueueing of receive
buffers on the virtqueue.

This patchset seems to help the test setups that I'm playing with.
Example tests include using several bit-torrent clients within a VM and
watching the network throughputs on the host.  Other similar workloads
(high network traffic, reasonably high disk IO causing memory pressure)
also appear to have throughput problems alleviated by these changes.


As a warning, I've only tested this using the "small buffers" and
"mergeable" buffers paths.  I haven't figured out how to force qemu-kvm
to not support the feature bits that trigger 'mergable' receive buffers.

ChangeLog:
==========
v2:
- Rewritten to not introduce a spinlock to protect the virtqueue data.

---

Mike Waychison (3):
      virtio_net: Split receive buffer alloc/add
      virtio_net: Batch receive buffer filling
      virtio_net: Don't disable NAPI while allocating


 drivers/net/virtio_net.c |  325 ++++++++++++++++++++++++++++++++++++++++------
 1 files changed, 285 insertions(+), 40 deletions(-)

