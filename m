Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533Ab2GZKbl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 06:31:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39761 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752425Ab2GZKbj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 06:31:39 -0400
Date: Thu, 26 Jul 2012 12:28:12 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] uprobes: rename vma_address() and make it return
	"unsigned long"
Message-ID: <20120726102812.GB7197@redhat.com>
References: <20120712170934.GA25455@redhat.com> <20120712171022.GA25507@redhat.com> <20120726050018.GD3810@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120726050018.GD3810@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26, Srikar Dronamraju wrote:
>
> * Oleg Nesterov <oleg@redhat.com> [2012-07-12 19:10:22]:
>
> > 1. vma_address() returns loff_t, this looks confusing and this is
> >    unnecessary after the previous change. Make it return "ulong",
> >    all callers truncate the result anyway.
> >
> > 2. Its name conflicts with mm/rmap.c:vma_address(), rename it to
> >    offset_to_vaddr(), this matches vaddr_to_offset().
> >
> > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
>
> Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

Thanks.

Could you please ack v2 below?

I forgot to update "loff_t vaddr" in mmap/munmap. IOW, this is the
same patch plus

	- loff_t vaddr = offset_to_vaddr(...);
	+ unsigned long vaddr = offset_to_vaddr(...);

in uprobe_mmap/munmap.

In fact I was going to do this in
"uprobes: teach build_probe_list() to consider the range" but
forgot as well.

Oleg.

--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -112,14 +112,9 @@ static bool valid_vma(struct vm_area_struct *vma, bool is_register)
 	return false;
 }
 
-static loff_t vma_address(struct vm_area_struct *vma, loff_t offset)
+static unsigned long offset_to_vaddr(struct vm_area_struct *vma, loff_t offset)
 {
-	loff_t vaddr;
-
-	vaddr = vma->vm_start + offset;
-	vaddr -= (loff_t)vma->vm_pgoff << PAGE_SHIFT;
-
-	return vaddr;
+	return vma->vm_start + offset - ((loff_t)vma->vm_pgoff << PAGE_SHIFT);
 }
 
 static loff_t vaddr_to_offset(struct vm_area_struct *vma, unsigned long vaddr)
@@ -775,7 +770,7 @@ build_map_info(struct address_space *mapping, loff_t offset, bool is_register)
 		curr = info;
 
 		info->mm = vma->vm_mm;
-		info->vaddr = vma_address(vma, offset);
+		info->vaddr = offset_to_vaddr(vma, offset);
 	}
 	mutex_unlock(&mapping->i_mmap_mutex);
 
@@ -1042,7 +1037,7 @@ int uprobe_mmap(struct vm_area_struct *vma)
 
 	list_for_each_entry_safe(uprobe, u, &tmp_list, pending_list) {
 		if (!ret) {
-			loff_t vaddr = vma_address(vma, uprobe->offset);
+			unsigned long vaddr = offset_to_vaddr(vma, uprobe->offset);
 
 			ret = install_breakpoint(uprobe, vma->vm_mm, vma, vaddr);
 			/*
@@ -1103,7 +1098,7 @@ void uprobe_munmap(struct vm_area_struct *vma, unsigned long start, unsigned lon
 	build_probe_list(inode, vma, start, end, &tmp_list);
 
 	list_for_each_entry_safe(uprobe, u, &tmp_list, pending_list) {
-		loff_t vaddr = vma_address(vma, uprobe->offset);
+		unsigned long vaddr = offset_to_vaddr(vma, uprobe->offset);
 		/*
 		 * An unregister could have removed the probe before
 		 * unmap. So check before we decrement the count.

