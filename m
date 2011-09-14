Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539Ab1INAWC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 20:22:02 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35858 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232Ab1INAWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 20:22:01 -0400
Subject: Re: [BUG] infinite loop in find_get_pages()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andrew Morton <akpm@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>,
        Dave Chinner <david@fromorbit.com>, Hugh Dickins <hughd@google.com>
In-Reply-To: <20110913165344.1d800582.akpm@google.com>
References: <1315941801.2565.19.camel@edumazet-laptop>
	 <20110913165344.1d800582.akpm@google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Sep 2011 02:21:54 +0200
Message-ID: <1315959715.2565.26.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 13 septembre 2011 à 16:53 -0700, Andrew Morton a écrit :
> On Tue, 13 Sep 2011 21:23:21 +0200
> Eric Dumazet <eric.dumazet@gmail.com> wrote:
> 
> > Linus,
> > 
> > It seems current kernels (3.1.0-rc6) are really unreliable, or maybe I
> > expect too much from them.
> > 
> > On my 4GB x86_64 machine (2 quad-core cpus, 2 threads per core), I can
> > have a cpu locked in
> > 
> >  find_get_pages -> radix_tree_gang_lookup_slot -> __lookup 
> > 
> > 
> > Problem is : A bisection will be very hard, since a lot of kernels
> > simply destroy my disk (the PCI MRRS horror stuff).
> 
> Yes, that's hard.  Quite often my bisection efforts involve moving to a
> new bisection point then hand-applying a few patches to make the the
> thing compile and/or work.
> 
> There have only been three commits to radix-tree.c this year, so a bit
> of manual searching through those would be practical?
> 
> > Messages at console :
> >  
> > INFO: rcu_preempt_state detected stalls on CPUs/tasks: {} (detected by
> > 11 t=60002 jiffies)
> > 
> > perf top -C 1
> > 
> > Events: 3K cycles                                                                                                                                             
> > +     43,08%  bash  [kernel.kallsyms]  [k] __lookup
> > +     41,51%  bash  [kernel.kallsyms]  [k] find_get_pages
> > +     15,31%  bash  [kernel.kallsyms]  [k] radix_tree_gang_lookup_slot
> > 
> >     43.08%     bash  [kernel.kallsyms]  [k] __lookup
> >                |
> >                --- __lookup
> >                   |          
> >                   |--97.09%-- radix_tree_gang_lookup_slot
> >                   |          find_get_pages
> >                   |          pagevec_lookup
> >                   |          invalidate_mapping_pages
> >                   |          drop_pagecache_sb
> >                   |          iterate_supers
> >                   |          drop_caches_sysctl_handler
> >                   |          proc_sys_call_handler.isra.3
> >                   |          proc_sys_write
> >                   |          vfs_write
> >                   |          sys_write
> >                   |          system_call_fastpath
> >                   |          __write
> >                   |          
> > 
> > 
> > Steps to reproduce :
> > 
> > In one terminal, kernel builds in a loop (defconfig + hpsa driver)
> > 
> > cd /usr/src/linux
> > while :
> > do
> >  make clean
> >  make -j128
> > done
> > 
> > 
> > In another term :
> > 
> > while :
> > do
> >  echo 3 >/proc/sys/vm/drop_caches
> >  sleep 20
> > done
> > 
> 
> This is a regression?  3.0 is OK?
> 

3.0 seems ok, and first bisection point seems OK too.

# git bisect log
git bisect start
# bad: [003f6c9df54970d8b19578d195b3e2b398cdbde2] lib/sha1.c: quiet
sparse noise about symbol not declared
git bisect bad 003f6c9df54970d8b19578d195b3e2b398cdbde2
# good: [02f8c6aee8df3cdc935e9bdd4f2d020306035dbe] Linux 3.0
git bisect good 02f8c6aee8df3cdc935e9bdd4f2d020306035dbe


(I let the machine runs one hour or so before concluding its a good/bad
point)


> Also, do you know that the hang is happening at the radix-tree level? 
> It might be at the filemap.c level or at the superblock level and we
> just end up spending most cycles at the lower levels because they're
> called so often?  The iterate_supers/drop_pagecache_sb code is fairly
> recent.
> 
> 

No idea yet, but I'll take a look after a bit of sleep ;)

Thanks !


