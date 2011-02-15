Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574Ab1BOJfd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 04:35:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56997 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754233Ab1BOJfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 04:35:30 -0500
Date: Tue, 15 Feb 2011 10:35:27 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] virtio: use __GFP_NOWARN for try_fill_recv in virtnet_poll
Message-ID: <20110215093527.GB8341@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
we have started seeing a lot of allocator messages complaining about
failed allocations from virtnet_poll in soft IRQ. Could you consider the
following patch, please?

The patch is based on 2.6.38-rc4.
--- 
>From aabc19f22915dafeac0f1f6aa7cb7e49a8021ba1 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Tue, 15 Feb 2011 10:20:59 +0100
Subject: [PATCH] virtio: use __GFP_NOWARN for try_fill_recv in virtnet_poll

virtnet_poll is called from soft IRQ and it tries to allocate GFP_ATOMIC
memory (through try_fill_recv). This allocation can fail and we are
falling back to schedule_delayed_work in that case.

Let's add __GFP_NOWARN to the allocation flags to get rid of the
allocator complains for failed allocations:

[22798.508903] The following is only an harmless informational message.
[22798.508909] Unless you get a _continuous_flood_ of these messages it means
[22798.508911] everything is working fine. Allocations from irqs cannot be
[22798.508913] perfectly reliable and the kernel is designed to handle that.
[22798.508917] loop3: page allocation failure. order:0, mode:0x20, alloc_flags:0x30 pflags:0x80208040

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 drivers/net/virtio_net.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 90a23e4..aea1e51 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -477,7 +477,7 @@ again:
 	}
 
 	if (vi->num < vi->max / 2) {
-		if (!try_fill_recv(vi, GFP_ATOMIC))
+		if (!try_fill_recv(vi, GFP_ATOMIC|__GFP_NOWARN))
 			schedule_delayed_work(&vi->refill, 0);
 	}
 
-- 
1.7.2.3


-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
