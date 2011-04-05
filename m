Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683Ab1DED2H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 23:28:07 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:62148 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443Ab1DED2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 23:28:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YkxBAbiVhvH6Iv0hapZy1Ouqf93GUCuAiKZOE7sripmOxFV22SCER2J+4lxDr/xmkQ
         MlY+A/32TfcJuQp+LqIZuFuN+/UH40OfkeU71A0cvXKnbt5d9vPj1ujg6TuaEz7Tftyh
         OQamQxrJrM30HToB5FUUSM9dgSnna8QcBA0O8=
Date: Mon, 4 Apr 2011 22:27:57 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: linux-media@vger.kernel.org
Cc: Huber Andreas <hobrom@corax.at>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-kernel@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>,
        Steven Toth <stoth@kernellabs.com>
Subject: [PATCH 4/7] [media] cx88: use a mutex to protect cx8802_devlist
Message-ID: <20110405032757.GE4498@elie>
References: <20110327150610.4029.95961.reportbug@xen.corax.at>
 <20110327152810.GA32106@elie>
 <20110402093856.GA17015@elie>
 <20110405032014.GA4498@elie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110405032014.GA4498@elie>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add and use a mutex to protect the cx88-mpeg device list.  Previously
the BKL prevented races.

Based on a patch by Ben Hutchings <ben@decadent.org.uk>.

Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
---
 drivers/media/video/cx88/cx88-mpeg.c |   20 +++++++++++++++++---
 1 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/cx88/cx88-mpeg.c b/drivers/media/video/cx88/cx88-mpeg.c
index 497f26f..b18f9fe 100644
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
@@ -722,7 +727,10 @@ int cx8802_register_driver(struct cx8802_driver *drv)
 		mutex_unlock(&drv->core->lock);
 	}
 
-	return i ? 0 : -ENODEV;
+	err = i ? 0 : -ENODEV;
+out:
+	mutex_unlock(&cx8802_mutex);
+	return err;
 }
 
 int cx8802_unregister_driver(struct cx8802_driver *drv)
@@ -736,6 +744,8 @@ int cx8802_unregister_driver(struct cx8802_driver *drv)
 	       drv->type_id == CX88_MPEG_DVB ? "dvb" : "blackbird",
 	       drv->hw_access == CX8802_DRVCTL_SHARED ? "shared" : "exclusive");
 
+	mutex_lock(&cx8802_mutex);
+
 	list_for_each_entry(dev, &cx8802_devlist, devlist) {
 		printk(KERN_INFO
 		       "%s/2: subsystem: %04x:%04x, board: %s [card=%d]\n",
@@ -762,6 +772,8 @@ int cx8802_unregister_driver(struct cx8802_driver *drv)
 		mutex_unlock(&dev->core->lock);
 	}
 
+	mutex_unlock(&cx8802_mutex);
+
 	return err;
 }
 
@@ -799,7 +811,9 @@ static int __devinit cx8802_probe(struct pci_dev *pci_dev,
 		goto fail_free;
 
 	INIT_LIST_HEAD(&dev->drvlist);
+	mutex_lock(&cx8802_mutex);
 	list_add_tail(&dev->devlist,&cx8802_devlist);
+	mutex_unlock(&cx8802_mutex);
 
 	/* now autoload cx88-dvb or cx88-blackbird */
 	request_modules(dev);
-- 
1.7.5.rc0

