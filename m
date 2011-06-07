Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291Ab1FGWZe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 18:25:34 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:53461 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757026Ab1FGWZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 18:25:33 -0400
Message-ID: <4DEEA548.5020405@kernel.org>
Date: Tue, 07 Jun 2011 15:25:12 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
CC: Matthew Garrett <mjg59@srcf.ucam.org>, Jim Bos <jim876@xs4all.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>, "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: 2.6.39.1 immediately reboots/resets on EFI system
References: <AANLkTikeYLrqXhvTP_uuKnKhy=k7pAQCbONJdKBc838O@mail.gmail.com> <20101115195115.GZ29412@tyan-ft48-01.lab.bos.redhat.com> <4CE1968D.3050706@xs4all.nl> <4DE8DC16.6030308@xs4all.nl> <20110603133351.GA25130@srcf.ucam.org> <4DE8EF13.9030609@xs4all.nl> <BANLkTinWj1LvQLverPTUm9rKEx=+HZUpDA@mail.gmail.com> <4DECFC1C.10801@xs4all.nl> <4DED0394.2090000@gmail.com> <BANLkTikVEj2Uz9N0B-kKA3GJTUWzmwz=zQ@mail.gmail.com> <20110607014127.GA8450@srcf.ucam.org> <4DED8752.5070005@kernel.org> <4DEDEA73.7010900@gmail.com> <4DEE17F9.6020503@gmail.com>
In-Reply-To: <4DEE17F9.6020503@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090202.4DEEA554.0010,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2011 05:22 AM, Maarten Lankhorst wrote:
> It seems the error still occurs when calling free_bootmem_late
> even if I only reserve blocks that haven't been reserved yet.

please check this one.

---
 arch/x86/platform/efi/efi.c |    2 +-
 include/linux/mm.h          |    2 ++
 mm/page_alloc.c             |   32 ++++++++++++++++++++++++++++++++
 3 files changed, 35 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/x86/platform/efi/efi.c
===================================================================
--- linux-2.6.orig/arch/x86/platform/efi/efi.c
+++ linux-2.6/arch/x86/platform/efi/efi.c
@@ -368,7 +368,7 @@ static void __init efi_free_boot_service
 		    md->type != EFI_BOOT_SERVICES_DATA)
 			continue;
 
-		free_bootmem_late(start, size);
+		free_bootmem_late_with_active_regions(start, size);
 	}
 }
 
Index: linux-2.6/include/linux/mm.h
===================================================================
--- linux-2.6.orig/include/linux/mm.h
+++ linux-2.6/include/linux/mm.h
@@ -1322,6 +1322,8 @@ extern void get_pfn_range_for_nid(unsign
 extern unsigned long find_min_pfn_with_active_regions(void);
 extern void free_bootmem_with_active_regions(int nid,
 						unsigned long max_low_pfn);
+void free_bootmem_late_with_active_regions(unsigned long addr,
+						unsigned long size);
 int add_from_early_node_map(struct range *range, int az,
 				   int nr_range, int nid);
 u64 __init find_memory_core_early(int nid, u64 size, u64 align,
Index: linux-2.6/mm/page_alloc.c
===================================================================
--- linux-2.6.orig/mm/page_alloc.c
+++ linux-2.6/mm/page_alloc.c
@@ -3828,6 +3828,38 @@ void __init free_bootmem_with_active_reg
 	}
 }
 
+/**
+ * free_bootmem_late_with_active_regions - Call free_bootmem_late for each active range
+ * @addr: starting address of the range
+ * @size: size of the range in bytes
+ *
+ * this function make sure on active regions only
+ */
+void __init free_bootmem_late_with_active_regions(unsigned long addr,
+						unsigned long size)
+{
+	int i;
+	int nid = MAX_NUMNODES;
+	unsigned long start_pfn = PFN_UP(addr);
+	unsigned long end_pfn = PFN_DOWN(addr + size);
+
+	if (start_pfn >= end_pfn)
+		return;
+
+	for_each_active_range_index_in_nid(i, nid) {
+		unsigned long common_start, common_end;
+
+		common_start = max(start_pfn, early_node_map[i].start_pfn);
+		common_end = min(end_pfn, early_node_map[i].end_pfn);
+
+		if (common_start >= common_end)
+			continue;
+
+		free_bootmem_late(common_start << PAGE_SHIFT,
+				  (common_end - common_start) << PAGE_SHIFT);
+	}
+}
+
 #ifdef CONFIG_HAVE_MEMBLOCK
 /*
  * Basic iterator support. Return the last range of PFNs for a node
