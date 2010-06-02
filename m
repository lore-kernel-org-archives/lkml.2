Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751907Ab0FBF3O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 01:29:14 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:36161 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751128Ab0FBF3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 01:29:12 -0400
Date: Wed, 2 Jun 2010 07:29:04 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joerg Roedel <joerg.roedel@amd.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 6/17] arch/x86/kernel: Add missing spin_unlock
In-Reply-To: <20100601141529.0c99f22c.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.1006020727380.18272@ask.diku.dk>
References: <Pine.LNX.4.64.1005261755260.23743@ask.diku.dk>
 <20100601141529.0c99f22c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jun 2010, Andrew Morton wrote:

> On Wed, 26 May 2010 17:55:59 +0200 (CEST)
> Julia Lawall <julia@diku.dk> wrote:
> 
> > From: Julia Lawall <julia@diku.dk>
> > 
> > Add a spin_unlock missing on the error path.  The locks and unlocks are
> > balanced in other functions, so it seems that the same should be the case
> > here.
> > 
> > The semantic match that finds this problem is as follows:
> > (http://coccinelle.lip6.fr/)
> > 
> > // <smpl>
> > @@
> > expression E1;
> > @@
> > 
> > * spin_lock(E1,...);
> >   <+... when != E1
> >   if (...) {
> >     ... when != E1
> > *   return ...;
> >   }
> >   ...+>
> > * spin_unlock(E1,...);
> > // </smpl>
> > 
> > Signed-off-by: Julia Lawall <julia@diku.dk>
> > 
> > ---
> >  arch/x86/kernel/amd_iommu.c |    8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
> > index fa5a147..b98e1cd 100644
> > --- a/arch/x86/kernel/amd_iommu.c
> > +++ b/arch/x86/kernel/amd_iommu.c
> > @@ -1499,12 +1499,16 @@ static int __attach_device(struct device *dev,
> >  
> >  	/* Some sanity checks */
> >  	if (alias_data->domain != NULL &&
> > -	    alias_data->domain != domain)
> > +	    alias_data->domain != domain) {
> > +		spin_unlock(&domain->lock);
> >  		return -EBUSY;
> > +	}
> >  
> >  	if (dev_data->domain != NULL &&
> > -	    dev_data->domain != domain)
> > +	    dev_data->domain != domain) {
> > +		spin_unlock(&domain->lock);
> >  		return -EBUSY;
> > +	}
> >  
> >  	/* Do real assignment */
> >  	if (dev_data->alias != dev) {
> 
> The reason why these bugs occur is that we sprinkle multiple `return'
> statements inside the middle of non-trivial functions.  People miss
> some or fail to modify some when later changing locking rules and we
> gain bugs (or, similarly, resource leaks).
> 
> So I'd suggest that when fixing such bugs, we also fix their cause.
> 
> ie:
> 
> --- a/arch/x86/kernel/amd_iommu.c~arch-x86-kernel-add-missing-spin_unlock
> +++ a/arch/x86/kernel/amd_iommu.c
> @@ -1487,6 +1487,7 @@ static int __attach_device(struct device
>  			   struct protection_domain *domain)
>  {
>  	struct iommu_dev_data *dev_data, *alias_data;
> +	int ret;
>  
>  	dev_data   = get_dev_data(dev);
>  	alias_data = get_dev_data(dev_data->alias);
> @@ -1497,14 +1498,17 @@ static int __attach_device(struct device
>  	/* lock domain */
>  	spin_lock(&domain->lock);
>  
> +	ret = -EBUSY;
>  	/* Some sanity checks */
>  	if (alias_data->domain != NULL &&
>  	    alias_data->domain != domain)
> -		return -EBUSY;
> +		goto out;
>  
>  	if (dev_data->domain != NULL &&
>  	    dev_data->domain != domain)
> -		return -EBUSY;
> +		goto out;
> +
> +	ret = 0;
>  
>  	/* Do real assignment */
>  	if (dev_data->alias != dev) {
> @@ -1522,8 +1526,8 @@ static int __attach_device(struct device
>  
>  	/* ready */
>  	spin_unlock(&domain->lock);
> -
> -	return 0;
> +out:
> +	return ret;
>  }

I don't have the impression that this actually fixes the problem, only the 
code structure.  Out should be above the spin_lock, and there should just 
be one return, of ret.  I will send another patch shortly.

julia
