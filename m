Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840Ab1KWFe3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 00:34:29 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60684 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726Ab1KWFe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 00:34:28 -0500
Date: Tue, 22 Nov 2011 21:34:25 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Kautuk Consul <consul.kautuk@gmail.com>, Joe Perches <joe@perches.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mm/vmalloc.c: eliminate extra loop in pcpu_get_vm_areas
 error path
In-Reply-To: <20111118115955.410af035.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.1111222134080.21009@chino.kir.corp.google.com>
References: <1321616630-28281-1-git-send-email-consul.kautuk@gmail.com> <20111118115955.410af035.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Nov 2011, Andrew Morton wrote:

> > If either of the vas or vms arrays are not properly kzalloced,
> > then the code jumps to the err_free label.
> > 
> > The err_free label runs a loop to check and free each of the array
> > members of the vas and vms arrays which is not required for this
> > situation as none of the array members have been allocated till this
> > point.
> > 
> > Eliminate the extra loop we have to go through by introducing a new
> > label err_free2 and then jumping to it.
> > 
> > Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
> > ---
> >  mm/vmalloc.c |    3 ++-
> >  1 files changed, 2 insertions(+), 1 deletions(-)
> > 
> > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > index b669aa6..1a0d4e2 100644
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -2352,7 +2352,7 @@ struct vm_struct **pcpu_get_vm_areas(const unsigned long *offsets,
> >  	vms = kzalloc(sizeof(vms[0]) * nr_vms, GFP_KERNEL);
> >  	vas = kzalloc(sizeof(vas[0]) * nr_vms, GFP_KERNEL);
> >  	if (!vas || !vms)
> > -		goto err_free;
> > +		goto err_free2;
> >  
> >  	for (area = 0; area < nr_vms; area++) {
> >  		vas[area] = kzalloc(sizeof(struct vmap_area), GFP_KERNEL);
> > @@ -2455,6 +2455,7 @@ err_free:
> >  		if (vms)
> >  			kfree(vms[area]);
> >  	}
> > +err_free2:
> >  	kfree(vas);
> >  	kfree(vms);
> >  	return NULL;
> 
> Which means we can also do the below, yes?  (please check my homework!)
> 
> --- a/mm/vmalloc.c~mm-vmallocc-eliminate-extra-loop-in-pcpu_get_vm_areas-error-path-fix
> +++ a/mm/vmalloc.c
> @@ -2449,10 +2449,8 @@ found:
>  
>  err_free:
>  	for (area = 0; area < nr_vms; area++) {
> -		if (vas)
> -			kfree(vas[area]);
> -		if (vms)
> -			kfree(vms[area]);
> +		kfree(vas[area]);
> +		kfree(vms[area]);
>  	}
>  err_free2:
>  	kfree(vas);

On both patches:

Acked-by: David Rientjes <rientjes@google.com>
