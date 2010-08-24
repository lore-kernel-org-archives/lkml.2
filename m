Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377Ab0HXJAD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 05:00:03 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50906 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752220Ab0HXJAB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 05:00:01 -0400
Message-ID: <4C738B34.6070602@cn.fujitsu.com>
Date: Tue, 24 Aug 2010 17:04:52 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: linux-mm@kvack.org,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        gthelen@google.com, m-ikeda@ds.jp.nec.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kamezawa.hiroyuki@gmail.com, "menage@google.com" <menage@google.com>
Subject: Re: [PATCH 1/5] cgroup: ID notification call back
References: <20100820185552.426ff12e.kamezawa.hiroyu@jp.fujitsu.com> <20100820185816.1dbcd53a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100820185816.1dbcd53a.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> CC'ed to Paul Menage and Li Zefan.
> ==
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> When cgroup subsystem use ID (ss->use_id==1), each css's ID is assigned
> after successful call of ->create(). css_ID is tightly coupled with
> css struct itself but it is allocated by ->create() call, IOW,
> per-subsystem special allocations.
> 
> To know css_id before creation, this patch adds id_attached() callback.
> after css_ID allocation. This will be used by memory cgroup's quick lookup
> routine.
> 
> Maybe you can think of other implementations as
> 	- pass ID to ->create()
> 	or
> 	- add post_create()
> 	etc...
> But when considering dirtiness of codes, this straightforward patch seems
> good to me. If someone wants post_create(), this patch can be replaced.
> 
> Changelog: 20100820
>  - new approarch.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Acked-by: Li Zefan <lizf@cn.fujitsu.com>

...
>  
> Index: mmotm-0811/include/linux/cgroup.h
> ===================================================================
> --- mmotm-0811.orig/include/linux/cgroup.h
> +++ mmotm-0811/include/linux/cgroup.h
> @@ -475,6 +475,7 @@ struct cgroup_subsys {
>  			struct cgroup *cgrp);
>  	void (*post_clone)(struct cgroup_subsys *ss, struct cgroup *cgrp);
>  	void (*bind)(struct cgroup_subsys *ss, struct cgroup *root);
> +	void (*id_attached)(struct cgroup_subsys *ss, struct cgroup *cgrp);

Maybe pass the id number to id_attached() is better.

And actually the @ss argument is not necessary, because the memcg's
id_attached() handler of course knows it's dealing with the memory
cgroup subsystem.

So I suspect we can just remove all the @ss from all the callbacks..

