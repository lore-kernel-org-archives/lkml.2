Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742Ab2KUAFE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 19:05:04 -0500
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:26286 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752489Ab2KUAFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 19:05:02 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18As8uLLWffzYqTTOXEv+15npVpS87gm9Q=
Date: Tue, 20 Nov 2012 15:27:27 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linaro-mm-sig@lists.linaro.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Soren Moch <smoch@web.de>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH v2] mm: dmapool: use provided gfp flags for all
 dma_alloc_coherent() calls
Message-ID: <20121120202727.GE22106@titan.lakedaemon.net>
References: <20121119144826.f59667b2.akpm@linux-foundation.org>
 <1353421905-3112-1-git-send-email-m.szyprowski@samsung.com>
 <20121120113325.dde266ed.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121120113325.dde266ed.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 11:33:25AM -0800, Andrew Morton wrote:
> On Tue, 20 Nov 2012 15:31:45 +0100
> Marek Szyprowski <m.szyprowski@samsung.com> wrote:
> 
> > dmapool always calls dma_alloc_coherent() with GFP_ATOMIC flag,
> > regardless the flags provided by the caller. This causes excessive
> > pruning of emergency memory pools without any good reason. Additionaly,
> > on ARM architecture any driver which is using dmapools will sooner or
> > later  trigger the following error: 
> > "ERROR: 256 KiB atomic DMA coherent pool is too small!
> > Please increase it with coherent_pool= kernel parameter!".
> > Increasing the coherent pool size usually doesn't help much and only
> > delays such error, because all GFP_ATOMIC DMA allocations are always
> > served from the special, very limited memory pool.
> > 
> 
> Is this problem serious enough to justify merging the patch into 3.7? 
> And into -stable kernels?

kirkwood and orion5x currently have the following code in their early
init:

/*
 * Some Kirkwood devices allocate their coherent buffers from atomic
 * context. Increase size of atomic coherent pool to make sure such the
 * allocations won't fail.
 */
init_dma_coherent_pool_size(SZ_1M);

We have a pending patch to do the same for mvebu (new armv7 Marvell
SoCs).  There is at least one reported real world case where even the
above isn't sufficient [1].

thx,

Jason.

[1] http://www.spinics.net/lists/arm-kernel/msg205495.html
