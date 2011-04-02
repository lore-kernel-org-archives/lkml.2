Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976Ab1DBJo6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 05:44:58 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62838 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755825Ab1DBJo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 05:44:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SFqW3W4QmMu/EQ5Ei8egH2KEGZ+aQGy+T24RNrEP61qjGifs5htgsPxeYAbQbHntx3
         VbLt356KU+REO6I1hQhsOk6fBeu7GEK1FLeNdyA3dEdqaq1xjR/4OcowJYh042X6gCR4
         5vWB1dIeEYlsjZaec5U7oG6KYlJuBR8bvP8og=
Date: Sat, 2 Apr 2011 04:44:51 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: linux-media@vger.kernel.org
Cc: Huber Andreas <hobrom@corax.at>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-kernel@vger.kernel.org,
        andrew.walker27@ntlworld.com, Ben Hutchings <ben@decadent.org.uk>,
        Trent Piepho <xyzzy@speakeasy.org>
Subject: [PATCH 3/3] [media] cx88: use a mutex to protect cx8802_devlist
Message-ID: <20110402094451.GD17015@elie>
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

Add and use a mutex to protect the cx88-mpeg device list.  Previously
the BKL prevented races.

[jn: split from a larger patch, with new commit message; also protect
 use in cx8802_probe]

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
---
That's the end of the series.  Hopefully I haven't mangled the patches
too much --- if we're lucky they might even still work, though I
wouldn't bet on it.  Bug reports and improvements welcome.

Good night,
Jonathan

 drivers/media/video/cx88/cx88-mpeg.c |   20 +++++++++++++++++---
 1 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/cx88/cx88-mpeg.c b/drivers/media/video/cx88/cx88-mpeg.c
index 9147c16..6b58647 100644
--- a/drivers/media/video/cx88/cx88-mpeg.c
+++ b/drivers/media/video/cx88/cx88-mpeg.c
@@ -78,6 +78,7 @@ static void flush_request_modules(struct cx8802_dev *dev)
 
 
 static LIST_HEAD(cx8802_devlist);
+static DEFINE_MUTEX(cx8802_mutex);
 /* ------------------------------------------------------------------ */
 
 static int cx8802_start_dma(struct cx8802_dev    *dev,
@@ -689,6 +690,8 @@ int cx8802_register_driver(struct cx8802_driver *drv)
 		return err;
 	}
 
+	mutex_lock(&cx8802_mutex);
+
 	list_for_each_entry(dev, &cx8802_devlist, devlist) {
 		printk(KERN_INFO
 		       "%s/2: subsystem: %04x:%04x, board: %s [card=%d]\n",
@@ -698,8 +701,10 @@ int cx8802_register_driver(struct cx8802_driver *drv)
 
 		/* Bring up a new struct for each driver instance */
 		driver = kzalloc(sizeof(*drv),GFP_KERNEL);
-		if (driver == NULL)
-			return -ENOMEM;
+		if (driver == NULL) {
+			err = -ENOMEM;
+			goto out;
+		}
 
 		/* Snapshot of the driver registration data */
 		drv->core = dev->core;
@@ -723,7 +728,10 @@ int cx8802_register_driver(struct cx8802_driver *drv)
 
 	}
 
-	return i ? 0 : -ENODEV;
+	err = i ? 0 : -ENODEV;
+out:
+	mutex_unlock(&cx8802_mutex);
+	return err;
 }
 
 int cx8802_unregister_driver(struct cx8802_driver *drv)
@@ -737,6 +745,8 @@ int cx8802_unregister_driver(struct cx8802_driver *drv)
 	       drv->type_id == CX88_MPEG_DVB ? "dvb" : "blackbird",
 	       drv->hw_access == CX8802_DRVCTL_SHARED ? "shared" : "exclusive");
 
+	mutex_lock(&cx8802_mutex);
+
 	list_for_each_entry(dev, &cx8802_devlist, devlist) {
 		printk(KERN_INFO
 		       "%s/2: subsystem: %04x:%04x, board: %s [card=%d]\n",
@@ -763,6 +773,8 @@ int cx8802_unregister_driver(struct cx8802_driver *drv)
 		mutex_unlock(&dev->core->lock);
 	}
 
+	mutex_unlock(&cx8802_mutex);
+
 	return err;
 }
 
@@ -800,7 +812,9 @@ static int __devinit cx8802_probe(struct pci_dev *pci_dev,
 		goto fail_free;
 
 	INIT_LIST_HEAD(&dev->drvlist);
+	mutex_lock(&cx8802_mutex);
 	list_add_tail(&dev->devlist,&cx8802_devlist);
+	mutex_unlock(&cx8802_mutex);
 
 	/* now autoload cx88-dvb or cx88-blackbird */
 	request_modules(dev);
-- 
1.7.5.rc0

