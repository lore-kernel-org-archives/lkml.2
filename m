Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758550Ab1ELUCl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 16:02:41 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46694 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753338Ab1ELUCj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 16:02:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Charles Hannum <root@ihack.net>
Subject: Re: [PATCH] scsi/sd: fix suspend with USB-connected Android phone (one line)
Date: Thu, 12 May 2011 22:03:13 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc7+; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, "Greg Kroah-Hartman" <gregkh@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        "linux-scsi" <linux-scsi@vger.kernel.org>, linux-usb@vger.kernel.org
References: <BANLkTi=XNyR8GD43GGnMag+=JmhUd_5HtA@mail.gmail.com>
In-Reply-To: <BANLkTi=XNyR8GD43GGnMag+=JmhUd_5HtA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201105122203.13671.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Added some CCs.

On Thursday, May 12, 2011, Charles Hannum wrote:
> Short version: My laptop doesn't suspend when my Android phone is
> connected and has been “ejected”.
> 
> Long version:
> 
> Android phones connect as USB mass storage devices.  After the “Turn
> on USB storage” button has been clicked, there are a few different
> ways to detach the “disk”:
> 
> 1) pull the cable
> 2) click “Turn off USB storage”
> 3) “eject” the device
> 
> In cases 2 & 3, the USB device is still attached to the system, but
> will now return MEDIUM NOT PRESENT for many commands, including
> SYNCHRONIZE CACHE—basically it acts like any device with removable
> media.  However, the act of the “media” being removed does not
> invalidate sdkp->WCE; therefore sd_shutdown() and sd_suspend() still
> call sd_sync_cache(), which *fails* because it gets a MEDIUM NOT
> PRESENT sense code.  In the sd_suspend() case, this causes the entire
> suspend to fail, and the laptop rewakes immediately.
> 
> There are a few different ways to fix this; e.g. one could
> specifically test media_not_present() if a sense code is returned in
> sd_sync_cache().  However, the following patch seems simpler, and
> avoids calling sd_sync_cache() at all in this case.  sdkp->WCE will be
> reset when new medium is recognized and sd_read_cache_type() is
> called.  Note this code always gets called—it's in the same path as
> sd_read_capacity(), which has to be called for the device to be usable
> again; thus the patch is inherently safe.
> 
> Kernel tested: 2.6.38 (Ubuntu Natty)

Patch appended for completness.

I need someone from USB/SCSI camp to see if this approach makes sense.

Thanks,
Rafael


--- linux-2.6.38/drivers/scsi/sd.c.orig	2011-05-11 18:08:44.969497976 -0400
+++ linux-2.6.38/drivers/scsi/sd.c	2011-05-11 15:26:15.439610760 -0400
@@ -996,6 +996,7 @@
 	if (sdkp->device->removable) {
 		sdkp->media_present = 0;
 		sdkp->capacity = 0;
+		sdkp->WCE = 0;
 	}
 }
 
