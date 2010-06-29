Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341Ab0F2Vxd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 17:53:33 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:56405 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414Ab0F2Vx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 17:53:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=kSJ4uPYr2RZlSeA4NGcklAJgXFJUQEKrKj3CY3EPMU40xtoyfq/iJCHYPLBpYiAgOF
         EL5mit8RSva1xNBww3u7SkLOCuiA1barC3+O+TWFlNBPhgAKlhYIhGmDjylJHv9oIR4h
         Jy0UzCAykeGCPJoAa9U2YYRPcnKQJ8p9beVHg=
Message-ID: <4C2A6B6C.1000306@gmail.com>
Date: Tue, 29 Jun 2010 14:53:48 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100615 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, lenb@kernel.org
Subject: Re: [PATCH 3/5]acpi:glue.c Fix warning: variable 'ret' set but not
 used
References: <4C29674C.9070503@gmail.com> <4C28E14D.5050701@gmail.com> <1277621246-10960-4-git-send-email-justinmattock@gmail.com> <1277621246-10960-1-git-send-email-justinmattock@gmail.com> <7214.1277729293@redhat.com> <8066.1277750854@redhat.com> <22319.1277826461@redhat.com>
In-Reply-To: <22319.1277826461@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2010 08:47 AM, David Howells wrote:
> Justin P. Mattock<justinmattock@gmail.com>  wrote:
>
>> +	if (fn) {
>> + 			printk(KERN_WARNING "dev%d: Failed to create
>> firmware_node: %d\n", status, fn);
>> +	}else if (pn) {
>> +			printk(KERN_WARNING "dev%d: Failed to create
>> physical_node: %d\n", status, pn);
>> + 			return 0;
>> +		}
>
> The if-statement should be correctly indented (it's inside another
> if-body, so needs to be one more tab over) and there needs to be a space
> before the else.
>
> You should probably split your printks up so they don't exceed 80 chars too,
> for example:
>
> 			printk(KERN_WARNING
> 			       "dev%d: Failed to create physical_node: %d\n",
> 			       status, pn);
>
> Also 'status' is probably the wrong thing to print as the number in "dev%d".
> If it worked, that should be unconditionally AE_OK, I think.  Can you not use
> dev_warn() or similar instead or printk?
>
> David
>


o.k. heres another go at this.. this goes through, using dev_warn
but am uncertain about using these three for the right info dev, %p, 
dev_acpi

but give it a look whenever you have the time, and let me know
then I'll go from there..



 From 34485b5709dc9ad18c57be8c672236580300e05c Mon Sep 17 00:00:00 2001
From: Justin P. Mattock <justinmattock@gmail.com>
Date: Tue, 29 Jun 2010 14:47:42 -0700
Subject: [PATCH ]ACPI:glue.c
  Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
  drivers/acpi/glue.c |   15 ++++++++++++---
  1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/glue.c b/drivers/acpi/glue.c
index 4af6301..69ca24d 100644
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
@@ -160,12 +161,20 @@ static int acpi_bind_one(struct device *dev, 
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
+		dev_warn(dev, "dev:%p Failed to create firmware_node: %d\n",
+			acpi_dev, fn);
+
+		} else if (pn) {
+		dev_warn(dev, "dev:%p Failed to create physical_node: %d\n",
+			acpi_dev, pn);
+			return AE_ERROR;
+		}
  		if (acpi_dev->wakeup.flags.valid) {
  			device_set_wakeup_capable(dev, true);
  			device_set_wakeup_enable(dev,
-- 
1.7.1.rc1.21.gf3bd6


Justin P. Mattock
