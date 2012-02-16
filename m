Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751589Ab2BPOHc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 09:07:32 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59445 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267Ab2BPOH3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 09:07:29 -0500
MIME-Version: 1.0
In-Reply-To: <1329398881.2893.8.camel@dabdike>
References: <1329375141-6944-1-git-send-email-amit.sahrawat83@gmail.com>
	<1329398881.2893.8.camel@dabdike>
Date: Thu, 16 Feb 2012 23:07:27 +0900
Message-ID: <CAKYAXd91v1vFa4EE27xn1sJkQDADJGcPOQ5WgsE900wPgw3mWw@mail.gmail.com>
Subject: Re: [PATCH 2/2] scsi: retrieve cache mode using ATA_16 cmd if normal
 routine fails
From: Namjae Jeon <linkinjeon@gmail.com>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Amit Sahrawat <amit.sahrawat83@gmail.com>, Jeff Garzik <jgarzik@pobox.com>,
        Nam-Jae Jeon <namjae.jeon@samsung.com>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/2/16 James Bottomley <James.Bottomley@hansenpartnership.com>:
> On Thu, 2012-02-16 at 12:22 +0530, Amit Sahrawat wrote:
>
>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>> index c691fb5..3ca507a 100644
>> --- a/drivers/scsi/sd.c
>> +++ b/drivers/scsi/sd.c
>> @@ -50,6 +50,11 @@
>>  #include <linux/string_helpers.h>
>>  #include <linux/async.h>
>>  #include <linux/slab.h>
>> +
>> +#ifdef CONFIG_ATA
>> +#include <linux/libata.h>
>> +#endif
>> +
>>  #include <linux/pm_runtime.h>
>>  #include <asm/uaccess.h>
>>  #include <asm/unaligned.h>
>> @@ -2129,7 +2134,11 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
>>               if (modepage == 0x3F) {
>>                       sd_printk(KERN_ERR, sdkp, "No Caching mode page "
>>                                 "present\n");
>> +#ifdef CONFIG_ATA
>> +                     goto WCE_USING_ATA;
>> +#else
>>                       goto defaults;
>> +#endif
>>               } else if ((buffer[offset] & 0x3f) != modepage) {
>>                       sd_printk(KERN_ERR, sdkp, "Got wrong page\n");
>>                       goto defaults;
>> @@ -2149,6 +2158,15 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
>>                                 "Uses READ/WRITE(6), disabling FUA\n");
>>                       sdkp->DPOFUA = 0;
>>               }
>> +#ifdef CONFIG_ATA
>> +WCE_USING_ATA:
>> +             if (!sdp->removable && !sdkp->WCE) {
>> +                     sd_printk(KERN_NOTICE, sdkp, "Try to check write cache"
>> +                             " enable/disable using ATA command\n");
>> +                     sdkp->WCE = ata_get_cachestatus(sdp);
>> +             }
>> +#endif
>> +
>
> I already said before, this is a non starter: we can't randomly send
> SCSI encapsulated ATA commands to disks from sd.  What we can do is give
> you a WCE variable you can change on the fly in sysfs via whatever
> mechanism is most appropriate (but this would have to be a mechanism
> external to sd.c).
Oops.. it is mistake. we will make patch v2 included setting via sysfs.
Thanks for your reply.
>
> Alternatively, you can co-opt the USB quirks handling to set it for you.
>
> James
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ide" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
