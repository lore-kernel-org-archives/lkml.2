Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab1GVOWt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 10:22:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32626 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754260Ab1GVOWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 10:22:47 -0400
Message-ID: <4E2987AE.2070707@redhat.com>
Date: Fri, 22 Jul 2011 16:22:38 +0200
From: Zdenek Kabelac <zkabelac@redhat.com>
Organization: Red Hat
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110720 Thunderbird/5.0
MIME-Version: 1.0
To: device-mapper development <dm-devel@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
        Kay Sievers <kay@redhat.com>
Subject: [PATCH] Reduce number of KOBJ_REMOVE events
X-Enigmail-Version: 1.2
Content-Type: multipart/mixed;
 boundary="------------000508090000040508090905"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000508090000040508090905
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit


--------------000508090000040508090905
Content-Type: text/x-patch;
 name="kobj_remove.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="kobj_remove.patch"

Author: Zdenek Kabelac <zkabelac@redhat.com>
Date:   Fri Jul 22 15:02:17 2011 +0200

Reduce number of KOBJ_REMOVE events

For now udev recieves 3 event for removal of DM logical volumes. (1 for
bdi and 2 for same block kobject). Reason is dm device generates its
own kobject event with approriate env parameter and block layer sends
another KOBJ_REMOVE event on its own unconditionaly for the same
kobject. As for now only the kobject cleanup checks that the REMOVE
event has been already sent and avoids duplicate REMOVE event.

The patch for kobject_uevent_env() which has been testing for duplicate
REMOVE event did not passed into the mainline (yet?):

https://www.redhat.com/archives/dm-devel/2010-March/msg00107.html 

I'm proposing alternative way around to always use kobject cleanup
routine for sending REMOVE event if it was not send by the module - so
it makes the code few lines shorter.

This patch removes single appearencies of kobject_uevent() prior
kobject removal.

Signed-off-by:  Zdenek Kabelac <zkabelac@redhat.com>

diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index 129b9e2..431f401 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -439,7 +439,6 @@ void blk_integrity_unregister(struct gendisk *disk)
 
 	bi = disk->integrity;
 
-	kobject_uevent(&bi->kobj, KOBJ_REMOVE);
 	kobject_del(&bi->kobj);
 	kobject_put(&bi->kobj);
 	disk->integrity = NULL;
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index d935bd8..a50472d 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -521,7 +521,6 @@ int blk_register_queue(struct gendisk *disk)
 
 	ret = elv_register_queue(q);
 	if (ret) {
-		kobject_uevent(&q->kobj, KOBJ_REMOVE);
 		kobject_del(&q->kobj);
 		blk_trace_remove_sysfs(dev);
 		kobject_put(&dev->kobj);
@@ -541,7 +540,6 @@ void blk_unregister_queue(struct gendisk *disk)
 	if (q->request_fn)
 		elv_unregister_queue(q);
 
-	kobject_uevent(&q->kobj, KOBJ_REMOVE);
 	kobject_del(&q->kobj);
 	blk_trace_remove_sysfs(disk_to_dev(disk));
 	kobject_put(&disk_to_dev(disk)->kobj);
diff --git a/block/elevator.c b/block/elevator.c
index b0b38ce..a8d912b 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -892,7 +892,6 @@ EXPORT_SYMBOL(elv_register_queue);
 
 static void __elv_unregister_queue(struct elevator_queue *e)
 {
-	kobject_uevent(&e->kobj, KOBJ_REMOVE);
 	kobject_del(&e->kobj);
 	e->registered = 0;
 }
diff --git a/drivers/base/core.c b/drivers/base/core.c
index bc8729d..8c9af0d 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1013,7 +1013,6 @@ done:
  ueventattrError:
 	device_remove_file(dev, &uevent_attr);
  attrError:
-	kobject_uevent(&dev->kobj, KOBJ_REMOVE);
 	kobject_del(&dev->kobj);
  Error:
 	cleanup_device_parent(dev);
@@ -1132,7 +1131,6 @@ void device_del(struct device *dev)
 	 */
 	if (platform_notify_remove)
 		platform_notify_remove(dev);
-	kobject_uevent(&dev->kobj, KOBJ_REMOVE);
 	cleanup_device_parent(dev);
 	kobject_del(&dev->kobj);
 	put_device(parent);
diff --git a/mm/slub.c b/mm/slub.c
index 35f351f..3c77956 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4720,7 +4720,6 @@ static void sysfs_slab_remove(struct kmem_cache *s)
 		 */
 		return;
 
-	kobject_uevent(&s->kobj, KOBJ_REMOVE);
 	kobject_del(&s->kobj);
 	kobject_put(&s->kobj);
 }
diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index 1bacca4..f20a945 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -153,7 +153,6 @@ static void del_nbp(struct net_bridge_port *p)
 
 	br_multicast_del_port(p);
 
-	kobject_uevent(&p->kobj, KOBJ_REMOVE);
 	kobject_del(&p->kobj);
 
 	br_netpoll_disable(p);

--------------000508090000040508090905--
