Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730Ab1AFAoU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:44:20 -0500
Received: from kroah.org ([198.145.64.141]:35870 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754456Ab1AFAac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:30:32 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:05 2011
Message-Id: <20110106002305.333910795@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:23:09 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [090/152] orinoco: clear countermeasure setting on commit
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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

---
 drivers/net/wireless/orinoco/main.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/net/wireless/orinoco/main.c
+++ b/drivers/net/wireless/orinoco/main.c
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


