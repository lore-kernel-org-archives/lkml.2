Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978Ab2ATPmN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 10:42:13 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:46117 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945Ab2ATPl5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 10:41:57 -0500
MIME-Version: 1.0
In-Reply-To: <20120120152819.GA3959@phenom.dumpdata.com>
References: <1327072528-8479-1-git-send-email-akinobu.mita@gmail.com>
	<1327072528-8479-4-git-send-email-akinobu.mita@gmail.com>
	<20120120152819.GA3959@phenom.dumpdata.com>
Date: Sat, 21 Jan 2012 00:41:56 +0900
Message-ID: <CAC5umyi9vuOh9Bx_HoB8ieXcVjZsisKOG6mCEM2ZGL7zXCrVTQ@mail.gmail.com>
Subject: Re: [PATCH] xen-blkfront: use bitmap_set() and bitmap_clear()
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Jeremy Fitzhardinge Jeremy Fitzhardinge <jeremy@goop.org>,
        xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/1/21 Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>:
> On Sat, Jan 21, 2012 at 12:15:26AM +0900, Akinobu Mita wrote:
>> Use bitmap_set and bitmap_clear rather than modifying individual bits
>> in a memory region.
>>
>> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
>> Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>> Cc: xen-devel@lists.xensource.com
>> Cc: virtualization@lists.linux-foundation.org
>> ---
>>  drivers/block/xen-blkfront.c |    7 +++----
>>  1 files changed, 3 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
>> index 2f22874..619868d 100644
>> --- a/drivers/block/xen-blkfront.c
>> +++ b/drivers/block/xen-blkfront.c
>> @@ -43,6 +43,7 @@
>>  #include <linux/slab.h>
>>  #include <linux/mutex.h>
>>  #include <linux/scatterlist.h>
>> +#include <linux/bitmap.h>
>>
>>  #include <xen/xen.h>
>>  #include <xen/xenbus.h>
>> @@ -177,8 +178,7 @@ static int xlbd_reserve_minors(unsigned int minor, unsigned int nr)
>>
>>       spin_lock(&minor_lock);
>>       if (find_next_bit(minors, end, minor) >= end) {
>> -             for (; minor < end; ++minor)
>> -                     __set_bit(minor, minors);
>> +             bitmap_set(minors, minor, nr);
>
> Hm, I would have thought the last argument should have been 'end'?

'end' is the index of the last bit to clear.  But the last argument of
bitmap_clear() is the number of bits to clear.  So I think 'nr' is correct.

> Did you test this patch with a large amount of minors?

Sorry I didn't do runtime test.

>>               rc = 0;
>>       } else
>>               rc = -EBUSY;
>> @@ -193,8 +193,7 @@ static void xlbd_release_minors(unsigned int minor, unsigned int nr)
>>
>>       BUG_ON(end > nr_minors);
>>       spin_lock(&minor_lock);
>> -     for (; minor < end; ++minor)
>> -             __clear_bit(minor, minors);
>> +     bitmap_clear(minors,  minor, nr);
>
> Ditto.
>>       spin_unlock(&minor_lock);
>>  }
>>
>> --
>> 1.7.4.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
