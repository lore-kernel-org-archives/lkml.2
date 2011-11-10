Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934829Ab1KJOOR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 09:14:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48355 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934785Ab1KJOOQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 09:14:16 -0500
Date: Thu, 10 Nov 2011 15:14:12 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/5]thp: improve the error code path
Message-ID: <20111110141412.GW5075@redhat.com>
References: <1319511521.22361.135.camel@sli10-conroe>
 <20111025114406.GC10182@redhat.com>
 <1319593680.22361.145.camel@sli10-conroe>
 <1320643049.22361.204.camel@sli10-conroe>
 <20111110021853.GQ5075@redhat.com>
 <1320892395.22361.229.camel@sli10-conroe>
 <alpine.DEB.2.00.1111091828500.32414@chino.kir.corp.google.com>
 <20111110030646.GT5075@redhat.com>
 <alpine.DEB.2.00.1111092039110.27280@chino.kir.corp.google.com>
 <1320904609.22361.239.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320904609.22361.239.camel@sli10-conroe>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 10, 2011 at 01:56:49PM +0800, Shaohua Li wrote:
> +static struct kobject *hugepage_kobj;

It's minor nitpick but we don't need to put this in .bss, passing it
as hugepage_init_sysfs(struct kobject **hugepage_kobj) and storing it
there in case the error returned by hugepage_init_sysfs is zero should
be fine. The feature cannot be unloaded so we can lose the pointer
after init is complete.

Then I think we can be done with this... and it looks better now.

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

  	struct kobject *hugepage_kobj;

> +
> +	if (!has_transparent_hugepage()) {
> +		transparent_hugepage_flags = 0;
> +		return -EINVAL;
> +	}
> +
> +	err = hugepage_init_sysfs();

	err = hugepage_init_sysfs(&hugepage_kobj);


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

	hugepage_exit_sysfs(hugepage_kobj);

>  	return err;
>  }
>  module_init(hugepage_init)
> 
> 
