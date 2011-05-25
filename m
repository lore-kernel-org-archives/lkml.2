Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834Ab1EYXe4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 19:34:56 -0400
Received: from smtp-out.google.com ([74.125.121.67]:5188 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756377Ab1EYXez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 19:34:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=ZMgdly1xI5YB8ReJ/y4LC425skDWyJ0LIrsPRKdo/SzGBvkZDeF0IqQ2/sTs9iKNcl
         uhLuAPiyw8wgJvkcnuQQ==
Date: Wed, 25 May 2011 16:34:48 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux.com>
cc: Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 4/6] slub: avoid compiling SLAB_CACHE_DMA without DMA
 support
In-Reply-To: <alpine.DEB.2.00.1105250957180.23309@router.home>
Message-ID: <alpine.DEB.2.00.1105251629020.29729@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1105241650230.29780@chino.kir.corp.google.com> <alpine.DEB.2.00.1105241652110.29780@chino.kir.corp.google.com> <alpine.DEB.2.00.1105250957180.23309@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 May 2011, Christoph Lameter wrote:

> > If CONFIG_ZONE_DMA is disabled, SLAB_CACHE_DMA is a no-op.  Avoid
> > compiling support for it on such a configuration.
> 
> Setting SLAB_CACHE_DMA to zero in the !ZONE_DMA case could avoid some of
> the ifdeffery.
> 

That doesn't actually accomplish anything since all SLAB_CACHE_DMA does is 
set SLUB_DMA, which is already 0 in slub_def.h without CONFIG_ZONE_DMA:

	#ifdef CONFIG_ZONE_DMA
	#define SLUB_DMA __GFP_DMA  
	#else
	/* Disable DMA functionality */
	#define SLUB_DMA (__force gfp_t)0
	#endif

So doing the same for SLAB_CACHE_DMA wouldn't do anything.  The point of 
the patchset is to break the build if SLAB_CACHE_DMA is passed to 
kmem_cache_create() and the kernel is not compiled for DMA support.  That 
should result in a build breakage rather than silently not supporting DMA 
slab caches since it needs to be corrected at build.
