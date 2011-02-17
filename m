Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874Ab1BQXwP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 18:52:15 -0500
Received: from smtp-out.google.com ([216.239.44.51]:49708 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895Ab1BQXwL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 18:52:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=RelyTR0K/2rA7mzu9mEOkDVkgK2L31Ix5s9BX9tA+MMP/Mp+b+w0KyZIzvlQIXIzkJ
         kmnPotcPk8VXBBtSWnYA==
MIME-Version: 1.0
In-Reply-To: <4D5C7F00.2050802@cn.fujitsu.com>
References: <4D5C7EA7.1030409@cn.fujitsu.com> <4D5C7F00.2050802@cn.fujitsu.com>
From: Paul Menage <menage@google.com>
Date: Thu, 17 Feb 2011 15:51:47 -0800
Message-ID: <AANLkTiki=aXr3KMXwrnnTrLC2Wt1F0eG8sVdXWiZrVFa@mail.gmail.com>
Subject: Re: [PATCH 4/4] cpuset: Hold callback_mutex in cpuset_clone()
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        =?UTF-8?B?57yqIOWLsA==?= <miaox@cn.fujitsu.com>, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 5:50 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> Chaning cpuset->mems/cpuset->cpus should be protected under
> callback_mutex.
>
> cpuset_clone() doesn't follow this rule. It's ok because it's
> called when creating and initializing a cgroup, but we'd better
> hold the lock to avoid subtil break in the future.
>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Acked-by: Paul Menage <menage@google.com>

Patch title should be s/cpuset_clone/cpuset_post_clone/

> ---
>  kernel/cpuset.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
> index 1e18d26..445573b 100644
> --- a/kernel/cpuset.c
> +++ b/kernel/cpuset.c
> @@ -1840,8 +1840,10 @@ static void cpuset_post_clone(struct cgroup_subsys *ss,
>        cs = cgroup_cs(cgroup);
>        parent_cs = cgroup_cs(parent);
>
> +       mutex_lock(&callback_mutex);
>        cs->mems_allowed = parent_cs->mems_allowed;
>        cpumask_copy(cs->cpus_allowed, parent_cs->cpus_allowed);
> +       mutex_unlock(&callback_mutex);
>        return;
>  }
>
> --
> 1.7.3.1
>
