Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932278Ab1GATpU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 15:45:20 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:58548 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932127Ab1GATpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 15:45:14 -0400
Subject: Re: Linux 3.0 oopses when pulling a USB CDROM
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, axboe@kernel.dk,
        rjw@sisk.pl
In-Reply-To: <1309548797.2722.37.camel@mulgrave>
References: <20110701170531.GA3693@tassilo.jf.intel.com>
	 <1309548044.2722.35.camel@mulgrave>  <1309548797.2722.37.camel@mulgrave>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Jul 2011 14:45:12 -0500
Message-ID: <1309549512.2722.41.camel@mulgrave>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-01 at 14:33 -0500, James Bottomley wrote:
> On Fri, 2011-07-01 at 14:20 -0500, James Bottomley wrote:
> > I'll see if I can find the refcounting problem.
> > 
> > Likely it's a longstanding bug which we didn't actually notice until
> > now.
> 
> OK, so it looks like we have correct refcounting on the sr_block ops,
> but not on the actual cdrom ops, so the device is already gone by the
> time the cdrom release function gets called.
> 
> This is my best guess at the fix (just add a get into the cdrom ops),
> does it work?

Actually, forget that.  The cdrom ops open/release is entirely
subordinate to the block one.

unless we have some type of double put, the sdev should be held by
refcount right up until the cdrom code calls cdo->release().  However,
there is one ioctl operation after that, but it's tray_move() not
lock_door().  This should be the fix for that, but if we're oopsing in
lock_door(), it's almost certain we've run into some refcounting
imbalance.

James

---

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 75fb965..512bd31 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -1220,12 +1220,12 @@ void cdrom_release(struct cdrom_device_info *cdi, fmode_t mode)
 	if (CDROM_CAN(CDC_RAM) && !cdi->use_count && cdi->for_data)
 		cdrom_close_write(cdi);
 
-	cdo->release(cdi);
 	if (cdi->use_count == 0) {      /* last process that closes dev*/
 		if (opened_for_data &&
 		    cdi->options & CDO_AUTO_EJECT && CDROM_CAN(CDC_OPEN_TRAY))
 			cdo->tray_move(cdi, 1);
 	}
+	cdo->release(cdi);
 }
 
 static int cdrom_read_mech_status(struct cdrom_device_info *cdi, 


