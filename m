Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831Ab1BPIo4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 03:44:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47401 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752205Ab1BPIow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 03:44:52 -0500
Date: Wed, 16 Feb 2011 09:44:50 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Julia Lawall <julia@diku.dk>, kernel-janitors@vger.kernel.org,
        David Sterba <dsterba@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] drivers/char/pcmcia/ipwireless/main.c: Convert
 release_resource to release_region/release_mem_region
In-Reply-To: <20110216072118.GA27029@comet.dominikbrodowski.net>
Message-ID: <alpine.LNX.2.00.1102160944340.2160@pobox.suse.cz>
References: <1297599132-7226-1-git-send-email-julia@diku.dk> <1297599132-7226-4-git-send-email-julia@diku.dk> <20110216072118.GA27029@comet.dominikbrodowski.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Feb 2011, Dominik Brodowski wrote:

> Applied to the pcmcia treee, thanks.

FWIW

	Signed-off-by: Jiri Kosina <jkosina@suse.cz>

> On Sun, Feb 13, 2011 at 01:12:10PM +0100, Julia Lawall wrote:
> > Request_region should be used with release_region, not release_resource.
> > 
> > This patch contains a number of changes, related to calls to request_region,
> > request_mem_region, and the associated error handling code.
> > 
> > 1. For the call to request_region, the variable io_resource storing the
> > result is dropped.  The call to release_resource at the end of the function
> > is changed to a call to release_region with the first two arguments of
> > request_region as its arguments.  The same call to release_region is also
> > added to release_ipwireless.
> > 
> > 2. The first call to request_mem_region is now tested and ret is set to
> > -EBUSY if the the call has failed.  This call was associated with the
> > initialization of ipw->attr_memory.  But the error handling code was
> > testing ipw->common_memory.  The definition of release_ipwireless also
> > suggests that this call should be associated with ipw->common_memory, not
> > ipw->attr_memory.
> > 
> > 3. The second call to request_mem_region is now tested and ret is
> > set to -EBUSY if the the call has failed.
> > 
> > 4. The various gotos to the error handling code is adjusted so that there
> > is no need for ifs.
> > 
> > 5. Return the value stored in the ret variable rather than -1.
> > 
> > The semantic match that finds this problem is as follows:
> > (http://coccinelle.lip6.fr/)
> > 
> > // <smpl>
> > @@
> > expression x,E;
> > @@
> > (
> > *x = request_region(...)
> > |
> > *x = request_mem_region(...)
> > )
> > ... when != release_region(x)
> >     when != x = E
> > * release_resource(x);
> > // </smpl>
> > 
> > Signed-off-by: Julia Lawall <julia@diku.dk>
> > 
> > ---
> > Compiled, not tested.
> > In release_ipwireless, should the added call to release_region be protected
> > by some if?
> > 
> >  drivers/char/pcmcia/ipwireless/main.c |   52 ++++++++++++++++++++--------------
> >  1 file changed, 32 insertions(+), 20 deletions(-)
> > 
> > diff --git a/drivers/char/pcmcia/ipwireless/main.c b/drivers/char/pcmcia/ipwireless/main.c
> > index 94b8eb4..444155a 100644
> > --- a/drivers/char/pcmcia/ipwireless/main.c
> > +++ b/drivers/char/pcmcia/ipwireless/main.c
> > @@ -78,7 +78,6 @@ static void signalled_reboot_callback(void *callback_data)
> >  static int ipwireless_probe(struct pcmcia_device *p_dev, void *priv_data)
> >  {
> >  	struct ipw_dev *ipw = priv_data;
> > -	struct resource *io_resource;
> >  	int ret;
> >  
> >  	p_dev->resource[0]->flags &= ~IO_DATA_PATH_WIDTH;
> > @@ -92,9 +91,12 @@ static int ipwireless_probe(struct pcmcia_device *p_dev, void *priv_data)
> >  	if (ret)
> >  		return ret;
> >  
> > -	io_resource = request_region(p_dev->resource[0]->start,
> > -				resource_size(p_dev->resource[0]),
> > -				IPWIRELESS_PCCARD_NAME);
> > +	if (!request_region(p_dev->resource[0]->start,
> > +			    resource_size(p_dev->resource[0]),
> > +			    IPWIRELESS_PCCARD_NAME)) {
> > +		ret = -EBUSY;
> > +		goto exit;
> > +	}
> >  
> >  	p_dev->resource[2]->flags |=
> >  		WIN_DATA_WIDTH_16 | WIN_MEMORY_TYPE_CM | WIN_ENABLE;
> > @@ -105,22 +107,25 @@ static int ipwireless_probe(struct pcmcia_device *p_dev, void *priv_data)
> >  
> >  	ret = pcmcia_map_mem_page(p_dev, p_dev->resource[2], p_dev->card_addr);
> >  	if (ret != 0)
> > -		goto exit2;
> > +		goto exit1;
> >  
> >  	ipw->is_v2_card = resource_size(p_dev->resource[2]) == 0x100;
> >  
> > -	ipw->attr_memory = ioremap(p_dev->resource[2]->start,
> > +	ipw->common_memory = ioremap(p_dev->resource[2]->start,
> >  				resource_size(p_dev->resource[2]));
> > -	request_mem_region(p_dev->resource[2]->start,
> > -			resource_size(p_dev->resource[2]),
> > -			IPWIRELESS_PCCARD_NAME);
> > +	if (!request_mem_region(p_dev->resource[2]->start,
> > +				resource_size(p_dev->resource[2]),
> > +				IPWIRELESS_PCCARD_NAME)) {
> > +		ret = -EBUSY;
> > +		goto exit2;
> > +	}
> >  
> >  	p_dev->resource[3]->flags |= WIN_DATA_WIDTH_16 | WIN_MEMORY_TYPE_AM |
> >  					WIN_ENABLE;
> >  	p_dev->resource[3]->end = 0; /* this used to be 0x1000 */
> >  	ret = pcmcia_request_window(p_dev, p_dev->resource[3], 0);
> >  	if (ret != 0)
> > -		goto exit2;
> > +		goto exit3;
> >  
> >  	ret = pcmcia_map_mem_page(p_dev, p_dev->resource[3], 0);
> >  	if (ret != 0)
> > @@ -128,23 +133,28 @@ static int ipwireless_probe(struct pcmcia_device *p_dev, void *priv_data)
> >  
> >  	ipw->attr_memory = ioremap(p_dev->resource[3]->start,
> >  				resource_size(p_dev->resource[3]));
> > -	request_mem_region(p_dev->resource[3]->start,
> > -			resource_size(p_dev->resource[3]),
> > -			IPWIRELESS_PCCARD_NAME);
> > +	if (!request_mem_region(p_dev->resource[3]->start,
> > +				resource_size(p_dev->resource[3]),
> > +				IPWIRELESS_PCCARD_NAME)) {
> > +		ret = -EBUSY;
> > +		goto exit4;
> > +	}
> >  
> >  	return 0;
> >  
> > +exit4:
> > +	iounmap(ipw->attr_memory);
> >  exit3:
> > +	release_mem_region(p_dev->resource[2]->start,
> > +			resource_size(p_dev->resource[2]));
> >  exit2:
> > -	if (ipw->common_memory) {
> > -		release_mem_region(p_dev->resource[2]->start,
> > -				resource_size(p_dev->resource[2]));
> > -		iounmap(ipw->common_memory);
> > -	}
> > +	iounmap(ipw->common_memory);
> >  exit1:
> > -	release_resource(io_resource);
> > +	release_region(p_dev->resource[0]->start,
> > +		       resource_size(p_dev->resource[0]));
> > +exit:
> >  	pcmcia_disable_device(p_dev);
> > -	return -1;
> > +	return ret;
> >  }
> >  
> >  static int config_ipwireless(struct ipw_dev *ipw)
> > @@ -219,6 +229,8 @@ exit:
> >  
> >  static void release_ipwireless(struct ipw_dev *ipw)
> >  {
> > +	release_region(ipw->link->resource[0]->start,
> > +		       resource_size(ipw->link->resource[0]));
> >  	if (ipw->common_memory) {
> >  		release_mem_region(ipw->link->resource[2]->start,
> >  				resource_size(ipw->link->resource[2]));
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
