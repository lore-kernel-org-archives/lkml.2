Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab0F1JDX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 05:03:23 -0400
Received: from smtp-out.google.com ([74.125.121.35]:27309 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642Ab0F1JDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 05:03:22 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=Hu93OuACSu9dexehqGDAk2ucTeiFZq7QZxRiuA77W92e4nQI8A/AOUwB91gRPVlJh
	aGgzt6GUm60Z63/9stNYw==
Date: Mon, 28 Jun 2010 02:03:16 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: linux-mm@kvack.org, Christoph Lameter <cl@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: kmem_cache_destroy() badness with SLUB
In-Reply-To: <1277688701.4200.159.camel@pasglop>
Message-ID: <alpine.DEB.2.00.1006280159010.28072@chino.kir.corp.google.com>
References: <1277688701.4200.159.camel@pasglop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jun 2010, Benjamin Herrenschmidt wrote:

> Hi folks !
> 
> Internally, I'm hitting a little "nit"...
> 
> sysfs_slab_add() has this check:
> 
> 	if (slab_state < SYSFS)
> 		/* Defer until later */
> 		return 0;
> 
> But sysfs_slab_remove() doesn't.
> 
> So if the slab is created -and- destroyed at, for example, arch_initcall
> time, then we hit a WARN in the kobject code, trying to dispose of a
> non-existing kobject.
> 

Indeed, but shouldn't we be appropriately handling the return value of 
sysfs_slab_add() so that it fails cache creation?  We wouldn't be calling 
sysfs_slab_remove() on a cache that was never created.

> Now, at first sight, just adding the same test to sysfs_slab_remove()
> would do the job... but it all seems very racy to me.
> 
> I don't understand in fact how this slab_state deals with races at all. 
> 

All modifiers of slab_state are intended to be run only on the boot cpu so 
the only concern is the ordering.  We need slab_state to indicate how far 
slab has been initialized since we can't otherwise enforce how code uses 
slab in between things like kmem_cache_init(), kmem_cache_init_late(), and 
initcalls on the boot cpu.
