Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758125Ab0LMPLE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 10:11:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4781 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757747Ab0LMPLA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 10:11:00 -0500
Date: Mon, 13 Dec 2010 10:10:45 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Jens Axboe <axboe@kernel.dk>, Corrado Zoccolo <czoccolo@gmail.com>,
        Chad Talbott <ctalbott@google.com>, Nauman Rafique <nauman@google.com>,
        Divyesh Shah <dpshah@google.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 8/8] blkio-cgroup: Document for blkio.use_hierarchy.
Message-ID: <20101213151045.GB20454@redhat.com>
References: <4CDF7BC5.9080803@cn.fujitsu.com>
 <4CDF9CC6.2040106@cn.fujitsu.com>
 <20101115165319.GI30792@redhat.com>
 <4CE2718C.6010406@kernel.dk>
 <4D01C6AB.9040807@cn.fujitsu.com>
 <4D057AB2.7010405@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D057AB2.7010405@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 13, 2010 at 09:45:22AM +0800, Gui Jianfeng wrote:
> Document for blkio.use_hierarchy.
> 
> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
> ---
>  Documentation/cgroups/blkio-controller.txt |   58 +++++++++++++++++++---------
>  1 files changed, 39 insertions(+), 19 deletions(-)
> 
> diff --git a/Documentation/cgroups/blkio-controller.txt b/Documentation/cgroups/blkio-controller.txt
> index 4ed7b5c..9c6dc9e 100644
> --- a/Documentation/cgroups/blkio-controller.txt
> +++ b/Documentation/cgroups/blkio-controller.txt
> @@ -91,30 +91,44 @@ Throttling/Upper Limit policy
>  
>  Hierarchical Cgroups
>  ====================
> -- Currently none of the IO control policy supports hierarhical groups. But
> -  cgroup interface does allow creation of hierarhical cgroups and internally
> -  IO policies treat them as flat hierarchy.
> +- Cgroup interface allows creation of hierarchical cgroups. Currently,
> +  internally IO policies are able to treat them as flat hierarchy or
> +  hierarchical hierarchy. Both hierarchical bandwidth division and flat
> +  bandwidth division are supported. "blkio.use_hierarchy" can be used to
> +  switch between flat mode and hierarchical mode.
>  
> -  So this patch will allow creation of cgroup hierarhcy but at the backend
> -  everything will be treated as flat. So if somebody created a hierarchy like
> -  as follows.
> +  Consider the following CGroup hierarchy:
>  
> -			root
> -			/  \
> -		     test1 test2
> -			|
> -		     test3
> +			  Root
> +			/  |   \
> +		     Grp1  Grp2 tsk1
> +	            /  \
> +		 Grp3 tsk2
>  
> -  CFQ and throttling will practically treat all groups at same level.
> +  If flat mode is enabled, CFQ and throttling will practically treat all
> +  groups at the same level.
>  
> -				pivot
> -			     /  |   \  \
> -			root  test1 test2  test3
> +			     Pivot tree
> +			    /  |   |   \
> +			Root Grp1 Grp2 Grp3
> +			 /     |
> +			tsk1   tsk2
>  
> -  Down the line we can implement hierarchical accounting/control support
> -  and also introduce a new cgroup file "use_hierarchy" which will control
> -  whether cgroup hierarchy is viewed as flat or hierarchical by the policy..
> -  This is how memory controller also has implemented the things.
> +  If hierarchical mode is enabled, CFQ will treat groups and tasks as the same
> +  view in CGroup hierarchy.
> +
> +			  Root
> +		        /  |   \
> +		    Grp1  Grp2 tsk1
> +		    /  \
> +		  Grp3 tsk2
> +
> +  Grp1, Grp2 and tsk1 are treated at the same level under Root group. Grp3 and
> +  tsk2 are treated at the same level under Grp1. Below is the mapping between
> +  task io priority and io weight:
> +
> +	    prio       0    1     2    3    4    5    6     7
> +	    weight  1000  868   740  612  484  356  228   100

I am curious to know that why did you choose above mappings. Current prio
to slice mapping seems to be.

	prio	0	1	2	3	4	5	6	7
	slice	180	160	140	120	100	80	60	40

Now with above weights difference between prio 0 and prio 7 will be 10
times as compared to old scheme of 4.5 times. Well then there is
slice offset logic which tries to introduce more service differentation.
anyway, I am not particular about it. Just curious. If it works well, then
it is fine.

>  
>  Various user visible config options
>  ===================================
> @@ -169,6 +183,12 @@ Proportional weight policy files
>  	  dev     weight
>  	  8:16    300
>  
> +- blkio.use_hierarchy
> +	- Switch between hierarchical mode and flat mode as stated above.
> +	  blkio.use_hierarchy == 1 means hierarchical mode is enabled.
> +	  blkio.use_hierarchy == 0 means flat mode is enabled.
> +	  The default mode is flat mode.
> +

Can you please explicitly mentiond that blkio.use_hierarchy only effects
CFQ and has impact on "throttling" logic as of today. Throttling will 
still continue to treat everything as flat. 

I am working on making throttling logic hierarchical. It has been going
on kind of slow and expecting it to get ready for 2.6.39.

Vivek
