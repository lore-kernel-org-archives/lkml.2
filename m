Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759412Ab2EWDz5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 23:55:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54705 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889Ab2EWDzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 23:55:55 -0400
Date: Tue, 22 May 2012 20:55:53 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux.com>
cc: Glauber Costa <glommer@parallels.com>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v2] slab+slob: dup name string
In-Reply-To: <alpine.DEB.2.00.1205220857380.17600@router.home>
Message-ID: <alpine.DEB.2.00.1205222048380.28165@chino.kir.corp.google.com>
References: <1337680298-11929-1-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1205220857380.17600@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2012, Christoph Lameter wrote:

> > [ v2: Also dup string for early caches, requested by David Rientjes ]
> 
> kstrdups that early could cause additional issues. Its better to leave
> things as they were.
> 

No, it's not, there's no reason to prevent caches created before 
g_cpucache_up <= EARLY to be destroyed because it makes a patch easier to 
implement and then leave that little gotcha as an undocumented treasure 
for someone to find when they try it later on.

I hate consistency patches like this because it could potentially fail a 
kmem_cache_create() from a sufficiently long cache name when it wouldn't 
have before, but I'm not really concerned since kmem_cache_create() will 
naturally be followed by kmem_cache_alloc() which is more likely to cause 
the oom anyway.  But it's just another waste of memory for consistency 
sake.

This is much easier to do, just statically allocate the const char *'s 
needed for the boot caches and then set their ->name's manually in 
kmem_cache_init() and then avoid the kfree() in kmem_cache_destroy() if 
the name is between &boot_cache_name[0] and &boot_cache_name[n].
