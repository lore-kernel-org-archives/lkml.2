Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932606Ab2GERhs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 13:37:48 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:21267 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756248Ab2GERhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 13:37:47 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: UmwO17oVM1mEhIUjDRQVCnksHimNQNJUOsHRfvdq3v5Ncaj
 Ohlnh4_QzIl.4ybHOjwMoKIAAGlv8Ds26Y84wGihgWXxT1XgAYDZ1V2aYCXN
 Z85c.J2p3JS1GBK1b03V1uDo08EtRR7Y33fhQjGqjJ7_UWHQp.Z3DAKlZIjR
 7h0G4LU4xLsJBfRl6NhmCEQ6Qt4icu69pVnUlAIICcJqPqWzmtUMilWindA1
 83RiCRSag8w75O2hjYyRB_ybxD6FkjLo_HbjMqgPjY.rXRGuSZp1c.zDs7fM
 iXvqg5wIvQ4jOEEUX3OiVGFHejVtdvCEgpl8lYFpFzfcLMtutHrjW9tHU2QH
 G9NZTk71hkVz3t0VHiPz1yVboeTwY21FU_20eydwy5XoibaaOBD275OKEvIO
 f
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 5 Jul 2012 12:37:41 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Jiang Liu <liuj97@gmail.com>
cc: Jiang Liu <jiang.liu@huawei.com>, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>, Mel Gorman <mgorman@suse.de>,
        Yinghai Lu <yinghai@kernel.org>, Tony Luck <tony.luck@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>, Minchan Kim <minchan@kernel.org>,
        Keping Chen <chenkeping@huawei.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/4] mm: make consistent use of PG_slab flag
In-Reply-To: <4FF5BD9D.9040101@gmail.com>
Message-ID: <alpine.DEB.2.00.1207051236310.8670@router.home>
References: <1341287837-7904-1-git-send-email-jiang.liu@huawei.com> <1341287837-7904-2-git-send-email-jiang.liu@huawei.com> <alpine.DEB.2.00.1207050945310.4984@router.home> <4FF5BD9D.9040101@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jul 2012, Jiang Liu wrote:

> On 07/05/2012 10:47 PM, Christoph Lameter wrote:
> > On Tue, 3 Jul 2012, Jiang Liu wrote:
> >
> >> PG_slabobject:	mark whether a (compound) page hosts SLUB/SLOB objects.
> >
> > Any subsystem may allocate a compound page to store metadata.
> >
> > The compound pages used by SLOB and SLUB are not managed in any way but
> > the calls to kfree and kmalloc are converted to calls to the page
> > allocator. There is no "management" by the slab allocators for these
> > cases and its inaccurate to say that these are SLUB/SLOB objects since the
> > allocators never deal with these objects.
> >
> Hi Chris,
> 	I think there's a little difference with SLUB and SLOB for compound page.
> For SLOB, it relies on the page allocator to allocate compound page to fulfill
> request bigger than one page. For SLUB, it relies on the page allocator if the
> request is bigger than two pages. So SLUB may allocate a 2-pages compound page
> to host SLUB managed objects.
> 	My proposal may be summarized as below:
> 	1) PG_slab flag marks a memory object is allocated from slab allocator.
> 	2) PG_slabobject marks a (compound) page hosts SLUB/SLOB managed objects.
> 	3) Only set PG_slab/PG_slabobject on the head page of compound pages.
> 	4) For SLAB, PG_slabobject is redundant and so not used.
>
> 	A summary of proposed usage of PG_slab(S) and PG_slabobject(O) with
> SLAB/SLUB/SLOB allocators as below:
> pagesize	SLAB			SLUB			SLOB
> 1page		S			S,O			S,O
> 2page		S			S,O			S
> >=4page		S			S			S

There is no point of recognizing such objects because those will be
kmalloc objects and they can only be freed in a subsystem specific way.
There is no standard way to even figure out which subsystem allocated
them. So for all practical purposes those are unrecoverable.


