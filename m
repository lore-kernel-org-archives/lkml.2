Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815Ab2GPT6T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 15:58:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45383 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753598Ab2GPT6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 15:58:11 -0400
Date: Mon, 16 Jul 2012 12:58:08 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux.com>
cc: Shuah Khan <shuah.khan@hp.com>, Pekka Enberg <penberg@kernel.org>,
        glommer@parallels.com, js1304@gmail.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Subject: Re: [PATCH TRIVIAL] mm: Fix build warning in kmem_cache_create()
In-Reply-To: <alpine.DEB.2.00.1207160915470.28952@router.home>
Message-ID: <alpine.DEB.2.00.1207161253240.29012@chino.kir.corp.google.com>
References: <1342221125.17464.8.camel@lorien2> <alpine.DEB.2.00.1207140216040.20297@chino.kir.corp.google.com> <CAOJsxLE3dDd01WaAp5UAHRb0AiXn_s43M=Gg4TgXzRji_HffEQ@mail.gmail.com> <1342407840.3190.5.camel@lorien2> <alpine.DEB.2.00.1207160257420.11472@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1207160915470.28952@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jul 2012, Christoph Lameter wrote:

> > > struct kmem_cache *kmem_cache_create(const char *name, size_t size,
> > > size_t align,
> > >                 unsigned long flags, void (*ctor)(void *))
> > > {
> > >         struct kmem_cache *s = NULL;
> > >
> > > #ifdef CONFIG_DEBUG_VM
> > >         if (!name || in_interrupt() || size < sizeof(void *) ||
> > >                 size > KMALLOC_MAX_SIZE) {
> > >                 printk(KERN_ERR "kmem_cache_create(%s) integrity check"
> > >                         " failed\n", name);
> > >                 goto out;
> > >         }
> > > #endif
> > >
> >
> > Agreed, this shouldn't depend on CONFIG_DEBUG_VM.
> 
> These checks are useless for regular kernel operations. They are
> only useful when developing code and should only be enabled during
> development. There is no point in testing the size and the name which are
> typically constant when a slab is created with a stable kernel.
> 

Sounds like a response from someone who is very familiar with slab 
allocators.  The reality, though, is that very few people are going to be 
doing development with CONFIG_DEBUG_VM enabled unless they notice problems 
beforehand.

Are you seriously trying to optimize kmem_cache_create()?  These checks 
certainly aren't going to hurt your perfromance and it seems appropriate 
to do some sanity checking before blowing up in unexpected ways.  It's 
also the way it's been done for years before extracting common allocator 
functions to their own file.
