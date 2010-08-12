Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933155Ab0HLIFU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 04:05:20 -0400
Received: from mtagate5.uk.ibm.com ([194.196.100.165]:60895 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932846Ab0HLIFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 04:05:13 -0400
Date: Thu, 12 Aug 2010 10:07:01 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Sachin Sant <sachinp@in.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org
Subject: Re: Latest git build failure on s390 - dma_get_cache_alignment()
Message-ID: <20100812080701.GB7814@osiris.boeblingen.de.ibm.com>
References: <4C63A551.3040701@in.ibm.com>
 <20100812075532.GA7814@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100812075532.GA7814@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 09:55:32AM +0200, Heiko Carstens wrote:
> On Thu, Aug 12, 2010 at 01:10:01PM +0530, Sachin Sant wrote:
> > Latest 2.6.35 git (2.6.35-git11 : 5af568cbd...) fails to build
> > on s390 with following errors :
> > 
> > arch/s390/mm/fault.c:396: warning: frame size of 'do_protection_exception' is 264 bytes
> > In file included from include/linux/dmaengine.h:26,
> >            from include/linux/skbuff.h:30,
> >            from include/linux/icmpv6.h:82,
> >            from include/linux/ipv6.h:220,
> >            from include/net/ipv6.h:16,
> >            from include/linux/sunrpc/clnt.h:25,
> >            from include/linux/nfs_fs.h:48,
> >            from init/do_mounts.c:20:
> > include/linux/dma-mapping.h:145: error: static declaration of 'dma_get_cache_alignment' follows non-static declaration
> > include/asm-generic/dma-mapping-broken.h:73: error: previous declaration of 'dma_get_cache_alignment' was here
> > make[1]: *** [init/do_mounts.o] Error 1
> > make[1]: *** Waiting for unfinished jobs....
> > init/do_mounts_md.c: In function 'md_setup_drive':
> > init/do_mounts_md.c:241: warning: frame size of 'md_setup_drive' is 496 bytes
> > make: *** [init] Error 2
> > make: *** Waiting for unfinished jobs....
> > 
> > The code in question was last changed via following commit
> > 
> > commit 4565f0170dfc849b3629c27d769db800467baa62
> > dma-mapping: unify dma_get_cache_alignment implementations
> 
> Cc'ing linux-arch since the original patch got posted there as well.
> 
> Patch below should fix it.
> 
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> ---
> 
>  include/asm-generic/dma-mapping-common.h |    8 ++++++++
>  include/linux/dma-mapping.h              |    8 --------
>  2 files changed, 8 insertions(+), 8 deletions(-)

Crap. By far not all converted architectures include dma-mapping-common.h
from their private dma-mapping header file. So the patch would probably
introduce a couple of new compile errors.
Looks like we need an explicit ifdef.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---

 include/linux/dma-mapping.h |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index e0670a5..ce29b81 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -142,6 +142,7 @@ static inline int dma_set_seg_boundary(struct device *dev, unsigned long mask)
 		return -EIO;
 }
 
+#ifdef CONFIG_HAS_DMA
 static inline int dma_get_cache_alignment(void)
 {
 #ifdef ARCH_DMA_MINALIGN
@@ -149,6 +150,7 @@ static inline int dma_get_cache_alignment(void)
 #endif
 	return 1;
 }
+#endif
 
 /* flags for the coherent memory api */
 #define	DMA_MEMORY_MAP			0x01
