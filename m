Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604Ab0KCPDv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 11:03:51 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:57994 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755456Ab0KCPD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 11:03:27 -0400
Message-ID: <4CD179B7.1050405@linux.vnet.ibm.com>
Date: Wed, 03 Nov 2010 20:33:19 +0530
From: Ciju Rajan K <ciju@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Jens Axboe <jaxboe@fusionio.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Nauman Rafique <nauman@google.com>,
        "Daniel P. Berrange" <berrange@redhat.com>
Subject: Re: [RFC] blk-cgroup: Allow creation of hierarchical cgroups
References: <20101102222030.GI7198@redhat.com>
In-Reply-To: <20101102222030.GI7198@redhat.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> o Allow hierarchical cgroup creation for blkio controller
>
> o Currently we disallow it as both the io controller policies (throttling
>   as well as proportion bandwidth) do not support hierarhical accounting
>   and control. But the flip side is that blkio controller can not be used with
>   libvirt as libvirt creates a cgroup hierarchy deeper than 1 level.
>
>   <top-level-cgroup-dir>/<controller>/libvirt/qemu/<virtual-machine-groups>
>
> o So this patch will allow creation of cgroup hierarhcy but at the backend
>   everything will be treated as flat. So if somebody created a an hierarchy
>   like as follows.
>
> 			root	
> 			/  \
> 		     test1 test2
> 			|
> 		     test3
>
>   CFQ and throttling will practically treat all groups at same level.
> 			
> 				pivot
> 			     /  |   \  \
> 			root  test1 test2  test3
>
> o Once we have actual support for hierarchical accounting and control
>   then we can introduce another cgroup tunable file "blkio.use_hierarchy"
>   which will be 0 by default but if user wants to enforce hierarhical
>   control then it can be set to 1. This way there should not be any
>   ABI problems down the line.
>
> o The only not so pretty part is introduction of extra file "use_hierarchy"
>   down the line. Kame-san had mentioned that hierarhical accounting is
>   expensive in memory controller hence they keep it off by default. I
>   suspect same will be the case for IO controller also as for each IO
>   completion we shall have to account IO through hierarchy up to the root.
>   if yes, then it probably is not a very bad idea to introduce this extra
>   file so that it will be used only when somebody needs it and some people
>   might enable hierarchy only in part of the hierarchy. 
>
> o This is how basically memory controller also uses "use_hierarhcy" and
>   they also allowed creation of hierarchies when actual backend support
>   was not available.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  Documentation/cgroups/blkio-controller.txt |   27 +++++++++++++++++++++++++++
>  block/blk-cgroup.c                         |    4 ----
>  2 files changed, 27 insertions(+), 4 deletions(-)
>
> Index: linux-2.6/block/blk-cgroup.c
> ===================================================================
> --- linux-2.6.orig/block/blk-cgroup.c	2010-10-28 14:19:02.000000000 -0400
> +++ linux-2.6/block/blk-cgroup.c	2010-11-02 13:10:13.000000000 -0400
> @@ -1452,10 +1452,6 @@ blkiocg_create(struct cgroup_subsys *sub
>  		goto done;
>  	}
>
> -	/* Currently we do not support hierarchy deeper than two level (0,1) */
> -	if (parent != cgroup->top_cgroup)
> -		return ERR_PTR(-EPERM);
> -
>  	blkcg = kzalloc(sizeof(*blkcg), GFP_KERNEL);
>  	if (!blkcg)
>  		return ERR_PTR(-ENOMEM);
> Index: linux-2.6/Documentation/cgroups/blkio-controller.txt
> ===================================================================
> --- linux-2.6.orig/Documentation/cgroups/blkio-controller.txt	2010-10-28 14:19:01.000000000 -0400
> +++ linux-2.6/Documentation/cgroups/blkio-controller.txt	2010-11-02 17:51:52.000000000 -0400
> @@ -89,6 +89,33 @@ Throttling/Upper Limit policy
>
>   Limits for writes can be put using blkio.write_bps_device file.
>
> +Hierarchical Cgroups
> +====================
> +- Currently none of the IO control policy supports hierarhical groups. But
> +  cgroup interface does allow creation of hierarhical cgroups and internally
> +  IO policies treat them as flat hierarchy.
> +
> +  So this patch will allow creation of cgroup hierarhcy but at the backend
> +  everything will be treated as flat. So if somebody created a hierarchy like
> +  as follows.
> +
> +			root
> +			/  \
> +		     test1 test2
> +			|
> +		     test3
> +
> +  CFQ and throttling will practically treat all groups at same level.
> +
> +				pivot
> +			     /  |   \  \
> +			root  test1 test2  test3
> +
> +  Down the line we can implement hierarchical accounting/control support
> +  and also introduce a new cgroup file "use_hierarchy" which will control
> +  whether cgroup hierarchy is viewed as flat or hierarchical by the policy.
> +  This is how memory controller also has implemented the things.
> +
>  Various user visible config options
>  ===================================
>  CONFIG_BLK_CGROUP
>   
Reviewed-by: Ciju Rajan K <ciju@linux.vnet.ibm.com>
Tested-by: Ciju Rajan K <ciju@linux.vnet.ibm.com>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>   

