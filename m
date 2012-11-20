Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564Ab2KTVtf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 16:49:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39289 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462Ab2KTVte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 16:49:34 -0500
Date: Tue, 20 Nov 2012 13:49:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch] mm, memcg: avoid unnecessary function call when memcg
 is disabled
Message-Id: <20121120134932.055bc192.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.1211191741060.24618@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1211191741060.24618@chino.kir.corp.google.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Nov 2012 17:44:34 -0800 (PST)
David Rientjes <rientjes@google.com> wrote:

> While profiling numa/core v16 with cgroup_disable=memory on the command 
> line, I noticed mem_cgroup_count_vm_event() still showed up as high as 
> 0.60% in perftop.
> 
> This occurs because the function is called extremely often even when memcg 
> is disabled.
> 
> To fix this, inline the check for mem_cgroup_disabled() so we avoid the 
> unnecessary function call if memcg is disabled.
> 
> ...
>
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -181,7 +181,14 @@ unsigned long mem_cgroup_soft_limit_reclaim(struct zone *zone, int order,
>  						gfp_t gfp_mask,
>  						unsigned long *total_scanned);
>  
> -void mem_cgroup_count_vm_event(struct mm_struct *mm, enum vm_event_item idx);
> +void __mem_cgroup_count_vm_event(struct mm_struct *mm, enum vm_event_item idx);
> +static inline void mem_cgroup_count_vm_event(struct mm_struct *mm,
> +					     enum vm_event_item idx)
> +{
> +	if (mem_cgroup_disabled() || !mm)
> +		return;
> +	__mem_cgroup_count_vm_event(mm, idx);
> +}

Does the !mm case occur frequently enough to justify inlining it, or
should that test remain out-of-line?

