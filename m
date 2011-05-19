Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934182Ab1ESSJl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:09:41 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:41930 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934148Ab1ESSJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:09:33 -0400
X-Sasl-enc: ILgkeaFsvVgQ8cyrd1sCZ1U5ik+/D3NlJty0JAEcjnuG 1305828572
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May 19 11:06:00 2011
Message-Id: <20110519180600.592807818@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 19 May 2011 11:05:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tejun Heo <tj@kernel.org>, Jens Axboe <jaxboe@fusionio.com>
Subject: [66/71] cdrom: always check_disk_change() on open
In-Reply-To: <20110519180626.GA16555@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tejun Heo <tj@kernel.org>

commit bf2253a6f00e8fea5b026e471e9f0d0a1b3621f2 upstream.

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

Stable: 2.6.38

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Amit Shah <amit.shah@redhat.com>
Tested-by: Amit Shah <amit.shah@redhat.com>
Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/cdrom/cdrom.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -986,6 +986,9 @@ int cdrom_open(struct cdrom_device_info
 
 	cdinfo(CD_OPEN, "entering cdrom_open\n"); 
 
+	/* open is event synchronization point, check events first */
+	check_disk_change(bdev);
+
 	/* if this was a O_NONBLOCK open and we should honor the flags,
 	 * do a quick open without drive/disc integrity checks. */
 	cdi->use_count++;
@@ -1012,9 +1015,6 @@ int cdrom_open(struct cdrom_device_info
 
 	cdinfo(CD_OPEN, "Use count for \"/dev/%s\" now %d\n",
 			cdi->name, cdi->use_count);
-	/* Do this on open.  Don't wait for mount, because they might
-	    not be mounting, but opening with O_NONBLOCK */
-	check_disk_change(bdev);
 	return 0;
 err_release:
 	if (CDROM_CAN(CDC_LOCK) && cdi->options & CDO_LOCK) {


