Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933721Ab0HXXDo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:03:44 -0400
Received: from kroah.org ([198.145.64.141]:32837 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933677Ab0HXXDh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 19:03:37 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:45:09 2010
Message-Id: <20100824224509.865906342@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:45:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sven Eckelmann <sven.eckelmann@gmx.de>
Subject: [099/114] Staging: batman-adv: Create batman_if only on register event
In-Reply-To: <20100824224610.GA5424@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sven Eckelmann <sven.eckelmann@gmx.de>

commit 1189f130f89b73eecb6117c0fc5e90abbcb7faa0 upstream.

We try to get all events for all net_devices to be able to add special
sysfs folders for the batman-adv configuration. This also includes such
events like NETDEV_POST_INIT which has no valid kobject according to
v2.6.32-rc3-13-g7ffbe3f. This would create an oops in that situation.

It is enough to create the batman_if only on NETDEV_REGISTER events
because we will also receive those events for devices which already
existed when we registered the notifier call.

Signed-off-by: Sven Eckelmann <sven.eckelmann@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/batman-adv/hard-interface.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/staging/batman-adv/hard-interface.c
+++ b/drivers/staging/batman-adv/hard-interface.c
@@ -397,15 +397,13 @@ static int hard_if_event(struct notifier
 	/* FIXME: each batman_if will be attached to a softif */
 	struct bat_priv *bat_priv = netdev_priv(soft_device);
 
-	if (!batman_if)
-		batman_if = hardif_add_interface(net_dev);
+	if (!batman_if && event == NETDEV_REGISTER)
+			batman_if = hardif_add_interface(net_dev);
 
 	if (!batman_if)
 		goto out;
 
 	switch (event) {
-	case NETDEV_REGISTER:
-		break;
 	case NETDEV_UP:
 		hardif_activate_interface(bat_priv, batman_if);
 		break;


