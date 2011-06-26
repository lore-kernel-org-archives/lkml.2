Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103Ab1FZI5V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 04:57:21 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:32846 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722Ab1FZI5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 04:57:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=MeQxzLOyYVQbABBVUUYb3w4shKbrtYD90I/eYOKzucPUWnZB/Zxxvp2Mu9OheTHj3Z
         oZIuLTMZTZSWIi/OjbrDWtTcXznePd/2qAOU9Wvs7AQKSoyxcEDkq8ozqtGCV6/o9F7r
         Qg5S2b1VSAVWiCxT+sHYQAffWaCKw1CmSOQLg=
From: Vasiliy Kulikov <segoon@openwall.com>
To: linux-kernel@vger.kernel.org
Cc: security@kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Vasiliy Kulikov <segooon@gmail.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Ian Abbott <abbotti@mev.co.uk>, Arnd Bergmann <arnd@arndb.de>,
        devel@driverdev.osuosl.org
Subject: [PATCH] staging: comedi: fix infoleak to userspace
Date: Sun, 26 Jun 2011 12:56:22 +0400
Message-Id: <1309078582-4298-1-git-send-email-segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

driver_name and board_name are pointers to strings, not buffers of size
COMEDI_NAMELEN.  Copying COMEDI_NAMELEN bytes of a string containing
less than COMEDI_NAMELEN-1 bytes would leak some unrelated bytes.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 drivers/staging/comedi/comedi_fops.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/comedi_fops.c b/drivers/staging/comedi/comedi_fops.c
index e7e72b8..c20694e 100644
--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -383,8 +383,8 @@ static int do_devinfo_ioctl(struct comedi_device *dev,
 	/* fill devinfo structure */
 	devinfo.version_code = COMEDI_VERSION_CODE;
 	devinfo.n_subdevs = dev->n_subdevices;
-	memcpy(devinfo.driver_name, dev->driver->driver_name, COMEDI_NAMELEN);
-	memcpy(devinfo.board_name, dev->board_name, COMEDI_NAMELEN);
+	strlcpy(devinfo.driver_name, dev->driver->driver_name, COMEDI_NAMELEN);
+	strlcpy(devinfo.board_name, dev->board_name, COMEDI_NAMELEN);
 
 	if (read_subdev)
 		devinfo.read_subdevice = read_subdev - dev->subdevices;
-- 
1.7.0.4

