Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171Ab0GaHQR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 03:16:17 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:22226 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449Ab0GaHQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 03:16:15 -0400
Message-ID: <4C53CD80.6070905@kernel.org>
Date: Sat, 31 Jul 2010 00:15:12 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 01/17 -v2] memblock: Add memblock_free/reserve_reserved_regions()
References: <1280432737-1808-1-git-send-email-yinghai@kernel.org>
In-Reply-To: <1280432737-1808-1-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4C53CDA0.00EE,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


So we can avoid export memblock_reserved_init_regions()
Suggested by Ben.

-v2: use __init_memblock attribute

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
+int __init_memblock memblock_free_reserved_regions(void)
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
+int __init_memblock memblock_reserve_reserved_regions(void)
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
