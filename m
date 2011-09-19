Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213Ab1ISNHA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 09:07:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60022 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756046Ab1ISNG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 09:06:58 -0400
Date: Mon, 19 Sep 2011 15:06:57 +0200
From: Michal Hocko <mhocko@suse.cz>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Johannes Weiner <jweiner@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <bsingharora@gmail.com>, Ying Han <yinghan@google.com>,
        Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 01/11] mm: memcg: consolidate hierarchy iteration
 primitives
Message-ID: <20110919130656.GD21847@tiehlicka.suse.cz>
References: <1315825048-3437-1-git-send-email-jweiner@redhat.com>
 <1315825048-3437-2-git-send-email-jweiner@redhat.com>
 <20110912223746.GA20765@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110912223746.GA20765@shutemov.name>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 13-09-11 01:37:46, Kirill A. Shutemov wrote:
> On Mon, Sep 12, 2011 at 12:57:18PM +0200, Johannes Weiner wrote:
[...]
> >  	while (1) {
> > -		victim = mem_cgroup_select_victim(root_memcg);
> > -		if (victim == root_memcg) {
> > +		victim = mem_cgroup_iter(root_memcg, victim, true);
> > +		if (!victim) {
> >  			loop++;
> >  			/*
> >  			 * We are not draining per cpu cached charges during
> > @@ -1689,10 +1644,8 @@ static int mem_cgroup_hierarchical_reclaim(struct mem_cgroup *root_memcg,
> >  				 * anything, it might because there are
> >  				 * no reclaimable pages under this hierarchy
> >  				 */
> > -				if (!check_soft || !total) {
> > -					css_put(&victim->css);
> > +				if (!check_soft || !total)
> >  					break;
> > -				}
> >  				/*
> >  				 * We want to do more targeted reclaim.
> >  				 * excess >> 2 is not to excessive so as to
> > @@ -1700,15 +1653,13 @@ static int mem_cgroup_hierarchical_reclaim(struct mem_cgroup *root_memcg,
> >  				 * coming back to reclaim from this cgroup
> >  				 */
> >  				if (total >= (excess >> 2) ||
> > -					(loop > MEM_CGROUP_MAX_RECLAIM_LOOPS)) {
> > -					css_put(&victim->css);
> > +					(loop > MEM_CGROUP_MAX_RECLAIM_LOOPS))
> >  					break;
> > -				}
> >  			}
> > +			continue;
> 
> Souldn't we do
> 
> victim = root_memcg;
> 
> instead?

You want to save mem_cgroup_iter call?
Yes it will work... I am not sure it is really an improvement. If we
just continue we can rely on mem_cgroup_iter doing the right thing.
Assignment might be not that obvious. But I dunno. 
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
