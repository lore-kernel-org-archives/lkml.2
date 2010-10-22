Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564Ab0JVIHh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 04:07:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:47401 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752952Ab0JVIHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 04:07:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,222,1286175600"; 
   d="scan'208";a="566407105"
Date: Fri, 22 Oct 2010 16:07:25 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Torsten Kaiser <just.for.lkml@googlemail.com>,
        Neil Brown <neilb@suse.de>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Li, Shaohua" <shaohua.li@intel.com>
Subject: Re: Deadlock possibly caused by too_many_isolated.
Message-ID: <20101022080725.GA22594@localhost>
References: <AANLkTimVu+5gTDs8przJVP2EbWC=FX-zWW7aH08BtrHC@mail.gmail.com>
 <20101020055717.GA12752@localhost>
 <20101020150346.1832.A69D9226@jp.fujitsu.com>
 <20101020092739.GA23869@localhost>
 <4CBEE888.2090606@kernel.dk>
 <20101022053755.GB16804@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101022053755.GB16804@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > We surely need 1 set aside for each level of that stack that will
> > potentially consume one. 1 should be enough for the generic pool, and
> > then clones will use a separate pool. So md and friends should really
> > have a pool per device, so that stacking will always work properly.
> 
> Agreed for the deadlock problem.
> 
> > There should be no throughput concerns, it should purely be a safe guard
> > measure to prevent us deadlocking when doing IO for reclaim.
> 
> It's easy to verify whether the minimal size will have negative
> impacts on IO throughput. In Torsten's case, increase BIO_POOL_SIZE
> by one and check how it performs.

Sorry it seems simply increasing BIO_POOL_SIZE is not enough to fix
possible deadlocks. We need adding new mempool(s). Because when there
BIO_POOL_SIZE=2 and there are two concurrent reclaimers each take 1
reservation, they will deadlock each other when trying to take the
next bio at the raid1 level.

Thanks,
Fengguang
