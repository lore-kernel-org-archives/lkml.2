Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756879Ab2KAItQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 04:49:16 -0400
Received: from mga01.intel.com ([192.55.52.88]:63517 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754334Ab2KAItL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 04:49:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,692,1344236400"; 
   d="scan'208";a="241261575"
From: "Zhang, Jun" <jun.zhang@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Fleming, Matt" <matt.fleming@intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] To crash dump, we need keep other memory type except
 E820_RAM, because other type come from BIOS or firmware is used by other
 code(for example: PCI_MMCONFIG).
Thread-Topic: [PATCH] To crash dump, we need keep other memory type except
 E820_RAM, because other type come from BIOS or firmware is used by other
 code(for example: PCI_MMCONFIG).
Thread-Index: AQHNt+hSfR2Fx2YnIECke/y8I0UmkJfUqpWQ
Date: Thu, 1 Nov 2012 08:49:07 +0000
Message-ID: <88DC34334CA3444C85D647DBFA962C270FD7F039@SHSMSX102.ccr.corp.intel.com>
References: <88DC34334CA3444C85D647DBFA962C270FD7EAD3@SHSMSX102.ccr.corp.intel.com>
 <50909120.3040101@zytor.com>
 <88DC34334CA3444C85D647DBFA962C270FD7EB0B@SHSMSX102.ccr.corp.intel.com>
 <5090AB3C.5050405@zytor.com>
 <88DC34334CA3444C85D647DBFA962C270FD7EB3A@SHSMSX102.ccr.corp.intel.com>
 <5090B966.4040605@zytor.com>
 <88DC34334CA3444C85D647DBFA962C270FD7EF68@SHSMSX102.ccr.corp.intel.com>
 <c6a025f9-0ac5-45d7-bda9-7f9bc8eaf9ab@email.android.com>
In-Reply-To: <c6a025f9-0ac5-45d7-bda9-7f9bc8eaf9ab@email.android.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qA18nRqU023643

Hello, Anvin

Thank for your advice.

Hello, All

the next patch is made by 2), please review it. Thanks!

Subject: [PATCH] When we are doing a crash dump, we still need non-E820_RAM
 memory information in order to do I/O. So only remove all
 RAM ranges which need to be dumped.

Signed-off-by: jzha144 <jun.zhang@intel.com>
---
 arch/x86/kernel/e820.c  |    8 --------
 arch/x86/kernel/setup.c |   22 ++++++++++++++++++++++
 2 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index df06ade..0bc1687 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -844,14 +844,6 @@ static int __init parse_memmap_opt(char *p)
 		return -EINVAL;
 
 	if (!strncmp(p, "exactmap", 8)) {
-#ifdef CONFIG_CRASH_DUMP
-		/*
-		 * If we are doing a crash dump, we still need to know
-		 * the real mem size before original memory map is
-		 * reset.
-		 */
-		saved_max_pfn = e820_end_of_ram_pfn();
-#endif
 		e820.nr_map = 0;
 		userdef = 1;
 		return 0;
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index ca45696..5eb178b 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -480,6 +480,25 @@ static void __init e820_reserve_setup_data(void)
 	e820_print_map("reserve setup_data");
 }
 
+#ifdef CONFIG_CRASH_DUMP
+static void __init e820_crashdump_remove_ram(void)
+{
+	/*
+	 * We are doing a crash dump, so remove all RAM ranges
+	 * as they are the ones that need to be dumped.
+	 * We still need all non-RAM information in order to do I/O.
+	 */
+	/* NOTE: if you use old kexec, please remove memmap=exactmap
+	 * which remove all ranges, not only RAM ranges.
+	 */
+	saved_max_pfn = e820_end_of_ram_pfn();
+	e820_remove_range(0, ULLONG_MAX, E820_RAM, 1);
+	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
+	printk(KERN_INFO "crash dump non-RAM map:\n");
+	e820_print_map("crash_dump");
+}
+#endif
+
 static void __init memblock_x86_reserve_range_setup_data(void)
 {
 	struct setup_data *data;
@@ -751,6 +770,9 @@ void __init setup_arch(char **cmdline_p)
 	parse_setup_data();
 	/* update the e820_saved too */
 	e820_reserve_setup_data();
+#ifdef CONFIG_CRASH_DUMP
+	e820_crashdump_remove_ram();
+#endif
 
 	copy_edd();
 
-- 
1.7.6

Best Regards!

Jun Zhang
Inet: 8821-4273
Dir.Tel: 86-21-6116-4273
Email: jun.zhang@intel.com


-----Original Message-----
From: H. Peter Anvin [mailto:hpa@zytor.com] 
Sent: Thursday, November 01, 2012 12:20 PM
To: Zhang, Jun
Cc: Thomas Gleixner; Ingo Molnar; x86@kernel.org; Andrew Morton; Fleming, Matt; Paul Gortmaker; linux-kernel@vger.kernel.org
Subject: RE: [PATCH] To crash dump, we need keep other memory type except E820_RAM, because other type come from BIOS or firmware is used by other code(for example: PCI_MMCONFIG).

2) would make most sense to me, but I'd be okay with 3) as well.

