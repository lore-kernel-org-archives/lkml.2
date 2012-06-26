Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727Ab2FZE56 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 00:57:58 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38678 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab2FZE54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 00:57:56 -0400
Date: Mon, 25 Jun 2012 21:57:54 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Glauber Costa <glommer@parallels.com>
cc: cgroups@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>,
        devel@openvz.org, kamezawa.hiroyu@jp.fujitsu.com,
        Tejun Heo <tj@kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Suleiman Souhlal <suleiman@google.com>,
        Frederic Weisbecker <fweisbec@redhat.com>
Subject: Re: [PATCH 11/11] protect architectures where THREAD_SIZE >= PAGE_SIZE
 against fork bombs
In-Reply-To: <1340633728-12785-12-git-send-email-glommer@parallels.com>
Message-ID: <alpine.DEB.2.00.1206252157000.30072@chino.kir.corp.google.com>
References: <1340633728-12785-1-git-send-email-glommer@parallels.com> <1340633728-12785-12-git-send-email-glommer@parallels.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jun 2012, Glauber Costa wrote:

> diff --git a/include/linux/thread_info.h b/include/linux/thread_info.h
> index ccc1899..914ec07 100644
> --- a/include/linux/thread_info.h
> +++ b/include/linux/thread_info.h
> @@ -61,6 +61,12 @@ extern long do_no_restart_syscall(struct restart_block *parm);
>  # define THREADINFO_GFP		(GFP_KERNEL | __GFP_NOTRACK)
>  #endif
>  
> +#ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM
> +# define THREADINFO_GFP_ACCOUNTED (THREADINFO_GFP | __GFP_KMEMCG)
> +#else
> +# define THREADINFO_GFP_ACCOUNTED (THREADINFO_GFP)
> +#endif
> +

This type of requirement is going to become nasty very quickly if nobody 
can use __GFP_KMEMCG without testing for CONFIG_CGROUP_MEM_RES_CTLR_KMEM.  
Perhaps define __GFP_KMEMCG to be 0x0 if it's not enabled, similar to how 
kmemcheck does?
