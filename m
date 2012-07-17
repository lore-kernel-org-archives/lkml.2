Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993Ab2GQRjI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 13:39:08 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:38111 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751109Ab2GQRjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 13:39:05 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Z295l0YVM1nJCy5N5U__Urh7V6LfzAv0yIUqK4lXLXuhB6d
 OgWnqKwtLhuf90mFkYNeCZvQJTTFfXKNyqvC8yJRLufq.imKTWQwRAoOVo_2
 2v4HQun786WqfNBylIM5dYkCWqzZE0GJqwzrvRtIPqYB2KkI94z_JgHiFVyX
 bOI4u7vsc5NWgsn8y5F1W4IhEksw03BAUCetavCrePh0maw.rxmTmo9ecf_N
 Eh6Qd5lzeoyVvcf2zkyPeUAZeBW7Evz6rlQaaCW3kU4KggoSXh0EfElCGOUF
 xQk_JSoW22Phs91yCRJwS59.r8B6xvjHG9ZvcqGyTT8aNMgMwUX5tzV.rYHh
 nB0Rs3nsn0lnJVdlX9fL7JyDZn9yBEsqtVsSRGNG9B2bbIxZLWNQPoCcZrmN
 h9PTq74KaRMFXGIQcmrEnCLkvPOGpMPrsDHbP
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 17 Jul 2012 12:39:00 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Jiang Liu <liuj97@gmail.com>
cc: Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Mel Gorman <mgorman@suse.de>, Jianguo Wu <wujianguo@huawei.com>,
        Jiang Liu <jiang.liu@huawei.com>, Tony Luck <tony.luck@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>, Minchan Kim <minchan@kernel.org>,
        Keping Chen <chenkeping@huawei.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/slub: fix a BUG_ON() when offlining a memory node
 and CONFIG_SLUB_DEBUG is on
In-Reply-To: <1342543816-10853-1-git-send-email-jiang.liu@huawei.com>
Message-ID: <alpine.DEB.2.00.1207171237320.15177@router.home>
References: <1342543816-10853-1-git-send-email-jiang.liu@huawei.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jul 2012, Jiang Liu wrote:

> From: Jianguo Wu <wujianguo@huawei.com>
>
> From: Jianguo Wu <wujianguo@huawei.com>
>
> SLUB allocator may cause a BUG_ON() when offlining a memory node if
> CONFIG_SLUB_DEBUG is on. The scenario is:
>
> 1) when creating kmem_cache_node slab, it cause inc_slabs_node() twice.
> early_kmem_cache_node_alloc
> 	->new_slab
> 		->inc_slabs_node
> 	->inc_slabs_node

New slab will not be able to increment the slab counter. It will
check that there is no per node structure yet and then skip the inc slabs
node.

This suggests that a call to early_kmem_cache_node_alloc was not needed
because the per node structure already existed. Lets fix that instead.

