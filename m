Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757364Ab1KJGS2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 01:18:28 -0500
Received: from mga02.intel.com ([134.134.136.20]:32185 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754168Ab1KJGS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 01:18:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="73165280"
Subject: Re: [patch 1/5]thp: improve the error code path
From: Shaohua Li <shaohua.li@intel.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1111092205400.2384@chino.kir.corp.google.com>
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
	 <alpine.DEB.2.00.1111092205400.2384@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Nov 2011 14:27:35 +0800
Message-ID: <1320906455.22361.243.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-10 at 14:08 +0800, David Rientjes wrote:
> On Thu, 10 Nov 2011, Shaohua Li wrote:
> 
> > Index: linux/mm/huge_memory.c
> > ===================================================================
> > --- linux.orig/mm/huge_memory.c	2011-11-07 13:52:48.000000000 +0800
> > +++ linux/mm/huge_memory.c	2011-11-10 13:52:08.000000000 +0800
> > @@ -487,41 +487,68 @@ static struct attribute_group khugepaged
> >  	.attrs = khugepaged_attr,
> >  	.name = "khugepaged",
> >  };
> > -#endif /* CONFIG_SYSFS */
> >  
> > -static int __init hugepage_init(void)
> > +static struct kobject *hugepage_kobj;
> > +static int __init hugepage_init_sysfs(void)
> >  {
> >  	int err;
> > -#ifdef CONFIG_SYSFS
> > -	static struct kobject *hugepage_kobj;
> > -#endif
> >  
> > -	err = -EINVAL;
> > -	if (!has_transparent_hugepage()) {
> > -		transparent_hugepage_flags = 0;
> > -		goto out;
> > -	}
> > -
> > -#ifdef CONFIG_SYSFS
> > -	err = -ENOMEM;
> >  	hugepage_kobj = kobject_create_and_add("transparent_hugepage", mm_kobj);
> >  	if (unlikely(!hugepage_kobj)) {
> >  		printk(KERN_ERR "hugepage: failed kobject create\n");
> > -		goto out;
> > +		return -ENOMEM;
> >  	}
> >  
> >  	err = sysfs_create_group(hugepage_kobj, &hugepage_attr_group);
> >  	if (err) {
> >  		printk(KERN_ERR "hugepage: failed register hugeage group\n");
> > -		goto out;
> > +		goto delete_obj;
> >  	}
> >  
> >  	err = sysfs_create_group(hugepage_kobj, &khugepaged_attr_group);
> >  	if (err) {
> >  		printk(KERN_ERR "hugepage: failed register hugeage group\n");
> > -		goto out;
> > +		goto remove_hp_group;
> >  	}
> > -#endif
> > +
> > +	return 0;
> > +
> > +remove_hp_group:
> > +	sysfs_remove_group(hugepage_kobj, &hugepage_attr_group);
> > +delete_obj:
> > +	kobject_put(hugepage_kobj);
> > +	return err;
> > +}
> > +
> > +static void __init hugepage_exit_sysfs(void)
> > +{
> > +	sysfs_remove_group(hugepage_kobj, &khugepaged_attr_group);
> > +	sysfs_remove_group(hugepage_kobj, &hugepage_attr_group);
> > +	kobject_put(hugepage_kobj);
> > +}
> 
> As mentioned previously, if khugepaged_slab_init() and 
> mm_slots_hash_init() is done first before sysfs is initialized, then you 
> shouldn't need hugepage_exit_sysfs() at all; all its error handling should 
> be localized to hugepage_init().
then we just move some error handling code to hugepage_init(). It
doesn't mean this one is better or that one is better, but I really see
no point to refresh the patch again.

Thanks,
Shaohua

