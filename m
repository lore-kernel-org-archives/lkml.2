Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756476Ab0JHJBJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 05:01:09 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55209 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756236Ab0JHJBI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 05:01:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wprvxbTYPwZOiOWAWLuGr5YevtQs8JbQqq1g9NKSoLxygFn7kcujL557Mef4eIXuZ3
         bUX/vFsFxxM4EZ7S9/KDHmP+OF0W2j3wTJjhmW1da+sjIddcdyCLWOBmsZBqHnn+gO74
         G0BywboUbl8NU96gqMw5vRDzC960K32cVb5ls=
MIME-Version: 1.0
In-Reply-To: <201010071431.14937.phillips@phunq.net>
References: <20101006083150.GA15758@zhongling>
	<201010071431.14937.phillips@phunq.net>
Date: Fri, 8 Oct 2010 17:01:06 +0800
Message-ID: <AANLkTimip4sT6Pkzz=-jA3RWiGnqfNtmbJzW_Hn1ynFt@mail.gmail.com>
Subject: Re: introduce dm-snap-mv
From: McPacino <mcpacino@gmail.com>
To: Daniel Phillips <phillips@phunq.net>, Christoph Hellwig <hch@lst.de>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Nick Piggin <npiggin@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

It is very cumbersome to deal with small (512, 1024 or 2048) blocksize.

I used fixed size (4096 bytes) block to save the exception list.

If the blocksize is 512 byte, I have to invoke __getblk() 8 times to read
the exception list. And what more cumbersome is, my exception list
struct might scatter in 8 non-continuous memory segments.

In my code, each exception is presented by a 6-bytes struct. 4K
block can present an exception list containing at most about 670
exceptions. If I used 512 bytes block to present an exception list,
the number is just about 80. That is too small.

So, it's really a big favor to me if __getblk() could read 4K buffer
head in any case.

PS: There is no other kernel component have the demand like my
case? I am learning ext FS code now.

Regards.

Cong Meng.



On Fri, Oct 8, 2010 at 5:31 AM, Daniel Phillips <phillips@phunq.net> wrote:
> Hi Meng,
>
> The patch looks sensible, however the question is: why do you want to
> do this?  Would it not be better to generalize your metadata format to
> accomodate the device's native blocksize?
>
> Regards,
>
> Daniel
>
>> a kernel patch
>> --------------
>> Now, dm-snap-mv highly depends on a kernel patch below, which make __getblk()
>> can get a 4K buffer head while block size of the disk is NOT 4K.
>>
>> Signed-off-by: Cong Meng <mcpacino@gmail.com>
>> ---
>>  fs/buffer.c |    7 ++-----
>>  1 files changed, 2 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/buffer.c b/fs/buffer.c
>> index 3e7dca2..f7f9d33 100644
>> --- a/fs/buffer.c
>> +++ b/fs/buffer.c
>> @@ -1051,10 +1051,7 @@ grow_buffers(struct block_device *bdev, sector_t block, int size)
>>       pgoff_t index;
>>       int sizebits;
>>
>> -     sizebits = -1;
>> -     do {
>> -             sizebits++;
>> -     } while ((size << sizebits) < PAGE_SIZE);
>> +     sizebits = PAGE_CACHE_SHIFT - bdev->bd_inode->i_blkbits;
>>
>>       index = block >> sizebits;
>>
>> @@ -2924,7 +2921,7 @@ int submit_bh(int rw, struct buffer_head * bh)
>>        */
>>       bio = bio_alloc(GFP_NOIO, 1);
>>
>> -     bio->bi_sector = bh->b_blocknr * (bh->b_size >> 9);
>> +     bio->bi_sector = bh->b_blocknr << (bh->b_bdev->bd_inode->i_blkbits - 9);
>>       bio->bi_bdev = bh->b_bdev;
>>       bio->bi_io_vec[0].bv_page = bh->b_page;
>>       bio->bi_io_vec[0].bv_len = bh->b_size;
>
