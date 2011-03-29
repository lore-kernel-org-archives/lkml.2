Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118Ab1C2TYi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 15:24:38 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60906 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836Ab1C2TYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 15:24:37 -0400
Date: Tue, 29 Mar 2011 15:24:34 -0400
From: "'Christoph Hellwig'" <hch@infradead.org>
To: Sean Noonan <Sean.Noonan@twosigma.com>
Cc: "'Michel Lespinasse'" <walken@google.com>,
        "'Christoph Hellwig'" <hch@infradead.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        Martin Bligh <Martin.Bligh@twosigma.com>,
        Trammell Hudson <Trammell.Hudson@twosigma.com>,
        Christos Zoulas <Christos.Zoulas@twosigma.com>,
        "'linux-xfs@oss.sgi.com'" <linux-xfs@oss.sgi.com>,
        Stephen Degler <Stephen.Degler@twosigma.com>,
        "'linux-mm@kvack.org'" <linux-mm@kvack.org>
Subject: Re: XFS memory allocation deadlock in 2.6.38
Message-ID: <20110329192434.GA10536@infradead.org>
References: <081DDE43F61F3D43929A181B477DCA95639B52FD@MSXAOA6.twosigma.com>
 <081DDE43F61F3D43929A181B477DCA95639B5327@MSXAOA6.twosigma.com>
 <20110324174311.GA31576@infradead.org>
 <AANLkTikwwRm6FHFtEdUg54NvmKdswQw-NPH5dtq1mXBK@mail.gmail.com>
 <081DDE43F61F3D43929A181B477DCA95639B5349@MSXAOA6.twosigma.com>
 <BANLkTin0jJevStg5P2hqsLbqMzo3o30sYg@mail.gmail.com>
 <081DDE43F61F3D43929A181B477DCA95639B534E@MSXAOA6.twosigma.com>
 <081DDE43F61F3D43929A181B477DCA95639B5359@MSXAOA6.twosigma.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <081DDE43F61F3D43929A181B477DCA95639B5359@MSXAOA6.twosigma.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you check if the brute force patch below helps?  If it does I
still need to refine it a bit, but it could be that we are doing
an allocation under an xfs lock that could recurse back into the
filesystem.  We have a per-process flag to disable that for normal
kmalloc allocation, but we lost it for vmalloc in the commit you
bisected the regression to.


Index: xfs/fs/xfs/linux-2.6/kmem.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/kmem.h	2011-03-29 21:16:58.039224236 +0200
+++ xfs/fs/xfs/linux-2.6/kmem.h	2011-03-29 21:17:08.368223598 +0200
@@ -63,7 +63,7 @@ static inline void *kmem_zalloc_large(si
 {
 	void *ptr;
 
-	ptr = vmalloc(size);
+	ptr = __vmalloc(size, GFP_NOFS | __GFP_HIGHMEM, PAGE_KERNEL);
 	if (ptr)
 		memset(ptr, 0, size);
 	return ptr;
