Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758613Ab1ELUgK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 16:36:10 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:44429 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752729Ab1ELUgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 16:36:08 -0400
Subject: Re: [PATCH] scsi/sd: fix suspend with USB-connected Android phone
 (one line)
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Charles Hannum <root@ihack.net>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-scsi <linux-scsi@vger.kernel.org>, linux-usb@vger.kernel.org
In-Reply-To: <201105122203.13671.rjw@sisk.pl>
References: <BANLkTi=XNyR8GD43GGnMag+=JmhUd_5HtA@mail.gmail.com>
	 <201105122203.13671.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 May 2011 15:36:03 -0500
Message-ID: <1305232563.2575.85.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-12 at 22:03 +0200, Rafael J. Wysocki wrote:
> Hi,
> 
> Added some CCs.
> 
> On Thursday, May 12, 2011, Charles Hannum wrote:
> > Short version: My laptop doesn't suspend when my Android phone is
> > connected and has been “ejected”.
> > 
> > Long version:
> > 
> > Android phones connect as USB mass storage devices.  After the “Turn
> > on USB storage” button has been clicked, there are a few different
> > ways to detach the “disk”:
> > 
> > 1) pull the cable
> > 2) click “Turn off USB storage”
> > 3) “eject” the device
> > 
> > In cases 2 & 3, the USB device is still attached to the system, but
> > will now return MEDIUM NOT PRESENT for many commands, including
> > SYNCHRONIZE CACHE—basically it acts like any device with removable
> > media.  However, the act of the “media” being removed does not
> > invalidate sdkp->WCE; therefore sd_shutdown() and sd_suspend() still
> > call sd_sync_cache(), which *fails* because it gets a MEDIUM NOT
> > PRESENT sense code.  In the sd_suspend() case, this causes the entire
> > suspend to fail, and the laptop rewakes immediately.

So this was the subject of some debate when suspend of sd was first
introduced.  The synopsis of that debate is that by suspending, we're
about the power down the system, and anything in the cache will be lost,
possibly causing corruption, so failure to synchronise the cache
*should* abort suspend.

> > There are a few different ways to fix this; e.g. one could
> > specifically test media_not_present() if a sense code is returned in
> > sd_sync_cache(). 

Isn't this the best approach?  For removable medium, the onus is on the
user not to eject with the cache unsynced.  If the user ignores that, we
should recognise the problem and take a caveat emptor approach.

As a side note: having write through caches on removable media is a
really silly idea because of the above problem ...

>  However, the following patch seems simpler, and
> > avoids calling sd_sync_cache() at all in this case.  sdkp->WCE will be
> > reset when new medium is recognized and sd_read_cache_type() is
> > called.  Note this code always gets called—it's in the same path as
> > sd_read_capacity(), which has to be called for the device to be usable
> > again; thus the patch is inherently safe.
> > 
> > Kernel tested: 2.6.38 (Ubuntu Natty)
> 
> Patch appended for completness.
> 
> I need someone from USB/SCSI camp to see if this approach makes sense.

I don't really think so, because it's pretending the device cache has
flipped to write through.  It's certainly possible to envisage removable
media where the cache is in the housing and we still need to preserve
the idea of it being write back.

Instinct tells me the correct set of fixes is to add a sync cache from
release (so we automatically sync on last close, which is usually when
an ordered remove happens), keep the one on shutdown, just in case the
system goes down with stuff still mounted and print a nasty message on
suspend for a write back device that's been removed.

I also think we shouldn't abort the suspend if the disk doesn't respond
correctly to start/stop ... the power is going to be disconnected
anyway, so it's no issue if the disk spins for a second or so longer.

The problem this is going to cause is double sync on shutdown (once when
final unmount closes the device and once on shutdown) ... do people
agree that's a price worth paying?

Something like this?

James

---
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index e567302..b5c485a 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -408,6 +408,41 @@ static void scsi_disk_put(struct scsi_disk *sdkp)
 	mutex_unlock(&sd_ref_mutex);
 }
 
