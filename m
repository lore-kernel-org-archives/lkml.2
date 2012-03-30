Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965979Ab2C3VUt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:20:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34386 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965783Ab2C3VUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:20:44 -0400
Message-Id: <20120330194840.220938122@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:49:44 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, NeilBrown <neilb@suse.de>
Subject: [ 079/175] md/bitmap: ensure to load bitmap when creating via sysfs.
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1904,6 +1904,8 @@ location_store(struct mddev *mddev, cons
 			if (mddev->pers) {
 				mddev->pers->quiesce(mddev, 1);
 				rv = bitmap_create(mddev);
+				if (!rv)
+					rv = bitmap_load(mddev);
 				if (rv) {
 					bitmap_destroy(mddev);
 					mddev->bitmap_info.offset = 0;


