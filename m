Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759683Ab2EPH5S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 03:57:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14582 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754398Ab2EPH5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 03:57:16 -0400
Date: Wed, 16 May 2012 10:57:13 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] virtio_net: invoke softirqs after __napi_schedule
Message-ID: <20120516075712.GA2921@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__napi_schedule might raise softirq but nothing
causes do_softirq to trigger, so it does not in fact
run. As a result,
the error message "NOHZ: local_softirq_pending 08"
sometimes occurs during boot of a KVM guest when the network service is
started and we are oom:

  ...
  Bringing up loopback interface:  [  OK  ]
  Bringing up interface eth0:
  Determining IP information for eth0...NOHZ: local_softirq_pending 08
   done.
  [  OK  ]
  ...

Further, receive queue processing might get delayed
indefinitely until some interrupt triggers:
virtio_net expected napi to be run immediately.

One way to cause do_softirq to be executed is by
invoking local_bh_enable(). As __napi_schedule is
normally called from bh or irq context, this
seems to make sense: disable bh before __napi_schedule
and enable afterwards.

Reported-by: Ulrich Obergfell <uobergfe@redhat.com>
Tested-by: Ulrich Obergfell <uobergfe@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

To test, one can hack try_fill_recv to always report oom.
I'm not sure it's not too late for 3.4, but we can try.
Rusty, could you review ASAP pls?

 drivers/net/virtio_net.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index af8acc8..cbefe67 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -492,7 +492,9 @@ static void virtnet_napi_enable(struct virtnet_info *vi)
 	 * We synchronize against interrupts via NAPI_STATE_SCHED */
 	if (napi_schedule_prep(&vi->napi)) {
 		virtqueue_disable_cb(vi->rvq);
+		local_bh_disable();
 		__napi_schedule(&vi->napi);
+		local_bh_enable();
 	}
 }
 
-- 
MST
