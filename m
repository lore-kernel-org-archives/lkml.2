Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933046Ab1CXOwN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 10:52:13 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62951 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203Ab1CXOwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 10:52:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QvKk+YzqmXqncv1HdET1xrRK5dTEetsyiVEoIsYyhOE0RmCkYNSqlnICtjxK0s2xX+
         xMIO1RV739ZV3nejrzQ+VpyuNhfjgODWSE4TkOjRTcM6fKo3lJP00gKDPMOh9U2xrzhG
         MtRdNHYAESty3gk8ANQRp7B3WobEYqLOeCeis=
Date: Thu, 24 Mar 2011 16:56:06 +0200
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Chris Wright <chrisw@sous-sol.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: check device_create_file() return code in
 usb_create_sysfs_intf_files()
Message-ID: <20110324145606.GB8200@swordfish.minsk.epam.com>
References: <20110324143116.GA8200@swordfish.minsk.epam.com>
 <op.vsuq5nez3l0zgt@mnazarewicz-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.vsuq5nez3l0zgt@mnazarewicz-glaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (03/24/11 15:42), Michal Nazarewicz wrote:
> >@@ -856,8 +856,10 @@ int usb_create_sysfs_intf_files(struct
> >usb_interface *intf)
> > 		alt->string = usb_cache_string(udev, alt->desc.iInterface);
> > 	if (alt->string)
> > 		retval = device_create_file(&intf->dev, &dev_attr_interface);
> >-	intf->sysfs_files_created = 1;
> >-	return 0;
> >+	if (retval == 0)
> >+		intf->sysfs_files_created = 1;
> >+
> >+	return retval;
> > }
> 
> retval may be uninitialised.  You need to zero it at the beginning of the
> function (or somewhere).
> 

Oops... Yes, indeed. Thanks.

---

 drivers/usb/core/sysfs.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/core/sysfs.c b/drivers/usb/core/sysfs.c
index 6781c36..d03c630 100644
--- a/drivers/usb/core/sysfs.c
+++ b/drivers/usb/core/sysfs.c
@@ -846,7 +846,7 @@ int usb_create_sysfs_intf_files(struct usb_interface *intf)
 {
 	struct usb_device *udev = interface_to_usbdev(intf);
 	struct usb_host_interface *alt = intf->cur_altsetting;
-	int retval;
+	int retval = -1;
 
 	if (intf->sysfs_files_created || intf->unregistering)
 		return 0;
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

