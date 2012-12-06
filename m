Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424328Ab2LFQQJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 11:16:09 -0500
Received: from server505g.appriver.com ([98.129.35.12]:4529 "EHLO
	server505.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1423988Ab2LFQQH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 11:16:07 -0500
X-Note-AR-ScanTimeLocal: 12/6/2012 10:16:06 AM
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
X-Note: Global Rule Hits: G328 G329 G330 G331 G335 G336 G347 G443 
X-Note: Encrypt Rule Hits: 
X-Note: Mail Class: ALLOWEDSENDER
X-Note: Headers Injected
From: Ed Cashin <ecashin@coraid.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 6 Dec 2012 10:16:02 -0600
Subject: Re: [PATCH 2/7] aoe: avoid races between device destruction and
 discovery
Thread-Topic: [PATCH 2/7] aoe: avoid races between device destruction and
 discovery
Thread-Index: Ac3TzPygwQmf8zTTTSei60hmQeneyw==
Message-ID: <CCC74268-5C66-446F-A81F-F9892CC0CAA0@coraid.com>
References: <cover.1354501189.git.ecashin@coraid.com>
 <d3095fd2ad59a9e1fffe9208c34e8b35e7a8b5e5.1354501189.git.ecashin@coraid.com>
 <20121204154534.7fb65f2b.akpm@linux-foundation.org>
In-Reply-To: <20121204154534.7fb65f2b.akpm@linux-foundation.org>
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

On Dec 4, 2012, at 6:45 PM, Andrew Morton wrote:

> On Mon, 3 Dec 2012 20:42:56 -0500
> Ed Cashin <ecashin@coraid.com> wrote:
> 
>> This change avoids a race that could result in a NULL pointer
>> derference following a WARNing from kobject_add_internal, "don't
>> try to register things with the same name in the same directory."
...
>> The check for a bad aoedev pointer remains from a time when about
>> half of this patch was done, and it was possible for the
>> bdev->bd_disk->private_data to become corrupted.  The check
>> should be removed eventually, but it is not expected to add
>> significant overhead, occurring in the aoeblk_open routine.
...
>> --- a/drivers/block/aoe/aoeblk.c
>> +++ b/drivers/block/aoe/aoeblk.c
>> @@ -147,9 +147,18 @@ aoeblk_open(struct block_device *bdev, fmode_t mode)
>> 	struct aoedev *d = bdev->bd_disk->private_data;
>> 	ulong flags;
>> 
>> +	if (!virt_addr_valid(d)) {
>> +		pr_crit("aoe: invalid device pointer in %s\n",
>> +			__func__);
>> +		WARN_ON(1);
>> +		return -ENODEV;
>> +	}
> 
> Can this ever happen?

This is the check mentioned in the last paragraph of the changelog
message.  I don't think it can happen now.  Folks have been using
it like this and nobody has seen the invalid device pointer message.

I'll go ahead and remove the check and resubmit the patch.

...
>> @@ -259,6 +268,18 @@ aoeblk_gdalloc(void *vp)
>> 	struct request_queue *q;
>> 	enum { KB = 1024, MB = KB * KB, READ_AHEAD = 2 * MB, };
>> 	ulong flags;
>> +	int late = 0;
>> +
>> +	spin_lock_irqsave(&d->lock, flags);
>> +	if (d->flags & DEVFL_GDALLOC
>> +	&& !(d->flags & DEVFL_TKILL)
>> +	&& !(d->flags & DEVFL_GD_NOW))
> 
> That's pretty sickly-looking code layout.
> 
> We often do
> 
> 	if ((d->flags & (DEVFL_GDALLOC|DEVFL_TKILL|DEVFL_GD_NOW)) ==
> 		DEVFL_GDALLOC)
> 
> in these cases.

OK.  When I'm resubmitting these patches, I'm planning to submit
the series of 7 patches and include info in the cover letter about
what has changed in the resubmission.

-- 
  Ed Cashin
  ecashin@coraid.com


