Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867Ab1CXO1T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 10:27:19 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63694 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208Ab1CXO1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 10:27:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=LMQMmsy92TgUbpTazPYZKt7l3p2nNAttywLCVJGOiyCqSDBuIhIvWubUecHfZqmGcE
         /8AhJzWX4pwMV4QAK9htGyoucaAiobUdc9q4WmHLF7nc9aK0PFu6F1mo2i+V5Fkd0MIO
         J2yZSw4gYKSrOTXUSXnMM/aKEQgQSt/HvUTec=
Date: Thu, 24 Mar 2011 16:31:16 +0200
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Stern <stern@rowland.harvard.edu>, Chris Wright <chrisw@sous-sol.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: check device_create_file() return code in
 usb_create_sysfs_intf_files()
Message-ID: <20110324143116.GA8200@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I just noticed that usb_create_sysfs_intf_files() ignores device_create_file() 
return code and sets intf->sysfs_files_created to 1, even if sysfs_add_file_mode() 
returned -ENOMEM (or later sysfs_add_one() returned -EEXIST).

Shouldn't we check retval for 0 before setting intf->sysfs_files_created?

---

 drivers/usb/core/sysfs.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/core/sysfs.c b/drivers/usb/core/sysfs.c
index 6781c36..5a02524 100644
--- a/drivers/usb/core/sysfs.c
+++ b/drivers/usb/core/sysfs.c
@@ -856,8 +856,10 @@ int usb_create_sysfs_intf_files(struct usb_interface *intf)
 		alt->string = usb_cache_string(udev, alt->desc.iInterface);
 	if (alt->string)
 		retval = device_create_file(&intf->dev, &dev_attr_interface);
-	intf->sysfs_files_created = 1;
-	return 0;
+	if (retval == 0)
+		intf->sysfs_files_created = 1;
+
+	return retval;
 }
 
 void usb_remove_sysfs_intf_files(struct usb_interface *intf)

