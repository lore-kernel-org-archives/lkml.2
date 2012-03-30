Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936663Ab2C3W5y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:57:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33001 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934905Ab2C3VFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:05:39 -0400
Message-Id: <20120330195729.293910591@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:58:12 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, NeilBrown <neilb@suse.de>
Subject: [ 050/108] md/bitmap: ensure to load bitmap when creating via sysfs.
In-Reply-To: <20120330195812.GA31833@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit 4474ca42e2577563a919fd3ed782e2ec55bf11a2 upstream.

When commit 69e51b449d383e (md/bitmap:  separate out loading a bitmap...)
created bitmap_load, it missed calling it after bitmap_create when a
bitmap is created through the sysfs interface.
So if a bitmap is added this way, we don't allocate memory properly
and can crash.

This is suitable for any -stable release since 2.6.35.
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/bitmap.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -1982,6 +1982,8 @@ location_store(mddev_t *mddev, const cha
 			if (mddev->pers) {
 				mddev->pers->quiesce(mddev, 1);
 				rv = bitmap_create(mddev);
+				if (!rv)
+					rv = bitmap_load(mddev);
 				if (rv) {
 					bitmap_destroy(mddev);
 					mddev->bitmap_info.offset = 0;


