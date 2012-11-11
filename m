Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab2KKCfL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2012 21:35:11 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:35625 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292Ab2KKCfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2012 21:35:08 -0500
Date: Sat, 10 Nov 2012 18:35:05 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "K. Y. Srinivasan" <kys@microsoft.com>
cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        andi@firstfloor.org, akpm@linux-foundation.org, linux-mm@kvack.org,
        kamezawa.hiroyuki@gmail.com, mhocko@suse.cz, hannes@cmpxchg.org,
        yinghan@google.com
Subject: Re: [PATCH 1/1] mm: Export a function to read vm_committed_as
In-Reply-To: <1352600728-17766-1-git-send-email-kys@microsoft.com>
Message-ID: <alpine.DEB.2.00.1211101830250.18494@chino.kir.corp.google.com>
References: <1352600728-17766-1-git-send-email-kys@microsoft.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Nov 2012, K. Y. Srinivasan wrote:

> diff --git a/mm/mmap.c b/mm/mmap.c
> index 2d94235..e527239 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -89,6 +89,17 @@ int sysctl_max_map_count __read_mostly = DEFAULT_MAX_MAP_COUNT;
>  struct percpu_counter vm_committed_as ____cacheline_aligned_in_smp;
>  
>  /*
> + * A wrapper to read vm_committed_as that can be used by external modules.
> + */
> +
> +unsigned long read_vm_committed_as(void)
> +{
> +	return percpu_counter_read_positive(&vm_committed_as);
> +}
> +
> +EXPORT_SYMBOL_GPL(read_vm_committed_as);
> +
> +/*
>   * Check that a process has enough memory to allocate a new virtual
>   * mapping. 0 means there is enough memory for the allocation to
>   * succeed and -ENOMEM implies there is not.

This is precisely what I didn't want to see; I was expecting that this 
function was going to have some name that would describe what a hypervisor 
would use it for, regardless of its implementation and current use of 
vm_committed_as.  read_vm_committed_as() misses the entire point of the 
suggestion and a few people have mentioned that they think this 
implementation will evolve over time.

Please think of what you're trying to determine in the code that will 
depend on this and then convert the existing user in 
drivers/xen/xen-selfballoon.c.
