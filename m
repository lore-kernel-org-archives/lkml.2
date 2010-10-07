Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008Ab0JGVKY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 17:10:24 -0400
Received: from smtp.outflux.net ([198.145.64.163]:57572 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751180Ab0JGVKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 17:10:23 -0400
Date: Thu, 7 Oct 2010 14:10:04 -0700
From: Kees Cook <kees.cook@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Jeff Garzik <jgarzik@redhat.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        netdev@vger.kernel.org
Subject: [PATCH] net: clear heap allocations for privileged ethtool actions
Message-ID: <20101007211004.GA20267@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several other ethtool functions leave heap uncleared (potentially) by
drivers. Some interfaces appear safe (eeprom, etc), in that the sizes
are well controlled. In some situations (e.g. unchecked error conditions),
the heap will remain unchanged in areas before copying back to userspace.
Note that these are less of an issue since these all require CAP_NET_ADMIN.

Cc: stable@kernel.org
Signed-off-by: Kees Cook <kees.cook@canonical.com>
---
 net/core/ethtool.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/core/ethtool.c b/net/core/ethtool.c
index 7a85367..fb9cf30 100644
--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -397,7 +397,7 @@ static noinline_for_stack int ethtool_get_rxfh_indir(struct net_device *dev,
 	    (KMALLOC_MAX_SIZE - sizeof(*indir)) / sizeof(*indir->ring_index))
 		return -ENOMEM;
 	full_size = sizeof(*indir) + sizeof(*indir->ring_index) * table_size;
-	indir = kmalloc(full_size, GFP_USER);
+	indir = kzalloc(full_size, GFP_USER);
 	if (!indir)
 		return -ENOMEM;
 
@@ -538,7 +538,7 @@ static int ethtool_get_rx_ntuple(struct net_device *dev, void __user *useraddr)
 
 	gstrings.len = ret;
 
-	data = kmalloc(gstrings.len * ETH_GSTRING_LEN, GFP_USER);
+	data = kzalloc(gstrings.len * ETH_GSTRING_LEN, GFP_USER);
 	if (!data)
 		return -ENOMEM;
 
@@ -775,7 +775,7 @@ static int ethtool_get_regs(struct net_device *dev, char __user *useraddr)
 	if (regs.len > reglen)
 		regs.len = reglen;
 
-	regbuf = kmalloc(reglen, GFP_USER);
+	regbuf = kzalloc(reglen, GFP_USER);
 	if (!regbuf)
 		return -ENOMEM;
 
-- 
1.7.1

-- 
Kees Cook
Ubuntu Security Team
