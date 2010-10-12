Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932288Ab0JLL7Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 07:59:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40237 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932231Ab0JLL7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 07:59:25 -0400
Date: Tue, 12 Oct 2010 13:52:57 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dan Williams <dan.j.williams@intel.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dma: get_user_pages -> get_user_pages_fast
Message-ID: <20101012115257.GA24389@redhat.com>
References: <20101011165310.GA5122@redhat.com>
 <1286818496.1998.43.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286818496.1998.43.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 11, 2010 at 07:34:56PM +0200, Peter Zijlstra wrote:
> On Mon, 2010-10-11 at 18:53 +0200, Michael S. Tsirkin wrote:
> > There doesn't seem to be any advantage to using
> > get_user_pages, so switch iovlock to get_user_pages_fast
> > instead.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> > 
> > Lightly tested.  This patch is on top of the bugfix patch I posted
> > previously.
> > 
> >  drivers/dma/iovlock.c |   10 ++--------
> >  1 files changed, 2 insertions(+), 8 deletions(-)
> > 
> > diff --git a/drivers/dma/iovlock.c b/drivers/dma/iovlock.c
> > index 21ed8f3..c6917e8 100644
> > --- a/drivers/dma/iovlock.c
> > +++ b/drivers/dma/iovlock.c
> > @@ -95,17 +95,11 @@ struct dma_pinned_list *dma_pin_iovec_pages(struct iovec *iov, size_t len)
> >  		pages += page_list->nr_pages;
> >  
> >  		/* pin pages down */
> > -		down_read(&current->mm->mmap_sem);
> > -		ret = get_user_pages(
> > -			current,
> > -			current->mm,
> > +		ret = get_user_pages_fast(
> >  			(unsigned long) iov[i].iov_base,
> >  			page_list->nr_pages,
> 
> What's the actual nr_pages here? Is it limited to some small number or
> can it be arbitrarily large?
> >  			1,	/* write */
> > -			0,	/* force */
> > -			page_list->pages,
> > -			NULL);
> > -		up_read(&current->mm->mmap_sem);
> > +			page_list->pages);
> >  
> >  		if (unlikely(ret < 0))
> >  			goto unpin;
> 


I think it can get arbitrarily large: just above this is this code:

                len -= iov[i].iov_len;

                if (!access_ok(VERIFY_WRITE, iov[i].iov_base, iov[i].iov_len))
                        goto unpin;
        
                page_list->nr_pages = num_pages_spanned(&iov[i]);

part of this is a bug: we should be locking at most len bytes.
This could be solved by an untested patch below.
Comments?
We probably should set a limit on the number of pages, too:
currently there could be a large # of very small chunks in the iovec.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

---

diff --git a/drivers/dma/iovlock.c b/drivers/dma/iovlock.c
index 121d7fd..1032f7b 100644
--- a/drivers/dma/iovlock.c
+++ b/drivers/dma/iovlock.c
@@ -32,11 +32,11 @@
 #include <asm/io.h>
 #include <asm/uaccess.h>
 
-static int num_pages_spanned(struct iovec *iov)
+static int num_pages_spanned(void __user *iov_base, size_t iov_len)
 {
 	return
-	((PAGE_ALIGN((unsigned long)iov->iov_base + iov->iov_len) -
-	((unsigned long)iov->iov_base & PAGE_MASK)) >> PAGE_SHIFT);
+		((PAGE_ALIGN((unsigned long)iov_base + iov_len) -
+		  ((unsigned long)iov_base & PAGE_MASK)) >> PAGE_SHIFT);
 }
 
 /*
@@ -54,19 +54,21 @@ struct dma_pinned_list *dma_pin_iovec_pages(struct iovec *iov, size_t len)
 	int i;
 	int ret;
 	int nr_iovecs = 0;
-	int iovec_len_used = 0;
 	int iovec_pages_used = 0;
+	size_t l = len;
 
 	/* don't pin down non-user-based iovecs */
 	if (segment_eq(get_fs(), KERNEL_DS))
 		return NULL;
 
 	/* determine how many iovecs/pages there are, up front */
-	do {
-		iovec_len_used += iov[nr_iovecs].iov_len;
-		iovec_pages_used += num_pages_spanned(&iov[nr_iovecs]);
+	while (l) {
+		size_t s = min(l, iov[nr_iovecs].iov_len);
+		l -= s;
+		iovec_pages_used += num_pages_spanned(iov[nr_iovecs].iov_base,
+						      s);
 		nr_iovecs++;
-	} while (iovec_len_used < len);
+	}
 
 	/* single kmalloc for pinned list, page_list[], and the page arrays */
 	local_list = kmalloc(sizeof(*local_list)
@@ -82,13 +84,14 @@ struct dma_pinned_list *dma_pin_iovec_pages(struct iovec *iov, size_t len)
 
 	for (i = 0; i < nr_iovecs; i++) {
 		struct dma_page_list *page_list = &local_list->page_list[i];
+		size_t s = min(len, iov[nr_iovecs].iov_len);
 
-		len -= iov[i].iov_len;
+		len -= s;
 
-		if (!access_ok(VERIFY_WRITE, iov[i].iov_base, iov[i].iov_len))
+		if (!access_ok(VERIFY_WRITE, iov[i].iov_base, s))
 			goto unpin;
 
-		page_list->nr_pages = num_pages_spanned(&iov[i]);
+		page_list->nr_pages = num_pages_spanned(iov[i].iov_base, s);
 		page_list->base_address = iov[i].iov_base;
 
 		page_list->pages = pages;

