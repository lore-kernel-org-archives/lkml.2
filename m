Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713Ab1HYWab (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 18:30:31 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:52750 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755561Ab1HYWaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 18:30:30 -0400
X-Sasl-enc: mrVYGVo1sHpwo1jo7f6xXDMQqyyHNPAIXtSYSTVO9tR/ 1314311429
Date: Thu, 25 Aug 2011 15:28:19 -0700
From: Greg KH <greg@kroah.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: Re: [PATCH 12/59] Staging: hv: vmbus: Cleanup vmbus_uevent() code
Message-ID: <20110825222819.GA13787@kroah.com>
References: <1314290866-2644-1-git-send-email-kys@microsoft.com>
 <1314290965-2698-1-git-send-email-kys@microsoft.com>
 <1314290965-2698-12-git-send-email-kys@microsoft.com>
 <20110825205930.GA10883@kroah.com>
 <20110825211514.GD26773@kroah.com>
 <6E21E5352C11B742B20C142EB499E048081B359F@TK5EX14MBXC126.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E048081B359F@TK5EX14MBXC126.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 10:20:32PM +0000, KY Srinivasan wrote:
> > > I have to edit this to get it to work properly with the fact that I
> > > added the driver_data field to hv_vmbus_device_id.
> > 
> > You should have a copy of the patch I applied in your inbox now, can you
> > verify I didn't mess it up?
> 
> Greg,
> 
> I don't think I got this mail. Could you resend the mail.

Sure, here it is:


From: "K. Y. Srinivasan" <kys@microsoft.com>
Date: Thu, 25 Aug 2011 09:48:38 -0700
Subject: [PATCH] Staging: hv: vmbus: Cleanup vmbus_uevent() code
Status: RO
Content-Length: 2871
Lines: 82

Now generate appropriate uevent based on the modalias string. As part of this,
cleanup the existing uevent code.

[gregkh - fixed code to handle driver_data portion of struct
hv_vmbus_device_id]

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index b651968..afb16704 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -237,58 +237,22 @@ static struct device_attribute vmbus_device_attrs[] = {
  * This routine is invoked when a device is added or removed on the vmbus to
  * generate a uevent to udev in the userspace. The udev will then look at its
  * rule and the uevent generated here to load the appropriate driver
+ *
+ * The alias string will be of the form vmbus:guid where guid is the string
+ * representation of the device guid (each byte of the guid will be
+ * represented with two hex characters.
  */
 static int vmbus_uevent(struct device *device, struct kobj_uevent_env *env)
 {
 	struct hv_device *dev = device_to_hv_device(device);
-	int ret;
-
-	ret = add_uevent_var(env, "VMBUS_DEVICE_CLASS_GUID={"
-			     "%02x%02x%02x%02x-%02x%02x-%02x%02x-"
-			     "%02x%02x%02x%02x%02x%02x%02x%02x}",
-			     dev->dev_type.b[3],
-			     dev->dev_type.b[2],
-			     dev->dev_type.b[1],
-			     dev->dev_type.b[0],
-			     dev->dev_type.b[5],
-			     dev->dev_type.b[4],
-			     dev->dev_type.b[7],
-			     dev->dev_type.b[6],
-			     dev->dev_type.b[8],
-			     dev->dev_type.b[9],
-			     dev->dev_type.b[10],
-			     dev->dev_type.b[11],
-			     dev->dev_type.b[12],
-			     dev->dev_type.b[13],
-			     dev->dev_type.b[14],
-			     dev->dev_type.b[15]);
-
-	if (ret)
-		return ret;
+	int i, ret;
+	char alias_name[((sizeof((struct hv_vmbus_device_id *)0)->guid) + 1) * 2];
 
-	ret = add_uevent_var(env, "VMBUS_DEVICE_DEVICE_GUID={"
-			     "%02x%02x%02x%02x-%02x%02x-%02x%02x-"
-			     "%02x%02x%02x%02x%02x%02x%02x%02x}",
-			     dev->dev_instance.b[3],
-			     dev->dev_instance.b[2],
-			     dev->dev_instance.b[1],
-			     dev->dev_instance.b[0],
-			     dev->dev_instance.b[5],
-			     dev->dev_instance.b[4],
-			     dev->dev_instance.b[7],
-			     dev->dev_instance.b[6],
-			     dev->dev_instance.b[8],
-			     dev->dev_instance.b[9],
-			     dev->dev_instance.b[10],
-			     dev->dev_instance.b[11],
-			     dev->dev_instance.b[12],
-			     dev->dev_instance.b[13],
-			     dev->dev_instance.b[14],
-			     dev->dev_instance.b[15]);
-	if (ret)
-		return ret;
+	for (i = 0; i < ((sizeof((struct hv_vmbus_device_id *)0)->guid) * 2); i += 2)
+		sprintf(&alias_name[i], "%02x", dev->dev_type.b[i/2]);
 
-	return 0;
+	ret = add_uevent_var(env, "MODALIAS=vmbus:%s", alias_name);
+	return ret;
 }
 
 
