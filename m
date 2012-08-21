Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630Ab2HUTPZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 15:15:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33109 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751509Ab2HUTPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 15:15:22 -0400
Date: Tue, 21 Aug 2012 22:16:12 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rafael Aquini <aquini@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Rusty Russell <rusty@rustcorp.com.au>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>, Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH v8 1/5] mm: introduce a common interface for balloon
 pages mobility
Message-ID: <20120821191612.GA9027@redhat.com>
References: <cover.1345519422.git.aquini@redhat.com>
 <e24f3073ef539985dea52943dcb84762213a0857.1345519422.git.aquini@redhat.com>
 <20120821135223.GA7117@redhat.com>
 <20120821175502.GC12294@t510.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120821175502.GC12294@t510.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 02:55:03PM -0300, Rafael Aquini wrote:
> On Tue, Aug 21, 2012 at 04:52:23PM +0300, Michael S. Tsirkin wrote:
> > > + * address_space_operations utilized methods for ballooned pages:
> > > + *   .migratepage    - used to perform balloon's page migration (as is)
> > > + *   .launder_page   - used to isolate a page from balloon's page list
> > > + *   .freepage       - used to reinsert an isolated page to balloon's page list
> > > + */
> > 
> > It would be a good idea to document the assumptions here.
> > Looks like .launder_page and .freepage are called in rcu critical
> > section.
> > But migratepage isn't - why is that safe?
> > 
> 
> The migratepage callback for virtio_balloon can sleep, and IIUC we cannot sleep
> within a RCU critical section. 
> 
> Also, The migratepage callback is called at inner migration's circle function
> move_to_new_page(), and I don't think embedding it in a RCU critical section
> would be a good idea, for the same understanding aforementioned.

Yes but this means it is still exposed to the module unloading
races that RCU was supposed to fix.
So need to either rework that code so it won't sleep
or switch to some other synchronization.

-- 
MST
