Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100Ab2FTN5Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 09:57:24 -0400
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:35721
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751740Ab2FTN5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 09:57:23 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I1432Izz1202hzz8275dhz2dh2a8h668h839h944hd25hf0ah)
Date: Wed, 20 Jun 2012 21:53:38 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Rob Herring <robherring2@gmail.com>
CC: Dong Aisheng-B29396 <B29396@freescale.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 1/1] of: reform prom_update_property function
Message-ID: <20120620135337.GM10387@shlinux2.ap.freescale.net>
References: <1340171647-2815-1-git-send-email-b29396@freescale.com>
 <4FE1CB2C.5040208@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4FE1CB2C.5040208@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 09:07:56PM +0800, Rob Herring wrote:
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
> 
Sorry, i missed that.
Thanks for reminder.

Regards
Dong Aisheng

> 
> >  arch/powerpc/platforms/85xx/p1022_ds.c    |    8 +-------
> >  arch/powerpc/platforms/pseries/mobility.c |    8 +-------
> >  arch/powerpc/platforms/pseries/reconfig.c |   13 +++----------
> >  drivers/of/base.c                         |   15 +++++++++++----
> >  fs/proc/proc_devtree.c                    |    5 +++++
> >  include/linux/of.h                        |    3 +--
> >  6 files changed, 22 insertions(+), 30 deletions(-)
> > 
> > diff --git a/arch/powerpc/platforms/85xx/p1022_ds.c b/arch/powerpc/platforms/85xx/p1022_ds.c
> > index f700c81..d66631c 100644
> > --- a/arch/powerpc/platforms/85xx/p1022_ds.c
> > +++ b/arch/powerpc/platforms/85xx/p1022_ds.c
> > @@ -348,13 +348,7 @@ void __init p1022_ds_pic_init(void)
> >   */
> >  static void __init disable_one_node(struct device_node *np, struct property *new)
> >  {
> > -	struct property *old;
> > -
> > -	old = of_find_property(np, new->name, NULL);
> > -	if (old)
> > -		prom_update_property(np, new, old);
> > -	else
> > -		prom_add_property(np, new);
> > +	prom_update_property(np, new);
> >  }
> >  
> >  /* TRUE if there is a "video=fslfb" command-line parameter. */
> > diff --git a/arch/powerpc/platforms/pseries/mobility.c b/arch/powerpc/platforms/pseries/mobility.c
> > index 029a562..dd30b12 100644
> > --- a/arch/powerpc/platforms/pseries/mobility.c
> > +++ b/arch/powerpc/platforms/pseries/mobility.c
> > @@ -67,7 +67,6 @@ static int update_dt_property(struct device_node *dn, struct property **prop,
> >  			      const char *name, u32 vd, char *value)
> >  {
> >  	struct property *new_prop = *prop;
> > -	struct property *old_prop;
> >  	int more = 0;
> >  
> >  	/* A negative 'vd' value indicates that only part of the new property
> > @@ -117,12 +116,7 @@ static int update_dt_property(struct device_node *dn, struct property **prop,
> >  	}
> >  
> >  	if (!more) {
> > -		old_prop = of_find_property(dn, new_prop->name, NULL);
> > -		if (old_prop)
> > -			prom_update_property(dn, new_prop, old_prop);
> > -		else
> > -			prom_add_property(dn, new_prop);
> > -
> > +		prom_update_property(dn, new_prop);
> >  		new_prop = NULL;
> >  	}
> >  
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
> 
> 

