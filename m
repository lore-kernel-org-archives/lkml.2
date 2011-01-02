Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106Ab1ABIKQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 03:10:16 -0500
Received: from mail.windriver.com ([147.11.1.11]:34347 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626Ab1ABHV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:21:56 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 037/260] staging: hv: Fix missing functions for net_device_ops
Date: Sun,  2 Jan 2011 02:15:33 -0500
Message-Id: <1293952756-15010-38-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:20:47.0085 (UTC) FILETIME=[934F69D0:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>

commit b681b5886bb5d1f5b6750a0ed7c62846da7ccea4 upstream.

Fix missing functions for net_device_ops.
It's a bug when porting the drivers from 2.6.27 to 2.6.32. In 2.6.27,
the default functions for Ethernet, like eth_change_mtu(), were assigned
by ether_setup(). But in 2.6.32, these function pointers moved to
net_device_ops structure and no longer be assigned in ether_setup(). So
we need to set these functions in our driver code. It will ensure the
MTU won't be set beyond 1500. Otherwise, this can cause an error on the
server side, because the HyperV linux driver doesn't support jumbo frame
yet.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/staging/hv/netvsc_drv.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
index ab27d9a..91e413e 100644
--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -382,6 +382,9 @@ static const struct net_device_ops device_ops = {
 	.ndo_start_xmit =		netvsc_start_xmit,
 	.ndo_get_stats =		netvsc_get_stats,
 	.ndo_set_multicast_list =	netvsc_set_multicast_list,
+	.ndo_change_mtu =		eth_change_mtu,
+	.ndo_validate_addr =		eth_validate_addr,
+	.ndo_set_mac_address =		eth_mac_addr,
 };
 
 static int netvsc_probe(struct device *device)
-- 
1.7.3.3

