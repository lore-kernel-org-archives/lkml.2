Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873Ab0G1TQ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 15:16:28 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:63257 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847Ab0G1TQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 15:16:26 -0400
Message-ID: <4C5081E4.4090205@kernel.org>
Date: Wed, 28 Jul 2010 12:15:48 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH 05/16] x86, memblock: Add get_free_all_memory_range()
References: <1279824241-17582-1-git-send-email-yinghai@kernel.org>	 <1279824241-17582-6-git-send-email-yinghai@kernel.org> <1280293338.1970.235.camel@pasglop>
In-Reply-To: <1280293338.1970.235.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4C5081EE.01DD,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2010 10:02 PM, Benjamin Herrenschmidt wrote:
> On Thu, 2010-07-22 at 11:43 -0700, Yinghai Lu wrote:
>>
>> +       /* Take out region array itself at first*/
>> +       if (memblock.reserved.regions != memblock_reserved_init_regions)
>> +               memblock_free(__pa(memblock.reserved.regions), sizeof(struct memblock_region) * memblock.reserved.max);
>> +
> 
> More of that horror. Don't.
> 
> Another option from what i proposed earlier is to actually have a function
> inside mm/memblock to free it (memblock_free_arrays()) that does nothing
> if memblock is to survive init.
> 
> I hate exporting variables or data structures like that. Functions are
> semantically a lot cleaner.


Please check if you are ok with this one. if so please put it in your branch.
then I could rebase the second half patchset and ask hpa to put all in tip.

Thanks

Yinghai

[PATCH] memblock: Add memblock_free/reserve_reserved_resgions()

So we can avoid export memblock_reserved_init_regions()
Suggested by Ben.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 include/linux/memblock.h |    2 ++
 mm/memblock.c            |   24 ++++++++++++++++++++++++
 2 files changed, 26 insertions(+)

Index: linux-2.6/include/linux/memblock.h
===================================================================
--- linux-2.6.orig/include/linux/memblock.h
+++ linux-2.6/include/linux/memblock.h
@@ -48,6 +48,8 @@ extern int memblock_can_resize;
 	if (memblock_debug) printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
 
 u64 memblock_find_in_range(u64 start, u64 end, u64 size, u64 align);
+int memblock_free_reserved_regions(void);
+int memblock_reserve_reserved_regions(void);
 
 extern void __init memblock_init(void);
 extern void __init memblock_analyze(void);
Index: linux-2.6/mm/memblock.c
===================================================================
--- linux-2.6.orig/mm/memblock.c
+++ linux-2.6/mm/memblock.c
@@ -170,6 +170,30 @@ u64 __init_memblock memblock_find_in_ran
 	return memblock_find_base(size, align, start, end);
 }
 
+/*
+ * Free memblock.reserved.regions
+ */
+int memblock_free_reserved_regions(void)
+{
+	if (memblock.reserved.regions == memblock_reserved_init_regions)
+		return 0;
+
+	return memblock_free(__pa(memblock.reserved.regions),
+		 sizeof(struct memblock_region) * memblock.reserved.max);
+}
+
+/*
+ * Reserve memblock.reserved.regions
+ */
+int memblock_reserve_reserved_regions(void)
+{
+	if (memblock.reserved.regions == memblock_reserved_init_regions)
+		return 0;
+
+	return memblock_reserve(__pa(memblock.reserved.regions),
+		 sizeof(struct memblock_region) * memblock.reserved.max);
+}
+
 static void __init_memblock memblock_remove_region(struct memblock_type *type, unsigned long r)
 {
 	unsigned long i;
