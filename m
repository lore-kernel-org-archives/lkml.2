Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430Ab2GJBgW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 21:36:22 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:36115 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755366Ab2GJBf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 21:35:58 -0400
Message-ID: <1341884144.2562.18.camel@ThinkPad-T420>
Subject: Re: [PATCH SLAB 1/2 v3] duplicate the cache name in SLUB's
 saved_alias list, SLAB, and SLOB
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linux-mm <linux-mm@kvack.org>,
        PowerPC email list <linuxppc-dev@lists.ozlabs.org>,
        Wanlong Gao <gaowanlong@cn.fujitsu.com>,
        Glauber Costa <glommer@parallels.com>
Date: Tue, 10 Jul 2012 09:35:44 +0800
In-Reply-To: <alpine.DEB.2.00.1207090859420.27737@router.home>
References: <1341561286.24895.9.camel@ThinkPad-T420>
	 <alpine.DEB.2.00.1207060855320.26441@router.home>
	 <1341801721.2439.29.camel@ThinkPad-T420>
	 <alpine.DEB.2.00.1207090859420.27737@router.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 12070915-1396-0000-0000-00000188A03B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-09 at 09:01 -0500, Christoph Lameter wrote:
> > I was pointed by Glauber to the slab common code patches. I need some
> > more time to read the patches. Now I think the slab/slot changes in this
> > v3 are not needed, and can be ignored.
> 
> That may take some kernel cycles. You have a current issue here that needs
> to be fixed.

I'm a little confused ... and what need I do for the next step? 

> 
> > >  	down_write(&slub_lock);
> > > -	s = find_mergeable(size, align, flags, name, ctor);
> > > +	s = find_mergeable(size, align, flags, n, ctor);
> > >  	if (s) {
> > >  		s->refcount++;
> > >  		/*
> >
> > 		......
> > 		up_write(&slub_lock);
> > 		return s;
> > 	}
> >
> > Here, the function returns without name string n be kfreed.
> 
> That is intentional since the string n is still referenced by the entry
> that sysfs_slab_alias has created.

I'm not sure whether the "referenced by ..." you mentioned is what I
understood. From my understanding:

if slab_state == SYS_FS, after 
	return sysfs_create_link(&slab_kset->kobj, &s->kobj, name); 
is called, the name string passed in sysfs_slab_alias is no longer
referenced (sysfs_new_dirent duplicates the string for sysfs to use).

else, the name sting is referenced by 
	al->name = name;
temporarily. After slab_sysfs_init is finished, the name is not
referenced any more.

So in my patch (slub part), the string is duplicated here, and kfreed in
slab_sysfs_init.

> > But we couldn't kfree n here, because in sysfs_slab_alias(), if
> > (slab_state < SYS_FS), the name need to be kept valid until
> > slab_sysfs_init() is finished adding the entry into sysfs.
> 
> Right that is why it is not freed and that is what fixes the issue you
> see.
> 


