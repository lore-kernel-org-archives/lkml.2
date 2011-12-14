Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122Ab1LNRuC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 12:50:02 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58908 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757314Ab1LNRt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 12:49:59 -0500
Message-ID: <1323884995.2334.71.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: Sparc-32 doesn't work in 3.1.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Sergei Trofimovich <slyich@gmail.com>
Cc: Rob Landley <rob@landley.net>,
        Aboriginal Linux <aboriginal@lists.landley.net>,
        linux-kernel@vger.kernel.org, davem@davemloft.net, tytso@mit.edu,
        sparclinux@vger.kernel.org, Jakub Jelinek <jakub@redhat.com>
Date: Wed, 14 Dec 2011 18:49:55 +0100
In-Reply-To: <20111214204225.7c8ec86c@sf.home>
References: <4EBEAB5A.5020809@landley.net> <4EBF0A25.20604@landley.net>
	 <20111211111801.5942ab39@sf.home> <4EE80891.70604@landley.net>
	 <20111214204225.7c8ec86c@sf.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 14 décembre 2011 à 20:42 +0300, Sergei Trofimovich a écrit :
> [ CCed Jakub ]
> 
> >>>   Boot time fixup v1.6. 4/Mar/98 Jakub Jelinek (jj@ultra.linux.cz).
> >>>   Patching kernel for srmmu[Fujitsu TurboSparc]/iommu
> >>>   Fixup i f029ddfc doesn't refer to a valid instruction at
> >>>   f00de648[95eea000]
> >>>   halt, power off
> 
> > I put the broken image up at http://landley.net/sparc-image for the
> > moment, but if you build 3.1 with the attached .config and the toolchain
> > mentioned last time, it should reproduce for you.  It's 100% reliable
> > for me...
> 
> Nice! With this config it breaks for me on your and mine toolchains.
> The offending function is ext4_kvmalloc (and similar ext4_kvzalloc).
> 
> The usual relocation in sparc looks like a pair of instructions loading
> two pats of address in 2 instructions:
> 
> Like that:
> >        sethi   %hi(ext4_fill_super), %o4       !, tmp113
> >        or      %o4, %lo(ext4_fill_super), %o4  ! tmp113,, tmp28
> 
> In our case relocatable symbol sits in tail call, so %lo part is in "unusual"
> RESTORE instruction:
> 
> > ext4_kvmalloc:
> ...
> >         sethi  %hi(___i_page_kernel), %i2      !, tmp112
> >        call    __vmalloc, 0    !
> >         restore %i2, %lo(___i_page_kernel), %o2        ! tmp112,,
> ...
> 
> David: is this code correct? Or it's a compiler bug? I am sparc32 newbie.
> (C source and asm sources of function are in [1])
> 
> I think this kind of code is generated only in -Os.
> So to workaround it I tried this hack:
> 
> > --- a/fs/ext4/super.c
> > +++ b/fs/ext4/super.c
> >         ret = kmalloc(size, flags);
> >         if (!ret)
> >                 ret = __vmalloc(size, flags, PAGE_KERNEL);
> > +
> > +       asm __volatile__("nop":::"memory");
> > +
> >         return ret;
> >  }
> (for both ext4_kvmalloc / ext4_kvzalloc. Attached workaround as a patch.)
> 
> It forces compiler to geterate "usual" pattern for relocation.
> 
> I think of 2 solutions:
> 
> 1. trying to fix sparc/boot/btfixupprep.c and arch/sparc/mm/btfixup.c
>    to distinct HI22 and LO10 relocations as different ones.
>    Right now they are merged into one 'i' type and rely on instruction heuristics to fix it.
> 2. Add a hack to arch/sparc/mm/btfixup.c to recognize restore instruction as well
> 
> Any others?

3)  Adding a memset() in ext4_kvmalloc() and ext4_kvzalloc() to prefault
pages ?

4) (Unrelated) : add __GFP_HIGHMEM to __vmalloc() flags, so that high
memory pages can be used for large allocations.



