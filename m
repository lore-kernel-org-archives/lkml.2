Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044Ab1A2XbA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 18:31:00 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:25297 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813Ab1A2Xa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 18:30:59 -0500
Date: Sun, 30 Jan 2011 00:32:11 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
cc: linux-kernel@vger.kernel.org, James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] SCSI, target: Avoid mem leak and needless work in
 transport_generic_get_mem().
In-Reply-To: <1296341530.14831.231.camel@haakon2.linux-iscsi.org>
Message-ID: <alpine.LNX.2.00.1101300025360.19392@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1101292316490.19392@swampdragon.chaosbits.net> <1296341530.14831.231.camel@haakon2.linux-iscsi.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Jan 2011, Nicholas A. Bellinger wrote:

> On Sat, 2011-01-29 at 23:21 +0100, Jesper Juhl wrote:
> > In drivers/target/target_core_transport.c::transport_generic_get_mem() 
> > there are a few potential memory leaks in the error paths. This patch 
> > makes sure that we free previously allocated memory when other allocations 
> > fail. It also moves some work (INIT_LIST_HEAD() and assignment to 
> > se_mem->se_len) below all the allocations so that if something fails we 
> > don't do the work at all.
> > 
> 
> Hi Jesper,
> 
> > Please review and consider for inclusion.
> > I don't have any hardware to actually test this so it is compile tested 
> > only.
> > 
> 
> Btw, you don't need any special hardware to test this.  Just a
> virtual NIC and a couple of VMs.  ;)
> 
> > 
> > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> > ---
> >  target_core_transport.c |    9 ++++++---
> >  1 file changed, 6 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> > index 28b6292..4776293 100644
> > --- a/drivers/target/target_core_transport.c
> > +++ b/drivers/target/target_core_transport.c
> > @@ -4334,11 +4334,9 @@ transport_generic_get_mem(struct se_cmd *cmd, u32 length, u32 dma_size)
> >  			printk(KERN_ERR "Unable to allocate struct se_mem\n");
> >  			goto out;
> >  		}
> > -		INIT_LIST_HEAD(&se_mem->se_list);
> > -		se_mem->se_len = (length > dma_size) ? dma_size : length;
> >  
> >  /* #warning FIXME Allocate contigous pages for struct se_mem elements */
> > -		se_mem->se_page = (struct page *) alloc_pages(GFP_KERNEL, 0);
> > +		se_mem->se_page = alloc_pages(GFP_KERNEL, 0);
> >  		if (!(se_mem->se_page)) {
> >  			printk(KERN_ERR "alloc_pages() failed\n");
> >  			goto out;
> > @@ -4349,6 +4347,8 @@ transport_generic_get_mem(struct se_cmd *cmd, u32 length, u32 dma_size)
> >  			printk(KERN_ERR "kmap_atomic() failed\n");
> >  			goto out;
> >  		}
> > +		INIT_LIST_HEAD(&se_mem->se_list);
> > +		se_mem->se_len = (length > dma_size) ? dma_size : length;
> >  		memset(buf, 0, se_mem->se_len);
> >  		kunmap_atomic(buf, KM_IRQ0);
> >  
> > @@ -4367,6 +4367,9 @@ transport_generic_get_mem(struct se_cmd *cmd, u32 length, u32 dma_size)
> >  
> >  	return 0;
> >  out:
> > +	if (se_mem)
> > +		__free_pages(se_mem->se_page, 0);
> > +	kmem_cache_free(se_mem_cache, se_mem);
> >  	return -1;
> >  }
> >  
> > 
> 
> There is actually not a memory leak here.
> 
> The T_TASK(cmd)->t_mem_list (and associated struct se_pages) are
> released during a transport_generic_get_mem() allocation failure
> directly from the 'normal' struct se_cmd descriptor release path called
> by all target fabric modules in transport_generic_remove() ->
> transport_free_pages().
> 
> So I think the allocation failure case in trasnport_generic_new_cmd() ->
> transport_allocate_resources() -> transport_generic_get_mem()
> is better served by some additional code comments perhaps..?
> 

well,

  static int
  transport_generic_get_mem(struct se_cmd *cmd, u32 length, u32 dma_size)
  {
  	unsigned char *buf;
  	struct se_mem *se_mem;
se_mem is a local variable --^
  ...
  	while (length) {
  		se_mem = kmem_cache_zalloc(se_mem_cache, GFP_KERNEL);
We allocate mem --^
  ...
  		se_mem->se_page = alloc_pages(GFP_KERNEL, 0);
  		if (!(se_mem->se_page)) {
  			printk(KERN_ERR "alloc_pages() failed\n");
  			goto out;
we've no assigned se_mem anywhere and now jump to 'out' --^
  ...
  out:
  	return -1;
'se_mem' goes out of scope --^

how is that not a leak?
what am I missing?

I also think the moving of 'INIT_LIST_HEAD()' and assignment to 
'se_mem->se_len' to after we know all mem allocations are ok is still 
worth doing.

-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

