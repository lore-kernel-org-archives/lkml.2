Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757000Ab2HXLk0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 07:40:26 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:15375 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755589Ab2HXLkW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 07:40:22 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 24 Aug 2012 04:40:02 -0700
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
CC: "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "chunsang.jeong@linaro.org" <chunsang.jeong@linaro.org>,
        Krishna Reddy <vdumpa@nvidia.com>,
        "subashrp@gmail.com" <subashrp@gmail.com>,
        "minchan@kernel.org" <minchan@kernel.org>,
        "pullip.cho@samsung.com" <pullip.cho@samsung.com>
Date: Fri, 24 Aug 2012 13:39:55 +0200
Subject: Re: [v3 2/4] ARM: dma-mapping: Refactor out to introduce
 __in_atomic_pool
Thread-Topic: [v3 2/4] ARM: dma-mapping: Refactor out to introduce
 __in_atomic_pool
Thread-Index: Ac2B7TAyBbh4czw9S5i+e/f38CjUsg==
Message-ID: <20120824.143955.659265444078193982.hdoyu@nvidia.com>
References: <1345796945-21115-1-git-send-email-hdoyu@nvidia.com><1345796945-21115-3-git-send-email-hdoyu@nvidia.com><20120824111455.GC11007@konrad-lan.dumpdata.com>
In-Reply-To: <20120824111455.GC11007@konrad-lan.dumpdata.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-nvconfidentiality: public
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote @ Fri, 24 Aug 2012 13:14:55 +0200:

> On Fri, Aug 24, 2012 at 11:29:03AM +0300, Hiroshi Doyu wrote:
> > Check the given range("start", "size") is included in "atomic_pool" or not.
> > 
> > Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
> > ---
> >  arch/arm/mm/dma-mapping.c |   25 +++++++++++++++++++------
> >  1 files changed, 19 insertions(+), 6 deletions(-)
> > 
> > diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
> > index b14ee64..508fde1 100644
> > --- a/arch/arm/mm/dma-mapping.c
> > +++ b/arch/arm/mm/dma-mapping.c
> > @@ -501,19 +501,32 @@ static void *__alloc_from_pool(size_t size, struct page **ret_page)
> >  	return ptr;
> >  }
> >  
> > +static bool __in_atomic_pool(void *start, size_t size)
> > +{
> > +	struct dma_pool *pool = &atomic_pool;
> > +	void *end = start + size;
> > +	void *pool_start = pool->vaddr;
> > +	void *pool_end = pool->vaddr + pool->size;
> > +
> > +	if (start < pool_start || start > pool_end)
> > +		return false;
> > +
> > +	if (end > pool_end) {
> > +		WARN(1, "freeing wrong coherent size from pool\n");
> 
> That does not tell what size or from what pool. Perhaps you should
> include some details, such as the 'size' value, the pool used, the
> range of the pool, etc. Something that will help _you_in the field
> be able to narrow down what might be wrong.

True. I'll.
