Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576Ab2JVN4f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 09:56:35 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:43811 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753182Ab2JVN4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 09:56:34 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <20121022133534.GR16230@one.firstfloor.org>
References: <1350665289-7288-1-git-send-email-andi@firstfloor.org>
 <CAHO5Pa0W-WGBaPvzdRJxYPdrg-K9guChswo3KJheK4BaRzsRwQ@mail.gmail.com>
 <20121022132733.GQ16230@one.firstfloor.org> <20121022133534.GR16230@one.firstfloor.org>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Mon, 22 Oct 2012 15:56:13 +0200
Message-ID: <CAKgNAkgQ6JZdwOsCAQ4Ak_gVXtav=TzgzW2tbk5jMUwxtMqOAg@mail.gmail.com>
Subject: Re: [PATCH] MM: Support more pagesizes for MAP_HUGETLB/SHM_HUGETLB v6
To: Andi Kleen <andi@firstfloor.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 3:35 PM, Andi Kleen <andi@firstfloor.org> wrote:
> On Mon, Oct 22, 2012 at 03:27:33PM +0200, Andi Kleen wrote:
>> > Maybe I am missing something obvious, but does this not conflict with
>> > include/uapi/asm-generic/mman-common.h:
>> >
>> > #ifdef CONFIG_MMAP_ALLOW_UNINITIALIZED
>> > # define MAP_UNINITIALIZED 0x4000000
>> > ...
>> >
>> > 0x4000000 == (1 << 26
>> >
>>
>> You're right. Someone added that since I wrote the patch originally.
>> I owned them when originally submitted @) Thanks for catching.
>>
>> Have to move my bits two up, which will still work, but limit the
>
> Two up won't work, need one up.
>
> 32..28 = 16  is too small for 2^30 = 1GB pages
> 32..27 = 32  max 4GB pages

Not sure of your notation there. I assume 31..27 means 5 bits (32
through to 28 inclusive, 27 excluded). That gives you just 2^31 ==
2GB, not 4GB (unless your planning to always add 1 to the value in
those bits, since a value of zero has little meaning).

But there seems an obvious solution here: given your value in those
bits (call it 'n'), the why not apply a multiplier. I mean, certainly
you never want a value <= 12 for n, and I suspect that the reasonable
minimum could be much larger (e.g., 2^16). Call that minimum M. Then
you could interpret the value in your bits as meaning a page size of

    (2^n) * M

> So this will use up all remaining flag bits now.

On the other hand, that seems really bad. It looks like that kills the
ability to further extend the mmap() API with new flags in the future.
It doesn't sound like we should be doing that.

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
