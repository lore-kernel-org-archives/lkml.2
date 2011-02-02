Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab1BBAoj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:44:39 -0500
Received: from mga11.intel.com ([192.55.52.93]:8119 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753513Ab1BBAob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:44:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="883418195"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: kilroyd@googlemail.com, linville@tuxdriver.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [84/139] orinoco: clear countermeasure setting on commit
Message-Id: <20110202004441.AD5743E09C6@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:44:41 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: David Kilroy <kilroyd@googlemail.com>

commit ba34fcee476d11e7c9df95932787a22a96ff6e68 upstream.

... and interface up.

In these situations, you are usually trying to connect to a new AP, so
keeping TKIP countermeasures active is confusing. This is already how
the driver behaves (inadvertently). However, querying SIOCGIWAUTH may
tell userspace that countermeasures are active when they aren't.

Clear the setting so that the reporting matches what the driver has
done..

Signed-off by: David Kilroy <kilroyd@googlemail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/net/wireless/orinoco/main.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux-2.6.35.y/drivers/net/wireless/orinoco/main.c
===================================================================
--- linux-2.6.35.y.orig/drivers/net/wireless/orinoco/main.c
+++ linux-2.6.35.y/drivers/net/wireless/orinoco/main.c
@@ -1813,6 +1813,12 @@ static int __orinoco_commit(struct orino
 	struct net_device *dev = priv->ndev;
 	int err = 0;
 
+	/* If we've called commit, we are reconfiguring or bringing the
+	 * interface up. Maintaining countermeasures across this would
+	 * be confusing, so note that we've disabled them. The port will
+	 * be enabled later in orinoco_commit or __orinoco_up. */
+	priv->tkip_cm_active = 0;
+
 	err = orinoco_hw_program_rids(priv);
 
 	/* FIXME: what about netif_tx_lock */
