Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203Ab1FPHEp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:04:45 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:58863 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756076Ab1FPHBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:01:42 -0400
X-Sasl-enc: UfCORiwiai0Xp9etrpkh2Jd/GG6b7bwAhvmV1Ayr2fTH 1308207701
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:02:36 2011
Message-Id: <20110616000236.643868294@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:00:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mitch Williams <mitch.a.williams@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [78/89] igb: fix i350 SR-IOV failture
In-Reply-To: <20110616000258.GA14529@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: "Williams, Mitch A" <mitch.a.williams@intel.com>

commit 665c8c8ee405738375b679246b49342ce38ba056 upstream.

When SR-IOV is enabled, i350 devices fail to pass traffic. This is due to
the driver attempting to enable RSS on the PF device, which is not
supported by the i350.

When max_vfs is specified on an i350 adapter, set the number of RSS queues
to 1.

This issue affects 2.6.39 as well.

Signed-off-by: Mitch Williams <mitch.a.williams@intel.com>
Tested-by: Jeff Pieper <jeffrey.e.pieper@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/igb/igb_main.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/igb/igb_main.c
+++ b/drivers/net/igb/igb_main.c
@@ -2372,6 +2372,9 @@ static int __devinit igb_sw_init(struct
 	}
 #endif /* CONFIG_PCI_IOV */
 	adapter->rss_queues = min_t(u32, IGB_MAX_RX_QUEUES, num_online_cpus());
+	/* i350 cannot do RSS and SR-IOV at the same time */
+	if (hw->mac.type == e1000_i350 && adapter->vfs_allocated_count)
+		adapter->rss_queues = 1;
 
 	/*
 	 * if rss_queues > 4 or vfs are going to be allocated with rss_queues


