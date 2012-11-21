Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab2KVXE0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 18:04:26 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:34813 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758522Ab2KVXDw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 18:03:52 -0500
Date: Wed, 21 Nov 2012 16:34:18 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Jan Kara <jack@suse.cz>
Cc: metin d <metdos@yahoo.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org
Subject: Re: Problem in Page Cache Replacement
Message-ID: <20121121213417.GC24381@cmpxchg.org>
References: <1353433362.85184.YahooMailNeo@web141101.mail.bf1.yahoo.com>
 <20121120182500.GH1408@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121120182500.GH1408@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Nov 20, 2012 at 07:25:00PM +0100, Jan Kara wrote:
> On Tue 20-11-12 09:42:42, metin d wrote:
> > I have two PostgreSQL databases named data-1 and data-2 that sit on the
> > same machine. Both databases keep 40 GB of data, and the total memory
> > available on the machine is 68GB.
> > 
> > I started data-1 and data-2, and ran several queries to go over all their
> > data. Then, I shut down data-1 and kept issuing queries against data-2.
> > For some reason, the OS still holds on to large parts of data-1's pages
> > in its page cache, and reserves about 35 GB of RAM to data-2's files. As
> > a result, my queries on data-2 keep hitting disk.
> > 
> > I'm checking page cache usage with fincore. When I run a table scan query
> > against data-2, I see that data-2's pages get evicted and put back into
> > the cache in a round-robin manner. Nothing happens to data-1's pages,
> > although they haven't been touched for days.
> > 
> > Does anybody know why data-1's pages aren't evicted from the page cache?
> > I'm open to all kind of suggestions you think it might relate to problem.

This might be because we do not deactive pages as long as there is
cache on the inactive list.  I'm guessing that the inter-reference
distance of data-2 is bigger than half of memory, so it's never
getting activated and data-1 is never challenged.

I have a series of patches that detects a thrashing inactive list and
handles working set changes up to the size of memory.  Would you be
willing to test them?  They are currently based on 3.4, let me know
what version works best for you.
