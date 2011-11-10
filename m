Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932872Ab1KJSvh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 13:51:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38475 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754966Ab1KJSve (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 13:51:34 -0500
Date: Thu, 10 Nov 2011 19:46:54 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Glauber Costa <glommer@parallels.com>, Nathan Lynch <ntl@pobox.com>,
        Tejun Heo <tj@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Serge Hallyn <serue@us.ibm.com>, Daniel Lezcano <dlezcano@fr.ibm.com>
Subject: Re: [PATCH 3/3] pids: Make it possible to clone tasks with given
	pids
Message-ID: <20111110184654.GA1006@redhat.com>
References: <4EBC0696.9030103@parallels.com> <4EBC06DB.3090202@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EBC06DB.3090202@parallels.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10, Pavel Emelyanov wrote:
>
> The child_tidptr points to an array of pids for current namespace and
> its ancestors. When 0 is met in this array the pid number for the
> corresponding namespace is generated, rather than set.

I must have missed something, but I can't unserstand how this works.

> For security reasons after a regular clone/fork is done in a namespace
> further cloning with predefined pid is not allowed.

I guess, this is pid_ns->last_pid != 0 check in set_pidmap(), right ?

> +static int set_pidmap(struct pid_namespace *pid_ns, int pid)
> +{
> +	int offset;
> +	struct pidmap *map;
> +
> +	offset = pid & BITS_PER_PAGE_MASK;
> +	map = &pid_ns->pidmap[pid/BITS_PER_PAGE];
> +
> +	if (unlikely(!map->page))
> +		if (alloc_pidmap_page(map))
> +			return -ENOMEM;
> +
> +	if (pid_ns->last_pid != 0)
> +		return -EPERM;

OK, but it should be always true, no? IOW, set_pidmap() should always
fail?

Unless: you are using CLONE_NEWPID along with CLONE_CHILD_USEPIDS and
this child_tidptr array has only one pid (before zero pid).

So, could you please explain what I have missed?

Oleg.

