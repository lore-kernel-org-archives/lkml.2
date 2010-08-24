Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933734Ab0HXXDq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 19:03:46 -0400
Received: from kroah.org ([198.145.64.141]:32843 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933614Ab0HXXDi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 19:03:38 -0400
X-Mailbox-Line: From gregkh@clark.site Tue Aug 24 15:45:10 2010
Message-Id: <20100824224509.954861420@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 24 Aug 2010 15:45:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sven Eckelmann <sven.eckelmann@gmx.de>
Subject: [100/114] Staging: batman-adv: Dont use net_dev after dev_put
In-Reply-To: <20100824224610.GA5424@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sven Eckelmann <sven.eckelmann@gmx.de>

commit 51a00eaf6e008b60943af6ab68c17ac3622208dc upstream.

dev_put allows a device to be freed when all its references are dropped.
After that we are not allowed to access that information anymore. Access
to the data structure of a net_device must be surrounded a dev_hold
and ended using dev_put.

batman-adv adds a device to its own management structure in
hardif_add_interface and will release it in hardif_remove_interface.
Thus it must hold a reference all the time between those functions to
prevent any access to the already released net_device structure.

Reported-by: Tim Glaremin <Tim.Glaremin@web.de>
Signed-off-by: Sven Eckelmann <sven.eckelmann@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/batman-adv/hard-interface.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/staging/batman-adv/hard-interface.c
+++ b/drivers/staging/batman-adv/hard-interface.c
@@ -194,8 +194,6 @@ static void hardif_activate_interface(st
 	if (batman_if->if_status != IF_INACTIVE)
 		return;
 
-	dev_hold(batman_if->net_dev);
-
 	update_mac_addresses(batman_if);
 	batman_if->if_status = IF_TO_BE_ACTIVATED;
 
@@ -222,8 +220,6 @@ static void hardif_deactivate_interface(
 	   (batman_if->if_status != IF_TO_BE_ACTIVATED))
 		return;
 
-	dev_put(batman_if->net_dev);
-
 	batman_if->if_status = IF_INACTIVE;
 
 	printk(KERN_INFO "batman-adv:Interface deactivated: %s\n",
@@ -321,12 +317,14 @@ static struct batman_if *hardif_add_inte
 	if (ret != 1)
 		goto out;
 
+	dev_hold(net_dev);
+
 	batman_if = kmalloc(sizeof(struct batman_if), GFP_ATOMIC);
 	if (!batman_if) {
 		printk(KERN_ERR "batman-adv:"
 		       "Can't add interface (%s): out of memory\n",
 		       net_dev->name);
-		goto out;
+		goto release_dev;
 	}
 
 	batman_if->dev = kstrdup(net_dev->name, GFP_ATOMIC);
@@ -350,6 +348,8 @@ free_dev:
 	kfree(batman_if->dev);
 free_if:
 	kfree(batman_if);
+release_dev:
+	dev_put(net_dev);
 out:
 	return NULL;
 }
@@ -378,6 +378,7 @@ static void hardif_remove_interface(stru
 	batman_if->if_status = IF_TO_BE_REMOVED;
 	list_del_rcu(&batman_if->list);
 	sysfs_del_hardif(&batman_if->hardif_obj);
+	dev_put(batman_if->net_dev);
 	call_rcu(&batman_if->rcu, hardif_free_interface);
 }
 


