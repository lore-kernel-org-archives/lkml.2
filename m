Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619Ab1C1G4p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 02:56:45 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40213 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140Ab1C1G4o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 02:56:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=HPDjqBt9ml20UPIDVmV0mu4fRyFn19ueehVATTB1jO1CVjBuJy59aOPwS7qu+9Qwuu
         rJwtcDmED7IVKM9vPNe3Ei27m75iYG5r84OQ71vYtDX58JGq7P7XfFSA11SkdlfD6s5Q
         ZtIl8f+Wea2g07xIayVleZ9kysREjnHqAvBvU=
MIME-Version: 1.0
In-Reply-To: <874o6n6a0e.fsf@devron.myhome.or.jp>
References: <20110318020433.GA27263@july>
	<877hbkpo7v.fsf@devron.myhome.or.jp>
	<AANLkTimxojxAKbOE6XYa5DctNMpU8ob4+eAG05iwN=3P@mail.gmail.com>
	<874o6n6a0e.fsf@devron.myhome.or.jp>
Date: Mon, 28 Mar 2011 15:56:42 +0900
X-Google-Sender-Auth: GbtqE7en6BCw9nEhZ7QPOAYzfuE
Message-ID: <AANLkTinTzj_BurexWAHa+EOt+GvpMB3Xm=GdtwdAt8i2@mail.gmail.com>
Subject: Re: [PATCH v5] fat: Batched discard support for fat
From: Kyungmin Park <kmpark@infradead.org>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Lukas Czerner <lczerner@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 3:21 PM, OGAWA Hirofumi
<hirofumi@mail.parknet.co.jp> wrote:
> Kyungmin Park <kmpark@infradead.org> writes:
>
>>>> +     start = range->start >> sb->s_blocksize_bits;
>>>> +     start = start / sbi->sec_per_clus;
>>>
>>> start is round-down, I think it's strange interface. E.g. user specified
>>> the range as "start=10 len=1024". So the range should be 10-1034,
>>> i.e. (assume cluster-size is 512) 512-1024, right?
>>
>> I don't know what's the correct way? If you're right. it's better to round-up.
>> If cluster-size is 32KiB and start sector is in the middle of cluster,
>> then which is better. round-down or round-up?
>
> It depends on the design of this interface though, I bet it's round-up,
> and should use same way with other FSes.
>
>>>> +     minlen = range->minlen >> sb->s_blocksize_bits;
>>>> +     minlen = minlen / sbi->sec_per_clus;
>>>> +     trimmed = 0;
>>>> +     count = 0;
>>>> +     err = -EINVAL;
>>>> +
>>>> +     lock_fat(sbi);
>>>> +     if (sbi->free_clusters != -1 && sbi->free_clus_valid)
>>>> +             goto out;
>>>
>>> free clusters count validation doesn't matter here. If you want to check
>>> free cluster count, you should check free_clusters==0 or not (after
>>> validation).
>>
>> I borrowed it from "fat_count_free_clusters()". anyway fill fix it.
>
> Yes. fat_count_free_clusters() needs to check free_clusters value,
> because it updates free_clusters value. If it's uptodate, does nothing.
>
>>>> +     if (start < FAT_START_ENT)
>>>> +             start = FAT_START_ENT;
>>>
>>> Valid data cluster is 2 - max_cluster, but it should be mapped to 0 -
>>> (max_cluster - FAT_START_ENT). Otherwise this interface's abstraction is
>>> useless, right?
>>
>> user program don't know the filesystem internals. The same program is
>> used for ext4 and fat. so it should be handled at filesystem.
>
> Yes. It's what I'm saying. If user wants to trim 0-2 then user will
> specify 0-2, but this trims only 2. It's not right.

There's similar code at ext4. it adjusts the start and len value if
given start is less than first_data_blk.

       if (start < first_data_blk) {
                len -= first_data_blk - start;
                start = first_data_blk;
        }

>
>>>> +     fatent_set_entry(&fatent, start);
>>>> +
>>>> +     while (count < sbi->max_cluster) {
>>>> +             if (fatent.entry >= sbi->max_cluster)
>>>> +                     fatent.entry = FAT_START_ENT;
>>>
>>> Why do we cyclic this?
>> If the start is middle and len is the whole disk size, then check the
>> all clusters.
>
> Strange design. If user wants to trim between middle and end, user have
> to know length from middle correctly? Ext4 really does it?

You're right, it only check the one-direction. else return -EINVAL.

       if (first_group > last_group)
                return -EINVAL;

>
> Thanks.
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
