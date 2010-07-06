Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460Ab0GFISW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 04:18:22 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44020 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310Ab0GFISU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 04:18:20 -0400
MIME-Version: 1.0
In-Reply-To: <20100707040734.05d625af@debxo>
References: <20100628215407.2017bf2f@debian> <20100628220037.5744c207@debian> 
	<AANLkTilN3_ntG7AWKi-8LM9X_dZJPPlWM6xRM_V_00xU@mail.gmail.com> 
	<20100629110324.2756cc02@debian> <AANLkTinPsrqxj5oQirEDRvVOuOeWgWSdljsMRbw8wn8V@mail.gmail.com> 
	<20100629193618.5a840b8e@dev.queued.net> <AANLkTilme2uAoXjorUEzam9j_xosR8kl70W8PS71d-Th@mail.gmail.com> 
	<20100707040734.05d625af@debxo>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 6 Jul 2010 02:17:59 -0600
X-Google-Sender-Auth: _Y5gc6DgBlRZyr3FMsSmHiBC4V0
Message-ID: <AANLkTinK40AAe-sZKAbkvELo737yfrSlX4HNLoWvHnqN@mail.gmail.com>
Subject: Re: [PATCH 2/4] sparc: break out some prom device-tree building code 
	out into drivers/of
To: Andres Salomon <dilinger@queued.net>
Cc: devicetree-discuss@lists.ozlabs.org, sparclinux@vger.kernel.org,
       x86@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       cjb@laptop.org, Mitch Bradley <wmb@laptop.org>, pgf@laptop.org,
       linux-kernel@vger.kernel.org, davem@davemloft.net,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 6, 2010 at 10:07 PM, Andres Salomon <dilinger@queued.net> wrote:
> On Wed, 30 Jun 2010 15:52:51 -0600
> Grant Likely <grant.likely@secretlab.ca> wrote:
>  - For the pdt, calling into the prom twice for each property/node,
>   getting the size of everything during the first tree traversal,
>   allocating memory, and then creating the tree during the second
>   traversal. This is slow and I don't see much point to it.
>
>  - For the pdt, calling into the prom once for each property/node to
>   create a fdt, and then unflattening it.  This is better than the
>   previous option, but I don't think the prom->fdt code will be very
>   nice.

No, don't do this.  It will be ugly.

>  - Changing the fdt code to allocate memory more dynamically; rather
>   than a first run through the fdt to determine the unflattened tree
>   size, simply allocate memory chunks as we run through the tree.
>   Memory might still be backed the same way (calling
>   early_init_dt_alloc_memory_arch to grab a chunk of memory, and then
>   allocating chunks of it via unflatten_dt_alloc), but the difference
>   would be that it wouldn't necessarily be contiguous, and in how it's
>   done.  For example, early_init_dt_alloc_memory_arch might be called
>   initially to allocate a 16k chunk, and once unflatten_dt_alloc runs
>   out of memory in that chunk, another 16k chunk might be allocated.
>   This would also translate to sparc's prom_early_alloc being used to
>   allocate the chunk, and then node/property structs being
>   allocated from those chunks.  (The 16k choice
>   is completely arbitrary; people more familiar w/ the early memory
>   setup of ppc/sparc might have a better suggestion)

I'm fine with option 3, but it is more complicated and the code for
option 1 already exists.  In fact, option 1 is almost of a
pre-requisite for doing option 3.  It makes sense to get the
double-pass method factored out of powerpc and working before
attempting the performance enhancement of option 3.

Note however, the fdt data format parser expects a single contiguous
region.  You'll want to copy it into a single region before parsing
it.

That Being Said....

I just finished talking with Ben about the parser code.  There is no
immediate imperative to generalizing the powerpc OF->fdt->unflatten
code (unless David decides it makes sense for sparc too), and the
possibility of an ARM machine using it is theoretical enough that I'm
just not going to waste cycles thinking about it.  If the situation
changes in a couple of year or two, then it can be refactored.

That clears the way for your original pdt patch.  It will need to be
respun for Stephen's CONFIG_OF changes, and I have some other
comments, but I'll reply to the patches directly for those.

Cheers,
g.
