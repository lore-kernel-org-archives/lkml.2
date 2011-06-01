Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162479Ab1FAJEK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 05:04:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43475 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162021Ab1FAIRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:17:08 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:04:35 2011
Message-Id: <20110601080433.645288314@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:00:56 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jonathan Nieder <jrnieder@gmail.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [120/146] [media] cx88: fix locking of sub-driver operations
In-Reply-To: <20110601080606.GA522@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jonathan Nieder <jrnieder@gmail.com>

commit 1fe70e963028f34ba5e32488a7870ff4b410b19b upstream.

The BKL conversion of this driver seems to have gone wrong.
Loading the cx88-blackbird driver deadlocks.

The cause: mpeg_ops::open in the cx2388x blackbird driver acquires the
device lock and calls the sub-driver's request_acquire, which tries to
acquire the lock again.  Fix it by clarifying the semantics of
request_acquire, request_release, advise_acquire, and advise_release:
now all will rely on the caller to acquire the device lock.

Based on work by Ben Hutchings <ben@decadent.org.uk>.

Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=31962

Reported-by: Andi Huber <hobrom@gmx.at>
Tested-by: Andi Huber <hobrom@gmx.at>
Tested-by: Marlon de Boer <marlon@hyves.nl>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/cx88/cx88-blackbird.c |    4 ++--
 drivers/media/video/cx88/cx88-dvb.c       |    3 +--
 drivers/media/video/cx88/cx88-mpeg.c      |    4 ----
 drivers/media/video/cx88/cx88.h           |    3 ++-
 4 files changed, 5 insertions(+), 9 deletions(-)

--- a/drivers/media/video/cx88/cx88-blackbird.c
+++ b/drivers/media/video/cx88/cx88-blackbird.c
@@ -1125,13 +1125,13 @@ static int mpeg_release(struct file *fil
 
 	/* Make sure we release the hardware */
 	drv = cx8802_get_driver(dev, CX88_MPEG_BLACKBIRD);
-	mutex_unlock(&dev->core->lock);
-
 	if (drv)
 		drv->request_release(drv);
 
 	atomic_dec(&dev->core->mpeg_users);
 
+	mutex_unlock(&dev->core->lock);
+
 	return 0;
 }
 
--- a/drivers/media/video/cx88/cx88-dvb.c
+++ b/drivers/media/video/cx88/cx88-dvb.c
@@ -134,8 +134,6 @@ static int cx88_dvb_bus_ctrl(struct dvb_
 
 	mutex_lock(&dev->core->lock);
 	drv = cx8802_get_driver(dev, CX88_MPEG_DVB);
-	mutex_unlock(&dev->core->lock);
-
 	if (drv) {
 		if (acquire){
 			dev->frontends.active_fe_id = fe_id;
@@ -145,6 +143,7 @@ static int cx88_dvb_bus_ctrl(struct dvb_
 			dev->frontends.active_fe_id = 0;
 		}
 	}
+	mutex_unlock(&dev->core->lock);
 
 	return ret;
 }
--- a/drivers/media/video/cx88/cx88-mpeg.c
+++ b/drivers/media/video/cx88/cx88-mpeg.c
@@ -624,13 +624,11 @@ static int cx8802_request_acquire(struct
 
 	if (drv->advise_acquire)
 	{
-		mutex_lock(&drv->core->lock);
 		core->active_ref++;
 		if (core->active_type_id == CX88_BOARD_NONE) {
 			core->active_type_id = drv->type_id;
 			drv->advise_acquire(drv);
 		}
-		mutex_unlock(&drv->core->lock);
 
 		mpeg_dbg(1,"%s() Post acquire GPIO=%x\n", __func__, cx_read(MO_GP0_IO));
 	}
@@ -643,14 +641,12 @@ static int cx8802_request_release(struct
 {
 	struct cx88_core *core = drv->core;
 
-	mutex_lock(&drv->core->lock);
 	if (drv->advise_release && --core->active_ref == 0)
 	{
 		drv->advise_release(drv);
 		core->active_type_id = CX88_BOARD_NONE;
 		mpeg_dbg(1,"%s() Post release GPIO=%x\n", __func__, cx_read(MO_GP0_IO));
 	}
-	mutex_unlock(&drv->core->lock);
 
 	return 0;
 }
--- a/drivers/media/video/cx88/cx88.h
+++ b/drivers/media/video/cx88/cx88.h
@@ -500,7 +500,8 @@ struct cx8802_driver {
 	/* Caller must _not_ hold core->lock */
 	int (*probe)(struct cx8802_driver *drv);
 
-	/* Caller must hold core->lock */
+	/* Callers to the following functions must hold core->lock */
+
 	int (*remove)(struct cx8802_driver *drv);
 
 	/* MPEG 8802 -> mini driver - Access for hardware control */


