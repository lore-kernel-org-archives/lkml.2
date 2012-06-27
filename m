Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758252Ab2F0R6Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 13:58:24 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62802 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758180Ab2F0R6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 13:58:23 -0400
Date: Wed, 27 Jun 2012 10:58:18 -0700
From: Tejun Heo <tj@kernel.org>
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Han Ying <yinghan@google.com>, Glauber Costa <glommer@parallels.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3][0/6] memcg: prevent -ENOMEM in pre_destroy()
Message-ID: <20120627175818.GM15811@google.com>
References: <4FACDED0.3020400@jp.fujitsu.com>
 <20120621202043.GD4642@google.com>
 <4FE3ADDD.9060908@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FE3ADDD.9060908@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, KAME.

On Fri, Jun 22, 2012 at 08:27:25AM +0900, Kamezawa Hiroyuki wrote:
> Remaining 20% of work is based on a modification to cgroup layer
> 
> How do you think this patch ? (This patch is not tested yet...so
> may have troubles...) I think callers of pre_destory() is not so many...
> 
> ==
> From a28db946f91f3509d25779e8c5db249506cc4b07 Mon Sep 17 00:00:00 2001
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Date: Fri, 22 Jun 2012 08:38:38 +0900
> Subject: [PATCH] cgroup: keep cgroup_mutex() while calling ->pre_destroy()
> 
> In past, memcg's pre_destroy() was verrry slow because of the possibility
> of page reclaiming in it. So, cgroup_mutex() was released before calling
> pre_destroy() callbacks. Now, it's enough fast. memcg just scans the list
> and move pages to other cgroup, no memory reclaim happens.
> Then, we can keep cgroup_mutex() there.
> 
> By holding looks, we can avoid following cases
>    1. new task is attached while rmdir().
>    2. new child cgroup is created while rmdir()
>    3. new task is attached to cgroup and removed from cgroup before
>       checking css's count. So, ->destroy() will be called even if
>       some trashes by the task remains
> 
> (3. is terrible case...even if I think it will not happen in real world..)

Ooh, once memcg drops the __DEPRECATED_clear_css_refs, cgroup_rmdir()
will mark the cgroup dead before start calling pre_destroy() and none
of the above will happen.

Thanks.

-- 
tejun
