Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334Ab1KJGI3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 01:08:29 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:62775 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332Ab1KJGI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 01:08:28 -0500
Date: Wed, 9 Nov 2011 22:08:25 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Shaohua Li <shaohua.li@intel.com>
cc: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/5]thp: improve the error code path
In-Reply-To: <1320904609.22361.239.camel@sli10-conroe>
Message-ID: <alpine.DEB.2.00.1111092205400.2384@chino.kir.corp.google.com>
References: <1319511521.22361.135.camel@sli10-conroe> <20111025114406.GC10182@redhat.com> <1319593680.22361.145.camel@sli10-conroe> <1320643049.22361.204.camel@sli10-conroe> <20111110021853.GQ5075@redhat.com> <1320892395.22361.229.camel@sli10-conroe>
 <alpine.DEB.2.00.1111091828500.32414@chino.kir.corp.google.com> <20111110030646.GT5075@redhat.com> <alpine.DEB.2.00.1111092039110.27280@chino.kir.corp.google.com> <1320904609.22361.239.camel@sli10-conroe>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Nov 2011, Shaohua Li wrote:

> Index: linux/mm/huge_memory.c
> ===================================================================
> --- linux.orig/mm/huge_memory.c	2011-11-07 13:52:48.000000000 +0800
> +++ linux/mm/huge_memory.c	2011-11-10 13:52:08.000000000 +0800
> @@ -487,41 +487,68 @@ static struct attribute_group khugepaged
>  	.attrs = khugepaged_attr,
>  	.name = "khugepaged",
>  };
> -#endif /* CONFIG_SYSFS */
>  
> -static int __init hugepage_init(void)
> +static struct kobject *hugepage_kobj;
> +static int __init hugepage_init_sysfs(void)
>  {
>  	int err;
> -#ifdef CONFIG_SYSFS
> -	static struct kobject *hugepage_kobj;
> -#endif
>  
> -	err = -EINVAL;
> -	if (!has_transparent_hugepage()) {
> -		transparent_hugepage_flags = 0;
> -		goto out;
> -	}
> -
> -#ifdef CONFIG_SYSFS
> -	err = -ENOMEM;
>  	hugepage_kobj = kobject_create_and_add("transparent_hugepage", mm_kobj);
>  	if (unlikely(!hugepage_kobj)) {
>  		printk(KERN_ERR "hugepage: failed kobject create\n");
> -		goto out;
> +		return -ENOMEM;
>  	}
>  
>  	err = sysfs_create_group(hugepage_kobj, &hugepage_attr_group);
>  	if (err) {
>  		printk(KERN_ERR "hugepage: failed register hugeage group\n");
> -		goto out;
> +		goto delete_obj;
>  	}
>  
>  	err = sysfs_create_group(hugepage_kobj, &khugepaged_attr_group);
>  	if (err) {
>  		printk(KERN_ERR "hugepage: failed register hugeage group\n");
> -		goto out;
> +		goto remove_hp_group;
>  	}
> -#endif
> +
> +	return 0;
> +
> +remove_hp_group:
> +	sysfs_remove_group(hugepage_kobj, &hugepage_attr_group);
> +delete_obj:
> +	kobject_put(hugepage_kobj);
> +	return err;
> +}
> +
> +static void __init hugepage_exit_sysfs(void)
> +{
> +	sysfs_remove_group(hugepage_kobj, &khugepaged_attr_group);
> +	sysfs_remove_group(hugepage_kobj, &hugepage_attr_group);
> +	kobject_put(hugepage_kobj);
> +}

As mentioned previously, if khugepaged_slab_init() and 
mm_slots_hash_init() is done first before sysfs is initialized, then you 
shouldn't need hugepage_exit_sysfs() at all; all its error handling should 
be localized to hugepage_init().

> +#else
> +static inline int hugepage_init_sysfs(void)
> +{
> +	return 0;
> +}
> +
> +static inline void hugepage_exit_sysfs(void)
> +{
> +}
> +#endif /* CONFIG_SYSFS */
> +
> +static int __init hugepage_init(void)
> +{
> +	int err;
> +
> +	if (!has_transparent_hugepage()) {
> +		transparent_hugepage_flags = 0;
> +		return -EINVAL;
> +	}
> +
> +	err = hugepage_init_sysfs();
> +	if (err)
> +		return err;
>  
>  	err = khugepaged_slab_init();
>  	if (err)
> @@ -545,7 +572,9 @@ static int __init hugepage_init(void)
>  
>  	set_recommended_min_free_kbytes();
>  
> +	return 0;
>  out:
> +	hugepage_exit_sysfs();
>  	return err;
>  }
>  module_init(hugepage_init)
