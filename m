Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908Ab1BHX1R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 18:27:17 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:28199 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091Ab1BHX1Q (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 8 Feb 2011 18:27:16 -0500
Date: Tue, 8 Feb 2011 18:25:38 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Daniel Kiper <dkiper@net-space.pl>
Cc: ian.campbell@citrix.com, akpm@linux-foundation.org, andi.kleen@intel.com,
        haicheng.li@linux.intel.com, fengguang.wu@intel.com, jeremy@goop.org,
        dan.magenheimer@oracle.com, v.tolstov@selfip.ru, pasik@iki.fi,
        dave@linux.vnet.ibm.com, wdauchy@gmail.com, rientjes@google.com,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH R3 1/7] mm: Add add_registered_memory() to memory
 hotplug API
Message-ID: <20110208232538.GB9857@dumpdata.com>
References: <20110203162514.GD1364@router-fw-old.local.net-space.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110203162514.GD1364@router-fw-old.local.net-space.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4D51D132.004A:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 03, 2011 at 05:25:14PM +0100, Daniel Kiper wrote:
> add_registered_memory() adds memory ealier registered
> as memory resource. It is required by memory hotplug
> for Xen guests, however it could be used also by other
> modules.
> 
> Signed-off-by: Daniel Kiper <dkiper@net-space.pl>
> ---
>  include/linux/memory_hotplug.h |    1 +
>  mm/memory_hotplug.c            |   50 ++++++++++++++++++++++++++++++---------
>  2 files changed, 39 insertions(+), 12 deletions(-)
> 
> diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
> index 8122018..fe63912 100644
> --- a/include/linux/memory_hotplug.h
> +++ b/include/linux/memory_hotplug.h
> @@ -223,6 +223,7 @@ static inline int is_mem_section_removable(unsigned long pfn,
>  #endif /* CONFIG_MEMORY_HOTREMOVE */
>  
>  extern int mem_online_node(int nid);
> +extern int add_registered_memory(int nid, u64 start, u64 size);
>  extern int add_memory(int nid, u64 start, u64 size);
>  extern int arch_add_memory(int nid, u64 start, u64 size);
>  extern int remove_memory(u64 start, u64 size);
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 321fc74..7947bdf 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -532,20 +532,12 @@ out:
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
> -	lock_memory_hotplug();
> -
> -	res = register_memory_resource(start, size);
> -	ret = -EEXIST;
> -	if (!res)
> -		goto out;
> -
>  	if (!node_online(nid)) {
>  		pgdat = hotadd_new_pgdat(nid, start);
>  		ret = -ENOMEM;
> @@ -579,14 +571,48 @@ int __ref add_memory(int nid, u64 start, u64 size)
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
> +	lock_memory_hotplug();
> +	ret = __add_memory(nid, start, size);
> +	unlock_memory_hotplug();

Isn't this a duplicate call to the mutex?
The __add_memory does an unlock_memory_hotplug when it finishes
and then you do another unlock_memory_hotplug here too.


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
> +	lock_memory_hotplug();
> +
> +	res = register_memory_resource(start, size);
> +
> +	if (!res)
> +		goto out;
> +
> +	ret = __add_memory(nid, start, size);

Ditto here. When __add_memory finishes the unlock_memory_hotplug
has been called, but you end up doing it in the out: label
too?

> +
> +	if (!ret)
> +		goto out;
> +
> +	release_memory_resource(res);
>  
>  out:
>  	unlock_memory_hotplug();
> +
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(add_memory);
> -- 
> 1.5.6.5
