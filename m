Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511Ab2JaKBt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 06:01:49 -0400
Received: from co202.xi-lite.net ([149.6.83.202]:33441 "EHLO co202.xi-lite.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235Ab2JaKBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 06:01:47 -0400
Message-ID: <5090F708.3010104@parrot.com>
Date: Wed, 31 Oct 2012 11:01:44 +0100
From: Matthieu CASTET <matthieu.castet@parrot.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100228)
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Matthieu CASTET <castet.matthieu@free.fr>,
        Russell King <rmk@arm.linux.org.uk>,
        Shiyong Li <shi-yong.li@motorola.com>,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] slab : allow SLAB_RED_ZONE and SLAB_STORE_USER to work
 on arm
References: <1350386231-770-1-git-send-email-matthieu.castet@parrot.com> <CAOJsxLHQy7pshnskn+wMp=1D9+9wGQZBhFD+kjtbCSJvoW7q2Q@mail.gmail.com>
In-Reply-To: <CAOJsxLHQy7pshnskn+wMp=1D9+9wGQZBhFD+kjtbCSJvoW7q2Q@mail.gmail.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg a écrit :
> Hi,
> 
> (Adding more people to CC.)
> 
> On Tue, Oct 16, 2012 at 2:17 PM, Matthieu CASTET
> <matthieu.castet@parrot.com> wrote:
>> From: Matthieu CASTET <castet.matthieu@free.fr>
>>
>> on cortexA8 (omap3) ralign is 64 and __alignof__(unsigned long long) is 8.
>> So we always disable debug.
>>
>> This patch is based on 5c5e3b33b7cb959a401f823707bee006caadd76e, but fix
>> case were align < sizeof(unsigned long long).
>>
>> Signed-off-by: Matthieu Castet <matthieu.castet@parrot.com>
>> CC: Russell King <rmk@arm.linux.org.uk>
>> CC: Pekka Enberg <penberg@cs.helsinki.fi>
>> ---
>>  mm/slab.c |    8 +++-----
>>  1 file changed, 3 insertions(+), 5 deletions(-)
>>
>> diff --git a/mm/slab.c b/mm/slab.c
>> index c685475..8427901 100644
>> --- a/mm/slab.c
>> +++ b/mm/slab.c
>> @@ -2462,9 +2462,6 @@ __kmem_cache_create (const char *name, size_t size, size_t align,
>>         if (ralign < align) {
>>                 ralign = align;
>>         }
>> -       /* disable debug if necessary */
>> -       if (ralign > __alignof__(unsigned long long))
>> -               flags &= ~(SLAB_RED_ZONE | SLAB_STORE_USER);
>>         /*
>>          * 4) Store it.
>>          */
>> @@ -2491,8 +2488,9 @@ __kmem_cache_create (const char *name, size_t size, size_t align,
>>          */
>>         if (flags & SLAB_RED_ZONE) {
>>                 /* add space for red zone words */
>> -               cachep->obj_offset += sizeof(unsigned long long);
>> -               size += 2 * sizeof(unsigned long long);
>> +               int offset = max(align, sizeof(unsigned long long));
>> +               cachep->obj_offset += offset;
>> +               size += offset + sizeof(unsigned long long);
>>         }
>>         if (flags & SLAB_STORE_USER) {
>>                 /* user store requires one word storage behind the end of
> 
> This piece of code tends to break in peculiar ways every time someone
> touches it. I could use some more convincing in the changelog this
> time it won't...
> 
Ok, is the following changelog is ok ?

The current slab code only allow to put redzone( and user store) info if "buffer
alignment(ralign) <= __alignof__(unsigned long long)". This was done because we
want to keep the buffer aligned for user even after adding redzone at the
beginning of the buffer (the user store is stored after user buffer) [1]

But instead of disabling this feature when "ralign > __alignof__(unsigned long
long)", we can force the alignment by allocating ralign before user buffer.

This is done by setting ralign in obj_offset when "ralign > __alignof__(unsigned
long long)" and keeping the old behavior when  "ralign <= __alignof__(unsigned
long long)" (we set sizeof(unsigned long long)).

The 5c5e3b33b7cb959a401f823707bee006caadd76e commit wasn't handling "ralign <=
__alignof__(unsigned long long)", that's why it broked some configuration.

This was tested on omap3 (ralign is 64 and __alignof__(unsigned long long) is 8)


[1]
/*
 * memory layout of objects:
 * 0        : objp
 * 0 .. cachep->obj_offset - BYTES_PER_WORD - 1: padding. This ensures that
 *      the end of an object is aligned with the end of the real
 *      allocation. Catches writes behind the end of the allocation.
 * cachep->obj_offset - BYTES_PER_WORD .. cachep->obj_offset - 1:
 *      redzone word.
 * cachep->obj_offset: The real object.
 * cachep->buffer_size - 2* BYTES_PER_WORD: redzone word [BYTES_PER_WORD long]
 * cachep->buffer_size - 1* BYTES_PER_WORD: last caller address
 *                  [BYTES_PER_WORD long]
 */
