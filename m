Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016Ab0INShA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 14:37:00 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:47145 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab0INSg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 14:36:59 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: "Hans J. Koch" <hjk@linutronix.de>, <linux-kernel@vger.kernel.org>
References: <m1y6b48973.fsf@fess.ebiederm.org>
Date: Tue, 14 Sep 2010 11:36:54 -0700
In-Reply-To: <m1y6b48973.fsf@fess.ebiederm.org> (Eric W. Biederman's message
	of "Tue, 14 Sep 2010 11:35:28 -0700")
Message-ID: <m1occ0894p.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg Kroah-Hartman <gregkh@suse.de>
X-Spam-Relay-Country: 
Subject: [PATCH 2/5] uio: Don't clear driver data
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Currently uio sets it's driver data to NULL just as it is unregistering
attributes.  sysfs maks the guaranatee that it will not call attributes
after device_destroy is called so this is unncessary and leads to lots
of unnecessary code in uio.c

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 drivers/uio/uio.c |   17 +++--------------
 1 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index bc774cc..8132288 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -229,10 +229,7 @@ static ssize_t show_name(struct device *dev,
 			 struct device_attribute *attr, char *buf)
 {
 	struct uio_device *idev = dev_get_drvdata(dev);
-	if (idev)
-		return sprintf(buf, "%s\n", idev->info->name);
-	else
-		return -ENODEV;
+	return sprintf(buf, "%s\n", idev->info->name);
 }
 static DEVICE_ATTR(name, S_IRUGO, show_name, NULL);
 
@@ -240,10 +237,7 @@ static ssize_t show_version(struct device *dev,
 			    struct device_attribute *attr, char *buf)
 {
 	struct uio_device *idev = dev_get_drvdata(dev);
-	if (idev)
-		return sprintf(buf, "%s\n", idev->info->version);
-	else
-		return -ENODEV;
+	return sprintf(buf, "%s\n", idev->info->version);
 }
 static DEVICE_ATTR(version, S_IRUGO, show_version, NULL);
 
@@ -251,11 +245,7 @@ static ssize_t show_event(struct device *dev,
 			  struct device_attribute *attr, char *buf)
 {
 	struct uio_device *idev = dev_get_drvdata(dev);
-	if (idev)
-		return sprintf(buf, "%u\n",
-				(unsigned int)atomic_read(&idev->event));
-	else
-		return -ENODEV;
+	return sprintf(buf, "%u\n", (unsigned int)atomic_read(&idev->event));
 }
 static DEVICE_ATTR(event, S_IRUGO, show_event, NULL);
 
@@ -878,7 +868,6 @@ void uio_unregister_device(struct uio_info *info)
 
 	uio_dev_del_attributes(idev);
 
-	dev_set_drvdata(idev->dev, NULL);
 	device_destroy(uio_class, MKDEV(uio_major, idev->minor));
 	kfree(idev);
 
-- 
1.7.2.2

