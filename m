Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758390Ab2CFRjC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 12:39:02 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:55158 "EHLO
	mail-lpp01m020-f174.google.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756883Ab2CFRjA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 12:39:00 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of amit.sahrawat83@gmail.com designates 10.152.136.36 as permitted sender) smtp.mail=amit.sahrawat83@gmail.com; dkim=pass header.i=amit.sahrawat83@gmail.com
MIME-Version: 1.0
In-Reply-To: <1329398881.2893.8.camel@dabdike>
References: <1329375141-6944-1-git-send-email-amit.sahrawat83@gmail.com>
	<1329398881.2893.8.camel@dabdike>
Date: Tue, 6 Mar 2012 23:08:57 +0530
Message-ID: <CADDb1s0rhEDnRunexnEyL3htpkN+Fu4P7cKJjiZr_s-F48J57g@mail.gmail.com>
Subject: Re: [PATCH 2/2] scsi: retrieve cache mode using ATA_16 cmd if normal
 routine fails
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Nam-Jae Jeon <namjae.jeon@samsung.com>,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

Few queries relating to solution for this long pending problem.
As per your suggestions - it is clear - we cannot have this as part of
default routine to retrieve WCE using ATA - as for some USB HDD - it
will result in halting their operations.
So,
1) USB quirks -> i think this will only be a workaround for few USB
hard disks - wherein we can their add their entries in the quirks list
and control this WC. So, this wont be a solution which can be used as
part of a long term solution.
2) As part of 'sysfs' interface - there is already an array for
cache_types in sd.c - Can we make an entry in this array for "write
back(ata cmd)" and make corresponding changes - to reflect this when
we do " echo "write back(ata cmd) >
/sys/class/scsi_disk/<>/cache_type".
So, these changes won't be part of default routine - but this will
still need minor changes in sd.c - will those changes be acceptable?
sd_store_cache_type()->revalidate_disk()->sd_revalidate_disk()->sd_read_cache_type()

Please share your opinion to bring out a solution to this.

Thanks & Regards,
Amit Sahrawat

On Thu, Feb 16, 2012 at 6:58 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
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
>
> Alternatively, you can co-opt the USB quirks handling to set it for you.
>
> James
>
>