"Zhang, Jun" <jun.zhang@intel.com> wrote:

>Hello, Anvin
>
>I want to explain why I modify in this place. In kexec, it pass three 
>parameters, memmap=exactmap memmap=544K@64K memmap=64964K@32768K I 
>think my patch modify the least code.
>Actually, there are some choise to fix it. 
>1)  my patch.
>2)  modify kexec, only pass two parameters -- memmap=544K@64K 
>memmap=64964K@32768K, in kernel setup_memory_map, we can remove RAM 
>range.
>3)  add extra optional, like memmap=REMOVERAM
>
>Which one do you like? Maybe you have better solution, please share it.
>Thanks!
>
>Best Regards!
>
>Jun Zhang
>Inet: 8821-4273
>Dir.Tel: 86-21-6116-4273
>Email: jun.zhang@intel.com
>
>-----Original Message-----
>From: H. Peter Anvin [mailto:hpa@zytor.com]
>Sent: Wednesday, October 31, 2012 1:39 PM
>To: Zhang, Jun
>Cc: Thomas Gleixner; Ingo Molnar; x86@kernel.org; Andrew Morton; 
>Fleming, Matt; Paul Gortmaker; linux-kernel@vger.kernel.org
>Subject: Re: [PATCH] To crash dump, we need keep other memory type 
>except E820_RAM, because other type come from BIOS or firmware is used 
>by other code(for example: PCI_MMCONFIG).
>
>On 10/30/2012 10:22 PM, Zhang, Jun wrote:
>> Hello, Anvin
>>    You are right. Thanks!
>>
>> Hello, All
>>    Please review it again. Thanks!
>>
>>  From bf7506ac7e9ce0df0b915164dbb7a6d858ef2e40 Mon Sep 17 00:00:00
>> 2001
>> From: jzha144 <jun.zhang@intel.com>
>> Date: Wed, 31 Oct 2012 08:51:18 +0800
>> Subject: [PATCH] When we are doing a crash dump, we still need
>non-E820_RAM
>>   memory type address information in order to do I/O. so only
>>   remove all RAM ranges which need to be dumped.
>>
>> Signed-off-by: jzha144 <jun.zhang@intel.com>
>> ---
>>   arch/x86/kernel/e820.c |    9 +++++++++
>>   1 files changed, 9 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c index
>> df06ade..77be839 100644
>> --- a/arch/x86/kernel/e820.c
>> +++ b/arch/x86/kernel/e820.c
>> @@ -851,6 +851,15 @@ static int __init parse_memmap_opt(char *p)
>>   		 * reset.
>>   		 */
>>   		saved_max_pfn = e820_end_of_ram_pfn();
>> +
>> +		/*
>> +		 * We are doing a crash dump, so remove all RAM ranges
>> +		 * as they are the ones that need to be dumped.
>> +		 * We still need all non-RAM information in order to do I/O.
>> +		 */
>> +		e820_remove_range(0, ULLONG_MAX, E820_RAM, 1);
>> +		userdef = 1;
>> +		return 0;
>>   #endif
>>   		e820.nr_map = 0;
>>   		userdef = 1;
>>
>
>The code is still wrong...
>
>	-hpa
>
>
>--
>H. Peter Anvin, Intel Open Source Technology Center I work for Intel. 
>I don't speak on their behalf.

--
Sent from my mobile phone. Please excuse brevity and lack of formatting.
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
