Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278Ab0EXA5m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 20:57:42 -0400
Received: from smtp-04.mandic.com.br ([200.225.81.151]:34717 "EHLO
	smtp-04.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab0EXA5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 20:57:40 -0400
Message-ID: <4BF9CF00.2030704@cesarb.net>
Date: Sun, 23 May 2010 21:57:36 -0300
From: Cesar Eduardo Barros <cesarb@cesarb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Minchan Kim <minchan.kim@gmail.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 0/3] mm: Swap checksum
References: <4BF81D87.6010506@cesarb.net>	<20100523140348.GA10843@barrios-desktop>	<4BF974D5.30207@cesarb.net> <AANLkTil1kwOHAcBpsZ_MdtjLmCAFByvF4xvm8JJ7r7dH@mail.gmail.com>
In-Reply-To: <AANLkTil1kwOHAcBpsZ_MdtjLmCAFByvF4xvm8JJ7r7dH@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 23-05-2010 21:09, Minchan Kim escreveu:
> Hi, Cesar.
> I am not sure Cesar is first name. :)

Yes, it is.

> On Mon, May 24, 2010 at 3:32 AM, Cesar Eduardo Barros<cesarb@cesarb.net>  wrote:
>> Em 23-05-2010 11:03, Minchan Kim escreveu:
>>> We have been used swap pages without checksum.
>>>
>>> First of all, Could you explain why you need checksum on swap pages?
>>> Do you see any problem which swap pages are broken?
>>
>> The same reason we need checksums in the filesystem.
>>
>> If you use btrfs as your root filesystem, you are protected by checksums
>> from damage in the filesystem, but not in the swap partition (which is often
>> in the same disk, and thus as vulnerable as the filesystem). It is better to
>> get a checksum error when swapping in than having a silently corrupted page.
>
> Do you mean "vulnerable" is other file system or block I/O operation
> invades swap partition and breaks data of swap?

Vulnerable in that the same kind of hardware problems which can silently 
damage filesystem data in the disk can damage swap pages in the disk.

This is the reason both btrfs and zfs checksum all their data and 
metadata. However, the swap partition is still vulnerable (using a swap 
file is not a solution, since the swap code bypasses the filesystem). 
And silent data corruption in the swap partition could be even worse 
than in the filesystem - while a program might not trust a file it is 
reading to not be corrupted, almost all programs will trust their 
*memory* to not be corrupted.

The internal ECC of the disk will not save you - a quick Google search 
found an instance of someone with silent data corruption caused by a 
faulty *power supply*.[1]

And if it is silent corruption, without the checksums you will not 
notice it - it will just be dismissed as "oh, Firefox just crashed 
again" or similar (the same as bit flips on RAM without ECC).

> If it is, I think it's the problem of them. so we have to fix it
> before merged into mainline. But I admit human being always take a
> mistake so that we can miss it at review time. In such case, it would
> be very hard bug when swap pages are broken. I haven't hear about such
> problem until now but it might be useful if the problem happens.
> (Maybe they can't notice that due to hard bug to find)
>
> But I have a concern about breaking memory which includes crc by
> dangling pointer. In this case, swap block is correct but it would
> emit crc error.
>
> Do you have an idea making sure memory includes crc is correct?

The swap checksum only protects the page against being silently 
corrupted while on the disk and at least to some degree on the I/O path 
between the memory and the disk. It does not protect against broken 
kernel-mode code writing to the wrong address, nor against broken 
hardware (or hardware misconfigured by broken drivers) doing DMA to 
wrong addresses. It also does not protect against hardware errors in the 
RAM itself (you have ECC memory for that).

That is, the code assumes the memory containing the checksums will not 
be corrupted, because if it is, you have worse problems (and the CRC 
error here would be a *good* thing, since it would make you notice 
something is not quite right).


[1] http://blogs.sun.com/elowe/entry/zfs_saves_the_day_ta

-- 
Cesar Eduardo Barros
cesarb@cesarb.net
cesar.barros@gmail.com
