Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792Ab0HEEyk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 00:54:40 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:60493 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756069Ab0HEEyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 00:54:38 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 5 Aug 2010 13:49:43 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linuxppc-dev@ozlabs.org,
        Greg KH <greg@kroah.com>, Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/9] v4  Add new phys_index properties
Message-Id: <20100805134943.9841a2e0.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4C581B9B.8050106@austin.ibm.com>
References: <4C581A6D.9030908@austin.ibm.com>
	<4C581B9B.8050106@austin.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Aug 2010 08:37:31 -0500
Nathan Fontenot <nfont@austin.ibm.com> wrote:

> Update the 'phys_index' properties of a memory block to include a
> 'start_phys_index' which is the same as the current 'phys_index' property.
> The property still appears as 'phys_index' in sysfs but the memory_block
> struct name is updated to indicate the start and end values.
> This also adds an 'end_phys_index' property to indicate the id of the
> last section in th memory block.
> 
> Signed-off-by: Nathan Fontenot <nfont@austin.ibm.com>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

nitpick. After this patch, end_phys_index is added but contains 0.
It's better to contain the same value with phys_index..

But, ok. Following patch will fix it.

Thanks,
-Kame

> ---
>  drivers/base/memory.c  |   28 ++++++++++++++++++++--------
>  include/linux/memory.h |    3 ++-
>  2 files changed, 22 insertions(+), 9 deletions(-)
> 
> Index: linux-2.6/drivers/base/memory.c
> ===================================================================
> --- linux-2.6.orig/drivers/base/memory.c	2010-08-02 13:32:21.000000000 -0500
> +++ linux-2.6/drivers/base/memory.c	2010-08-02 13:33:27.000000000 -0500
> @@ -109,12 +109,20 @@ unregister_memory(struct memory_block *m
>   * uses.
>   */
>  
> -static ssize_t show_mem_phys_index(struct sys_device *dev,
> +static ssize_t show_mem_start_phys_index(struct sys_device *dev,
>  			struct sysdev_attribute *attr, char *buf)
>  {
>  	struct memory_block *mem =
>  		container_of(dev, struct memory_block, sysdev);
> -	return sprintf(buf, "%08lx\n", mem->phys_index);
> +	return sprintf(buf, "%08lx\n", mem->start_phys_index);
> +}
> +
> +static ssize_t show_mem_end_phys_index(struct sys_device *dev,
> +			struct sysdev_attribute *attr, char *buf)
> +{
> +	struct memory_block *mem =
> +		container_of(dev, struct memory_block, sysdev);
> +	return sprintf(buf, "%08lx\n", mem->end_phys_index);
>  }
>  
>  /*
> @@ -128,7 +136,7 @@ static ssize_t show_mem_removable(struct
>  	struct memory_block *mem =
>  		container_of(dev, struct memory_block, sysdev);
>  
> -	start_pfn = section_nr_to_pfn(mem->phys_index);
> +	start_pfn = section_nr_to_pfn(mem->start_phys_index);
>  	ret = is_mem_section_removable(start_pfn, PAGES_PER_SECTION);
>  	return sprintf(buf, "%d\n", ret);
>  }
> @@ -191,7 +199,7 @@ memory_block_action(struct memory_block
>  	int ret;
>  	int old_state = mem->state;
>  
> -	psection = mem->phys_index;
> +	psection = mem->start_phys_index;
>  	first_page = pfn_to_page(psection << PFN_SECTION_SHIFT);
>  
>  	/*
> @@ -264,7 +272,7 @@ store_mem_state(struct sys_device *dev,
>  	int ret = -EINVAL;
>  
>  	mem = container_of(dev, struct memory_block, sysdev);
> -	phys_section_nr = mem->phys_index;
> +	phys_section_nr = mem->start_phys_index;
>  
>  	if (!present_section_nr(phys_section_nr))
>  		goto out;
> @@ -296,7 +304,8 @@ static ssize_t show_phys_device(struct s
>  	return sprintf(buf, "%d\n", mem->phys_device);
>  }
>  
> -static SYSDEV_ATTR(phys_index, 0444, show_mem_phys_index, NULL);
> +static SYSDEV_ATTR(phys_index, 0444, show_mem_start_phys_index, NULL);
> +static SYSDEV_ATTR(end_phys_index, 0444, show_mem_end_phys_index, NULL);
>  static SYSDEV_ATTR(state, 0644, show_mem_state, store_mem_state);
>  static SYSDEV_ATTR(phys_device, 0444, show_phys_device, NULL);
>  static SYSDEV_ATTR(removable, 0444, show_mem_removable, NULL);
> @@ -476,16 +485,18 @@ static int add_memory_block(int nid, str
>  	if (!mem)
>  		return -ENOMEM;
>  
> -	mem->phys_index = __section_nr(section);
> +	mem->start_phys_index = __section_nr(section);
>  	mem->state = state;
>  	mutex_init(&mem->state_mutex);
> -	start_pfn = section_nr_to_pfn(mem->phys_index);
> +	start_pfn = section_nr_to_pfn(mem->start_phys_index);
>  	mem->phys_device = arch_get_memory_phys_device(start_pfn);
>  
>  	ret = register_memory(mem, section);
>  	if (!ret)
>  		ret = mem_create_simple_file(mem, phys_index);
>  	if (!ret)
> +		ret = mem_create_simple_file(mem, end_phys_index);
> +	if (!ret)
>  		ret = mem_create_simple_file(mem, state);
>  	if (!ret)
>  		ret = mem_create_simple_file(mem, phys_device);
> @@ -507,6 +518,7 @@ int remove_memory_block(unsigned long no
>  	mem = find_memory_block(section);
>  	unregister_mem_sect_under_nodes(mem);
>  	mem_remove_simple_file(mem, phys_index);
> +	mem_remove_simple_file(mem, end_phys_index);
>  	mem_remove_simple_file(mem, state);
>  	mem_remove_simple_file(mem, phys_device);
>  	mem_remove_simple_file(mem, removable);
> Index: linux-2.6/include/linux/memory.h
> ===================================================================
> --- linux-2.6.orig/include/linux/memory.h	2010-08-02 13:23:49.000000000 -0500
> +++ linux-2.6/include/linux/memory.h	2010-08-02 13:33:27.000000000 -0500
> @@ -21,7 +21,8 @@
>  #include <linux/mutex.h>
>  
>  struct memory_block {
> -	unsigned long phys_index;
> +	unsigned long start_phys_index;
> +	unsigned long end_phys_index;
>  	unsigned long state;
>  	/*
>  	 * This serializes all state change requests.  It isn't
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 

