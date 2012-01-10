Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622Ab2AJW0b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 17:26:31 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35797 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754943Ab2AJW0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 17:26:30 -0500
Date: Tue, 10 Jan 2012 14:26:25 -0800
From: Tejun Heo <tj@kernel.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, rjw@sisk.pl, xen-devel@lists.xensource.com
Subject: Re: Bootup regression introduced by
 7bd0b0f0da3b1ec11cbcc798eb0ef747a1184077 ("memblock: Reimplement memblock
 allocation using reverse free area iterato") in v3.3-rc0
Message-ID: <20120110222625.GA26832@google.com>
References: <20120110202838.GA10402@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120110202838.GA10402@phenom.dumpdata.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 10, 2012 at 03:28:38PM -0500, Konrad Rzeszutek Wilk wrote:
> With that patch I get this when trying to launch a 4GB xen guest:
> 
> kernel="/mnt/lab/latest/vmlinuz"
> ramdisk="/mnt/lab/latest/initramfs.cpio.gz"
> extra="console=hvc0 debug earlyprintk=xen" 
> memory=4096
> maxmem=8192
> vcpus=4
> on_crash="preserve"
> vif = [ 'mac=00:0F:4B:00:00:68, bridge=switch' ]
> vfb = [ 'vnc=1, vnclisten=0.0.0.0,vncunused=1'
> 
> If I change the "memory" to be "4000" it or if I revert the
> mention git commit it boots. This is what I get with the mentioned
> git commit:

Heh, interesting.  Can you please apply the following patch and report
the failing boot log?

Thanks.

diff --git a/mm/memblock.c b/mm/memblock.c
index 2f55f19..978b58eff 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -102,6 +102,10 @@ phys_addr_t __init_memblock memblock_find_in_range_node(phys_addr_t start,
 	/* align @size to avoid excessive fragmentation on reserved array */
 	size = round_up(size, align);
 
+	printk("memblock_find: [0x%llx, 0x%llx) size=%llu align=%llu nid=%d\n",
+	       (unsigned long long)start, (unsigned long long)end,
+	       (unsigned long long)size, (unsigned long long)align, nid);
+
 	/* pump up @end */
 	if (end == MEMBLOCK_ALLOC_ACCESSIBLE)
 		end = memblock.current_limit;
@@ -110,13 +114,27 @@ phys_addr_t __init_memblock memblock_find_in_range_node(phys_addr_t start,
 	start = max3(start, size, (phys_addr_t)PAGE_SIZE);
 	end = max(start, end);
 
+	printk("memblock_find: [0x%llx, 0x%llx) - adjusted\n",
+	       (unsigned long long)start, (unsigned long long)end);
+
 	for_each_free_mem_range_reverse(i, nid, &this_start, &this_end, NULL) {
+		printk("memblock_find: cand [0x%llx, 0x%llx) -> ",
+		       (unsigned long long)this_start,
+		       (unsigned long long)this_end);
+
 		this_start = clamp(this_start, start, end);
 		this_end = clamp(this_end, start, end);
 
+		printk("[0x%llx, 0x%llx) ",
+		       (unsigned long long)this_start,
+		       (unsigned long long)this_end);
+
 		cand = round_down(this_end - size, align);
-		if (cand >= this_start)
+		if (cand >= this_start) {
+			printk("- success %llx\n", (unsigned long long)cand);
 			return cand;
+		}
+		printk("- rejected\n");
 	}
 	return 0;
 }
