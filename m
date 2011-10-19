Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476Ab1JSB63 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 21:58:29 -0400
Received: from smtp-out.google.com ([74.125.121.67]:41798 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308Ab1JSB61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 21:58:27 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=BuJsQgKJcXaiCCX9KkkRWOiFG7ojbUfNgeAOEXFrd+TahrxfpRU0dnz6Tl1gS4nz2
	VeEfABm8PishriX33ZyYQ==
Date: Tue, 18 Oct 2011 18:58:21 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andi Kleen <andi@firstfloor.org>
cc: p.herz@profihost.ag, linux-kernel@vger.kernel.org
Subject: Re: Vanilla-Kernel 3 - page allocation failure
In-Reply-To: <m2ipnmz49x.fsf@firstfloor.org>
Message-ID: <alpine.DEB.2.00.1110181848150.12850@chino.kir.corp.google.com>
References: <4E9D53FF.7090609@profihost.ag> <m2ipnmz49x.fsf@firstfloor.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Oct 2011, Andi Kleen wrote:

> Philipp Herz - Profihost AG <p.herz@profihost.ag> writes:
> 
> > After updating kernel (x86_64) to stable version 3 there are a few
> > messages appearing in the kernel log such as
> >
> > kworker/0:1: page allocation failure: order:1, mode:0x20
> > mysql: page allocation failure: order:1, mode:0x20
> > php5: page allocation failure: order:1, mode:0x20
> 
> You just ran out of memory.
> 

He ran out of order-1 physically contiguous memory and was unable to 
compact or reclaim because of the atomic context.

Philipp, based on your pastes from another post, it's evident you're using 
CONFIG_SLAB and, unfortunately, it's not possible to change to single 
page allocations (which would only result in a page allocation failure if 
you were completely out of memory) without recompiling.

You have a couple options:

 - recompile with BREAK_GFP_ORDER_HI redefined to 0 in mm/slab.c, or

 - recompile with CONFIG_SLUB instead of CONFIG_SLAB.

It's very possible that neither of these will help, but it will tell you 
whether you need to go out and buy more RAM or not.  If you try to 
recompile with BREAK_GFP_ORDER_HI, these may turn into order-0 
allocations.  If you can't reboot, send the output of 
/proc/<pid>/net/protocols where <pid> is the pid of one of the above tasks 
(kworker, mysql, php5) when they are running and we'll know.

 [ Changing slab_break_gfp_order should really be a CONFIG_SLAB command-
   line option.  It can't be runtime because slab depends on the order for
   caches remaining constant, but we can certainly change it on boot. ]

If you try CONFIG_SLUB instead of CONFIG_SLAB, you can pass 
slub_max_order=0 on the command line and see if it helps.
