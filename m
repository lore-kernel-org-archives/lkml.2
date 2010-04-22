Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757823Ab0DVT5c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 15:57:32 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:39986 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757784Ab0DVT52 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:57:28 -0400
Date: Thu, 22 Apr 2010 12:57:25 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "containers@lists.osdl.org" <containers@lists.osdl.org>,
       Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Vivek Goyal <vgoyal@redhat.com>,
       Gui Jianfeng <GuiJianfeng@cn.fujitsu.com>
Subject: Re: [PATCH 5/5] blk-cgroup: Fix an RCU warning in blkiocg_create()
Message-ID: <20100422195725.GM2524@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4BD016F4.8060108@cn.fujitsu.com>
 <4BD017AC.1020209@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BD017AC.1020209@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 22, 2010 at 05:32:28PM +0800, Li Zefan wrote:
> with CONFIG_PROVE_RCU=y, a warning can be triggered:
> 
>   # mount -t cgroup -o blkio xxx /mnt
>   # mkdir /mnt/subgroup
> 
> ...
> kernel/cgroup.c:4442 invoked rcu_dereference_check() without protection!
> ...
> 
> To fix this, we avoid caling css_depth() here, which is a bit simpler
> than the original code.

Queued for 2.6.34, thank you!

							Thanx, Paul

> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  block/blk-cgroup.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index 5fe03de..2cc682b 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -286,16 +286,16 @@ done:
>  static struct cgroup_subsys_state *
>  blkiocg_create(struct cgroup_subsys *subsys, struct cgroup *cgroup)
>  {
> -	struct blkio_cgroup *blkcg, *parent_blkcg;
> +	struct blkio_cgroup *blkcg;
> +	struct cgroup *parent = cgroup->parent;
> 
> -	if (!cgroup->parent) {
> +	if (!parent) {
>  		blkcg = &blkio_root_cgroup;
>  		goto done;
>  	}
> 
>  	/* Currently we do not support hierarchy deeper than two level (0,1) */
> -	parent_blkcg = cgroup_to_blkio_cgroup(cgroup->parent);
> -	if (css_depth(&parent_blkcg->css) > 0)
> +	if (parent != cgroup->top_cgroup)
>  		return ERR_PTR(-EINVAL);
> 
>  	blkcg = kzalloc(sizeof(*blkcg), GFP_KERNEL);
> -- 
> 1.6.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
