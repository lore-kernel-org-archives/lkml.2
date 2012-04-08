Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756520Ab2DIAAc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 20:00:32 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49250 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507Ab2DIAAa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 20:00:30 -0400
MIME-Version: 1.0
In-Reply-To: <1333925535.2508.15.camel@joe2Laptop>
References: <1333924698-3894-1-git-send-email-jim.cromie@gmail.com> <1333925535.2508.15.camel@joe2Laptop>
From: Jim Cromie <jim.cromie@gmail.com>
Date: Sun, 8 Apr 2012 17:59:59 -0600
Message-ID: <CAJfuBxz2fD2KDxpg5gZfGW4bFvuviTG709Aev0=p-ojuzRNpCQ@mail.gmail.com>
Subject: Re: [00/02] add BUILD_BUG_DECL assertion (for 3.4??)
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 8, 2012 at 4:52 PM, Joe Perches <joe@perches.com> wrote:
> On Sun, 2012-04-08 at 16:38 -0600, Jim Cromie wrote:
>
>> this patch (0001) adds new bug.h macro, BUILD_BUG_DECL(name, cond),
>> which unlike other *BUG* assertions is usable at file scope.  Its
>> primary purpose is to enforce identical sizes of 2 separate arrays,
>> which but for considerations of packing/padding/section, would be
>> together in a struct.
>>
>> const char const *names[] = { "bart", "lisa", "homer", "marge" };
>> int a[] = {1,2,3,4};
>> int b[] = {1,2,3,5};
>> long d[] = {1,2};
>>
>> BUILD_BUG_DECL(foo, ARRAY_SIZE(a) != ARRAY_SIZE(b));
>> BUILD_BUG_DECL(buz, sizeof(a) != sizeof(b));  // good
>> BUILD_BUG_DECL(a, sizeof(a) != sizeof(d));    // ok on x32, error x64
>> BUILD_BUG_DECL(b, ARRAY_SIZE(a) != ARRAY_SIZE(names));        // good
>>
>> macro expands as:
>> static __attribute__ ((__section__(".init.data"))) struct {
>>        int BUILD_BUG_DECL_buz[1 - 2*!!(sizeof(a) != sizeof(b))];
>> } BUILD_BUG_DECL_buz[0] __attribute__((unused));
>>
>
> If possible, it might be better to wrap the
> declarations themselves in a macro that ensures
> the sizes are the same.
>
> Something like:
>
> declare_same_size_arrays(
>        typeof array1[] = {...},
>        typeof array2[] = {...}
> );
>
>

Unless Im mis-reading you, this has a couple disadvantages:

- bigger patches where its added.
granted these are mostly whitespace, but theyre less trivial to inspect.

- not useful for array definitions which are not contiguous
granted thats a minority case, and the definitions could often be moved,
but not always.

WAG: If *80211 code were to export tables that drivers could use,
(say standardized frequency, channel stuff)
it would be helpful if the drivers could assert that their private tables match
the exported ones.  (I havent looked in *80211, or tried using
BUILD_BUG_DECL this way)

Do you see advantages other than stylistic ones ?
