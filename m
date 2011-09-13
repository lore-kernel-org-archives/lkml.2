Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390Ab1IMFlE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 01:41:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51943 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754227Ab1IMFlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 01:41:03 -0400
Date: Tue, 13 Sep 2011 07:40:33 +0200
From: Johannes Weiner <jweiner@redhat.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <bsingharora@gmail.com>, Ying Han <yinghan@google.com>,
        Michal Hocko <mhocko@suse.cz>, Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 01/11] mm: memcg: consolidate hierarchy iteration
 primitives
Message-ID: <20110913054033.GC2929@redhat.com>
References: <1315825048-3437-1-git-send-email-jweiner@redhat.com>
 <1315825048-3437-2-git-send-email-jweiner@redhat.com>
 <20110912223746.GA20765@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110912223746.GA20765@shutemov.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 13, 2011 at 01:37:46AM +0300, Kirill A. Shutemov wrote:
> On Mon, Sep 12, 2011 at 12:57:18PM +0200, Johannes Weiner wrote:
> > -static struct mem_cgroup *mem_cgroup_get_next(struct mem_cgroup *iter,
> > -					struct mem_cgroup *root,
> > -					bool cond)
> > -{
> > -	int nextid = css_id(&iter->css) + 1;
> > -	int found;
> > -	int hierarchy_used;
> > -	struct cgroup_subsys_state *css;
> > +	if (prev && !remember)
> > +		id = css_id(&prev->css);
> >  
> > -	hierarchy_used = iter->use_hierarchy;
> > +	if (prev && prev != root)
> > +		css_put(&prev->css);
> >  
> > -	css_put(&iter->css);
> > -	/* If no ROOT, walk all, ignore hierarchy */
> > -	if (!cond || (root && !hierarchy_used))
> > -		return NULL;
> > +	if (!root->use_hierarchy && root != root_mem_cgroup) {
> > +		if (prev)
> > +			return NULL;
> > +		return root;
> > +	}
> >  
> > -	if (!root)
> > -		root = root_mem_cgroup;
> > +	while (!mem) {
> > +		struct cgroup_subsys_state *css;
> >  
> > -	do {
> > -		iter = NULL;
> > -		rcu_read_lock();
> > +		if (remember)
> > +			id = root->last_scanned_child;
> >  
> > -		css = css_get_next(&mem_cgroup_subsys, nextid,
> > -				&root->css, &found);
> > -		if (css && css_tryget(css))
> > -			iter = container_of(css, struct mem_cgroup, css);
> > +		rcu_read_lock();
> > +		css = css_get_next(&mem_cgroup_subsys, id + 1, &root->css, &id);
> > +		if (css) {
> > +			if (css == &root->css || css_tryget(css))
> 
> When does css != &root->css here?

It does not grab an extra reference to the passed hierarchy root, as
all callsites must already hold one to guarantee it's not going away.

> > +static void mem_cgroup_iter_break(struct mem_cgroup *root,
> > +				  struct mem_cgroup *prev)
> > +{
> > +	if (!root)
> > +		root = root_mem_cgroup;
> > +	if (prev && prev != root)
> > +		css_put(&prev->css);
> > +}
