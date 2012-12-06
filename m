Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947073Ab2LFTgS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 14:36:18 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40223 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946556Ab2LFTgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 14:36:11 -0500
Date: Thu, 6 Dec 2012 17:36:02 -0200
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tejun Heo <tj@kernel.org>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>,
        Aristeu Rozanski <aris@redhat.com>, Li Zefan <lizefan@huawei.com>
Subject: Re: [ 06/89] device_cgroup: fix RCU usage
Message-ID: <20121206193602.GD3034@herton-Z68MA-D2H-B3>
References: <20121203143146.549859007@decadent.org.uk>
 <20121203143147.609467839@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121203143147.609467839@decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2012 at 02:31:52PM +0000, Ben Hutchings wrote:
> 3.2-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Tejun Heo <tj@kernel.org>
> 
> commit 201e72acb2d3821e2de9ce6091e98859c316b29a upstream.
> 
> dev_cgroup->exceptions is protected with devcgroup_mutex for writes
> and RCU for reads; however, RCU usage isn't correct.
> 
> * dev_exception_clean() doesn't use RCU variant of list_del() and
>   kfree().  The function can race with may_access() and may_access()
>   may end up dereferencing already freed memory.  Use list_del_rcu()
>   and kfree_rcu() instead.
> 
> * may_access() may be called only with RCU read locked but doesn't use
>   RCU safe traversal over ->exceptions.  Use list_for_each_entry_rcu().
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Acked-by: Serge E. Hallyn <serge.hallyn@ubuntu.com>
> Cc: Aristeu Rozanski <aris@redhat.com>
> Cc: Li Zefan <lizefan@huawei.com>
> [bwh: Backported to 3.2:
>  - Adjust context
>  - Exception list is called whitelist]
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>

I belive this backport is uneeded for 3.2 (or any stable <= 3.6), since
may_access_whitelist (may_access now in mainline) isn't called under
rcu_read_lock.

> ---
>  security/device_cgroup.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> --- a/security/device_cgroup.c
> +++ b/security/device_cgroup.c
> @@ -202,8 +202,8 @@ static void devcgroup_destroy(struct cgr
>  
>  	dev_cgroup = cgroup_to_devcgroup(cgroup);
>  	list_for_each_entry_safe(wh, tmp, &dev_cgroup->whitelist, list) {
> -		list_del(&wh->list);
> -		kfree(wh);
> +		list_del_rcu(&wh->list);
> +		kfree_rcu(wh, rcu);
>  	}
>  	kfree(dev_cgroup);
>  }
> @@ -278,7 +278,7 @@ static int may_access_whitelist(struct d
>  {
>  	struct dev_whitelist_item *whitem;
>  
> -	list_for_each_entry(whitem, &c->whitelist, list) {
> +	list_for_each_entry_rcu(whitem, &c->whitelist, list) {
>  		if (whitem->type & DEV_ALL)
>  			return 1;
>  		if ((refwh->type & DEV_BLOCK) && !(whitem->type & DEV_BLOCK))
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
[]'s
Herton
