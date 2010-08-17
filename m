Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751796Ab0HQHPG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 03:15:06 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64185 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750713Ab0HQHPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 03:15:03 -0400
Message-ID: <4C6A3812.1070002@cn.fujitsu.com>
Date: Tue, 17 Aug 2010 15:19:46 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Paul Menage <menage@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        Ben Blum <bblum@google.com>, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] cgroups: fix API thinko
References: <20100805225914.GA26772@redhat.com>
In-Reply-To: <20100805225914.GA26772@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Just came back from vacation)

Michael S. Tsirkin wrote:
> cgroup_attach_task_current_cg API that have upstream is backwards: we
> really need an API to attach to the cgroups from another process A to
> the current one.
> 
> In our case (vhost), a priveledged user wants to attach it's task to cgroups
> from a less priveledged one, the API makes us run it in the other
> task's context, and this fails.
> 
> So let's make the API generic and just pass in 'from' and 'to' tasks.
> Add an inline wrapper for cgroup_attach_task_current_cg to avoid
> breaking bisect.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Acked-by: Li Zefan <lizf@cn.fujitsu.com>

I also don't like the name, but I'm not good at English or naming. ;)

> ---
> 
> Paul, Li, Sridhar, could you please review the following
> patch?
> 
> I only compile-tested it due to travel, but looks
> straight-forward to me.
> Alex Williamson volunteered to test and report the results.
> Sending out now for review as I might be offline for a bit.
> Will only try to merge when done, obviously.
> 
> If OK, I would like to merge this through -net tree,
> together with the patch fixing vhost-net.
> Let me know if that sounds ok.
> 

That's Ok.

...
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index 43b2072..b38ec60 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -525,7 +525,11 @@ struct task_struct *cgroup_iter_next(struct cgroup *cgrp,
>  void cgroup_iter_end(struct cgroup *cgrp, struct cgroup_iter *it);
>  int cgroup_scan_tasks(struct cgroup_scanner *scan);
>  int cgroup_attach_task(struct cgroup *, struct task_struct *);
> -int cgroup_attach_task_current_cg(struct task_struct *);
> +int cgroup_attach_task_all(struct task_struct *from, struct task_struct *);

a nitpick:

better add a blank line here.

> +static inline int cgroup_attach_task_current_cg(struct task_struct *tsk)
> +{
> +	return cgroup_attach_task_all(current, tsk);
> +}
