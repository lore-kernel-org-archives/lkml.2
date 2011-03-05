Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801Ab1CEEZk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 23:25:40 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:45412 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537Ab1CEEZg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 23:25:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ig1DS6dv3X4KBHZYnFwNIh62/Cu1v91syarDozMUIZ3YEK9LjrIIMSCqrlHZMeXmec
         QkPngk/XRL4ZSQj8t7GQrLCRYGcPPjdgyBm4BpTaXdJG7b9yUTqTrkY6ZyIh9WVSYKYU
         jMQtn216tikqN7sBGPsgICMxf1chUuKDpWKJ8=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1103021257210.2942@dhcp-27-109.brq.redhat.com>
References: <20110225010346.GA9019@july>
	<alpine.LFD.2.00.1102251114580.3316@dhcp-27-109.brq.redhat.com>
	<AANLkTikBOk=gJ70fO4zQTYJ5=bdWAmjVfuNiVaMt-atW@mail.gmail.com>
	<alpine.LFD.2.00.1102281334080.3297@dhcp-27-109.brq.redhat.com>
	<AANLkTi=L_3-_orw8_mkdvR-55z0iKWGR6=7OKgSf8QR2@mail.gmail.com>
	<AANLkTimu5rFCTmtOxct1oTxqQa-0TxV-r2CzKb5ZZNwe@mail.gmail.com>
	<alpine.LFD.2.00.1103021257210.2942@dhcp-27-109.brq.redhat.com>
