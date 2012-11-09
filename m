Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477Ab2KICK6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 21:10:58 -0500
Received: from server505k.appriver.com ([98.129.35.43]:56231 "EHLO
	server505.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756372Ab2KICKz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 21:10:55 -0500
X-Note-AR-ScanTimeLocal: 11/8/2012 8:10:50 PM
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Policy: GLOBAL - coraid.com
X-Primary: ecashin@coraid.com
X-Note: This Email was scanned by AppRiver SecureTide
X-ALLOW: @coraid.com ALLOWED
X-Virus-Scan: V-
X-Note: Spam Tests Failed: 
X-Country-Path: UNKNOWN->UNITED STATES->UNITED STATES
X-Note-Sending-IP: 98.129.35.1
X-Note-Reverse-DNS: smtp.exg5.exghost.com
X-Note-Return-Path: ecashin@coraid.com
X-Note: User Rule Hits: 
X-Note: Global Rule Hits: G329 G330 G331 G332 G336 G337 G348 G444 
X-Note: Encrypt Rule Hits: 
X-Note: Mail Class: ALLOWEDSENDER
X-Note: Headers Injected
From: Ed Cashin <ecashin@coraid.com>
To: Jeff Garzik <jgarzik@pobox.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 8 Nov 2012 20:10:49 -0600
Subject: Re: [PATCH 2/8] aoe: provide ATA identify device content to user on
 request
Thread-Topic: [PATCH 2/8] aoe: provide ATA identify device content to user
 on request
Thread-Index: Ac2+H3A64irUqf3ZSV6iHOmksL5ftQ==
Message-ID: <6B79CBB8-3486-490A-87D1-03D917EE8491@coraid.com>
References: <d63a612e77d92e4f7c13fc2bb545a762a664522d.1352316179.git.ecashin@coraid.com>
 <9a089f76a8e21e64c89556d155833bcb286e48be.1352316179.git.ecashin@coraid.com>
 <509C5110.5090809@pobox.com>
In-Reply-To: <509C5110.5090809@pobox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 8, 2012, at 7:40 PM, Jeff Garzik wrote:

> On 11/08/2012 11:32 AM, Ed Cashin wrote:
>> This patch makes the aoe driver follow expected behavior when
>> the user uses ioctl to get the ATA device identify information.
>> 
>> Signed-off-by: Ed Cashin <ecashin@coraid.com>
>> ---
>>  drivers/block/aoe/aoe.h    |    1 +
>>  drivers/block/aoe/aoeblk.c |   30 ++++++++++++++++++++++++++++++
>>  drivers/block/aoe/aoecmd.c |   16 ++++++++++++++++
>>  3 files changed, 47 insertions(+), 0 deletions(-)
>> 
>> diff --git a/drivers/block/aoe/aoe.h b/drivers/block/aoe/aoe.h
>> index 536942b..f6e0c03 100644
>> --- a/drivers/block/aoe/aoe.h
>> +++ b/drivers/block/aoe/aoe.h
>> @@ -169,6 +169,7 @@ struct aoedev {
>>  	struct aoetgt *htgt;	/* target needing rexmit assistance */
>>  	ulong ntargets;
>>  	ulong kicked;
>> +	char ident[512];
>>  };
>> 
>>  /* kthread tracking */
>> diff --git a/drivers/block/aoe/aoeblk.c b/drivers/block/aoe/aoeblk.c
>> index 56736cd..7ba0fcf 100644
>> --- a/drivers/block/aoe/aoeblk.c
>> +++ b/drivers/block/aoe/aoeblk.c
>> @@ -17,6 +17,7 @@
>>  #include <linux/mutex.h>
>>  #include <linux/export.h>
>>  #include <linux/moduleparam.h>
>> +#include <scsi/sg.h>
>>  #include "aoe.h"
>> 
>>  static DEFINE_MUTEX(aoeblk_mutex);
>> @@ -212,9 +213,38 @@ aoeblk_getgeo(struct block_device *bdev, struct hd_geometry *geo)
>>  	return 0;
>>  }
>> 
>> +static int
>> +aoeblk_ioctl(struct block_device *bdev, fmode_t mode, uint cmd, ulong arg)
>> +{
>> +	struct aoedev *d;
>> +
>> +	if (!arg)
>> +		return -EINVAL;
>> +
>> +	d = bdev->bd_disk->private_data;
>> +	if ((d->flags & DEVFL_UP) == 0) {
>> +		pr_err("aoe: disk not up\n");
>> +		return -ENODEV;
>> +	}
>> +
>> +	if (cmd == HDIO_GET_IDENTITY) {
>> +		if (!copy_to_user((void __user *) arg, &d->ident,
>> +			sizeof(d->ident)))
>> +			return 0;
>> +		return -EFAULT;
>> +	}
>> +
>> +	/* udev calls scsi_id, which uses SG_IO, resulting in noise */
>> +	if (cmd != SG_IO)
>> +		pr_info("aoe: unknown ioctl 0x%x\n", cmd);
>> +
>> +	return -ENOTTY;
>> +}
>> +
>>  static const struct block_device_operations aoe_bdops = {
>>  	.open = aoeblk_open,
>>  	.release = aoeblk_release,
>> +	.ioctl = aoeblk_ioctl,
>>  	.getgeo = aoeblk_getgeo,
>>  	.owner = THIS_MODULE,
>>  };
>> diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
>> index 3ce01f6..c4ff70b 100644
>> --- a/drivers/block/aoe/aoecmd.c
>> +++ b/drivers/block/aoe/aoecmd.c
>> @@ -799,6 +799,17 @@ aoecmd_sleepwork(struct work_struct *work)
>>  }
>> 
>>  static void
>> +ata_ident_fixstring(u16 *id, int ns)
>> +{
>> +	u16 s;
>> +
>> +	while (ns-- > 0) {
>> +		s = *id;
>> +		*id++ = s >> 8 | s << 8;
>> +	}
>> +}
>> +
>> +static void
>>  ataid_complete(struct aoedev *d, struct aoetgt *t, unsigned char *id)
>>  {
>>  	u64 ssize;
>> @@ -833,6 +844,11 @@ ataid_complete(struct aoedev *d, struct aoetgt *t, unsigned char *id)
>>  		d->geo.sectors = get_unaligned_le16(&id[56 << 1]);
>>  	}
>> 
>> +	ata_ident_fixstring((u16 *) &id[10<<1], 10);	/* serial */
>> +	ata_ident_fixstring((u16 *) &id[23<<1], 4);	/* firmware */
>> +	ata_ident_fixstring((u16 *) &id[27<<1], 20);	/* model */
> 
> This duplicates ata_id_string() and/or ata_id_c_string(), does it not?


They're similar, yes, but aoecmd.c:ata_ident_fixstring performs the byte swapping 
in place, avoiding the need for any on-stack or other memory allocation.  The code
is pretty readable now as a simple in-place byte swap, and I'm concerned that the
extra mechanics of buffer allocation, any allocation failure handling, and memmov-ing 
the results back into the id array wouldn't simplify the code if aoecmd.c tried to use 
ata_id_string as it is.

-- 
  Ed Cashin
  ecashin@coraid.com


