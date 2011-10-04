Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772Ab1JDKLY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 06:11:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24285 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755586Ab1JDKLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 06:11:23 -0400
Date: Tue, 4 Oct 2011 12:10:36 +0200
From: Johannes Weiner <jweiner@redhat.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@google.com>, Kautuk Consul <consul.kautuk@gmail.com>,
        Mel Gorman <mel@csn.ul.ie>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] mm: disable user interface to manually rescue
 unevictable pages
Message-ID: <20111004101036.GB1687@redhat.com>
References: <1316948380-1879-1-git-send-email-consul.kautuk@gmail.com>
 <20110926112944.GC14333@redhat.com>
 <20110926161136.b4508ecb.akpm@google.com>
 <20110927072714.GA1997@redhat.com>
 <20110928021424.GA2715@barrios-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110928021424.GA2715@barrios-desktop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 28, 2011 at 11:14:24AM +0900, Minchan Kim wrote:
> On Tue, Sep 27, 2011 at 09:27:14AM +0200, Johannes Weiner wrote:
> > At one point, anonymous pages were supposed to go on the unevictable
> > list when no swap space was configured, and the idea was to manually
> > rescue those pages after adding swap and making them evictable again.
> > But nowadays, swap-backed pages on the anon LRU list are not scanned
> > without available swap space anyway, so there is no point in moving
> > them to a separate list anymore.
> > 
> > The manual rescue could also be used in case pages were stranded on
> > the unevictable list due to race conditions.  But the code has been
> > around for a while now and newly discovered bugs should be properly
> > reported and dealt with instead of relying on such a manual fixup.
> > 
> > In addition to the lack of a usecase, the sysfs interface to rescue
> > pages from a specific NUMA node has been broken since its
> > introduction, so it's unlikely that anybody ever relied on that.
> > 
> > This patch removes the functionality behind the sysctl and the
> > node-interface and emits a one-time warning when somebody tries to
> > access either of them.
> > 
> > Signed-off-by: Johannes Weiner <jweiner@redhat.com>
> > Reported-by: Kautuk Consul <consul.kautuk@gmail.com>
> Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

Thanks, Minchan.

> > @@ -3469,11 +3415,8 @@ int scan_unevictable_handler(struct ctl_table *table, int write,
> >  			   void __user *buffer,
> >  			   size_t *length, loff_t *ppos)
> >  {
> > +	warn_scan_unevictable_pages();
> >  	proc_doulongvec_minmax(table, write, buffer, length, ppos);
> > -
> > -	if (write && *(unsigned long *)table->data)
> > -		scan_all_zones_unevictable_pages();
> > -
> >  	scan_unevictable_pages = 0;
> 
> Nitpick:
> Could we remove this resetting with zero?

table->data = &scan_unevictable_pages, so I let it in such that the
generic sysctl stuff to process the input and clean up afterward is
complete.
