Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986Ab0LQT5K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 14:57:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57723 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755532Ab0LQT44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 14:56:56 -0500
Message-ID: <4D0BC067.90507@zytor.com>
Date: Fri, 17 Dec 2010 11:56:23 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Yinghai Lu <yinghai@kernel.org>, Stanislaw Gruszka <sgruszka@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Maxim Uvarov <muvarov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Neil Horman <nhorman@redhat.com>
Subject: Re: kdump broken on 2.6.37-rc4
References: <20101215103954.GA2243@redhat.com> <4D09958D.2040907@kernel.org> <4D0AD976.3020504@zytor.com> <3C6B7683-9CDC-4C4A-A32A-56227DE01387@kernel.org> <20101217170146.GC9568@redhat.com> <4D0BA45A.7020402@zytor.com> <20101217180242.GB12425@redhat.com> <4D0BAA24.3080801@kernel.org> <4D0BBC55.4010207@zytor.com> <4D0BBE00.3010602@kernel.org> <20101217195035.GE14502@redhat.com>
In-Reply-To: <20101217195035.GE14502@redhat.com>
Content-Type: multipart/mixed;
 boundary="------------060706070509000800080800"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060706070509000800080800
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 12/17/2010 11:50 AM, Vivek Goyal wrote:
> On Fri, Dec 17, 2010 at 11:46:08AM -0800, Yinghai Lu wrote:
>> On 12/17/2010 11:39 AM, H. Peter Anvin wrote:
>>> On 12/17/2010 10:21 AM, Yinghai Lu wrote:
>>>>>>
>>>>>> Do we have actual testing for how high the 64-bit kernel will load?
>>>>>
>>>>> I will do some experiments on my box today and let you know.
>>>>
>>>> if bzImage is used, it is 896M.
>>>>
>>>
>>> Why?  896 MiB is a 32-bit kernel limitation which doesn't have anything
>>> to do with the bzImage format.
>>>
>>> So unless there is something going on here, I suspect you're just plain
>>> flat wrong.
>>
>> kexec-tools have some checking when it loads bzImage.
>>
> 
> Yinghai,
> 
> I think x86_64 might have just inherited the settings of 32bit without
> giving it too much of thought. At that point of time nobody bothered
> to load the kernel from high addresses. So these might be artificial
> limits.
> 

Can we do this in the meantime, just so we fix the immediate problem?

	-hpa

--------------060706070509000800080800
Content-Type: text/x-patch;
 name="0001-x86-kexec-Limit-the-crashkernel-address-to-768-MiB.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-x86-kexec-Limit-the-crashkernel-address-to-768-MiB.patc";
 filename*1="h"

>From 1ec83ca8dcc85bc5810bf7407d470a7261be1372 Mon Sep 17 00:00:00 2001
From: H. Peter Anvin <hpa@linux.intel.com>
Date: Thu, 16 Dec 2010 19:20:41 -0800
Subject: [PATCH] x86, kexec: Limit the crashkernel address to 768 MiB

Keep the crash kernel address below 768 MiB.  This makes it work on
32 bits even if the vmalloc= setting is adjusted slightly.

For 64 bits, we should be able to increase this substantially once a
hard-coded 896 MiB limit in kexec-tools is fixed.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <20101217195035.GE14502@redhat.com>
---
 arch/x86/kernel/setup.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 21c6746..2b7f5ab 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -501,7 +501,14 @@ static inline unsigned long long get_total_mem(void)
 	return total << PAGE_SHIFT;
 }
 
-#define DEFAULT_BZIMAGE_ADDR_MAX 0x37FFFFFF
+/*
+ * Keep the crash kernel below this limit.  This should be sufficient
+ * to load a 32-bit kernel even if the vmalloc limit is modified
+ * (within reason.)  This can be increased on 64 bits once kexec-tools
+ * is fixed.
+ */
+#define CRASH_KERNEL_ADDR_MAX	(768 << 20)
+
 static void __init reserve_crashkernel(void)
 {
 	unsigned long long total_mem;
@@ -520,10 +527,10 @@ static void __init reserve_crashkernel(void)
 		const unsigned long long alignment = 16<<20;	/* 16M */
 
 		/*
-		 *  kexec want bzImage is below DEFAULT_BZIMAGE_ADDR_MAX
+		 *  kexec want bzImage is below CRASH_KERNEL_ADDR_MAX
 		 */
 		crash_base = memblock_find_in_range(alignment,
-			       DEFAULT_BZIMAGE_ADDR_MAX, crash_size, alignment);
+			       CRASH_KERNEL_ADDR_MAX, crash_size, alignment);
 
 		if (crash_base == MEMBLOCK_ERROR) {
 			pr_info("crashkernel reservation failed - No suitable area found.\n");
-- 
1.7.2.3


--------------060706070509000800080800--
