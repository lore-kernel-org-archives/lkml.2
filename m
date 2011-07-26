Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807Ab1GZPsS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 11:48:18 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:47811 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750Ab1GZPsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 11:48:11 -0400
Subject: Re: [dm-devel] [PATCH] Reduce number of KOBJ_REMOVE events
From: Kay Sievers <kay.sievers@vrfy.org>
To: Zdenek Kabelac <zkabelac@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Greg KH <greg@kroah.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 26 Jul 2011 17:48:06 +0200
In-Reply-To: <CAPXgP12y2bPiGTJEpDQpwztUoooXX1DB=F8=VWzjop5roMhhhQ@mail.gmail.com>
References: <4E2987AE.2070707@redhat.com> <1311553130.1671.21.camel@mop>
	 <4E2D4177.9000402@redhat.com>
	 <CAPXgP101Jr3-k4p8ow-F3Phq+fNmC1eR8LD+j609xBvGfd1cUg@mail.gmail.com>
	 <4E2D678E.2010209@redhat.com>
	 <CAPXgP12y2bPiGTJEpDQpwztUoooXX1DB=F8=VWzjop5roMhhhQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1311695289.1325.9.camel@mop>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-25 at 16:22 +0200, Kay Sievers wrote:
> On Mon, Jul 25, 2011 at 14:54, Zdenek Kabelac <zkabelac@redhat.com> wrote:
> > Dne 25.7.2011 14:17, Kay Sievers napsal(a):
> 
> >>>> Then have 'dm_blk_dops' add '.uevent' and let the core call into the dm
> >>>> code to the needed properties to the 'remove' event, instead of sending
> >>>> its own, and see the duplication.
> >>>
> >>> Sounds like complex solution
> >>
> >> I don't think so, It's clean, ~30 lines long, and technically correct, I expect.
> 
> In include/linux/blkdev.h add:
>   int (*uevent) (struct gendisk *, struct kobj_uevent_env *env);
> to
>   struct block_device_operations
> 
> In block/genhd.c add:
>   .uevent = block_uevent;
> to
>   struct class block_class
> and have the block_uevent() callback check for an existing uevent() in
> the block_device_operations, call it when it's specified.
> 
> In drivers/md/dm.c add:
>   .dm_uevent;
> to
>   struct block_device_operations dm_blk_dops
> and add all the needed variables there, instead of sending out a faked
> device 'remove' event.

Here is the code to illustrate, and fix the issue of needing to send any
'remove' for a device from a driver.

Thanks,
Kay


diff --git a/block/genhd.c b/block/genhd.c
index 6024b82..c2e9714 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1097,8 +1097,21 @@ static void disk_release(struct device *dev)
 	free_part_info(&disk->part0);
 	kfree(disk);
 }
+
+static int block_uevent(struct device *dev, struct kobj_uevent_env *env)
+{
+	struct gendisk *disk = dev_to_disk(dev);
+
+	if (!disk->fops)
+		return 0;
+	if (disk->fops->uevent)
+		return disk->fops->uevent(disk, env);
+	return 0;
+}
+
 struct class block_class = {
 	.name		= "block",
+	.dev_uevent	= block_uevent,
 };
 
 static char *block_devnode(struct device *dev, mode_t *mode)
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 0cf68b4..22e486e 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2682,11 +2682,17 @@ void dm_free_md_mempools(struct dm_md_mempools *pools)
 	kfree(pools);
 }
 
+static int dm_uevent(struct gendisk *disk, struct kobj_uevent_env *env)
+{
+	return add_uevent_var(env, "COOKIE_MONSTER=1");
+}
+
 static const struct block_device_operations dm_blk_dops = {
 	.open = dm_blk_open,
 	.release = dm_blk_close,
 	.ioctl = dm_blk_ioctl,
 	.getgeo = dm_blk_getgeo,
+	.uevent = dm_uevent,
 	.owner = THIS_MODULE
 };
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 1a23722..6dbd69e 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1300,6 +1300,7 @@ struct block_device_operations {
 						void **, unsigned long *);
 	unsigned int (*check_events) (struct gendisk *disk,
 				      unsigned int clearing);
+	int (*uevent) (struct gendisk *, struct kobj_uevent_env *env);
 	/* ->media_changed() is DEPRECATED, use ->check_events() instead */
 	int (*media_changed) (struct gendisk *);
 	void (*unlock_native_capacity) (struct gendisk *);


