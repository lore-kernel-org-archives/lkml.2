Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004Ab1AEL7K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 06:59:10 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:35665 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716Ab1AEL7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 06:59:09 -0500
Date: Wed, 5 Jan 2011 12:58:40 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Subject: Re: [BUGFIX][PATCH] memcg: fix memory migration of shmem swapcache
Message-ID: <20110105115840.GD4654@cmpxchg.org>
References: <20110105130020.e2a854e4.nishimura@mxp.nes.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110105130020.e2a854e4.nishimura@mxp.nes.nec.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 05, 2011 at 01:00:20PM +0900, Daisuke Nishimura wrote:
> In current implimentation, mem_cgroup_end_migration() decides whether the page
> migration has succeeded or not by checking "oldpage->mapping".
> 
> But if we are tring to migrate a shmem swapcache, the page->mapping of it is
> NULL from the begining, so the check would be invalid.
> As a result, mem_cgroup_end_migration() assumes the migration has succeeded
> even if it's not, so "newpage" would be freed while it's not uncharged.
> 
> This patch fixes it by passing mem_cgroup_end_migration() the result of the
> page migration.

Are there other users that rely on unused->mapping being NULL after
migration?

If so, aren't they prone to misinterpreting this for shmem swapcache
as well?

If not, wouldn't it be better to remove that page->mapping = NULL from
migrate_page_copy() altogether?  I think it's an ugly exception where
the outcome of PageAnon() is not meaningful for an LRU page.

To your patch:

> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2856,7 +2856,7 @@ int mem_cgroup_prepare_migration(struct page *page,
>  
>  /* remove redundant charge if migration failed*/
>  void mem_cgroup_end_migration(struct mem_cgroup *mem,
> -	struct page *oldpage, struct page *newpage)
> +	struct page *oldpage, struct page *newpage, int result)
>  {
>  	struct page *used, *unused;
>  	struct page_cgroup *pc;
> @@ -2865,8 +2865,7 @@ void mem_cgroup_end_migration(struct mem_cgroup *mem,
>  		return;
>  	/* blocks rmdir() */
>  	cgroup_exclude_rmdir(&mem->css);
> -	/* at migration success, oldpage->mapping is NULL. */
> -	if (oldpage->mapping) {
> +	if (result) {

Since this function does not really need more than a boolean value,
wouldn't it make the code more obvious if the parameter was `bool
success'?

	if (!success) {
>  		used = oldpage;
>  		unused = newpage;
>  	} else {

Minor nit, though.  I agree with the patch in general.

	Hannes
