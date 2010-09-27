Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864Ab0I0Xmj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 19:42:39 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:61363 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410Ab0I0Xmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 19:42:38 -0400
Message-ID: <4CA12BAB.1040308@kernel.org>
Date: Mon, 27 Sep 2010 16:41:31 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: caiqian@redhat.com, Ingo Molnar <mingo@elte.hu>,
        kexec <kexec@lists.infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: kexec load failure introduced by "x86, memblock: Replace e820_/_early
 string with memblock_"
References: <632974489.2046131285586512527.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com> <4CA11918.7050708@kernel.org> <4CA11FB7.2080101@zytor.com> <4CA126BE.7000609@kernel.org> <4CA1283C.9010105@zytor.com> <4CA12976.5060504@kernel.org> <4CA129EB.5000309@zytor.com>
In-Reply-To: <4CA129EB.5000309@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2010 04:34 PM, H. Peter Anvin wrote:
> On 09/27/2010 04:32 PM, Yinghai Lu wrote:
>> On 09/27/2010 04:26 PM, H. Peter Anvin wrote:
>>> On 09/27/2010 04:20 PM, Yinghai Lu wrote:
>>>>
>>>> x86 own version for find_area?
>>>>
>>>
>>> No, double no.
>>>
>>> Same kind of crap: overloading an interface with semantics it shouldn't
>>> have.  The right thing is to introduce a new interface with carries the
>>> explicitly needed policy with it... e.g. memblock_find_in_range_lowest().
>>>
>>> That interface would have the explicit semantics of returning the lowest
>>> possible address, as opposed to any suitable address (which may change
>>> if policy requirements change.)
>>>
>>> The other question is why does kexec need this in the first place?  Is
>>> this due to a design bug in kexec or is there some fundamental reason
>>> for this?
>>
>> bzImage is used here. so need range below 4g.
>>
> 
> OK, so why don't you cap the range to 4 GiB and then pass that down to
> the existing interface?  That's different from "lowest possible address".

but if later bzImage will use 64 entry and kexec honor it, or use 64bit vmlinux directly.
and crashkernel=4096M, we could get failure again.

maybe something like this, will give it a try, hope kexec doesn't have other limitation.

[PATCH -v3] x86, memblock: Fix crashkernel allocation

Cai Qian found crashkernel is broken with x86 memblock changes
1. crashkernel=128M@32M always reported that range is used, even first kernel is small
   no one use that range
2. always get following report when using "kexec -p"
	Could not find a free area of memory of a000 bytes...
	locate_hole failed

The root cause is that generic memblock_find_in_range() will try to get range from top_down.
But crashkernel do need from low and specified range.

Let's limit the target range with rash_base + crash_size to make sure that
We get range from bottom.

-v3: don't use loop for find low one

Reported-and-Bisected-by: CAI Qian <caiqian@redhat.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/setup.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -518,17 +518,23 @@ static void __init reserve_crashkernel(v
 	if (crash_base <= 0) {
 		const unsigned long long alignment = 16<<20;	/* 16M */
 
-		crash_base = memblock_find_in_range(alignment, ULONG_MAX, crash_size,
-				 alignment);
+		crash_base = memblock_find_in_range(alignment, 0xffffffff,
+				crash_size, alignment);
+
 		if (crash_base == MEMBLOCK_ERROR) {
-			pr_info("crashkernel reservation failed - No suitable area found.\n");
-			return;
+			crash_base = memblock_find_in_range(alignment,
+					 ULONG_MAX, crash_size, alignment);
+
+			if (crash_base == MEMBLOCK_ERROR) {
+				pr_info("crashkernel reservation failed - No suitable area found.\n");
+				return;
+			}
 		}
 	} else {
 		unsigned long long start;
 
-		start = memblock_find_in_range(crash_base, ULONG_MAX, crash_size,
-				 1<<20);
+		start = memblock_find_in_range(crash_base,
+				 crash_base + crash_size, crash_size, 1<<20);
 		if (start != crash_base) {
 			pr_info("crashkernel reservation failed - memory is in use.\n");
 			return;
