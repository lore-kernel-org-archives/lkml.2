Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616Ab0EXCFu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 22:05:50 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58693 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754793Ab0EXCFs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 22:05:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qyLF31XUk5f3tLPMvQ/DuSSkHywsjqZMCBr5FcN7n5zdgWyjhcShgMZRy+0S9GfXKy
         ID7WDRo+X0i3+sDzdlivtLjngUGKQO21NptkXxlJ0XS5I43+0VZGszjKlFxsruPv9n9m
         NpdTodQ0YQydEH+aRZmno1VLOFxjg0ov2mOH0=
MIME-Version: 1.0
In-Reply-To: <4BF9CF00.2030704@cesarb.net>
References: <4BF81D87.6010506@cesarb.net>
	<20100523140348.GA10843@barrios-desktop>
	<4BF974D5.30207@cesarb.net>
	<AANLkTil1kwOHAcBpsZ_MdtjLmCAFByvF4xvm8JJ7r7dH@mail.gmail.com>
	<4BF9CF00.2030704@cesarb.net>
Date: Mon, 24 May 2010 11:05:47 +0900
Message-ID: <AANLkTin_BV6nWlmX6aXTaHvzH-DnsFIVxP5hz4aZYlqH@mail.gmail.com>
Subject: Re: [PATCH 0/3] mm: Swap checksum
From: Minchan Kim <minchan.kim@gmail.com>
To: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 24, 2010 at 9:57 AM, Cesar Eduardo Barros <cesarb@cesarb.net> wrote:
> Em 23-05-2010 21:09, Minchan Kim escreveu:
>>
>> Hi, Cesar.
>> I am not sure Cesar is first name. :)
>
> Yes, it is.
>
>> On Mon, May 24, 2010 at 3:32 AM, Cesar Eduardo Barros<cesarb@cesarb.net>
>>  wrote:
>>>
>>> Em 23-05-2010 11:03, Minchan Kim escreveu:
>>>>
>>>> We have been used swap pages without checksum.
>>>>
>>>> First of all, Could you explain why you need checksum on swap pages?
>>>> Do you see any problem which swap pages are broken?
>>>
>>> The same reason we need checksums in the filesystem.
>>>
>>> If you use btrfs as your root filesystem, you are protected by checksums
>>> from damage in the filesystem, but not in the swap partition (which is
>>> often
>>> in the same disk, and thus as vulnerable as the filesystem). It is better
>>> to
>>> get a checksum error when swapping in than having a silently corrupted
>>> page.
>>
>> Do you mean "vulnerable" is other file system or block I/O operation
>> invades swap partition and breaks data of swap?
>
> Vulnerable in that the same kind of hardware problems which can silently
> damage filesystem data in the disk can damage swap pages in the disk.
>
> This is the reason both btrfs and zfs checksum all their data and metadata.
> However, the swap partition is still vulnerable (using a swap file is not a
> solution, since the swap code bypasses the filesystem). And silent data
> corruption in the swap partition could be even worse than in the filesystem
> - while a program might not trust a file it is reading to not be corrupted,
> almost all programs will trust their *memory* to not be corrupted.
>
> The internal ECC of the disk will not save you - a quick Google search found
> an instance of someone with silent data corruption caused by a faulty *power
> supply*.[1]
>
> And if it is silent corruption, without the checksums you will not notice it
> - it will just be dismissed as "oh, Firefox just crashed again" or similar
> (the same as bit flips on RAM without ECC).

Thanks for kind explanation.

When I read your comment, suddenly some thought occurred to me.
If we can't believe ECC of the disk, why do we separate error
detection logic between file system and swap disk?

I mean it make sense that put crc detection into block layer?
It can make sure any block I/O.

And what's BER of disk?
Is it usual to meet the problem?

In normal desktop, some app killed are not critical. If the
application is critical, maybe app have to logic fault handling.
Firefox has session restore feature and Office program has temporal
save feature.

On the other hand, in server, does it designed well to use swap disk
until we meet bit error of disk?

My feel is that it seem to be rather overkill.

>
>> If it is, I think it's the problem of them. so we have to fix it
>> before merged into mainline. But I admit human being always take a
>> mistake so that we can miss it at review time. In such case, it would
>> be very hard bug when swap pages are broken. I haven't hear about such
>> problem until now but it might be useful if the problem happens.
>> (Maybe they can't notice that due to hard bug to find)
>>
>> But I have a concern about breaking memory which includes crc by
>> dangling pointer. In this case, swap block is correct but it would
>> emit crc error.
>>
>> Do you have an idea making sure memory includes crc is correct?
>
> The swap checksum only protects the page against being silently corrupted
> while on the disk and at least to some degree on the I/O path between the
> memory and the disk. It does not protect against broken kernel-mode code
> writing to the wrong address, nor against broken hardware (or hardware
> misconfigured by broken drivers) doing DMA to wrong addresses. It also does
> not protect against hardware errors in the RAM itself (you have ECC memory
> for that).
>
> That is, the code assumes the memory containing the checksums will not be
> corrupted, because if it is, you have worse problems (and the CRC error here
> would be a *good* thing, since it would make you notice something is not
> quite right).
>

Which is high between BER of RAM and disk?
It's a just question. :)

>
> [1] http://blogs.sun.com/elowe/entry/zfs_saves_the_day_ta
>
> --
> Cesar Eduardo Barros
> cesarb@cesarb.net
> cesar.barros@gmail.com
>



-- 
Kind regards,
Minchan Kim
