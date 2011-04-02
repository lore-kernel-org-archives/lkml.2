Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643Ab1DBJmE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 05:42:04 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:64417 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096Ab1DBJmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 05:42:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ibSRiHgeRYbeFc5Jn0Xrs9Aid7I28qo1y/AApcJ6NuVV9N5Bwf8drTjX2Vw941SbSu
         aXusrnDHvLx++qbeClbWNwze7C6NjrxZcqruUe5VJLybAgygJAz5pqLqOHY4/CcSpBpQ
         bKXMXoK5uhH5wX9yHpVu5HKC6dZBgwstvyap4=
Date: Sat, 2 Apr 2011 04:41:55 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: linux-media@vger.kernel.org
Cc: Huber Andreas <hobrom@corax.at>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-kernel@vger.kernel.org,
        andrew.walker27@ntlworld.com, Ben Hutchings <ben@decadent.org.uk>,
        Trent Piepho <xyzzy@speakeasy.org>
Subject: [PATCH 2/3] [media] cx88: fix locking of sub-driver operations
Message-ID: <20110402094155.GC17015@elie>
References: <20110327150610.4029.95961.reportbug@xen.corax.at>
 <20110327152810.GA32106@elie>
 <20110402093856.GA17015@elie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110402093856.GA17015@elie>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>
Date: Tue, 29 Mar 2011 03:25:15 +0100

The BKL conversion of this family of drivers seems to have gone wrong.
Opening cx88-blackbird will deadlock.  Various other uses of the
sub-device and driver lists appear to be subject to race conditions.

In particular, mpeg_ops::open in the cx2388x blackbird driver acquires
the device lock and then calls the drivers' request_acquire, which
tries to acquire the lock again --- deadlock.  Fix it by clarifying
the semantics of request_acquire, request_release, advise_acquire, and
advise_release: all require the caller to hold the device lock now.

[jn: split from a larger patch, with new commit message]

Reported-by: Andi Huber <hobrom@gmx.at>
Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=31962
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
Cc: stable@kernel.org
---
 drivers/media/video/cx88/cx88-blackbird.c |    9 ++-------
 drivers/media/video/cx88/cx88-dvb.c       |    8 +-------
 drivers/media/video/cx88/cx88-mpeg.c      |    4 ----
 drivers/media/video/cx88/cx88.h           |    3 ++-
 4 files changed, 5 insertions(+), 19 deletions(-)

diff --git a/drivers/media/video/cx88/cx88-blackbird.c b/drivers/media/video/cx88/cx88-blackbird.c
index 85910c6..a6f7d53 100644
--- a/drivers/media/video/cx88/cx88-blackbird.c
+++ b/drivers/media/video/cx88/cx88-blackbird.c
@@ -1125,18 +1125,13 @@ static int mpeg_release(struct file *file)
 
 	/* Make sure we release the hardware */
 	drv = cx8802_get_driver(dev, CX88_MPEG_BLACKBIRD);
-	mutex_unlock(&dev->core->lock);
-
-	/*
-	 * NEEDSWORK: the driver can be yanked from under our feet.
-	 * The following really ought to be protected with core->lock.
-	 */
-
 	if (drv)
 		drv->request_release(drv);
 
 	atomic_dec(&dev->core->mpeg_users);
 
+	mutex_unlock(&dev->core->lock);
+
 	return 0;
 }
 
diff --git a/drivers/media/video/cx88/cx88-dvb.c b/drivers/media/video/cx88/cx88-dvb.c
index 5d0f947..c69df7e 100644
--- a/drivers/media/video/cx88/cx88-dvb.c
+++ b/drivers/media/video/cx88/cx88-dvb.c
@@ -135,13 +135,6 @@ static int cx88_dvb_bus_ctrl(struct dvb_frontend* fe, int acquire)
 
 	mutex_lock(&dev->core->lock);
 	drv = cx8802_get_driver(dev, CX88_MPEG_DVB);
-	mutex_unlock(&dev->core->lock);
-
-	/*
-	 * NEEDSWORK: The driver can be yanked from under our feet now.
-	 * We ought to keep holding core->lock during the below.
-	 */
-
 	if (drv) {
 		if (acquire){
 			dev->frontends.active_fe_id = fe_id;
@@ -151,6 +144,7 @@ static int cx88_dvb_bus_ctrl(struct dvb_frontend* fe, int acquire)
 			dev->frontends.active_fe_id = 0;
 		}
 	}
+	mutex_unlock(&dev->core->lock);
 
 	return ret;
 }
diff --git a/drivers/media/video/cx88/cx88-mpeg.c b/drivers/media/video/cx88/cx88-mpeg.c
index 918172b..9147c16 100644
--- a/drivers/media/video/cx88/cx88-mpeg.c
+++ b/drivers/media/video/cx88/cx88-mpeg.c
@@ -624,13 +624,11 @@ static int cx8802_request_acquire(struct cx8802_driver *drv)
 
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
@@ -643,14 +641,12 @@ static int cx8802_request_release(struct cx8802_driver *drv)
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
diff --git a/drivers/media/video/cx88/cx88.h b/drivers/media/video/cx88/cx88.h
index e3d56c2..9731daa 100644
--- a/drivers/media/video/cx88/cx88.h
+++ b/drivers/media/video/cx88/cx88.h
@@ -510,7 +510,8 @@ struct cx8802_driver {
 	/* Caller must _not_ hold core->lock */
 	int (*probe)(struct cx8802_driver *drv);
 
-	/* Caller must hold core->lock */
+	/* Callers to the following functions must hold core->lock */
+
 	int (*remove)(struct cx8802_driver *drv);
 
 	/* MPEG 8802 -> mini driver - Access for hardware control */
-- 
1.7.5.rc0

