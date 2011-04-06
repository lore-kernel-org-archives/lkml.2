Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810Ab1DFMUW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 08:20:22 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:58277 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807Ab1DFMUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 08:20:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=OSGvFAORtGPW1AAluJAGkwt39rxnDRpUPqNxgHNZE4ErnMM9cDgw6+Na9xJKHwrfxz
         YZG+LKDMuDI/kqXpsSSVwMgYUlUEJiYqNuUnhDKLPJPw4fhEMA/1npZq5L0Lb7KypvA5
         RMCRdyyBYxsgrJP59UdV49O7XC9rtXZttxlv8=
Date: Wed, 6 Apr 2011 05:20:09 -0700
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Amit Shah <amit.shah@redhat.com>, David Zeuthen <zeuthen@gmail.com>,
        Martin Pitt <martin.pitt@ubuntu.com>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] cdrom: always check_disk_change() on open
Message-ID: <20110406121920.GC4142@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cdrom_open() called check_disk_change() after the rest of open path
succeeded which leads to the following bizarre behavior.

* After media change, if the device opened without O_NONBLOCK,
  open_for_data() naturally fails with -ENOMEDIA and
  check_disk_change() is never called.  The media is known to be gone
  and the open failure makes it obvious to the userland but device
  invalidation never happens.

* But if the device is opened with O_NONBLOCK, all the checks are
  bypassed and cdrom_open() doesn't notice that the media is not there
  and check_disk_change() is called and invalidation happens.

There's nothing to be gained by avoiding calling check_disk_change()
on open failure.  Common cases end up calling check_disk_change()
anyway.  All we get is inconsistent behavior.

Fix it by moving check_disk_change() invocation to the top of
cdrom_open() so that it always gets called regardless of how the rest
of open proceeds.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Amit Shah <amit.shah@redhat.com>
Tested-by: Amit Shah <amit.shah@redhat.com>
---
 drivers/cdrom/cdrom.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index e2c48a7..5ade78a 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -986,6 +986,9 @@ int cdrom_open(struct cdrom_device_info *cdi, struct block_device *bdev, fmode_t
 
 	cdinfo(CD_OPEN, "entering cdrom_open\n"); 
 
+	/* open is event synchronization point, check events first */
+	check_disk_change(bdev);
+
 	/* if this was a O_NONBLOCK open and we should honor the flags,
 	 * do a quick open without drive/disc integrity checks. */
 	cdi->use_count++;
@@ -1012,9 +1015,6 @@ int cdrom_open(struct cdrom_device_info *cdi, struct block_device *bdev, fmode_t
 
 	cdinfo(CD_OPEN, "Use count for \"/dev/%s\" now %d\n",
 			cdi->name, cdi->use_count);
-	/* Do this on open.  Don't wait for mount, because they might
-	    not be mounting, but opening with O_NONBLOCK */
-	check_disk_change(bdev);
 	return 0;
 err_release:
 	if (CDROM_CAN(CDC_LOCK) && cdi->options & CDO_LOCK) {
