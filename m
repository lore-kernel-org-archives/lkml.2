Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756995Ab1KJC7N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 21:59:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11541 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752546Ab1KJC7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 21:59:12 -0500
Date: Thu, 10 Nov 2011 03:59:06 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/5]thp: improve the error code path
Message-ID: <20111110025906.GS5075@redhat.com>
References: <1319511521.22361.135.camel@sli10-conroe>
 <20111025114406.GC10182@redhat.com>
 <1319593680.22361.145.camel@sli10-conroe>
 <1320643049.22361.204.camel@sli10-conroe>
 <20111110021853.GQ5075@redhat.com>
 <1320892395.22361.229.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320892395.22361.229.camel@sli10-conroe>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 10, 2011 at 10:33:15AM +0800, Shaohua Li wrote:
> On Thu, 2011-11-10 at 10:18 +0800, Andrea Arcangeli wrote:
> > Hi Shaohua,
> > 
> > On Mon, Nov 07, 2011 at 01:17:29PM +0800, Shaohua Li wrote:
> > > On Wed, 2011-10-26 at 09:48 +0800, Shaohua Li wrote:
> > > > On Tue, 2011-10-25 at 19:44 +0800, Andrea Arcangeli wrote:
> > > > > Hello,
> > > > > 
> > > > > On Tue, Oct 25, 2011 at 10:58:41AM +0800, Shaohua Li wrote:
> > > > > > +#ifdef CONFIG_SYSFS
> > > > > > +	sysfs_remove_group(hugepage_kobj, &khugepaged_attr_group);
> > > > > > +remove_hp_group:
> > > > > > +	sysfs_remove_group(hugepage_kobj, &hugepage_attr_group);
> > > > > > +delete_obj:
> > > > > > +	kobject_put(hugepage_kobj);
> > > > > >  out:
> > > > > > +#endif
> > > > > 
> > > > > Adding an ifdef is making the code worse, the whole point of having
> > > > > these functions become noops at build time is to avoid having to add
> > > > > ifdefs in the callers.
> > > > yes, but hugepage_attr_group is defined in CONFIG_SYSFS. And the
> > > > functions are inline functions. They really should be a '#define xxx'.
> > 
> > hugepage_attr_group is defined even if CONFIG_SYSFS is not set and I
> > just made a build with CONFIG_SYSFS=n and it builds just fine without
> > any change.
> 
> > $ grep CONFIG_SYSFS .config
> > # CONFIG_SYSFS is not set
> > 
> > So we can drop 1/5 above.
> this isn't the case in the code. And the code uses hugepage_attr_group
> is already within CONFIG_SYSFS, so your build success.

I thought it was related to a SYSFS=n build failure, so when I
verified it build just fine I didn't really see the point of messing
with sysfs adding more #ifdefs but I see you want to avoid leaking
those two entries if the allocation doesn't succeed.

If the later allocations don't succeed we can panic() and be done with
it. Adding more code will just grow the zImage a bit, but I can
appreciate the more theoretical correctness so I'm ok with it now that
I see the point of it.
