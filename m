Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921Ab0F2DXj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 23:23:39 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42361 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab0F2DXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 23:23:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=kVbxRajL1Vpuof9KPTuDD7ZAL6uDOfKnBOuq1G+YFd2UCWIHKXbxKLT1uOZwsjU2nu
         IRXkhVAU8HJrG2NpfKfzHnmQB9F4ttI4+TXWAh4b6O8hHje/Ow7KaWKUvpegyQ5XSDQo
         juHakOULmc3fKpzjsDTsRD1A969Bk+FrCJ+Y8=
Message-ID: <4C29674C.9070503@gmail.com>
Date: Mon, 28 Jun 2010 20:23:56 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100615 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, lenb@kernel.org
Subject: Re: [PATCH 3/5]acpi:glue.c Fix warning: variable 'ret' set but not
 used
References: <4C28E14D.5050701@gmail.com> <1277621246-10960-4-git-send-email-justinmattock@gmail.com> <1277621246-10960-1-git-send-email-justinmattock@gmail.com> <7214.1277729293@redhat.com> <8066.1277750854@redhat.com>
In-Reply-To: <8066.1277750854@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o.k. after stepping out for a while.. I'm finally sitting down and 
looking at this. below is what I came up with.. hopefully it's in the 
area/vecinity of what might be a good idea for this(if not then let me know)



 From da5cfa463f29ff3fe4af3874649db0809e50ab96 Mon Sep 17 00:00:00 2001
From: Justin P. Mattock <justinmattock@gmail.com>
Date: Mon, 28 Jun 2010 20:14:50 -0700
Subject: [PATCH] glue.c
  Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
  drivers/acpi/glue.c |   12 +++++++++---
  1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/glue.c b/drivers/acpi/glue.c
index 4af6301..970d7f3 100644
--- a/drivers/acpi/glue.c
+++ b/drivers/acpi/glue.c
@@ -145,6 +145,7 @@ static int acpi_bind_one(struct device *dev, 
acpi_handle handle)
  {
  	struct acpi_device *acpi_dev;
  	acpi_status status;
+	int fn, pn;

  	if (dev->archdata.acpi_handle) {
  		dev_warn(dev, "Drivers changed 'acpi_handle'\n");
@@ -160,12 +161,17 @@ static int acpi_bind_one(struct device *dev, 
acpi_handle handle)

  	status = acpi_bus_get_device(handle, &acpi_dev);
  	if (!ACPI_FAILURE(status)) {
-		int ret;

-		ret = sysfs_create_link(&dev->kobj, &acpi_dev->dev.kobj,
+		fn = sysfs_create_link(&dev->kobj, &acpi_dev->dev.kobj,
  				"firmware_node");
-		ret = sysfs_create_link(&acpi_dev->dev.kobj, &dev->kobj,
+		pn = sysfs_create_link(&acpi_dev->dev.kobj, &dev->kobj,
  				"physical_node");
+	if (fn) {
+ 			printk(KERN_WARNING "dev%d: Failed to create firmware_node: %d\n", 
status, fn);
+	}else if (pn) {
+			printk(KERN_WARNING "dev%d: Failed to create physical_node: %d\n", 
status, pn);
+ 			return 0;
+		}
  		if (acpi_dev->wakeup.flags.valid) {
  			device_set_wakeup_capable(dev, true);
  			device_set_wakeup_enable(dev,
-- 
1.7.1.rc1.21.gf3bd6


keep in mind Im not exactly sure what should go into the printk
as for words to say, and functions, so I just used status, fn/pn
for the two because I was getting a not enough function error.

Justin P. Mattock
