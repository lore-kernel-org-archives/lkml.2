Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935082Ab0GPANm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 20:13:42 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:42271 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933992Ab0GPANl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 20:13:41 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 16 Jul 2010 09:08:57 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 2/5] v2 Create new 'end_phys_index' file
Message-Id: <20100716090857.5e5c91a3.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4C3F55BC.4020600@austin.ibm.com>
References: <4C3F53D1.3090001@austin.ibm.com>
	<4C3F55BC.4020600@austin.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jul 2010 13:38:52 -0500
Nathan Fontenot <nfont@austin.ibm.com> wrote:

> Add a new 'end_phys_index' file to each memory sysfs directory to
> report the physical index of the last memory section
> covered by the sysfs directory.
> 
> Signed-off-by: Nathan Fontenot <nfont@austin.ibm.com>

Does memory_block have to be contiguous between [phys_index, end_phys_index] ?
Should we provide "# of sections" or "amount of memory under a block" ?

No objections to end_phys_index...buf plz fix diff style.

Thanks,
-Kame


> ---
>  drivers/base/memory.c  |   14 +++++++++++++-
>  include/linux/memory.h |    3 +++
>  2 files changed, 16 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/drivers/base/memory.c
> ===================================================================
> --- linux-2.6.orig/drivers/base/memory.c	2010-07-15 09:55:54.000000000 -0500
> +++ linux-2.6/drivers/base/memory.c	2010-07-15 09:56:05.000000000 -0500
> @@ -121,7 +121,15 @@
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
> @@ -321,6 +329,7 @@
>  }
>  
>  static SYSDEV_ATTR(phys_index, 0444, show_mem_phys_index, NULL);
> +static SYSDEV_ATTR(end_phys_index, 0444, show_mem_end_phys_index, NULL);
>  static SYSDEV_ATTR(state, 0644, show_mem_state, store_mem_state);
>  static SYSDEV_ATTR(phys_device, 0444, show_phys_device, NULL);
>  static SYSDEV_ATTR(removable, 0444, show_mem_removable, NULL);
> @@ -533,6 +542,8 @@
>  		if (!ret)
>  			ret = mem_create_simple_file(mem, phys_index);
>  		if (!ret)
> +			ret = mem_create_simple_file(mem, end_phys_index);
> +		if (!ret)
>  			ret = mem_create_simple_file(mem, state);
>  		if (!ret)
>  			ret = mem_create_simple_file(mem, phys_device);
> @@ -577,6 +588,7 @@
>  	if (list_empty(&mem->sections)) {
>  		unregister_mem_sect_under_nodes(mem);
>  		mem_remove_simple_file(mem, phys_index);
> +		mem_remove_simple_file(mem, end_phys_index);
>  		mem_remove_simple_file(mem, state);
>  		mem_remove_simple_file(mem, phys_device);
>  		mem_remove_simple_file(mem, removable);
> Index: linux-2.6/include/linux/memory.h
> ===================================================================
> --- linux-2.6.orig/include/linux/memory.h	2010-07-15 09:54:06.000000000 -0500
> +++ linux-2.6/include/linux/memory.h	2010-07-15 09:56:05.000000000 -0500
> @@ -29,6 +29,9 @@
>  
>  struct memory_block {
>  	unsigned long state;
> +	unsigned long start_phys_index;
> +	unsigned long end_phys_index;
> +
>  	/*
>  	 * This serializes all state change requests.  It isn't
>  	 * held during creation because the control files are
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

