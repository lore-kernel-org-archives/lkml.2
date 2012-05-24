Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473Ab2EXBBz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 21:01:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34398 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab2EXBBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 21:01:53 -0400
Date: Wed, 23 May 2012 18:01:51 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux.com>
cc: Glauber Costa <glommer@parallels.com>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v2] slab+slob: dup name string
In-Reply-To: <alpine.DEB.2.00.1205230849410.29893@router.home>
Message-ID: <alpine.DEB.2.00.1205231759460.28167@chino.kir.corp.google.com>
References: <1337680298-11929-1-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1205220857380.17600@router.home> <alpine.DEB.2.00.1205222048380.28165@chino.kir.corp.google.com> <alpine.DEB.2.00.1205230849410.29893@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2012, Christoph Lameter wrote:

> > No, it's not, there's no reason to prevent caches created before
> > g_cpucache_up <= EARLY to be destroyed because it makes a patch easier to
> > implement and then leave that little gotcha as an undocumented treasure
> > for someone to find when they try it later on.
> 
> g_cpucache_up <= EARLY is slab bootstrap code and the system is in a
> pretty fragile state. Plus the the kmalloc logic *depends* on these
> caches being present. Removing those is not a good idea. The other caches
> that are created at that point are needed to create more caches.
> 
> There is no reason to remove these caches.
> 

Yes, we know that we don't want to remove the caches that are currently 
created in kmem_cache_init(), it would be a pretty stupid thing to do.  
I'm talking about the possibility of creating additional caches while 
g_cpucache_up <= EARLY in the future and then finding that you can't 
destroy them because of this string allocation.  I don't think it's too 
difficult to statically allocate space for these names and then test for 
it before doing kfree() in kmem_cache_destroy(), it's not performance 
critical.
