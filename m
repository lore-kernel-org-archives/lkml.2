Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761156Ab0J2KRf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 06:17:35 -0400
Received: from gir.skynet.ie ([193.1.99.77]:55682 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756784Ab0J2KRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 06:17:32 -0400
Date: Fri, 29 Oct 2010 11:17:19 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Shaohua Li <shaohua.li@intel.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH 2/2] mm: vmstat: Use a single setter function and
	callback for adjusting percpu thresholds
Message-ID: <20101029101718.GH4896@csn.ul.ie>
References: <1288278816-32667-1-git-send-email-mel@csn.ul.ie> <1288278816-32667-3-git-send-email-mel@csn.ul.ie> <20101028150904.79fe9beb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20101028150904.79fe9beb.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 28, 2010 at 03:09:04PM -0700, Andrew Morton wrote:
> On Thu, 28 Oct 2010 16:13:36 +0100
> Mel Gorman <mel@csn.ul.ie> wrote:
> 
> > reduce_pgdat_percpu_threshold() and restore_pgdat_percpu_threshold()
> > exist to adjust the per-cpu vmstat thresholds while kswapd is awake to
> > avoid errors due to counter drift. The functions duplicate some code so
> > this patch replaces them with a single set_pgdat_percpu_threshold() that
> > takes a callback function to calculate the desired threshold as a
> > parameter.
> 
> hm.  Could have passed in some silly flag rather than a function
> pointer but whatever.
> 
> >
> > ...
> >
> > -void reduce_pgdat_percpu_threshold(pg_data_t *pgdat)
> > +void set_pgdat_percpu_threshold(pg_data_t *pgdat,
> > +				int (*calculate_pressure)(struct zone *))
> >  {
> >  	struct zone *zone;
> >  	int cpu;
> > @@ -196,28 +197,7 @@ void reduce_pgdat_percpu_threshold(pg_data_t *pgdat)
> >  		if (!zone->percpu_drift_mark)
> >  			continue;
> >  
> > -		threshold = calculate_pressure_threshold(zone);
> > -		for_each_online_cpu(cpu)
> > -			per_cpu_ptr(zone->pageset, cpu)->stat_threshold
> > -							= threshold;
> > -	}
> > -	put_online_cpus();
> > -}
> > -
> > -void restore_pgdat_percpu_threshold(pg_data_t *pgdat)
> > -{
> > -	struct zone *zone;
> > -	int cpu;
> > -	int threshold;
> > -	int i;
> > -
> > -	get_online_cpus();
> > -	for (i = 0; i < pgdat->nr_zones; i++) {
> > -		zone = &pgdat->node_zones[i];
> > -		if (!zone->percpu_drift_mark)
> > -			continue;
> > -
> > -		threshold = calculate_threshold(zone);
> > +		threshold = calculate_pressure(zone);
> 
> Readability nit: it's better to use the
> 
> 		threshold = (*calculate_pressure)(zone);
> 
> syntax here.  So the code reader doesn't go running around trying to
> find the function "calculate_pressure".  I've been fooled that way
> plenty of times.
> 

Fair point, I'll know for future reference. Thanks

> 
> >  		for_each_online_cpu(cpu)
> >  			per_cpu_ptr(zone->pageset, cpu)->stat_threshold
> >  							= threshold;
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
