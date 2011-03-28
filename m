Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239Ab1C1GVL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 02:21:11 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:44855 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259Ab1C1GVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 02:21:10 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Kyungmin Park <kmpark@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH v5] fat: Batched discard support for fat
References: <20110318020433.GA27263@july> <877hbkpo7v.fsf@devron.myhome.or.jp>
	<AANLkTimxojxAKbOE6XYa5DctNMpU8ob4+eAG05iwN=3P@mail.gmail.com>
Date: Mon, 28 Mar 2011 15:21:05 +0900
In-Reply-To: <AANLkTimxojxAKbOE6XYa5DctNMpU8ob4+eAG05iwN=3P@mail.gmail.com>
	(Kyungmin Park's message of "Mon, 28 Mar 2011 14:57:22 +0900")
Message-ID: <874o6n6a0e.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyungmin Park <kmpark@infradead.org> writes:

>>> +     start = range->start >> sb->s_blocksize_bits;
>>> +     start = start / sbi->sec_per_clus;
>>
>> start is round-down, I think it's strange interface. E.g. user specified
>> the range as "start=10 len=1024". So the range should be 10-1034,
>> i.e. (assume cluster-size is 512) 512-1024, right?
>
> I don't know what's the correct way? If you're right. it's better to round-up.
> If cluster-size is 32KiB and start sector is in the middle of cluster,
> then which is better. round-down or round-up?

It depends on the design of this interface though, I bet it's round-up,
and should use same way with other FSes.

>>> +     minlen = range->minlen >> sb->s_blocksize_bits;
>>> +     minlen = minlen / sbi->sec_per_clus;
>>> +     trimmed = 0;
>>> +     count = 0;
>>> +     err = -EINVAL;
>>> +
>>> +     lock_fat(sbi);
>>> +     if (sbi->free_clusters != -1 && sbi->free_clus_valid)
>>> +             goto out;
>>
>> free clusters count validation doesn't matter here. If you want to check
>> free cluster count, you should check free_clusters==0 or not (after
>> validation).
>
> I borrowed it from "fat_count_free_clusters()". anyway fill fix it.

Yes. fat_count_free_clusters() needs to check free_clusters value,
because it updates free_clusters value. If it's uptodate, does nothing.

>>> +     if (start < FAT_START_ENT)
>>> +             start = FAT_START_ENT;
>>
>> Valid data cluster is 2 - max_cluster, but it should be mapped to 0 -
>> (max_cluster - FAT_START_ENT). Otherwise this interface's abstraction is
>> useless, right?
>
> user program don't know the filesystem internals. The same program is
> used for ext4 and fat. so it should be handled at filesystem.

Yes. It's what I'm saying. If user wants to trim 0-2 then user will
specify 0-2, but this trims only 2. It's not right.

>>> +     fatent_set_entry(&fatent, start);
>>> +
>>> +     while (count < sbi->max_cluster) {
>>> +             if (fatent.entry >= sbi->max_cluster)
>>> +                     fatent.entry = FAT_START_ENT;
>>
>> Why do we cyclic this?
> If the start is middle and len is the whole disk size, then check the
> all clusters.

Strange design. If user wants to trim between middle and end, user have
to know length from middle correctly? Ext4 really does it?

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
