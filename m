Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab1C2TjP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 15:39:15 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:32877 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212Ab1C2TjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 15:39:13 -0400
Date: Tue, 29 Mar 2011 21:39:07 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: "'Christoph Hellwig'" <hch@infradead.org>
Cc: Sean Noonan <Sean.Noonan@twosigma.com>,
        "'Michel Lespinasse'" <walken@google.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        Martin Bligh <Martin.Bligh@twosigma.com>,
        Trammell Hudson <Trammell.Hudson@twosigma.com>,
        Christos Zoulas <Christos.Zoulas@twosigma.com>,
        "'linux-xfs@oss.sgi.com'" <linux-xfs@oss.sgi.com>,
        Stephen Degler <Stephen.Degler@twosigma.com>,
        "'linux-mm@kvack.org'" <linux-mm@kvack.org>
Subject: Re: XFS memory allocation deadlock in 2.6.38
Message-ID: <20110329193907.GK2310@cmpxchg.org>
References: <081DDE43F61F3D43929A181B477DCA95639B52FD@MSXAOA6.twosigma.com>
 <081DDE43F61F3D43929A181B477DCA95639B5327@MSXAOA6.twosigma.com>
 <20110324174311.GA31576@infradead.org>
 <AANLkTikwwRm6FHFtEdUg54NvmKdswQw-NPH5dtq1mXBK@mail.gmail.com>
 <081DDE43F61F3D43929A181B477DCA95639B5349@MSXAOA6.twosigma.com>
 <BANLkTin0jJevStg5P2hqsLbqMzo3o30sYg@mail.gmail.com>
 <081DDE43F61F3D43929A181B477DCA95639B534E@MSXAOA6.twosigma.com>
 <081DDE43F61F3D43929A181B477DCA95639B5359@MSXAOA6.twosigma.com>
 <20110329192434.GA10536@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110329192434.GA10536@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 29, 2011 at 03:24:34PM -0400, 'Christoph Hellwig' wrote:
> Can you check if the brute force patch below helps?  If it does I
> still need to refine it a bit, but it could be that we are doing
> an allocation under an xfs lock that could recurse back into the
> filesystem.  We have a per-process flag to disable that for normal
> kmalloc allocation, but we lost it for vmalloc in the commit you
> bisected the regression to.
> 
> 
> Index: xfs/fs/xfs/linux-2.6/kmem.h
> ===================================================================
> --- xfs.orig/fs/xfs/linux-2.6/kmem.h	2011-03-29 21:16:58.039224236 +0200
> +++ xfs/fs/xfs/linux-2.6/kmem.h	2011-03-29 21:17:08.368223598 +0200
> @@ -63,7 +63,7 @@ static inline void *kmem_zalloc_large(si
>  {
>  	void *ptr;
>  
> -	ptr = vmalloc(size);
> +	ptr = __vmalloc(size, GFP_NOFS | __GFP_HIGHMEM, PAGE_KERNEL);
>  	if (ptr)
>  		memset(ptr, 0, size);
>  	return ptr;

Note that vmalloc is currently broken in that it does a GFP_KERNEL
allocation if it has to allocate page table pages, even when invoked
with GFP_NOFS:

	http://marc.info/?l=linux-mm&m=128942194520631&w=4

