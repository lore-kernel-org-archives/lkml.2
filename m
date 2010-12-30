Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab0L3Aum (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 19:50:42 -0500
Received: from smtp-out.google.com ([216.239.44.51]:30265 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182Ab0L3Auk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 19:50:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=lkLKjo7OPtXYdKpZKTS3I7ubw3p6sGDy56oVE+nujJ6etEvAx8ln+681XrHqkxAiNd
         /urncwSsIj9S9eMpzbhA==
Date: Wed, 29 Dec 2010 16:50:25 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Daniel Kiper <dkiper@net-space.pl>
cc: ian.campbell@citrix.com, Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi.kleen@intel.com>, haicheng.li@linux.intel.com,
        fengguang.wu@intel.com, jeremy@goop.org, konrad.wilk@oracle.com,
        dan.magenheimer@oracle.com, v.tolstov@selfip.ru,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH R2 1/7] mm: Add add_registered_memory() to memory hotplug
 API
In-Reply-To: <20101229170212.GF2743@router-fw-old.local.net-space.pl>
Message-ID: <alpine.DEB.2.00.1012291643290.6040@chino.kir.corp.google.com>
References: <20101229170212.GF2743@router-fw-old.local.net-space.pl>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Dec 2010, Daniel Kiper wrote:

> diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
> index 864035f..2458b2f 100644
> --- a/include/linux/memory_hotplug.h
> +++ b/include/linux/memory_hotplug.h
> @@ -203,6 +203,7 @@ static inline int is_mem_section_removable(unsigned long pfn,
>  #endif /* CONFIG_MEMORY_HOTREMOVE */
>  
>  extern int mem_online_node(int nid);
> +extern int add_registered_memory(int nid, u64 start, u64 size);
>  extern int add_memory(int nid, u64 start, u64 size);
>  extern int arch_add_memory(int nid, u64 start, u64 size);
>  extern int remove_memory(u64 start, u64 size);
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index dd186c1..b642f26 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -509,20 +509,12 @@ out:
>  }
>  
>  /* we are OK calling __meminit stuff here - we have CONFIG_MEMORY_HOTPLUG */
> -int __ref add_memory(int nid, u64 start, u64 size)
> +static int __ref __add_memory(int nid, u64 start, u64 size)
>  {
>  	pg_data_t *pgdat = NULL;
>  	int new_pgdat = 0;
> -	struct resource *res;
>  	int ret;
>  
> -	lock_system_sleep();
> -
> -	res = register_memory_resource(start, size);
> -	ret = -EEXIST;
> -	if (!res)
> -		goto out;
> -
>  	if (!node_online(nid)) {
>  		pgdat = hotadd_new_pgdat(nid, start);
>  		ret = -ENOMEM;

Looks like this patch was based on a kernel before 2.6.37-rc4 since it 
doesn't have 20d6c96b5f (mem-hotplug: introduce {un}lock_memory_hotplug()) 

> @@ -556,14 +548,48 @@ int __ref add_memory(int nid, u64 start, u64 size)
>  	goto out;
>  
>  error:
> -	/* rollback pgdat allocation and others */
> +	/* rollback pgdat allocation */
>  	if (new_pgdat)
>  		rollback_node_hotadd(nid, pgdat);
> -	if (res)
> -		release_memory_resource(res);
> +
> +out:
> +	return ret;
> +}
> +
> +int add_registered_memory(int nid, u64 start, u64 size)
> +{
> +	int ret;
> +
> +	lock_system_sleep();
> +	ret = __add_memory(nid, start, size);
> +	unlock_system_sleep();
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(add_registered_memory);
> +
> +int add_memory(int nid, u64 start, u64 size)
> +{
> +	int ret = -EEXIST;
> +	struct resource *res;
> +
> +	lock_system_sleep();
> +
> +	res = register_memory_resource(start, size);
> +
> +	if (!res)
> +		goto out;
> +
> +	ret = __add_memory(nid, start, size);
> +
> +	if (!ret)
> +		goto out;
> +
> +	release_memory_resource(res);
>  
>  out:
>  	unlock_system_sleep();
> +
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(add_memory);

Lots of unnecessary empty lines here, and scripts/checkpatch.pl says there 
are trailing whitespaces as well.
