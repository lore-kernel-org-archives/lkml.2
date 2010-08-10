Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751729Ab0HJEyj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 00:54:39 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56773 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab0HJEyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 00:54:33 -0400
Message-ID: <4C60DBA1.5070507@vflare.org>
Date: Tue, 10 Aug 2010 10:24:57 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2 Thunderbird/3.1.1
MIME-Version: 1.0
To: Jens Axboe <jaxboe@fusionio.com>
CC: Pekka Enberg <penberg@kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Linux Driver Project <devel@driverdev.osuosl.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 06/10] Block discard support
References: <1281374816-904-1-git-send-email-ngupta@vflare.org>	<1281374816-904-7-git-send-email-ngupta@vflare.org> <AANLkTimtdLb4Mk81fmCwksPR0GbTEaGZbo888OFefjXK@mail.gmail.com> <4C60B82B.5020905@fusionio.com>
In-Reply-To: <4C60B82B.5020905@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/2010 07:53 AM, Jens Axboe wrote:
> On 08/09/2010 03:03 PM, Pekka Enberg wrote:
>> On Mon, Aug 9, 2010 at 8:26 PM, Nitin Gupta <ngupta@vflare.org> wrote:
>>> The 'discard' bio discard request provides information to
>>> zram disks regarding blocks which are no longer in use by
>>> filesystem. This allows freeing memory allocated for such
>>> blocks.
>>>
>>> When zram devices are used as swap disks, we already have
>>> a callback (block_device_operations->swap_slot_free_notify).
>>> So, the discard support is useful only when used as generic
>>> (non-swap) disk.
>>>
>>> Signed-off-by: Nitin Gupta <ngupta@vflare.org>
>>
>> Lets CC fsdevel and Jens for this.
> 
> Looks OK from a quick look. One comment, though:
> 
>>> +static void zram_discard(struct zram *zram, struct bio *bio)
>>> +{
>>> +       size_t bytes = bio->bi_size;
>>> +       sector_t sector = bio->bi_sector;
>>> +
>>> +       while (bytes >= PAGE_SIZE) {
>>> +               zram_free_page(zram, sector >> SECTORS_PER_PAGE_SHIFT);
>>> +               sector += PAGE_SIZE >> SECTOR_SHIFT;
>>> +               bytes -= PAGE_SIZE;
>>> +       }
>>> +
>>> +       bio_endio(bio, 0);
>>> +}
>>> +
> 
> So freeing the page here will guarantee zeroed return on read?

For reads on freed/unwritten sectors, it simply returns success and
does not touch the bio page. Is it better to zero the page in such
cases?

> And since you set PAGE_SIZE as the discard granularity, the above loop
> could be coded more readable with the knowledge that ->bi_size is always
> a multiple of the page size.
> 

Ok, I will cleanup it up.

Thanks for comments.
Nitin
