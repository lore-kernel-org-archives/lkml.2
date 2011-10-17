Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210Ab1JQSuy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 14:50:54 -0400
Received: from www.hansjkoch.de ([178.63.77.200]:41910 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751269Ab1JQSuw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 14:50:52 -0400
Date: Mon, 17 Oct 2011 20:50:20 +0200
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Greg KH <gregkh@suse.de>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>, Kumar Gala <galak@kernel.crashing.org>,
        linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
        Kai Jiang <Kai.Jiang@freescale.com>
Subject: Re: [PATCH] uio: Support 36-bit physical addresses on 32-bit systems
Message-ID: <20111017185020.GF13919@local>
References: <1318521058-15662-1-git-send-email-galak@kernel.crashing.org>
 <20111014183144.GD28556@local>
 <4D73F261-3795-4F71-9921-568C1B9F06E0@kernel.crashing.org>
 <20111017171859.GB13919@local>
 <20111017180350.GC13919@local>
 <20111017182345.GA14416@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111017182345.GA14416@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 17, 2011 at 11:23:45AM -0700, Greg KH wrote:
> On Mon, Oct 17, 2011 at 08:03:51PM +0200, Hans J. Koch wrote:
> > On Mon, Oct 17, 2011 at 07:18:59PM +0200, Hans J. Koch wrote:
> > > On Mon, Oct 17, 2011 at 11:00:55AM -0500, Kumar Gala wrote:
> > > > 
> > > > On Oct 14, 2011, at 1:31 PM, Hans J. Koch wrote:
> > > > 
> > > > > On Thu, Oct 13, 2011 at 10:50:58AM -0500, Kumar Gala wrote:
> > > > >> From: Kai Jiang <Kai.Jiang@freescale.com>
> > > > >> 
> > > > >> To support >32-bit physical addresses for UIO_MEM_PHYS type we need to
> > > > >> extend the width of 'addr' in struct uio_mem.  Numerous platforms like
> > > > >> embedded PPC, ARM, and X86 have support for systems with larger physical
> > > > >> address than logical.
> > > > >> 
> > > > >> Since 'addr' may contain a physical, logical, or virtual address the
> > > > >> easiest solution is to just change the type to 'phys_addr_t' which
> > > > >> should always be greater than or equal to the sizeof(void *) such that
> > > > >> it can properly hold any of the address types.
> > > > >> 
> > > > >> For physical address we can support up to a 44-bit physical address on a
> > > > >> typical 32-bit system as we utilize remap_pfn_range() for the mapping of
> > > > >> the memory region and pfn's are represnted by shifting the address by
> > > > >> the page size (typically 4k).
> > > > >> 
> > > > >> Signed-off-by: Kai Jiang <Kai.Jiang@freescale.com>
> > > > >> Signed-off-by: Minghuan Lian <Minghuan.Lian@freescale.com>
> > > > >> Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
> > > > > 
> > > > > Signed-off-by: "Hans J. Koch" <hjk@hansjkoch.de>
> > > > > 
> > > > > That looks good to me. There's an unnecessary cast (see below), but I fixed that
> > > > > on the way.
> > > > > 
> > > > > Greg, please pull this from branch uio-for-gregkh from
> > > > > 
> > > > > git://hansjkoch.de/git/linux-hjk
> > > > > 
> > > > > Thanks,
> > > > > Hans
> > > > 
> > > > I think removing that cast is wrong:
> > > > 
> > > > drivers/uio/uio.c: In function 'uio_vma_fault':
> > > > drivers/uio/uio.c:637:26: warning: cast to pointer from integer of different size
> > > 
> > > Hmm, on what platform did you see this? I tested on 32bit-x86 and didn't get
> > > any warnings.
> > 
> > OK, you're right. I turned on CONFIG_HIGHMEM64G and got that warning. Damned x86...
> > 
> > Greg, can you fix it, or should I send the patch again?
> 
> Please send it again.

>From 30767223785a2ea412bd31a00a4534051af1f5dd Mon Sep 17 00:00:00 2001
From: Kai Jiang <Kai.Jiang@freescale.com>
Date: Fri, 14 Oct 2011 20:04:43 +0200
Subject: [PATCH] uio: Support physical addresses >32 bits on 32-bit systems

From: Kai Jiang <Kai.Jiang@freescale.com>

To support >32-bit physical addresses for UIO_MEM_PHYS type we need to
extend the width of 'addr' in struct uio_mem.  Numerous platforms like
embedded PPC, ARM, and X86 have support for systems with larger physical
address than logical.

Since 'addr' may contain a physical, logical, or virtual address the
easiest solution is to just change the type to 'phys_addr_t' which
should always be greater than or equal to the sizeof(void *) such that
it can properly hold any of the address types.

For physical address we can support up to a 44-bit physical address on a
typical 32-bit system as we utilize remap_pfn_range() for the mapping of
the memory region and pfn's are represnted by shifting the address by
the page size (typically 4k).

Signed-off-by: Kai Jiang <Kai.Jiang@freescale.com>
Signed-off-by: Minghuan Lian <Minghuan.Lian@freescale.com>
Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
Signed-off-by: Hans J. Koch <hjk@hansjkoch.de>
---
 Documentation/DocBook/uio-howto.tmpl |    2 +-
 drivers/uio/uio.c                    |    7 +++----
 include/linux/uio_driver.h           |    7 +++++--
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/Documentation/DocBook/uio-howto.tmpl b/Documentation/DocBook/uio-howto.tmpl
index 7c4b514d..54883de 100644
--- a/Documentation/DocBook/uio-howto.tmpl
+++ b/Documentation/DocBook/uio-howto.tmpl
@@ -529,7 +529,7 @@ memory (e.g. allocated with <function>kmalloc()</function>). There's also
 </para></listitem>
 
 <listitem><para>
-<varname>unsigned long addr</varname>: Required if the mapping is used.
+<varname>phys_addr_t addr</varname>: Required if the mapping is used.
 Fill in the address of your memory block. This address is the one that
 appears in sysfs.
 </para></listitem>
diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index d2efe82..dc27d89 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -69,7 +69,7 @@ static ssize_t map_name_show(struct uio_mem *mem, char *buf)
 
 static ssize_t map_addr_show(struct uio_mem *mem, char *buf)
 {
-	return sprintf(buf, "0x%lx\n", mem->addr);
+	return sprintf(buf, "0x%llx\n", (unsigned long long)mem->addr);
 }
 
 static ssize_t map_size_show(struct uio_mem *mem, char *buf)
@@ -79,7 +79,7 @@ static ssize_t map_size_show(struct uio_mem *mem, char *buf)
 
 static ssize_t map_offset_show(struct uio_mem *mem, char *buf)
 {
-	return sprintf(buf, "0x%lx\n", mem->addr & ~PAGE_MASK);
+	return sprintf(buf, "0x%llx\n", (unsigned long long)mem->addr & ~PAGE_MASK);
 }
 
 struct map_sysfs_entry {
@@ -634,8 +634,7 @@ static int uio_vma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	if (idev->info->mem[mi].memtype == UIO_MEM_LOGICAL)
 		page = virt_to_page(idev->info->mem[mi].addr + offset);
 	else
-		page = vmalloc_to_page((void *)idev->info->mem[mi].addr
-							+ offset);
+		page = vmalloc_to_page((void *)(unsigned long)idev->info->mem[mi].addr + offset);
 	get_page(page);
 	vmf->page = page;
 	return 0;
diff --git a/include/linux/uio_driver.h b/include/linux/uio_driver.h
index 665517c..fd99ff9 100644
--- a/include/linux/uio_driver.h
+++ b/include/linux/uio_driver.h
@@ -23,7 +23,10 @@ struct uio_map;
 /**
  * struct uio_mem - description of a UIO memory region
  * @name:		name of the memory region for identification
- * @addr:		address of the device's memory
+ * @addr:		address of the device's memory (phys_addr is used since
+ * 			addr can be logical, virtual, or physical & phys_addr_t
+ * 			should always be large enough to handle any of the
+ * 			address types)
  * @size:		size of IO
  * @memtype:		type of memory addr points to
  * @internal_addr:	ioremap-ped version of addr, for driver internal use
@@ -31,7 +34,7 @@ struct uio_map;
  */
 struct uio_mem {
 	const char		*name;
-	unsigned long		addr;
+	phys_addr_t		addr;
 	unsigned long		size;
 	int			memtype;
 	void __iomem		*internal_addr;
-- 
1.7.6.3


