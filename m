Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513Ab2AYABw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 19:01:52 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52086 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754453Ab2AYABt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 19:01:49 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 25 Jan 2012 09:00:25 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>, Ying Han <yinghan@google.com>
Subject: Re: [PATCH v4] memcg: remove PCG_CACHE page_cgroup flag
Message-Id: <20120125090025.6d24cd0f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20120124180842.GA18372@tiehlicka.suse.cz>
References: <20120119181711.8d697a6b.kamezawa.hiroyu@jp.fujitsu.com>
	<20120120122658.1b14b512.kamezawa.hiroyu@jp.fujitsu.com>
	<20120120084545.GC9655@tiehlicka.suse.cz>
	<20120124121636.115f1cf0.kamezawa.hiroyu@jp.fujitsu.com>
	<20120124111644.GE1660@cmpxchg.org>
	<20120124145411.GF1660@cmpxchg.org>
	<20120124160140.GH26289@tiehlicka.suse.cz>
	<20120124164449.GH1660@cmpxchg.org>
	<20120124172308.GI26289@tiehlicka.suse.cz>
	<20120124180842.GA18372@tiehlicka.suse.cz>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jan 2012 19:09:47 +0100
Michal Hocko <mhocko@suse.cz> wrote:

> On Tue 24-01-12 18:23:08, Michal Hocko wrote:
> > On Tue 24-01-12 17:44:49, Johannes Weiner wrote:
> > > On Tue, Jan 24, 2012 at 05:01:40PM +0100, Michal Hocko wrote:
> > > > On Tue 24-01-12 15:54:11, Johannes Weiner wrote:
> > > > > Hold on, I think this patch is still not complete: end_migration()
> > > > > directly uses __mem_cgroup_uncharge_common() with the FORCE charge
> > > > > type.  This will uncharge all migrated anon pages as cache, when it
> > > > > should decide based on PageAnon(used), which is the page where
> > > > > ->mapping is intact after migration.
> > > > 
> > > > You are right, I've missed that one as well. Anyway
> > > > MEM_CGROUP_CHARGE_TYPE_FORCE is used only in mem_cgroup_end_migration
> > > > these days and it got out of sync with its documentation (used by
> > > > force_empty) quite some time ago (f817ed48). What about something like
> > > > the following on top of the previous patch?
> > > > --- 
> > > > Should be foldet into the previous patch with the updated changelog:
> > > > 
> > > > Mapping of the unused page is not touched during migration (see
> > > 
> > > used one, not unused.  unused->mapping is globbered during migration.
> > 
> > Yes, you are right:
> 
> Sorry I haven't sent the most recent update. Here we go:
> ---
> Should be folded into the previous patch with the updated changelog:
> 
Thanks, I'll fold this into v5.
-Kame


> Mapping of the used page is not touched during migration (see
> page_remove_rmap) so we can rely on it and push the correct charge type
> down to __mem_cgroup_uncharge_common from end_migration for unused page.
> The force flag was misleading was abused for skipping the needless
> page_mapped() / PageCgroupMigration() check, as we know the unused page
> is no longer mapped and cleared the migration flag just a few lines
> up.  But doing the checks is no biggie and it's not worth adding another
> flag just to skip them.  But I guess this should be mentioned in the
> changelog.
> ---
>  mm/memcontrol.c |    9 +++++++--
>  1 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 4d655ee..869744a 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3195,6 +3195,7 @@ void mem_cgroup_end_migration(struct mem_cgroup *memcg,
>  {
>  	struct page *used, *unused;
>  	struct page_cgroup *pc;
> +	bool anon;
>  
>  	if (!memcg)
>  		return;
> @@ -3207,6 +3208,7 @@ void mem_cgroup_end_migration(struct mem_cgroup *memcg,
>  		used = newpage;
>  		unused = oldpage;
>  	}
> +
>  	/*
>  	 * We disallowed uncharge of pages under migration because mapcount
>  	 * of the page goes down to zero, temporarly.
> @@ -3217,7 +3219,10 @@ void mem_cgroup_end_migration(struct mem_cgroup *memcg,
>  	ClearPageCgroupMigration(pc);
>  	unlock_page_cgroup(pc);
>  
> -	__mem_cgroup_uncharge_common(unused, MEM_CGROUP_CHARGE_TYPE_FORCE);
> +	anon = PageAnon(used);
> +	__mem_cgroup_uncharge_common(unused,
> +			anon ? MEM_CGROUP_CHARGE_TYPE_MAPPED
> +			: MEM_CGROUP_CHARGE_TYPE_CACHE);
>  
>  	/*
>  	 * If a page is a file cache, radix-tree replacement is very atomic
> @@ -3227,7 +3232,7 @@ void mem_cgroup_end_migration(struct mem_cgroup *memcg,
>  	 * and USED bit check in mem_cgroup_uncharge_page() will do enough
>  	 * check. (see prepare_charge() also)
>  	 */
> -	if (PageAnon(used))
> +	if (anon)
>  		mem_cgroup_uncharge_page(used);
>  	/*
>  	 * At migration, we may charge account against cgroup which has no
> -- 
> 1.7.8.3
> 
> -- 
> Michal Hocko
> SUSE Labs
> SUSE LINUX s.r.o.
> Lihovarska 1060/12
> 190 00 Praha 9    
> Czech Republic
> 