Date: Sat, 5 Mar 2011 13:25:34 +0900
X-Google-Sender-Auth: Ox7oAOQ9h16e3cXVgic0Ku7GZ0k
Message-ID: <AANLkTik8Qc=qZmo=u8YbO8f9=JeSJdE-7VK1aa_xh16T@mail.gmail.com>
Subject: Re: [PATCH v3] fat: Batched discard support for fat
From: Kyungmin Park <kmpark@infradead.org>
To: Lukas Czerner <lczerner@redhat.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 2, 2011 at 9:10 PM, Lukas Czerner <lczerner@redhat.com> wrote:
> On Wed, 2 Mar 2011, Kyungmin Park wrote:
>
>> On Wed, Mar 2, 2011 at 11:07 AM, Kyungmin Park <kmpark@infradead.org> wrote:
>> > On Mon, Feb 28, 2011 at 9:51 PM, Lukas Czerner <lczerner@redhat.com> wrote:
>> >> On Mon, 28 Feb 2011, Kyungmin Park wrote:
>> >>
>> >>> On Fri, Feb 25, 2011 at 8:17 PM, Lukas Czerner <lczerner@redhat.com> wrote:
>> >>> > On Fri, 25 Feb 2011, Kyungmin Park wrote:
>> >>> >
>> >>> >> From: Kyungmin Park <kyungmin.park@samsung.com>
>> >>> >>
>> >>> >> FAT supports batched discard as ext4.
>> >>> >>
>> >>> >> Cited from Lukas words.
>> >>> >> "The current solution is not ideal because of its bad performance impact.
>> >>> >> So basic idea to improve things is to avoid discarding every time some
>> >>> >> blocks are freed. and instead batching is together into bigger trims,
>> >>> >> which tends to be more effective."
>> >>> >>
>> >>> >> You can find an information in detail at following URLs.
>> >>> >> http://lwn.net/Articles/397538/
>> >>> >> http://lwn.net/Articles/383933/
>> >>> >>
>> >>> >> Clearify the meaning of "len" (Cited form Lukas mail)
>> >>> >>
>> >>> >> Let the "O" be free (bytes, blocks, whatever), and "=" be used.
>> >>> >> Now, we have a filesystem like this.
>> >>> >>
>> >>> >>   OOOO==O===OO===OOOOO==O===O===OOOOOOO===
>> >>> >>   ^                                      ^
>> >>> >>   0                                      40
>> >>> >>
>> >>> >> This is how it supposed to wotk if you have called FITIRM with parameters:
>> >>> >>
>> >>> >> start = 0
>> >>> >> minlen = 2
>> >>> >> len = 20
>> >>> >>
>> >>> >> So you will go through (blocks, bytes...) 0 -> 20
>> >>> >>
>> >>> >>   OOOO==O===OO===OOOOO==O===O===OOOOOOO===
>> >>> >>   ^                   ^
>> >>> >>   0                   20
>> >>> >>
>> >>> >> So, you will call discard on extents:
>> >>> >>
>> >>> >> 0-3
>> >>> >> You'll skip 6 because is smaller than minlen
>> >>> >> 10-11
>> >>> >> 15-19
>> >>> >>
>> >>> >> instead of
>> >>> >>
>> >>> >> 0-3
>> >>> >> 10-11
>> >>> >> 15-19
>> >>> >> 30-36
>> >>> >
>> >>> > Hi thanks for the next version. And again I have to ask: Did you test it
>> >>> > ? and how ? Did you tried xfstest No. 251 ? Couple of comments bellow.
>> >>>
>> >>> I tested it with your test program. Of course I modified for our
>> >>> environment (eMMC).
>> >>
>> >> Ok, good.
>> >>
>> >>>
>> >>> #include <errno.h>
>> >>> #include <fcntl.h>
>> >>> #include <stdio.h>
>> >>> #include <stdint.h>
>> >>> #include <sys/ioctl.h>
>> >>>
>> >>> struct fstrim_range {
>> >>>         uint64_t start;
>> >>>         uint64_t len;
>> >>>         uint64_t minlen;
>> >>> };
>> >>>
>> >>> #define FITRIM          _IOWR('X', 121, struct fstrim_range)
>> >>>
>> >>> int main(int argc, char **argv)
>> >>> {
>> >>>         struct fstrim_range range;
>> >>>         uint64_t len;
>> >>>         int fd;
>> >>>
>> >>>         if (argc < 2) {
>> >>>                 fprintf(stderr, "usage: %s mountpoint [size]\n", argv[0]);
>> >>>                 return 1;
>> >>>         }
>> >>>
>> >>>         if (argc == 3)
>> >>>                 len = atoll(argv[1]);
>> >>>         else
>> >>>                 len = ((1UL<<31) - 1);
>> >>>
>> >>>         range.start = 0;
>> >>>         range.len = len;
>> >>>         range.minlen = 256 * 1024;      /* Minimum is 256KiB */
>> >>
>> >> Why exactly you need to set this ? What will happen if the minlen is 0 ?
>> >
>> > It's dependent on eMMC chip. it's for our environment. If it passed
>> > with 0, the code is working but the less than 256KiB trim command is
>> > meaningless.
>
> Ok but user would not care, actually he would not even know so it is
> good that this will work, but if kernel knows what minlen value is
> meaningless maybe you should adjust that properly the same way as you
> are adjusting according to the discard_granularity ?

It's out of this patch, it will be handled each underlying devices,
e.g., MMC and ATA.
>
> ..snip..
>
>>
>> How about this code?
>>
>>         while (count < sbi->max_cluster) {
>>                 if (fatent.entry >= sbi->max_cluster)
>>                         fatent.entry = FAT_START_ENT;
>>                 /* readahead of fat blocks */
>>                 if ((cur_block & reada_mask) == 0) {
>>                         unsigned long rest = sbi->fat_length - cur_block;
>>                         fat_ent_reada(sb, &fatent, min(reada_blocks, rest));
>>                 }
>>                 cur_block++;
>>
>>                 err = fat_ent_read_block(sb, &fatent);
>>                 if (err)
>>                         goto out;
>>
>>                 do {
>>                         if (ops->ent_get(&fatent) == FAT_ENT_FREE) {
>>                                 free++;
>>                                 if (!entry)
>>                                         entry = fatent.entry;
>>                         } else if (entry) {
>>                                 /*
>>                                  * Discard if free entry is equal or greater
>>                                  * than minimum length
>>                                  */
>
> This comment states what we can already see in the simple condition, so
> it is not needed, but rather comment while() and do..while loops. But as
> I said I am not familiar with FAT code so that might be just my fault.

No problem I will delete it.
>
>>                                 if (free >= minlen) {
>>                                         fat_issue_discard(sb, entry, free);
>>                                         trimmed += free;
>>                                 }
>>                                 free = 0;
>>                                 entry = 0;
>>                         }
>>                         count++;
>>                         /* Check the loop count */
> same thing with this comment, we can see that in the simple condition.
I'll delete it.
>>                         if (count >= len)
>>                                 goto done;
>>                 } while (fat_ent_next(sbi, &fatent));
>>         }
>> done:
>>         if (free >= minlen) {
>>                 fat_issue_discard(sb, entry, free);
>>                 trimmed += free;
>>         }
>>         range->len = (trimmed * sbi->sec_per_clus) << sb->s_blocksize_bits;
>>         fatent_brelse(&fatent);
>> out:
>>         unlock_fat(sbi);
>>         return err;
>>
> It looks better, thanks for your work!

I'll resend it.

Thank you,
Kyungmin Park
>
> -Lukas
>
>
> ..snip..
