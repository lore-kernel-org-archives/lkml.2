Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206Ab1GVHeY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 03:34:24 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:52236 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552Ab1GVHeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 03:34:22 -0400
Date: Fri, 22 Jul 2011 09:34:17 +0200
From: Tejun Heo <tj@kernel.org>
To: Shreshtha <shreshthakumar@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Kernel Oops on enabling CONFIG_LOCK_STAT
Message-ID: <20110722073417.GB2622@htj.dyndns.org>
References: <CAKWOLpKFe=rjms5=cvEMJSbiHE0+j+3wK-bGRJWpP1QCJ63Sow@mail.gmail.com>
 <20110722061054.GA2622@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="wRRV7LY7NUeQGEoC"
Content-Disposition: inline
In-Reply-To: <20110722061054.GA2622@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

On Fri, Jul 22, 2011 at 08:10:54AM +0200, Tejun Heo wrote:
> Hrmm... so it's pcpu_populate_chunk() failure path.  Can you please
> attach full kernel log?  Attaching full kernel log and including a bit
> of hardware details is generally a good idea when reporting a bug.
> 
> It's most likely there's a bug in the code which rolls back from
> partial allocation after encountering alloc failure in the middle.
> I'll take a deeper look there and report what I find.

The code looks correct and seems to behave correct under induced
error.  Can you please apply the following patch and see whether the
problem goes away?

diff --git a/mm/percpu-vm.c b/mm/percpu-vm.c
index ea53496..53eae44 100644
--- a/mm/percpu-vm.c
+++ b/mm/percpu-vm.c
@@ -347,6 +347,7 @@ clear:
 	return 0;
 
 err_unmap:
+	pcpu_post_map_flush(chunk, page_start, unmap_end);
 	pcpu_pre_unmap_flush(chunk, page_start, unmap_end);
 	pcpu_for_each_unpop_region(chunk, rs, re, page_start, unmap_end)
 		pcpu_unmap_pages(chunk, pages, populated, rs, re);

If not, can you please apply the attached debug patch, trigger the
problem and post the log?

Thank you.

-- 
tejun

--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="pcpu-debug.patch"

diff --git a/mm/percpu-vm.c b/mm/percpu-vm.c
index ea53496..4421619 100644
--- a/mm/percpu-vm.c
+++ b/mm/percpu-vm.c
@@ -80,16 +80,19 @@ static void pcpu_free_pages(struct pcpu_chunk *chunk,
 			    int page_start, int page_end)
 {
 	unsigned int cpu;
-	int i;
+	int i, cnt = 0;
 
 	for_each_possible_cpu(cpu) {
 		for (i = page_start; i < page_end; i++) {
 			struct page *page = pages[pcpu_page_idx(cpu, i)];
 
-			if (page)
+			if (page) {
 				__free_page(page);
+				cnt++;
+			}
 		}
 	}
+	printk("XXX pcpu_free_pages: freed %d pages\n", cnt);
 }
 
 /**
@@ -110,7 +113,7 @@ static int pcpu_alloc_pages(struct pcpu_chunk *chunk,
 {
 	const gfp_t gfp = GFP_KERNEL | __GFP_HIGHMEM | __GFP_COLD;
 	unsigned int cpu;
-	int i;
+	int i, cnt = 0;
 
 	for_each_possible_cpu(cpu) {
 		for (i = page_start; i < page_end; i++) {
@@ -118,12 +121,15 @@ static int pcpu_alloc_pages(struct pcpu_chunk *chunk,
 
 			*pagep = alloc_pages_node(cpu_to_node(cpu), gfp, 0);
 			if (!*pagep) {
+				printk("XXX pcpu_alloc_pages: failed after %d allocs\n", cnt);
 				pcpu_free_pages(chunk, pages, populated,
 						page_start, page_end);
 				return -ENOMEM;
 			}
+			cnt++;
 		}
 	}
+	printk("XXX pcpu_alloc_pages: allocated %d pages\n", cnt);
 	return 0;
 }
 
@@ -149,6 +155,8 @@ static void pcpu_pre_unmap_flush(struct pcpu_chunk *chunk,
 
 static void __pcpu_unmap_pages(unsigned long addr, int nr_pages)
 {
+	printk("XXX __pcpu_unmap_pages: %p - %p\n", (void *)addr,
+	       (void *)addr + nr_pages * PAGE_SIZE);
 	unmap_kernel_range_noflush(addr, nr_pages << PAGE_SHIFT);
 }
 
@@ -173,6 +181,11 @@ static void pcpu_unmap_pages(struct pcpu_chunk *chunk,
 	unsigned int cpu;
 	int i;
 
+	for_each_possible_cpu(cpu)
+		printk("XXX pcpu_unmap_pages: cpu%u: %#lx - %#lx\n", cpu,
+		       pcpu_chunk_addr(chunk, cpu, page_start),
+		       pcpu_chunk_addr(chunk, cpu, page_end));
+
 	for_each_possible_cpu(cpu) {
 		for (i = page_start; i < page_end; i++) {
 			struct page *page;
@@ -210,11 +223,27 @@ static void pcpu_post_unmap_tlb_flush(struct pcpu_chunk *chunk,
 		pcpu_chunk_addr(chunk, pcpu_last_unit_cpu, page_end));
 }
 
+#include <linux/moduleparam.h>
+static int failcnt;
+module_param(failcnt, int, 0644);
+
 static int __pcpu_map_pages(unsigned long addr, struct page **pages,
 			    int nr_pages)
 {
-	return map_kernel_range_noflush(addr, nr_pages << PAGE_SHIFT,
-					PAGE_KERNEL, pages);
+	int ret;
+
+	printk("XXX __pcpu_map_pages: %#lx - %#lx\n",
+	       addr, addr + nr_pages * PAGE_SIZE);
+
+	if (failcnt > 0 && !--failcnt) {
+		printk("XXX __pcpu_map_pages: inducing failure\n");
+		return -ENOMEM;
+	}
+	ret = map_kernel_range_noflush(addr, nr_pages << PAGE_SHIFT,
+				       PAGE_KERNEL, pages);
+	if (ret < 0)
+		printk("XXX __pcpu_map_pages: failed ret=%d\n", ret);
+	return ret;
 }
 
 /**
@@ -240,6 +269,11 @@ static int pcpu_map_pages(struct pcpu_chunk *chunk,
 	unsigned int cpu, tcpu;
 	int i, err;
 
+	for_each_possible_cpu(cpu)
+		printk("XXX pcpu_map_pages: cpu%u: %#lx - %#lx\n", cpu,
+		       pcpu_chunk_addr(chunk, cpu, page_start),
+		       pcpu_chunk_addr(chunk, cpu, page_end));
+
 	for_each_possible_cpu(cpu) {
 		err = __pcpu_map_pages(pcpu_chunk_addr(chunk, cpu, page_start),
 				       &pages[pcpu_page_idx(cpu, page_start)],

--wRRV7LY7NUeQGEoC--
