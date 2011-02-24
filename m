Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173Ab1BXAQf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 19:16:35 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:59646 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751186Ab1BXAQe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 19:16:34 -0500
Date: Wed, 23 Feb 2011 16:16:30 -0800
From: Andres Salomon <dilinger@queued.net>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Daniel Drake <dsd@laptop.org>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Subject: Re: [PATCH] of/pdt: allow DT device matching by fixing 'name'
 brokenness (v2)
Message-ID: <20110223161630.3ae470bf@queued.net>
In-Reply-To: <20110223232815.GC5404@angua.secretlab.ca>
References: <20110223150357.5a40793d@queued.net>
	<20110223232815.GC5404@angua.secretlab.ca>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Feb 2011 16:28:15 -0700
Grant Likely <grant.likely@secretlab.ca> wrote:

> On Wed, Feb 23, 2011 at 03:03:57PM -0800, Andres Salomon wrote:
> > 
> > Commit e2f2a93b changed dp->name from using the 'name' property to
> > using package-to-path.  This fixed /proc/device-tree creation by
> > eliminating conflicts between names (the 'name' property provides
> > names like 'battery', whereas package-to-path provides names like
> > '/foo/bar/battery@0', which we stripped to 'battery@0').  However,
> > it also breaks of_device_id table matching.
> > 
> > The fix that we _really_ wanted was to keep dp->name based upon
> > the name property ('battery'), but based dp->full_name upon
> > package-to-path ('battery@0').  This patch does just that.
> > 
> > This also changes OLPC behavior to use the full result from
> > package-to-path for full_name, rather than stripping the directory
> > out.  In practice, the strings end up being exactly the same; this
> > change saves time, code, and memory.
> > 
> > Note that this affects sparc by reverting dp->name back to what
> > sparc was originally doing (looking at the name property).
> > 
> > v2: combine two patches and revert of_pdt_node_name to original
> > version.
> > 
> > Signed-off-by: Andres Salomon <dilinger@queued.net>
> 
> Hi Andres, comments below.
> 
> g.
> 
> > ---
> >  drivers/of/pdt.c |   42 +++++++++++++++---------------------------
> >  1 files changed, 15 insertions(+), 27 deletions(-)
> > 
> > diff --git a/drivers/of/pdt.c b/drivers/of/pdt.c
> > index 28295d0..a7aa85e 100644
> > --- a/drivers/of/pdt.c
> > +++ b/drivers/of/pdt.c
> > @@ -134,7 +134,7 @@ static char * __init
> > of_pdt_get_one_property(phandle node, const char *name) 
> >  static char * __init of_pdt_try_pkg2path(phandle node)
> >  {
> > -	char *res, *buf = NULL;
> > +	char *buf = NULL;
> >  	int len;
> >  
> >  	if (!of_pdt_prom_ops->pkg2path)
> > @@ -147,29 +147,6 @@ static char * __init
> > of_pdt_try_pkg2path(phandle node) pr_err("%s: package-to-path
> > failed\n", __func__); return NULL;
> >  	}
> > -
> > -	res = strrchr(buf, '/');
> > -	if (!res) {
> > -		pr_err("%s: couldn't find / in %s\n", __func__,
> > buf);
> > -		return NULL;
> > -	}
> > -	return res+1;
> > -}
> > -
> > -/*
> > - * When fetching the node's name, first try using package-to-path;
> > if
> > - * that fails (either because the arch hasn't supplied a PROM
> > callback,
> > - * or some other random failure), fall back to just looking at the
> > node's
> > - * 'name' property.
> > - */
> > -static char * __init of_pdt_build_name(phandle node)
> > -{
> > -	char *buf;
> > -
> > -	buf = of_pdt_try_pkg2path(node);
> > -	if (!buf)
> > -		buf = of_pdt_get_one_property(node, "name");
> > -
> >  	return buf;
> >  }
> >  
> 
> It seems to me that of_pdt_build_full_name will still be missing the
> '@<addr>' component on non-sparc non-olpc builds because it uses the
> broken of_pdt_node_name().  That needs to be fixed too, even if there
> are no current users (or removed).


The intent if for them to use the pkg2path hook.  If
they can't use that, they'll need an architecture-specific way to
figure out the @<addr> component.  It may even be possible for sparc
to use package-to-path; but either way, if an architecture doesn't
have package-to-path (OLPC and powerpc have it; I don't know about
sparc), and can't fake it, it'll need to do something special.

If the pkg2path hook isn't set and we're not sparc, we fall back to
dp->name.  That sucks, but I don't know of a better way to do things.



> 
> > @@ -187,7 +164,7 @@ static struct device_node * __init
> > of_pdt_create_node(phandle node, 
> >  	kref_init(&dp->kref);
> >  
> > -	dp->name = of_pdt_build_name(node);
> > +	dp->name = of_pdt_get_one_property(node, "name");
> >  	dp->type = of_pdt_get_one_property(node, "device_type");
> >  	dp->phandle = node;
> >  
> > @@ -198,11 +175,22 @@ static struct device_node * __init
> > of_pdt_create_node(phandle node, return dp;
> >  }
> >  
> > -static char * __init of_pdt_build_full_name(struct device_node *dp)
> > +static char * __init of_pdt_build_full_name(struct device_node *dp,
> > +		phandle node)
> 
> Is dp->phandle not suitable here?
> 
> >  {
> >  	int len, ourlen, plen;
> >  	char *n;
> >  
> > +	/*
> > +	 * When fetching the full name we want the name we see with
> > +	 * package-to-path (ie, '/foo/bar/battery@0') rather than
> > what
> > +	 * we see with the name property (ie, 'battery').
> > +	 */
> > +	n = of_pdt_try_pkg2path(node);
> > +	if (n)
> > +		return n;
> > +
> > +	/* Older method for determining full name */
> >  	plen = strlen(dp->parent->full_name);
> >  	ourlen = strlen(of_pdt_node_name(dp));
> >  	len = ourlen + plen + 2;
> > @@ -243,7 +231,7 @@ static struct device_node * __init
> > of_pdt_build_tree(struct device_node *parent, #if
> > defined(CONFIG_SPARC) dp->path_component_name =
> > build_path_component(dp); #endif
> 
> I still think it would be useful to remove the #if
> defined(CONFIG_SPARC) from path_component_name, and it might be the
> best way to solve my comment about broken of_pdt_node_name above.
> 

path_component_name is filled in by build_path_component() in
sparc-land.  It's very sparc-specific, and having path_component_name
around doesn't help us on other architectures if we don't know how to
fill it in.


> > -		dp->full_name = of_pdt_build_full_name(dp);
> > +		dp->full_name = of_pdt_build_full_name(dp, node);
> >  
> >  		dp->child = of_pdt_build_tree(dp,
> >  				of_pdt_prom_ops->getchild(node),
> > nextp); -- 
> > 1.7.2.3
> > 
