Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041Ab1HaXNy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 19:13:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57247 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752207Ab1HaXNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 19:13:53 -0400
Date: Wed, 31 Aug 2011 16:13:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Hans J. Koch" <hjk@hansjkoch.de>
Cc: Jan Altenberg <jan@linutronix.de>, linux-mm@kvack.org,
        b.spranger@linutronix.de, LKML <linux-kernel@vger.kernel.org>
Subject: Re: bade page state while calling munmap() for kmalloc'ed UIO
 memory
Message-Id: <20110831161307.d605848b.akpm@linux-foundation.org>
In-Reply-To: <20110831095825.GC4769@local>
References: <1314630347.2258.150.camel@bender.lan>
	<20110831095825.GC4769@local>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Aug 2011 11:58:25 +0200
"Hans J. Koch" <hjk@hansjkoch.de> wrote:

> On Mon, Aug 29, 2011 at 05:05:47PM +0200, Jan Altenberg wrote:
> 
> [Since we got no reply on linux-mm, I added lkml and Andrew to Cc: (mm doesn't
> seem to have a maintainer...)]
> 
> > Hi,
> > 
> > I'm currently analysing a problem similar to some mmap() issue reported
> > in the past: https://lkml.org/lkml/2010/7/11/140
> 
> The arch there was microblaze, and you are working on arm. That means
> the problem appears on at least to archs.
> 
> > 
> > So, what I'm trying to do is mapping some physically continuous memory
> > (allocated by kmalloc) to userspace, using a trivial UIO driver (the
> > idea is that a device can directly DMA to that buffer):
> > 
> > [...]
> > #define MEM_SIZE (4 * PAGE_SIZE)
> > 
> > addr = kmalloc(MEM_SIZE, GFP_KERNEL)
> > [...]
> > info.mem[0].addr = (unsigned long) addr;
> > info.mem[0].internal_addr = addr;
> > info.mem[0].size = MEM_SIZE;
> > info.mem[0].memtype = UIO_MEM_LOGICAL;
> > [...]
> > ret = uio_register_device(&pdev->dev, &info);
> > 
> > Userspace maps that memory range and writes its contents to a file:
> > 
> > [...]
> > 
> > fd = open("/dev/uio0", O_RDWR);
> > if (fd < 0) {
> >            perror("Can't open UIO device\n");
> >            exit(1);
> > }
> > 
> > mem_map = mmap(NULL, MAP_SIZE, PROT_READ | PROT_WRITE,
> >                   MAP_PRIVATE, fd, 0);
> > 
> > if(mem_map == MAP_FAILED) {
> >            perror("Can't map UIO memory\n");
> >            ret = -ENOMEM;
> >            goto out_file;
> > }
> > [...]
> > bytes_written = write(fd_file, mem_map, MAP_SIZE)
> > [...]
> > 
> > munmap(mem_map);
> 
> >From my point of view (I've got Jan's full test case code), this
> is a completely correct UIO use case.
> 
> > 
> > So, what happens is (I'm currently testing with 3.0.3 on ARM
> > VersatilePB): When I do the munmap(), I run into the following error:
> > 
> > BUG: Bad page state in process uio_test  pfn:078ed
> > page:c0409154 count:0 mapcount:0 mapping:  (null) index:0x0
> > page flags: 0x284(referenced|slab|arch_1)

PG_slab is set.  The kernel is complaining because a page which was
allocated via kmalloc/kmem_cache_alloc was directly passed to the page
allocator for freeing.  It should have been passed to kfree().

Presumably the uio driver expects that its memory was allocated via
alloc_pages(), not via kmalloc().

