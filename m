Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204Ab1BXMCw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 07:02:52 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:34734 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380Ab1BXMCt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 07:02:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=D+zMTeT7DLX59FhbwOw41XPBxOP15Sou/WmkYxDcxN9BrhaiHofDkyLwl8uwxcfsey
         9XFWib/jSJ6gB/f+kC/ftAOBOYXxB9KTfI9jQwglXyzdXfAt2UR2z/CXzLcRyq2K5OL6
         qCz/5l6x0gDaasmaozP1EwNzkgBYLzyjZPkgQ=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1102241227040.3190@dhcp-27-109.brq.redhat.com>
References: <20110224051046.GA30130@july>
	<alpine.LFD.2.00.1102240934360.3190@dhcp-27-109.brq.redhat.com>
	<AANLkTi==xJLbqSs6E-+cqxRNZqb4ANayCaqUfST_MoqO@mail.gmail.com>
	<alpine.LFD.2.00.1102241158320.3190@dhcp-27-109.brq.redhat.com>
	<AANLkTimnj1Cq1ojs6RkVxqsus1Ab4ycebfcdL05XLrjQ@mail.gmail.com>
	<alpine.LFD.2.00.1102241227040.3190@dhcp-27-109.brq.redhat.com>
Date: Thu, 24 Feb 2011 21:02:47 +0900
X-Google-Sender-Auth: vv474kyJJwAL4SMScFt6BuBwxEY
Message-ID: <AANLkTikHMtzeqnvOEC7eNNADw0ziUTYztbQ=d4R2Y4rq@mail.gmail.com>
Subject: Re: [PATCH v2] fat: Batched discard support for fat
From: Kyungmin Park <kmpark@infradead.org>
To: Lukas Czerner <lczerner@redhat.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2011 at 8:40 PM, Lukas Czerner <lczerner@redhat.com> wrote:
> On Thu, 24 Feb 2011, Kyungmin Park wrote:
>
> ...snip...
>> >> >> +     while (count < sbi->max_cluster) {
>> >> >> +             if (fatent.entry >= sbi->max_cluster)
>> >> >> +                     fatent.entry = FAT_START_ENT;
>> >> >> +             /* readahead of fat blocks */
>> >> >> +             if ((cur_block & reada_mask) == 0) {
>> >> >> +                     unsigned long rest = sbi->fat_length - cur_block;
>> >> >> +                     fat_ent_reada(sb, &fatent, min(reada_blocks, rest));
>> >> >> +             }
>> >> >> +             cur_block++;
>> >> >> +
>> >> >> +             err = fat_ent_read_block(sb, &fatent);
>> >> >> +             if (err)
>> >> >> +                     goto out;
>> >> >> +
>> >> >> +             do {
>> >> >> +                     if (ops->ent_get(&fatent) == FAT_ENT_FREE) {
>> >> >> +                             free++;
>> >> >> +                             if (!entry)
>> >> >> +                                     entry = fatent.entry;
>> >> >> +                             if (free >= (len - trimmed) && free >= minlen) {
>> >> >
>> >> > It seems to me that you are using len as number of bytes to trim. This
>> >> > is not right and I am sorry for not explaining it correctly. "len" is
>> >> > supposed to be a number of bytes you want to "investigate" from the start.
>> >> > So it means that you will trim every single free extent bigger than minlen
>> >> > between "start" byte and "start + len" byte of the underlying device, or
>> >> > partition.
>> >> No. len is adjusted at fat cluster number. it's not used byte unit.
>> >> I think it's easy to compare with fat internal units.
>> >
>> > Does not matter what units are you using for len. I it just that you are
>> > checking for (free >= (len - trimmed)) which is wrong because len is not
>> > meant to be "overall length of trimmed data" but rather "overall length
>> > of data to walk through and check for free extents" see ext4
>> > implementation for reference.
>> I think I used it as you said. e.g., I want to trim 256 (* minimum
>> discard granularity),
>> First time, I can find 10 entries. and trimmed has 10 and len has still 256.
>> next time, I found the 246 free entries then trim remaining 246 one.
>>
>> do you want to trim it more than given len?
>
> Let the "O" be free (bytes, blocks, whatever), and "=" be used.
> Now, we have a filesystem like this.
>
>   OOOO==O===OO===OOOOO==O===O===OOOOOOO===
>   ^                                      ^
>   0                                      40
>
> This is how it supposed to wotk if you have called FITIRM with parameters:
>
> start = 0
> minlen = 2
> len = 20
>
> So you will go through (blocks, bytes...) 0 -> 20
>
>   OOOO==O===OO===OOOOO==O===O===OOOOOOO===
>   ^                   ^
>   0                   20
>
> So, you will call discard on extents:
>
> 0-3
> You'll skip 6 because is smaller than minlen
> 10-11
> 15-19
>
>
> But in your implementation you will trim extents:
> 0-3
> 10-11
> 15-19
> 30-36
>
> Hope it is clear now.

Okay you mean it's end address instead of total amount of trim size.
It will be helpful if you add these diagram or comments on
linux/include/fs.h

Thank you,
Kyungmin Park
>
>>
>> Thank you,
>> Kyungmin Park
>> >
>> > Thanks!
>> > -Lukas
>> >
>> >>
>> >> I hope fat peoples comment this one.
>> >>
>> >> Thank you,
>> >> Kyungmin Park
>> >> >
>> >> >> +                                     fat_issue_discard(sb, entry, free);
>> >> >> +                                     trimmed += free;
>> >> >> +                             }
>> >> >> +                             if (trimmed >= len)
>> >> >> +                                     goto done;
>> >> >> +                     } else if (entry) {
>> >> >> +                             if (free >= minlen) {
>> >> >> +                                     fat_issue_discard(sb, entry, free);
>> >> >> +                                     trimmed += free;
>> >> >> +                             }
>> >> >> +                             if (trimmed >= len)
>> >> >> +                                     goto done;
>> >> >> +                             free = 0;
>> >> >> +                             entry = 0;
>> >> >> +                     }
>> >> >> +                     count++;
>> >> >> +             } while (fat_ent_next(sbi, &fatent));
>> >> >> +     }
>> >> >> +     if (free >= minlen) {
>> >> >> +             fat_issue_discard(sb, entry, free);
>> >> >> +             trimmed += free;
>> >> >> +     }
>> >> >> +done:
>> >> >> +     range->len = (trimmed * sbi->sec_per_clus) << sb->s_blocksize_bits;
>> >> >> +     fatent_brelse(&fatent);
>> >> >> +out:
>> >> >> +     unlock_fat(sbi);
>> >> >> +     return err;
>> >> >> +}
>
> ...snip...
