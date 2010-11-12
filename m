Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695Ab0KLI1L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 03:27:11 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:58590 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752052Ab0KLI1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 03:27:09 -0500
Date: Fri, 12 Nov 2010 00:27:04 -0800
From: Andres Salomon <dilinger@queued.net>
To: Milton Miller <miltonm@bga.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] x86: OLPC: speed up device tree creation during
 boot (v2)
Message-ID: <20101112002704.50c629e2@queued.net>
In-Reply-To: <reply-olpc-3-v2@mdm.bga.com>
References: <20101111214546.4e573cad@queued.net>
	<reply-olpc-3-v2@mdm.bga.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Nov 2010 01:48:30 -0600
Milton Miller <miltonm@bga.com> wrote:

> On Thu, 11 Nov 2010 around 21:45:46 -0800, Andres Salomon wrote:
> > diff --git a/arch/x86/platform/olpc/olpc_dt.c
> > b/arch/x86/platform/olpc/olpc_dt.c index b8c8ff9..0ab824d 100644
> > --- a/arch/x86/platform/olpc/olpc_dt.c
> > +++ b/arch/x86/platform/olpc/olpc_dt.c
> > @@ -126,14 +126,31 @@  static unsigned int prom_early_allocated
> > __initdata; 
> >  void * __init prom_early_alloc(unsigned long size)
> >  {
> > +	static u8 *mem = NULL;
> > +	static size_t free_mem = 0;
> 
> Static variables are implicitly 0 and NULL

That's true for global static variables; is it also true for static
variables that are local to a function?


> 
> >  	void *res;
> >  
> > -	res = alloc_bootmem(size);
> > -	if (res)
> > -		memset(res, 0, size);
> > -
> > -	prom_early_allocated += size;
> > +	if (free_mem < size) {
> > +		const size_t chunk_size = max(PAGE_SIZE, size);
> > +
> > +		/*
> > +		 * To mimimize the number of allocations, grab at
> > least 4k of
> > +		 * memory (that's an arbitrary choice that matches
> > PAGE_SIZE on
> > +		 * the platforms we care about, and minimizes
> > wasted bootmem)
> > +		 * and hand off chunks of it to callers.
> > +		 */
> > +		res = mem = alloc_bootmem(chunk_size);
> > +		if (!res)
> > +			return NULL;
> 
> Oops.  If alloc_bootmem fails, we loose mem but don't reset free_mem,
> so a later call (possibly for a smaller chunk) may return memory
> starting at NULL.

You're right, good catch.  Thanks!


> 
> I suggest just assinging res above and then add mem = res inside this
> if.
> 
> Oh, this is alloc_bootmem not alloc_bootmem_nopainc ... should it be?
> 

Currently, nothing in drivers/of/pdt.c actually checks alloc_bootmem
results.. so we're panicking whether we like it or not.  It would be
good to actually handle memory failures gracefully and not oops (the DT
certainly isn't essential to booting in OLPC's case), but that's a
separate patch (series).


> > +		prom_early_allocated += chunk_size;
> > +		memset(res, 0, chunk_size);
> > +		free_mem = chunk_size;
> > +	}
> >  
> > +	/* allocate from the local cache */
> > +	free_mem -= size;
> > +	res = mem;
> > +	mem += size;
> >  	return res;
> >  }
> >  
> 
> milton
