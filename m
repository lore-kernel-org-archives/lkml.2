Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696Ab0I3CFH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 22:05:07 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:41152 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707Ab0I3CFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 22:05:05 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 30 Sep 2010 10:59:44 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Robin Holt <holt@sgi.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        "Robert P. J. Day" <rpjday@crashcourse.ca>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Badari Pulavarty <pbadari@us.ibm.com>,
        Dave Hansen <haveblue@us.ibm.com>, Gary Hade <garyhade@us.ibm.com>,
        Ingo Molnar <mingo@elte.hu>,
        Matt Tolentino <matthew.e.tolentino@intel.com>
Subject: Re: [Patch 1/3] Introduce kset_find_obj_hinted.
Message-Id: <20100930105944.3a625b94.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100929190115.494540024@gulag1.americas.sgi.com>
References: <20100929190053.992911934@gulag1.americas.sgi.com>
	<20100929190115.494540024@gulag1.americas.sgi.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Sep 2010 14:00:54 -0500
Robin Holt <holt@sgi.com> wrote:

> One call chain getting to kset_find_obj is:
>   link_mem_sections()
>     find_mem_section()
>       kset_find_obj()
> 
> This is done during boot.  The memory sections were added in a linearly
> increasing order and link_mem_sections tends to utilize them in that
> same linear order.
> 
> Introduce a kset_find_obj_hinted which is passed the result of the
> previous kset_find_obj which it uses for a quick "is the next object
> our desired object" check before falling back to the old behavior.
> 
> Signed-off-by: Robin Holt <holt@sgi.com>
> To: Robert P. J. Day <rpjday@crashcourse.ca>
> To: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: lkml <linux-kernel@vger.kernel.org>
> 

Interesting. Thank you.

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


> ---
> 
>  include/linux/kobject.h |    2 +
>  lib/kobject.c           |   39 ++++++++++++++++++++++++++++++++++++++
>  2 files changed, 41 insertions(+)
> 
> Index: pv1010359/include/linux/kobject.h
> ===================================================================
> --- pv1010359.orig/include/linux/kobject.h	2010-09-29 11:03:42.000000000 -0500
> +++ pv1010359/include/linux/kobject.h	2010-09-29 11:20:09.903825173 -0500
> @@ -191,6 +191,8 @@ static inline struct kobj_type *get_ktyp
>  }
>  
>  extern struct kobject *kset_find_obj(struct kset *, const char *);
> +extern struct kobject *kset_find_obj_hinted(struct kset *, const char *,
> +						struct kobject *);
>  
>  /* The global /sys/kernel/ kobject for people to chain off of */
>  extern struct kobject *kernel_kobj;
> Index: pv1010359/lib/kobject.c
> ===================================================================
> --- pv1010359.orig/lib/kobject.c	2010-09-29 11:03:42.000000000 -0500
> +++ pv1010359/lib/kobject.c	2010-09-29 11:21:14.343956075 -0500
> @@ -746,17 +746,56 @@ void kset_unregister(struct kset *k)
>   */
>  struct kobject *kset_find_obj(struct kset *kset, const char *name)
>  {
> +	return kset_find_obj_hinted(kset, name, NULL);
> +}
> +
> +/**
> + * kset_find_obj_hinted - search for object in kset given a predecessor hint.
> + * @kset: kset we're looking in.
> + * @name: object's name.
> + * @hint: hint to possible object's predecessor.
> + *
> + * Check the hint's next object and if it is a match return it directly,
> + * otherwise, fall back to the behavior of kset_find_obj().  Either way
> + * a reference for the returned object is held and the reference on the
> + * hinted object is released.
> + */
> +struct kobject *kset_find_obj_hinted(struct kset *kset, const char *name,
> +				     struct kobject *hint)
> +{
>  	struct kobject *k;
>  	struct kobject *ret = NULL;
>  
>  	spin_lock(&kset->list_lock);
> +
> +	if (!hint)
> +		goto slow_search;
> +
> +	/* end of list detection */
> +	if (hint->entry.next == kset->list.next)
> +		goto slow_search;
> +
> +	k = container_of(hint->entry.next, struct kobject, entry);
> +	if (!kobject_name(k) || strcmp(kobject_name(k), name))
> +		goto slow_search;
> +
> +	ret = kobject_get(k);
> +	goto unlock_exit;
> +
> +slow_search:
>  	list_for_each_entry(k, &kset->list, entry) {
>  		if (kobject_name(k) && !strcmp(kobject_name(k), name)) {
>  			ret = kobject_get(k);
>  			break;
>  		}
>  	}
> +
> +unlock_exit:
>  	spin_unlock(&kset->list_lock);
> +
> +	if (hint)
> +		kobject_put(hint);
> +
>  	return ret;
>  }
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

