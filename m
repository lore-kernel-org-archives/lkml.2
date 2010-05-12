Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950Ab0ELSKd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 14:10:33 -0400
Received: from relay3.sgi.com ([192.48.152.1]:48465 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751849Ab0ELSKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 14:10:32 -0400
Message-ID: <4BEAEF10.9040809@sgi.com>
Date: Wed, 12 May 2010 11:10:24 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: x86@kernel.org, Yinghai Lu <yinghai@kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jens Axboe <jens.axboe@oracle.com>, Jack Steiner <steiner@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [Patch 1/1] x86 efi: Fill all reserved memmap entries if add_efi_memmap
 specified.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Currently, the e820_reserve_resources() function does not add entries
obtained via the "add_efi_memmap" kernel cmdline option.  This causes
/sys/firmware/memmap/... to be incomplete (stops after 128 entries).
Utilities that examine these entries then do not get the complete
picture of system memory.

This patch causes the above function to use the e820 memmap instead
of the e820_saved memmap if "add_efi_memmap" cmdline option is
specified.

Signed-off-by: Mike Travis <travis@sgi.com>
Signed-off-by: Jack Steiner <steiner@sgi.com>
---
 arch/x86/include/asm/e820.h |    1 +
 arch/x86/kernel/e820.c      |    8 ++++++--
 2 files changed, 7 insertions(+), 2 deletions(-)

--- linux.orig/arch/x86/include/asm/e820.h
+++ linux/arch/x86/include/asm/e820.h
@@ -89,6 +89,7 @@ extern int e820_search_gap(unsigned long
 			unsigned long start_addr, unsigned long long end_addr);
 struct setup_data;
 extern void parse_e820_ext(struct setup_data *data, unsigned long pa_data);
+extern int add_efi_memmap;
 
 #if defined(CONFIG_X86_64) || \
 	(defined(CONFIG_X86_32) && defined(CONFIG_HIBERNATION))
--- linux.orig/arch/x86/kernel/e820.c
+++ linux/arch/x86/kernel/e820.c
@@ -1074,6 +1074,7 @@ void __init e820_reserve_resources(void)
 	int i;
 	struct resource *res;
 	u64 end;
+	struct e820map *e_map = &e820_saved;
 
 	res = alloc_bootmem(sizeof(struct resource) * e820.nr_map);
 	e820_res = res;
@@ -1101,8 +1102,11 @@ void __init e820_reserve_resources(void)
 		res++;
 	}
 
-	for (i = 0; i < e820_saved.nr_map; i++) {
-		struct e820entry *entry = &e820_saved.map[i];
+	if (add_efi_memmap)
+		e_map = &e820;
+
+	for (i = 0; i < e_map->nr_map; i++) {
+		struct e820entry *entry = &e_map->map[i];
 		firmware_map_add_early(entry->addr,
 			entry->addr + entry->size - 1,
 			e820_type_to_string(entry->type));
