Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293Ab1C2FLi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 01:11:38 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:40697 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab1C2FLg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 01:11:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=LQJgj5W69FLIRJgRuXW0p0Lgiu8Kd44OMppnYzdvwZn3mtOInK4R0TcI+xtmlGwayv
         dN29Q+9Bdwab5ITr52o3bIIpewVGad9wmM4pe2KIP6FKove0vL/ABmxmhWey4dy+f2eM
         W1vZ8CUgShHXRLk6b4egduew8mkSb5tH3Mfto=
MIME-Version: 1.0
In-Reply-To: <87k4fi4iwq.fsf@devron.myhome.or.jp>
References: <20110328103431.GA22323@july>
	<87k4fi4iwq.fsf@devron.myhome.or.jp>
Date: Tue, 29 Mar 2011 14:11:35 +0900
X-Google-Sender-Auth: OfB_Xav0bsvagiEyxglUWnVTGi8
Message-ID: <AANLkTinGPxxTaCzDUfgK7QX6C-AWim5ZJUub1BgCw4YC@mail.gmail.com>
Subject: Re: [PATCH v6] fat: Batched discard support for fat
From: Kyungmin Park <kmpark@infradead.org>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Lukas Czerner <lczerner@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 29, 2011 at 2:04 PM, OGAWA Hirofumi
<hirofumi@mail.parknet.co.jp> wrote:
> Kyungmin Park <kmpark@infradead.org> writes:
>
>> +int fat_trim_fs(struct super_block *sb, struct fstrim_range *range)
>> +{
>> +     struct msdos_sb_info *sbi = MSDOS_SB(sb);
>> +     struct fatent_operations *ops = sbi->fatent_ops;
>> +     struct fat_entry fatent;
>> +     unsigned long reada_blocks, reada_mask, cur_block;
>> +     int err, free, count, entry;
>> +     int start, len, minlen, trimmed;
>> +
>> +     start = range->start >> sb->s_blocksize_bits;
>> +     len = range->len >> sb->s_blocksize_bits;
>> +     len = round_down(start + len, sbi->sec_per_clus);
>> +     start = round_up(start, sbi->sec_per_clus);
>> +     minlen = range->minlen >> sb->s_blocksize_bits;
>> +     minlen = round_up(minlen, sbi->sec_per_clus);
>> +     trimmed = 0;
>> +     count = 0;
>> +     err = -EINVAL;
>
> Sorry for didn't mention at previous. You can use ->cluster_size, and
> ->cluster_bits.
>
>> +     if (start >= sbi->max_cluster)
>> +             goto out;
>> +
>> +     len = (len > sbi->max_cluster) ? sbi->max_cluster : len;
>
> [...]
>
>> +             trimmed += free;
>> +     }
>> +     range->len = (u64)(trimmed * sbi->sec_per_clus) << sb->s_blocksize_bits;
>> +     fatent_brelse(&fatent);
>> +out:
>> +     unlock_fat(sbi);
>> +     return err;
>
> Again, this ioctl's design is unclear, and seems to be strange. I
> wouldn't want to add this before clearing it. Please explain what is
> right behavior.

Umm it's out of my scope. it's trim design.
See also btrfs batched discard support. it's also no consideration as
you mentioned.

As I know, now xfs, ext4, and btrfs support this fstrim without these concern.

http://thread.gmane.org/gmane.comp.file-systems.btrfs/9758

Thank you,
Kyungmin Park

>
> E.g. if user specified 0-1024 and FS data block was actually started at
> 2048. What is right behavior? And if the end of blocks, what returned?
> For now, it seems to return range->len == 0 on both cases.
>
> Well, so, my suggestion is providing this like flat one extent
> file. I.e. FS have to map actual block placement to flat. And result
> also like write/read (return bytes as trimed, and at EOF returns 0).
>
> Thanks.
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
