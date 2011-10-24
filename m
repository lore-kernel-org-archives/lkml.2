Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370Ab1JXHDq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 03:03:46 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39288 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227Ab1JXHDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 03:03:45 -0400
Message-ID: <1319439819.2517.38.camel@edumazet-laptop>
Subject: Re: Vanilla-Kernel 3 - page allocation failure
From: Eric Dumazet <eric.dumazet@gmail.com>
To: p.herz@profihost.ag
Cc: David Rientjes <rientjes@google.com>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org
Date: Mon, 24 Oct 2011 09:03:39 +0200
In-Reply-To: <4EA506B9.4030604@profihost.ag>
References: <4E9D53FF.7090609@profihost.ag> <m2ipnmz49x.fsf@firstfloor.org>
	 <alpine.DEB.2.00.1110181848150.12850@chino.kir.corp.google.com>
	 <4EA506B9.4030604@profihost.ag>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 24 octobre 2011 à 08:33 +0200, Philipp Herz - Profihost AG a
écrit :
> Am 19.10.2011 03:58, schrieb David Rientjes:
> > On Tue, 18 Oct 2011, Andi Kleen wrote:
> >
> >> Philipp Herz - Profihost AG<p.herz@profihost.ag>  writes:
> >>
> >>> After updating kernel (x86_64) to stable version 3 there are a few
> >>> messages appearing in the kernel log such as
> >>>
> >>> kworker/0:1: page allocation failure: order:1, mode:0x20
> >>> mysql: page allocation failure: order:1, mode:0x20
> >>> php5: page allocation failure: order:1, mode:0x20
> >>
> >> You just ran out of memory.
> >>
> >
> > He ran out of order-1 physically contiguous memory and was unable to
> > compact or reclaim because of the atomic context.
> >
> > Philipp, based on your pastes from another post, it's evident you're using
> > CONFIG_SLAB and, unfortunately, it's not possible to change to single
> > page allocations (which would only result in a page allocation failure if
> > you were completely out of memory) without recompiling.
> >
> > You have a couple options:
> >
> >   - recompile with BREAK_GFP_ORDER_HI redefined to 0 in mm/slab.c, or
> >
> >   - recompile with CONFIG_SLUB instead of CONFIG_SLAB.
> >
> > It's very possible that neither of these will help, but it will tell you
> > whether you need to go out and buy more RAM or not.  If you try to
> > recompile with BREAK_GFP_ORDER_HI, these may turn into order-0
> > allocations.  If you can't reboot, send the output of
> > /proc/<pid>/net/protocols where<pid>  is the pid of one of the above tasks
> > (kworker, mysql, php5) when they are running and we'll know.
> >
> >   [ Changing slab_break_gfp_order should really be a CONFIG_SLAB command-
> >     line option.  It can't be runtime because slab depends on the order for
> >     caches remaining constant, but we can certainly change it on boot. ]
> >
> > If you try CONFIG_SLUB instead of CONFIG_SLAB, you can pass
> > slub_max_order=0 on the command line and see if it helps.
> 
> Hi David,
> 
> we have recompiled the kernel of one machine with CONFIG_SLUB instead of 
> CONFIG_SLAB, but it is showing similar message.
> 
> Now it's showing failure at "order:5, mode:0x4020".
> 
> Call trace can be found at:
> * http://pastebin.com/uGJiwvG1
> 
> Comparing kernel 2.6.32 (mm/page_alloc.c) there seams to be the same way 
> of dealing with page allocation.
> 
> Do you have an idea why these (warning) messages do never appear running 
> 2.6.32?

Your tg3 has a firmware limitation, and some skbs using fragments have
to be reallocated using a single and contiguous area of memory.

Initial skb delivered by tcp stack only uses order-0 pages, but the
reallocated one, being 64K, can be order-5

You can avoid this by following tuning :

ethtool -K eth0 sg off



