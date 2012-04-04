Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999Ab2DDVeJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 17:34:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43323 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935Ab2DDVeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 17:34:06 -0400
Date: Wed, 4 Apr 2012 14:34:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 5/6] memcg: fix broken boolen expression
Message-Id: <20120404143403.fd05a284.akpm@linux-foundation.org>
In-Reply-To: <1324695619-5537-5-git-send-email-kirill@shutemov.name>
References: <1324695619-5537-1-git-send-email-kirill@shutemov.name>
	<1324695619-5537-5-git-send-email-kirill@shutemov.name>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Dec 2011 05:00:18 +0200
"Kirill A. Shutemov" <kirill@shutemov.name> wrote:

> From: "Kirill A. Shutemov" <kirill@shutemov.name>
> 
> action != CPU_DEAD || action != CPU_DEAD_FROZEN is always true.
> 
> Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
> ---
>  mm/memcontrol.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index b27ce0f..3833a7b 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2100,7 +2100,7 @@ static int __cpuinit memcg_cpu_hotplug_callback(struct notifier_block *nb,
>  		return NOTIFY_OK;
>  	}
>  
> -	if ((action != CPU_DEAD) || action != CPU_DEAD_FROZEN)
> +	if (action != CPU_DEAD && action != CPU_DEAD_FROZEN)
>  		return NOTIFY_OK;
>  
>  	for_each_mem_cgroup(iter)

This spent too long in the backlog, sorry.

I don't want to merge this patch into either mainline or -stable until
I find out what it does!

afacit the patch will newly cause the kernel to drain various resource
counters away from the target CPU when the CPU_DEAD or CPU_DEAD_FROZEN
events occur for thet CPU, yes?

So the user-visible effects of the bug whcih was just fixed is that
these counters will be somewhat inaccurate after a CPU is taken down,
yes?

Why wasn't this bug noticed before?  Has anyone tested the patch and
confirmed that the numbers are now correct?

Given that this bug has been present for 1.5 years and nobody noticed,
I don't think a backport into -stable is warranted?

