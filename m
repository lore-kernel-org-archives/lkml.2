Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab0HJCXo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 22:23:44 -0400
Received: from mx1.fusionio.com ([64.244.102.30]:47229 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753674Ab0HJCXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 22:23:38 -0400
X-ASG-Debug-ID: 1281407016-1ec600120000-xx1T2L
X-Barracuda-URL: http://10.101.1.180:8000/cgi-bin/mark.cgi
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4C60B82B.5020905@fusionio.com>
Date: Mon, 9 Aug 2010 22:23:39 -0400
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: Nitin Gupta <ngupta@vflare.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Minchan Kim <minchan.kim@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Linux Driver Project <devel@driverdev.osuosl.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
X-ASG-Orig-Subj: Re: [PATCH 06/10] Block discard support
Subject: Re: [PATCH 06/10] Block discard support
References: <1281374816-904-1-git-send-email-ngupta@vflare.org>	<1281374816-904-7-git-send-email-ngupta@vflare.org> <AANLkTimtdLb4Mk81fmCwksPR0GbTEaGZbo888OFefjXK@mail.gmail.com>
In-Reply-To: <AANLkTimtdLb4Mk81fmCwksPR0GbTEaGZbo888OFefjXK@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1281407016
X-Barracuda-Virus-Scanned: by Barracuda Spam & Virus Firewall at fusionio.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2010 03:03 PM, Pekka Enberg wrote:
> On Mon, Aug 9, 2010 at 8:26 PM, Nitin Gupta <ngupta@vflare.org> wrote:
>> The 'discard' bio discard request provides information to
>> zram disks regarding blocks which are no longer in use by
>> filesystem. This allows freeing memory allocated for such
>> blocks.
>>
>> When zram devices are used as swap disks, we already have
>> a callback (block_device_operations->swap_slot_free_notify).
>> So, the discard support is useful only when used as generic
>> (non-swap) disk.
>>
>> Signed-off-by: Nitin Gupta <ngupta@vflare.org>
> 
> Lets CC fsdevel and Jens for this.

Looks OK from a quick look. One comment, though:

>> +static void zram_discard(struct zram *zram, struct bio *bio)
>> +{
>> +       size_t bytes = bio->bi_size;
>> +       sector_t sector = bio->bi_sector;
>> +
>> +       while (bytes >= PAGE_SIZE) {
>> +               zram_free_page(zram, sector >> SECTORS_PER_PAGE_SHIFT);
>> +               sector += PAGE_SIZE >> SECTOR_SHIFT;
>> +               bytes -= PAGE_SIZE;
>> +       }
>> +
>> +       bio_endio(bio, 0);
>> +}
>> +

So freeing the page here will guarantee zeroed return on read?
And since you set PAGE_SIZE as the discard granularity, the above loop
could be coded more readable with the knowledge that ->bi_size is always
a multiple of the page size.

-- 
Jens Axboe


Confidentiality Notice: This e-mail message, its contents and any attachments to it are confidential to the intended recipient, and may contain information that is privileged and/or exempt from disclosure under applicable law. If you are not the intended recipient, please immediately notify the sender and destroy the original e-mail message and any attachments (and any copies that may have been made) from your system or otherwise. Any unauthorized use, copying, disclosure or distribution of this information is strictly prohibited.
