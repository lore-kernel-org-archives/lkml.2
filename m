Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548Ab0JEXGL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 19:06:11 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:54968 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754791Ab0JEXGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 19:06:10 -0400
Message-ID: <4CABAF2A.5090501@kernel.org>
Date: Tue, 05 Oct 2010 16:05:14 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>, Vivek Goyal <vgoyal@redhat.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>
Subject: Re: [PATCH 2/4] x86, memblock: Fix crashkernel allocation
References: <4CAA4BD5.4020505@kernel.org> <4CAA4DE2.1020406@kernel.org> <4CABA6E5.6030601@zytor.com>
In-Reply-To: <4CABA6E5.6030601@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2010 03:29 PM, H. Peter Anvin wrote:
> On 10/04/2010 02:57 PM, Yinghai Lu wrote:
>>
>> +#define DEFAULT_BZIMAGE_ADDR_MAX 0x37FFFFFF
>>  static void __init reserve_crashkernel(void)
>>  {
>>  	unsigned long long total_mem;
>> @@ -518,17 +519,28 @@ static void __init reserve_crashkernel(v
>>  	if (crash_base <= 0) {
>>  		const unsigned long long alignment = 16<<20;	/* 16M */
>>  
>> -		crash_base = memblock_find_in_range(alignment, ULONG_MAX, crash_size,
>> -				 alignment);
>> +		/*
>> +		 * Assume half crash_size is for bzImage
>> +		 *  kexec want bzImage is below DEFAULT_BZIMAGE_ADDR_MAX
>> +		 */
>> +		crash_base = memblock_find_in_range(alignment,
>> +				DEFAULT_BZIMAGE_ADDR_MAX + crash_size/2,
>> +				crash_size, alignment);
>> +
>>  		if (crash_base == MEMBLOCK_ERROR) {
>> -			pr_info("crashkernel reservation failed - No suitable area found.\n");
>> -			return;
>> +			crash_base = memblock_find_in_range(alignment,
>> +					 ULONG_MAX, crash_size, alignment);
>> +
>> +			if (crash_base == MEMBLOCK_ERROR) {
>> +				pr_info("crashkernel reservation failed - No suitable area found.\n");
>> +				return;
>> +			}
>>  		}
>>  
> 
> Okay, this *really* doesn't make sense.
> 
> It's bad enough that kexec doesn't know what memory is safe for it, but
> why the heck the heuristic that "half is for bzImage and the rest can go
> beyond the heuristic limit"?

kdump want that range half for bzImage or half for initrd.

and kexec only check if bzImage can be put under small range.

>  Can't we at least simply cap the region to
> the default, unless the kexec system has passed in some knowable
> alternative?

+		crash_base = memblock_find_in_range(alignment,
+				DEFAULT_BZIMAGE_ADDR_MAX,
+				crash_size, alignment);


  Furthermore, why bother having the "fallback" at all
> (certainly without having a message!?)  If we don't get the memory area
> we need we're likely to randomly fail anyway.

if kexec is fixed to work with bzImage with 64bit entry...

> 
> Let me be completely clear -- it's obvious from all of this that kexec
> is fundamentally broken by design: if kexec can't communicate the safe
> memory to use it's busted seven ways to Sunday and it needs to be fixed.
>  However, in the meantime I can see capping the memory available to it
> as a temporary band-aid, but a fallback to picking random memory is
> nuts, especially on the motivation that "a future kexec version might be
> able to use it."  If so, the "future kexec tools" should SAY SO.

ok, please check

[PATCH -v6] x86, memblock: Fix crashkernel allocation

Cai Qian found crashkernel is broken with x86 memblock changes
1. crashkernel=128M@32M always reported that range is used, even first kernel is small
   no one use that range
2. always get following report when using "kexec -p"
	Could not find a free area of memory of a000 bytes...
	locate_hole failed

The root cause is that generic memblock_find_in_range() will try to get range from top_down.
But crashkernel do need from low and specified range.

Let's limit the target range with crash_base + crash_size to make sure that
We get exact range.

-v6: use DEFAULT_BZIMAGE_ADDR_MAX to limit area that could be used by bzImge.

Reported-and-Bisected-by: CAI Qian <caiqian@redhat.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/setup.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -501,6 +501,7 @@ static inline unsigned long long get_tot
 	return total << PAGE_SHIFT;
 }
 
+#define DEFAULT_BZIMAGE_ADDR_MAX 0x37FFFFFF
 static void __init reserve_crashkernel(void)
 {
 	unsigned long long total_mem;
@@ -518,8 +519,12 @@ static void __init reserve_crashkernel(v
 	if (crash_base <= 0) {
 		const unsigned long long alignment = 16<<20;	/* 16M */
 
-		crash_base = memblock_find_in_range(alignment, ULONG_MAX, crash_size,
-				 alignment);
+		/*
+		 *  kexec want bzImage is below DEFAULT_BZIMAGE_ADDR_MAX
+		 */
+		crash_base = memblock_find_in_range(alignment,
+			       DEFAULT_BZIMAGE_ADDR_MAX, crash_size, alignment);
+
 		if (crash_base == MEMBLOCK_ERROR) {
 			pr_info("crashkernel reservation failed - No suitable area found.\n");
 			return;
@@ -527,8 +532,8 @@ static void __init reserve_crashkernel(v
 	} else {
 		unsigned long long start;
 
-		start = memblock_find_in_range(crash_base, ULONG_MAX, crash_size,
-				 1<<20);
+		start = memblock_find_in_range(crash_base,
+				 crash_base + crash_size, crash_size, 1<<20);
 		if (start != crash_base) {
 			pr_info("crashkernel reservation failed - memory is in use.\n");
 			return;
