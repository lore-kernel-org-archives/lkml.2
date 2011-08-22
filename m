Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795Ab1HVKOj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 06:14:39 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:41540 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752461Ab1HVKOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 06:14:33 -0400
Date: Mon, 22 Aug 2011 12:14:27 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: walter harms <wharms@bfs.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        kernel-janitors@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 2/2] arch/powerpc/platforms/powermac/setup.c: add missing
 of_node_put
In-Reply-To: <4E522AD0.7030907@bfs.de>
Message-ID: <Pine.LNX.4.64.1108221213150.10948@ask.diku.dk>
References: <1313943001-12884-2-git-send-email-julia@diku.dk> <4E522AD0.7030907@bfs.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Aug 2011, walter harms wrote:

> 
> 
> Am 21.08.2011 18:10, schrieb Julia Lawall:
> > From: Julia Lawall <julia@diku.dk>
> > 
> > np is initialized to the result of calling a function that calls
> > of_node_get, so of_node_put should be called before the pointer is dropped.
> > 
> > The semantic match that finds this problem is as follows:
> > (http://coccinelle.lip6.fr/)
> > 
> > // <smpl>
> > @@
> > expression e,e1,e2;
> > @@
> > 
> > * e = \(of_find_node_by_type\|of_find_node_by_name\)(...)
> >   ... when != of_node_put(e)
> >       when != true e == NULL
> >       when != e2 = e
> >   e = e1
> > // </smpl>
> > 
> > Signed-off-by: Julia Lawall <julia@diku.dk>
> > 
> > ---
> >  arch/powerpc/platforms/powermac/setup.c |    8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/powerpc/platforms/powermac/setup.c b/arch/powerpc/platforms/powermac/setup.c
> > index 96580b1..970ea1d 100644
> > --- a/arch/powerpc/platforms/powermac/setup.c
> > +++ b/arch/powerpc/platforms/powermac/setup.c
> > @@ -494,11 +494,15 @@ static int __init pmac_declare_of_platform_devices(void)
> >  		return -1;
> >  
> >  	np = of_find_node_by_name(NULL, "valkyrie");
> > -	if (np)
> > +	if (np) {
> >  		of_platform_device_create(np, "valkyrie", NULL);
> > +		of_node_put(np);
> > +	}
> >  	np = of_find_node_by_name(NULL, "platinum");
> > -	if (np)
> > +	if (np) {
> >  		of_platform_device_create(np, "platinum", NULL);
> > +		of_node_put(np);
> > +	}
> >          np = of_find_node_by_type(NULL, "smu");
> >          if (np) {
> >  		of_platform_device_create(np, "smu", NULL);
> > 
> 
> 
> hi,
> it seems save to call of_node_put(np) with np==NULL, i assume the same is true
> for of_platform_device_create().
> 
> so the code collapses to:
> 
> _test_node(char *name)
> {
>  struct device_node *np;
>  np = of_find_node_by_name(NULL, name);
>  of_platform_device_create(np, name, NULL);

of_platform_device_create seems to do a lot of work if np is NULL.  It 
returns NULL in the end, as far as I can see, but a lot of function calls 
are required.

julia

>  of_node_put(np);
>  return NULL?:0:1;
> }
> 
> maybe there is already something like find_node() ?
> 
> re,
>  wh
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
