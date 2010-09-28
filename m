Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab0I1HQy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 03:16:54 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:61277 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981Ab0I1HQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 03:16:53 -0400
Message-ID: <4CA195D7.4010706@kernel.org>
Date: Tue, 28 Sep 2010 00:14:31 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Vivek Goyal <vgoyal@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        kexec <kexec@lists.infradead.org>, caiqian@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: kexec load failure introduced by "x86, memblock: Replace e820_/_early
 string with memblock_"
References: <632974489.2046131285586512527.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com> <4CA11918.7050708@kernel.org> <4CA11FB7.2080101@zytor.com> <4CA126BE.7000609@kernel.org> <4CA1283C.9010105@zytor.com> <4CA12976.5060504@kernel.org> <4CA129EB.5000309@zytor.com> <4CA12BAB.1040308@kernel.org> <20100928005358.GA6456@redhat.com> <4CA16522.8060107@zytor.com>
In-Reply-To: <4CA16522.8060107@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2010 08:46 PM, H. Peter Anvin wrote:
> On 09/27/2010 05:53 PM, Vivek Goyal wrote:
>>
>> Actually, hardcoding the upper limit to 4G is probably not the best idea.
>> Kexec loads the the relocatable binary (purgatory) and I remember that
>> one of the generated relocation type was signed 32 bit and allowed max value
>> to be 2G only. So IIRC, purgatory code always needed to be loaded below 2G.
>>
>> I liked HPA's other idea better of introducing memblock_find_in_range_lowest() 
>> so that we search bottom up and not rely on a specific upper limit.
>>
> 
> No, it's just another crappy hack which is broken in the same way.  It's
> better than open-coding, but it's still a hack.
> 
> The Right Thing[TM] to do is for kexec to communicate the topmost
> address it wants to this code, so it has both the upper and the lower
> boundaries available to it instead of just one.

hope you are happy with this one.

[PATCH -v5] x86, memblock: Fix crashkernel allocation

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

-v5: use DEFAULT_BZIMAGE_ADDR_MAX to limit area that could be used by bzImge.
     also second try for vmlinux or new kexec tools will use bzImage 64bit entry

Reported-and-Bisected-by: CAI Qian <caiqian@redhat.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/setup.c |   24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

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
@@ -518,17 +519,28 @@ static void __init reserve_crashkernel(v
 	if (crash_base <= 0) {
 		const unsigned long long alignment = 16<<20;	/* 16M */
 
-		crash_base = memblock_find_in_range(alignment, ULONG_MAX, crash_size,
-				 alignment);
+		/*
+		 * Assume half crash_size is for bzImage
+		 *  kexec want bzImage is below DEFAULT_BZIMAGE_ADDR_MAX
+		 */
+		crash_base = memblock_find_in_range(alignment,
+				DEFAULT_BZIMAGE_ADDR_MAX + crash_size/2,
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