+static int sd_sync_cache(struct scsi_disk *sdkp)
+{
+	int retries, res;
+	struct scsi_device *sdp = sdkp->device;
+	struct scsi_sense_hdr sshdr;
+
+	if (!scsi_device_online(sdp))
+		return -ENODEV;
+
+
+	for (retries = 3; retries > 0; --retries) {
+		unsigned char cmd[10] = { 0 };
+
+		cmd[0] = SYNCHRONIZE_CACHE;
+		/*
+		 * Leave the rest of the command zero to indicate
+		 * flush everything.
+		 */
+		res = scsi_execute_req(sdp, cmd, DMA_NONE, NULL, 0, &sshdr,
+				       SD_FLUSH_TIMEOUT, SD_MAX_RETRIES, NULL);
+		if (res == 0)
+			break;
+	}
+
+	if (res) {
+		sd_print_result(sdkp, res);
+		if (driver_byte(res) & DRIVER_SENSE)
+			sd_print_sense_hdr(sdkp, &sshdr);
+	}
+
+	if (res)
+		return -EIO;
+	return 0;
+}
+
 static void sd_prot_op(struct scsi_cmnd *scmd, unsigned int dif)
 {
 	unsigned int prot_op = SCSI_PROT_NORMAL;
@@ -897,6 +932,11 @@ static int sd_release(struct gendisk *disk, fmode_t mode)
 			scsi_set_medium_removal(sdev, SCSI_REMOVAL_ALLOW);
 	}
 
+	if (sdkp->WCE) {
+		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
+		sd_sync_cache(sdkp);
+	}
+
 	/*
 	 * XXX and what if there are packets in flight and this close()
 	 * XXX is followed by a "rmmod sd_mod"?
@@ -1093,41 +1133,6 @@ out:
 	return retval;
 }
 
-static int sd_sync_cache(struct scsi_disk *sdkp)
-{
-	int retries, res;
-	struct scsi_device *sdp = sdkp->device;
-	struct scsi_sense_hdr sshdr;
-
-	if (!scsi_device_online(sdp))
-		return -ENODEV;
-
-
-	for (retries = 3; retries > 0; --retries) {
-		unsigned char cmd[10] = { 0 };
-
-		cmd[0] = SYNCHRONIZE_CACHE;
-		/*
-		 * Leave the rest of the command zero to indicate
-		 * flush everything.
-		 */
-		res = scsi_execute_req(sdp, cmd, DMA_NONE, NULL, 0, &sshdr,
-				       SD_FLUSH_TIMEOUT, SD_MAX_RETRIES, NULL);
-		if (res == 0)
-			break;
-	}
-
-	if (res) {
-		sd_print_result(sdkp, res);
-		if (driver_byte(res) & DRIVER_SENSE)
-			sd_print_sense_hdr(sdkp, &sshdr);
-	}
-
-	if (res)
-		return -EIO;
-	return 0;
-}
-
 static void sd_rescan(struct device *dev)
 {
 	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
@@ -2627,15 +2632,19 @@ static int sd_suspend(struct device *dev, pm_message_t mesg)
 		return 0;	/* this can happen */
 
 	if (sdkp->WCE) {
-		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
-		ret = sd_sync_cache(sdkp);
-		if (ret)
-			goto done;
+		if (sdkp->media_present) {
+			sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
+			ret = sd_sync_cache(sdkp);
+			if (ret)
+				goto done;
+		} else {
+			sd_printk(KERN_NOTICE, sdkp, "Disk already ejected, not synchronizing SCSI cache\n");
+		}	
 	}
 
 	if ((mesg.event & PM_EVENT_SLEEP) && sdkp->device->manage_start_stop) {
 		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
-		ret = sd_start_stop_device(sdkp, 0);
+		sd_start_stop_device(sdkp, 0); /* ignore return code */
 	}
 
 done:


