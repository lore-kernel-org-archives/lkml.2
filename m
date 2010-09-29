Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050Ab0I2U7Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 16:59:24 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:49219 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751154Ab0I2U7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 16:59:23 -0400
Subject: Re: [Patch 1/3] Introduce kset_find_obj_hinted.
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Robin Holt <holt@sgi.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        "Robert P. J. Day" <rpjday@crashcourse.ca>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Badari Pulavarty <pbadari@us.ibm.com>,
        Dave Hansen <haveblue@us.ibm.com>, Gary Hade <garyhade@us.ibm.com>,
        Ingo Molnar <mingo@elte.hu>,
        Matt Tolentino <matthew.e.tolentino@intel.com>
In-Reply-To: <20100929190115.494540024@gulag1.americas.sgi.com>
References: <20100929190053.992911934@gulag1.americas.sgi.com>
	 <20100929190115.494540024@gulag1.americas.sgi.com>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Wed, 29 Sep 2010 13:59:16 -0700
Message-ID: <1285793956.19976.10359.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-29 at 14:00 -0500, Robin Holt wrote:
> 
>  struct kobject *kset_find_obj(struct kset *kset, const char *name)
>  {
> +       return kset_find_obj_hinted(kset, name, NULL);
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
> +                                    struct kobject *hint)
> +{
>         struct kobject *k;
>         struct kobject *ret = NULL;
> 
>         spin_lock(&kset->list_lock);
> +
> +       if (!hint)
> +               goto slow_search;
> +
> +       /* end of list detection */
> +       if (hint->entry.next == kset->list.next)
> +               goto slow_search;
> +
> +       k = container_of(hint->entry.next, struct kobject, entry);
> +       if (!kobject_name(k) || strcmp(kobject_name(k), name))
> +               goto slow_search;
> +
> +       ret = kobject_get(k);
> +       goto unlock_exit;
> +
> +slow_search:
>         list_for_each_entry(k, &kset->list, entry) {
>                 if (kobject_name(k) && !strcmp(kobject_name(k), name)) {
>                         ret = kobject_get(k);
>                         break;
>                 }
>         }

So, the slow search ends up looking through _all_ of the sections in the
order they got registered, which _guarantees_ that we'll go all the way
through the list every time.  Right?

I guess we could also add to the list using list_add_tail(), iterate
during the search using list_for_each_tail(), or even just look at the
last entry by looking at kset->list.prev directly.  Those would have the
advantage of not having to have several levels in the call chain.  We
also wouldn't have to change anything if and when this gets fixed
properly.

-- Dave

