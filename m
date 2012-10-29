Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759595Ab2J2PrW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 11:47:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41545 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753743Ab2J2PrU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 11:47:20 -0400
Date: Mon, 29 Oct 2012 17:49:32 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Ian Campbell <Ian.Campbell@citrix.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/8] enable/disable zero copy tx dynamically
Message-ID: <cover.1351524501.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


tun supports zero copy transmit since 0690899b4d4501b3505be069b9a687e68ccbe15b,
however you can only enable this mode if you know your workload does not
trigger heavy guest to host/host to guest traffic - otherwise you
get a (minor) performance regression.
This patchset addresses this problem by notifying the owner
device when callback is invoked because of a data copy.
This makes it possible to detect whether zero copy is appropriate
dynamically: we start in zero copy mode, when we detect
data copied we disable zero copy for a while.

With this patch applied, I get the same performance for
guest to host and guest to guest both with and without zero copy tx.

Michael S. Tsirkin (8):
  skb: report completion status for zero copy skbs
  skb: api to report errors for zero copy skbs
  tun: report orphan frags errors to zero copy callback
  vhost-net: cleanup macros for DMA status tracking
  vhost: track zero copy failures using DMA length
  vhost: move -net specific code out
  vhost-net: select tx zero copy dynamically
  vhost-net: reduce vq polling on tx zerocopy

 drivers/net/tun.c         |   1 +
 drivers/vhost/net.c       | 109 +++++++++++++++++++++++++++++++++++++++++++---
 drivers/vhost/tcm_vhost.c |   1 +
 drivers/vhost/vhost.c     |  52 +++-------------------
 drivers/vhost/vhost.h     |  11 ++---
 include/linux/skbuff.h    |   5 ++-
 net/core/skbuff.c         |  23 +++++++++-
 7 files changed, 141 insertions(+), 61 deletions(-)

-- 
MST
