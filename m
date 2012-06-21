Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932596Ab2FUARE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 20:17:04 -0400
Received: from gate.crashing.org ([63.228.1.57]:49034 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758646Ab2FUARA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 20:17:00 -0400
Message-ID: <1340237796.28143.207.camel@pasglop>
Subject: Re: [PATCH 1/1] of: reform prom_update_property function
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Rob Herring <robherring2@gmail.com>
Cc: Dong Aisheng <b29396@freescale.com>, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Kumar Gala <galak@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Date: Thu, 21 Jun 2012 10:16:36 +1000
In-Reply-To: <4FE1CB2C.5040208@gmail.com>
References: <1340171647-2815-1-git-send-email-b29396@freescale.com>
	 <4FE1CB2C.5040208@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-20 at 08:07 -0500, Rob Herring wrote:
> On 06/20/2012 12:54 AM, Dong Aisheng wrote:
> > From: Dong Aisheng <dong.aisheng@linaro.org>
> > 
> > prom_update_property() currently fails if the property doesn't
> > actually exist yet which isn't what we want. Change to add-or-update
> > instead of update-only, then we can remove a lot duplicated lines.
> > 
> > Suggested-by: Grant Likely <grant.likely@secretlab.ca>
> > Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> > ---
> 
> Looks fine, but you need to cc powerpc maintainers.

Generally fine, just one issue I spotted:

> > diff --git a/arch/powerpc/platforms/pseries/reconfig.c b/arch/powerpc/platforms/pseries/reconfig.c
> > index 7b3bf76..4c92f1c 100644
> > --- a/arch/powerpc/platforms/pseries/reconfig.c
> > +++ b/arch/powerpc/platforms/pseries/reconfig.c
> > @@ -432,7 +432,7 @@ static int do_update_property(char *buf, size_t bufsize)
> >  	unsigned char *value;
> >  	char *name, *end, *next_prop;
> >  	int rc, length;
> > -	struct property *newprop, *oldprop;
> > +	struct property *newprop;
> >  	buf = parse_node(buf, bufsize, &np);
> >  	end = buf + bufsize;
> >  
> > @@ -450,18 +450,11 @@ static int do_update_property(char *buf, size_t bufsize)
> >  	if (!strcmp(name, "slb-size") || !strcmp(name, "ibm,slb-size"))
> >  		slb_set_size(*(int *)value);
> >  
> > -	oldprop = of_find_property(np, name,NULL);
> > -	if (!oldprop) {
> > -		if (strlen(name))
> > -			return prom_add_property(np, newprop);
> > -		return -ENODEV;
> > -	}
> > -

Here the code would exit the function with an error if the property
didn't already exist, you are losing that semantic.

Additionally there's that oddball test for strlen(name) ... you might
want to check that somewhere... and the strange fact that it would
actually add the new property anyway despite returning an error which is
very very odd semantics but I'd rather not break them since this is
exposed to userspace, so we may have tools relying on them.

> >  	upd_value.node = np;
> >  	upd_value.property = newprop;
> >  	pSeries_reconfig_notify(PSERIES_UPDATE_PROPERTY, &upd_value);
> >  
> > -	rc = prom_update_property(np, newprop, oldprop);
> > +	rc = prom_update_property(np, newprop);
> >  	if (rc)
> >  		return rc;
> >  
> > @@ -486,7 +479,7 @@ static int do_update_property(char *buf, size_t bufsize)
> >  
> >  		rc = pSeries_reconfig_notify(action, value);
> >  		if (rc) {
> > -			prom_update_property(np, oldprop, newprop);
> > +			prom_update_property(np, newprop);
> >  			return rc;
> >  		}
> >  	}
> > diff --git a/drivers/of/base.c b/drivers/of/base.c
> > index d9bfd49..a14f109 100644
> > --- a/drivers/of/base.c
> > +++ b/drivers/of/base.c
> > @@ -1051,7 +1051,8 @@ int prom_remove_property(struct device_node *np, struct property *prop)
> >  }
> >  
> >  /*
> > - * prom_update_property - Update a property in a node.
> > + * prom_update_property - Update a property in a node, if the property does
> > + * not exist, add it.
> >   *
> >   * Note that we don't actually remove it, since we have given out
> >   * who-knows-how-many pointers to the data using get-property.
> > @@ -1059,13 +1060,19 @@ int prom_remove_property(struct device_node *np, struct property *prop)
> >   * and add the new property to the property list
> >   */
> >  int prom_update_property(struct device_node *np,
> > -			 struct property *newprop,
> > -			 struct property *oldprop)
> > +			 struct property *newprop)
> >  {
> > -	struct property **next;
> > +	struct property **next, *oldprop;
> >  	unsigned long flags;
> >  	int found = 0;
> >  
> > +	if (!newprop->name)
> > +		return -EINVAL;
> > +
> > +	oldprop = of_find_property(np, newprop->name, NULL);
> > +	if (!oldprop)
> > +		return prom_add_property(np, newprop);
> > +
> >  	write_lock_irqsave(&devtree_lock, flags);
> >  	next = &np->properties;
> >  	while (*next) {
> > diff --git a/fs/proc/proc_devtree.c b/fs/proc/proc_devtree.c
> > index 927cbd1..df7dd08 100644
> > --- a/fs/proc/proc_devtree.c
> > +++ b/fs/proc/proc_devtree.c
> > @@ -101,6 +101,11 @@ void proc_device_tree_update_prop(struct proc_dir_entry *pde,
> >  {
> >  	struct proc_dir_entry *ent;
> >  
> > +	if (!oldprop) {
> > +		proc_device_tree_add_prop(pde, newprop);
> > +		return;
> > +	}
> > +
> >  	for (ent = pde->subdir; ent != NULL; ent = ent->next)
> >  		if (ent->data == oldprop)
> >  			break;
> > diff --git a/include/linux/of.h b/include/linux/of.h
> > index 2ec1083..b27c871 100644
> > --- a/include/linux/of.h
> > +++ b/include/linux/of.h
> > @@ -260,8 +260,7 @@ extern int of_machine_is_compatible(const char *compat);
> >  extern int prom_add_property(struct device_node* np, struct property* prop);
> >  extern int prom_remove_property(struct device_node *np, struct property *prop);
> >  extern int prom_update_property(struct device_node *np,
> > -				struct property *newprop,
> > -				struct property *oldprop);
> > +				struct property *newprop);
> >  
> >  #if defined(CONFIG_OF_DYNAMIC)
> >  /* For updating the device tree at runtime */

Note that another issue you aren't addressing is that this is a
fundamentally leaky operation.

IE. The allocation of the "old" property isn't disposed of. It can't
because today we don't know whether any of those pointers was
dynamically allocated or not. IE they could point to the fdt
string list, data block, or could be bootmem ... or could be
actual kernel memory.

We might want to extend the struct property to contain indications of
the allocation type so we can kfree dynamic properties properly.

But then there's the question of the lifetime of a property... since
they aren't reference counted like nodes are.

Cheers,
Ben.


