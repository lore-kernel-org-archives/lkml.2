Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370Ab0FHArO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 20:47:14 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:41887 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab0FHArN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 20:47:13 -0400
Message-ID: <4C0D9278.60907@oracle.com>
Date: Mon, 07 Jun 2010 17:44:40 -0700
From: Yinghai Lu <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] kernel/range: Remove unused definition of ARRAY_SIZE()
References: <alpine.DEB.2.00.1006052131230.15241@ayla.of.borg> <20100607154909.8581d654.akpm@linux-foundation.org>
In-Reply-To: <20100607154909.8581d654.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090207.4C0D92C5.00CD:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2010 03:49 PM, Andrew Morton wrote:
> On Sat, 5 Jun 2010 21:32:15 +0200 (CEST)
> Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> 
>> Remove duplicate definition of ARRAY_SIZE(), which was never used anyway.
>>
>> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>> ---
>>  kernel/range.c |    4 ----
>>  1 files changed, 0 insertions(+), 4 deletions(-)
>>
>> diff --git a/kernel/range.c b/kernel/range.c
>> index 74e2e61..471b66a 100644
>> --- a/kernel/range.c
>> +++ b/kernel/range.c
>> @@ -7,10 +7,6 @@
>>  
>>  #include <linux/range.h>
>>  
>> -#ifndef ARRAY_SIZE
>> -#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
>> -#endif
>> -
>>  int add_range(struct range *range, int az, int nr_range, u64 start, u64 end)
>>  {
>>  	if (start >= end)
> 
> <discovers range.c>
> 
> That's not terribly great code, sorry.
> 
> - The names are all wrong.  Should be range_add(),
>   range_add_with_merge(), range_subtract(), etc.
> 
> - It's completely undocumented!
> 
> - It's linked into every vmlinux in the world, many of which won't use it
>   afacit.
> 
> - The return value from add_range() is a bit odd.  I guess callers must do
> 
> 	if (add_range(..., ..., nr_range, ..., ...) == nr_range)
> 		error()
> 
> - What does the identifier "az" mean?
> 
> - `az' and `nr_range' should be unsigned types.  That would make the
>   "Out of slots:" check non-buggy.
> 
> - The return value from add_range_with_merge() is unusable!  If it
>   did a merge into the final range it will return the caller's
>   nr_range.  If it failed to merge it will call add_range() and then
>   will return the caller's nr_range if it ran out of space.
> 
>   So the caller cannot determine from the return value whether or not
>   the range was added.
> 
>   Or something.  This is an advantage of actually documenting code -
>   it makes people think about such things.
> 
> - The main structure seems just wrong, or at least inappropriate.  Should be
> 
> 	struct range {
> 		/* Number of ranges presently at *ranges */
> 		unsigned nr_ranges;
> 		/* Maximum number of ranges storable at *ranges */
> 		unsigned max_ranges;
> 		struct {
> 			u64 start;
> 			u64 end;
> 		} *ranges;
> 	};
> 
>   Or similar.
> 
> - I can't be bothered working out what subtract_range() and
>   clean_sort_range() are supposed to be doing, so I didn't look at
>   them.
> 
> c'mon guys, we can do better than this.

will work on using lmb to replace range.c later after lmb for x86 is in tip and linux-next.

Thanks

Yinghai
