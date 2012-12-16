Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246Ab2LPUEt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 15:04:49 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:60389 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700Ab2LPUEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 15:04:48 -0500
Date: Sun, 16 Dec 2012 20:04:46 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] omap_vout: find_vma() needs ->mmap_sem held
Message-ID: <20121216200446.GF4939@ZenIV.linux.org.uk>
References: <20121215201237.GW4939@ZenIV.linux.org.uk>
 <1355688070.767.4.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355688070.767.4.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 16, 2012 at 09:01:10PM +0100, Paul Bolle wrote:
> > +	vma = find_vma(mm, virtp);
> >  	} else if (vma && (vma->vm_flags & VM_IO) && vma->vm_pgoff) {
> 
> Shouldn't that line become 
>     if (vma && (vma->vm_flags & VM_IO) && vma->vm_pgoff) {
> 
> so that this actually compiles?

*Do'h*

Yes, it should.  Mea culpa...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/drivers/media/platform/omap/omap_vout.c b/drivers/media/platform/omap/omap_vout.c
index 9935040..cb564d0 100644
--- a/drivers/media/platform/omap/omap_vout.c
+++ b/drivers/media/platform/omap/omap_vout.c
@@ -207,19 +207,21 @@ static u32 omap_vout_uservirt_to_phys(u32 virtp)
 	struct vm_area_struct *vma;
 	struct mm_struct *mm = current->mm;
 
-	vma = find_vma(mm, virtp);
 	/* For kernel direct-mapped memory, take the easy way */
-	if (virtp >= PAGE_OFFSET) {
-		physp = virt_to_phys((void *) virtp);
-	} else if (vma && (vma->vm_flags & VM_IO) && vma->vm_pgoff) {
+	if (virtp >= PAGE_OFFSET)
+		return virt_to_phys((void *) virtp);
+
+	down_read(&current->mm->mmap_sem);
+	vma = find_vma(mm, virtp);
+	if (vma && (vma->vm_flags & VM_IO) && vma->vm_pgoff) {
 		/* this will catch, kernel-allocated, mmaped-to-usermode
 		   addresses */
 		physp = (vma->vm_pgoff << PAGE_SHIFT) + (virtp - vma->vm_start);
+		up_read(&current->mm->mmap_sem);
 	} else {
 		/* otherwise, use get_user_pages() for general userland pages */
 		int res, nr_pages = 1;
 		struct page *pages;
-		down_read(&current->mm->mmap_sem);
 
 		res = get_user_pages(current, current->mm, virtp, nr_pages, 1,
 				0, &pages, NULL);
