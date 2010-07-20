Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222Ab0GTHAX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 03:00:23 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:35279 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248Ab0GTHAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 03:00:21 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 20 Jul 2010 15:55:02 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linuxppc-dev@ozlabs.org,
        greg@kroah.com
Subject: Re: [PATCH 1/8] v3 Move the find_memory_block() routine up
Message-Id: <20100720155502.17242173.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4C451D4E.8040600@austin.ibm.com>
References: <4C451BF5.50304@austin.ibm.com>
	<4C451D4E.8040600@austin.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Jul 2010 22:51:42 -0500
Nathan Fontenot <nfont@austin.ibm.com> wrote:

> Move the find_me mory_block() routine up to avoid needing a forward
> declaration in subsequent patches.
> 
> Signed-off-by: Nathan Fontenot <nfont@austin.ibm.com>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

> ---
>  drivers/base/memory.c |   62 +++++++++++++++++++++++++-------------------------
>  1 file changed, 31 insertions(+), 31 deletions(-)
> 
> Index: linux-2.6/drivers/base/memory.c
> ===================================================================
> --- linux-2.6.orig/drivers/base/memory.c	2010-07-16 12:41:30.000000000 -0500
> +++ linux-2.6/drivers/base/memory.c	2010-07-19 20:42:11.000000000 -0500
> @@ -435,6 +435,37 @@ int __weak arch_get_memory_phys_device(u
>  	return 0;
>  }
>  
> +/*
> + * For now, we have a linear search to go find the appropriate
> + * memory_block corresponding to a particular phys_index. If
> + * this gets to be a real problem, we can always use a radix
> + * tree or something here.
> + *
> + * This could be made generic for all sysdev classes.
> + */
> +struct memory_block *find_memory_block(struct mem_section *section)
> +{
> +	struct kobject *kobj;
> +	struct sys_device *sysdev;
> +	struct memory_block *mem;
> +	char name[sizeof(MEMORY_CLASS_NAME) + 9 + 1];
> +
> +	/*
> +	 * This only works because we know that section == sysdev->id
> +	 * slightly redundant with sysdev_register()
> +	 */
> +	sprintf(&name[0], "%s%d", MEMORY_CLASS_NAME, __section_nr(section));
> +
> +	kobj = kset_find_obj(&memory_sysdev_class.kset, name);
> +	if (!kobj)
> +		return NULL;
> +
> +	sysdev = container_of(kobj, struct sys_device, kobj);
> +	mem = container_of(sysdev, struct memory_block, sysdev);
> +
> +	return mem;
> +}
> +
>  static int add_memory_block(int nid, struct mem_section *section,
>  			unsigned long state, enum mem_add_context context)
>  {
> @@ -468,37 +499,6 @@ static int add_memory_block(int nid, str
>  	return ret;
>  }
>  
> -/*
> - * For now, we have a linear search to go find the appropriate
> - * memory_block corresponding to a particular phys_index. If
> - * this gets to be a real problem, we can always use a radix
> - * tree or something here.
> - *
> - * This could be made generic for all sysdev classes.
> - */
> -struct memory_block *find_memory_block(struct mem_section *section)
> -{
> -	struct kobject *kobj;
> -	struct sys_device *sysdev;
> -	struct memory_block *mem;
> -	char name[sizeof(MEMORY_CLASS_NAME) + 9 + 1];
> -
> -	/*
> -	 * This only works because we know that section == sysdev->id
> -	 * slightly redundant with sysdev_register()
> -	 */
> -	sprintf(&name[0], "%s%d", MEMORY_CLASS_NAME, __section_nr(section));
> -
> -	kobj = kset_find_obj(&memory_sysdev_class.kset, name);
> -	if (!kobj)
> -		return NULL;
> -
> -	sysdev = container_of(kobj, struct sys_device, kobj);
> -	mem = container_of(sysdev, struct memory_block, sysdev);
> -
> -	return mem;
> -}
> -
>  int remove_memory_block(unsigned long node_id, struct mem_section *section,
>  		int phys_device)
>  {
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

