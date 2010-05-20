Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014Ab0ETAJH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 20:09:07 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:23435 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467Ab0ETAJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 20:09:04 -0400
Message-ID: <4BF47D25.8060209@oracle.com>
Date: Wed, 19 May 2010 17:07:01 -0700
From: Yinghai <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Mathieu Rondonneau <mathieu.rondonneau@gmail.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Prevent reserving RAM in the region already reserved
 by  BIOS
References: <AANLkTimwxXtNnmBuDJxg3i72VwWuHmemjrr1iGqj4j8e@mail.gmail.com>	 <4BF42296.1030905@oracle.com> <4BF4235D.3080904@zytor.com>	 <AANLkTikYcu6fM3yLoYIZOGZXgsRUfCgJeWS51Sjo-Fny@mail.gmail.com>	 <4BF46D9B.4090806@zytor.com> <AANLkTiltANJ9eaGBkfJJOyZ8skCxxOmkAs1UvCLB_YQ9@mail.gmail.com>
In-Reply-To: <AANLkTiltANJ9eaGBkfJJOyZ8skCxxOmkAs1UvCLB_YQ9@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090201.4BF47D77.00DE:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2010 05:01 PM, Mathieu Rondonneau wrote:
> it' s not in ISA space.
> once loading the NVIDIA driver, the warnign oops shows up.
> 4K starting at 0x9f800 (i.e. to 0xa007ff) overlap with the ISA space
> (starting at 0xa0000).
> 
> When I don' t load the driver, no oops.
> So I am assuming nvidia driver request 4K of memory, that happens to
> be available in the bios area.
> 
> I think that there is a check missing somewhere to report that
> available RAM buffer is already reserved (by BIOS) so we need to get
> it from somewhere else.

please check if this patch fix the problem.

Subject: [PATCH] x86: Align e820 ram range to page

To workaround wrong BIOS memory map.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/e820.c |   44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

Index: linux-2.6/arch/x86/kernel/e820.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820.c
+++ linux-2.6/arch/x86/kernel/e820.c
@@ -910,6 +910,47 @@ static int __init parse_memmap_opt(char
 }
 early_param("memmap", parse_memmap_opt);
 
+static void __init e820_align_ram_page(void)
+{
+	int i;
+	bool changed = false;;
+
+	for (i = 0; i < e820.nr_map; i++) {
+		struct e820entry *entry = &e820.map[i];
+		u64 start, end;
+		u64 start_aligned, end_aligned;
+
+		if (entry->type != E820_RAM)
+			continue;
+
+		start = entry->addr;
+		end = start + entry->size;
+
+		start_aligned = round_up(start, PAGE_SIZE);
+		end_aligned = round_down(end, PAGE_SIZE);
+
+		if (end_aligned <= start_aligned) {
+			e820_update_range(start, end - start, E820_RAM, E820_RESERVED);
+			changed = true;
+			continue;
+		}
+		if (start < start_aligned) {
+			e820_update_range(start, start_aligned - start, E820_RAM, E820_RESERVED);
+			changed = true;
+		}
+		if (end_aligned < end) {
+			e820_update_range(end_aligned, end - end_aligned, E820_RAM, E820_RESERVED);
+			changed = true;
+		}
+	}
+
+	if (changed) {
+		sanitize_e820_map();
+		printk(KERN_INFO "aligned physical RAM map:\n");
+		e820_print_map("aligned");
+	}
+}
+
 void __init finish_e820_parsing(void)
 {
 	if (userdef) {
@@ -922,6 +963,9 @@ void __init finish_e820_parsing(void)
 		printk(KERN_INFO "user-defined physical RAM map:\n");
 		e820_print_map("user");
 	}
+
+	/* In case, We have RAM entres that are not PAGE aligned */
+	e820_align_ram_page();
 }
 
 static inline const char *e820_type_to_string(int e820_type)
