Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753029Ab2KSWZT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 17:25:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52292 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346Ab2KSWZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 17:25:18 -0500
Date: Mon, 19 Nov 2012 14:25:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Bob Liu <lliubbo@gmail.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        sjenning@linux.vnet.ibm.com, dan.magenheimer@oracle.com,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, ngupta@vflare.org, minchan@kernel.org,
        mgorman@suse.de, fschmaus@gmail.com, andor.daam@googlemail.com,
        ilendir@googlemail.com
Subject: Re: [PATCH 2/8] mm: frontswap: lazy initialization to allow tmem
 backends to build/run as modules
Message-Id: <20121119142516.b2936a7c.akpm@linux-foundation.org>
In-Reply-To: <CAA_GA1crg1ngNx2MAv-fJbgKYqSKmkapZHq=8F4QcNgFja1A-w@mail.gmail.com>
References: <1352919432-9699-1-git-send-email-konrad.wilk@oracle.com>
	<1352919432-9699-3-git-send-email-konrad.wilk@oracle.com>
	<20121116151619.aa60acff.akpm@linux-foundation.org>
	<CAA_GA1crg1ngNx2MAv-fJbgKYqSKmkapZHq=8F4QcNgFja1A-w@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Nov 2012 08:53:46 +0800
Bob Liu <lliubbo@gmail.com> wrote:

> On Sat, Nov 17, 2012 at 7:16 AM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > On Wed, 14 Nov 2012 13:57:06 -0500
> > Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> >
> >> From: Dan Magenheimer <dan.magenheimer@oracle.com>
> >>
> >> With the goal of allowing tmem backends (zcache, ramster, Xen tmem) to be
> >> built/loaded as modules rather than built-in and enabled by a boot parameter,
> >> this patch provides "lazy initialization", allowing backends to register to
> >> frontswap even after swapon was run. Before a backend registers all calls
> >> to init are recorded and the creation of tmem_pools delayed until a backend
> >> registers or until a frontswap put is attempted.
> >>
> >>
> >> ...
> >>
> >> --- a/mm/frontswap.c
> >> +++ b/mm/frontswap.c
> >> @@ -80,6 +80,18 @@ static inline void inc_frontswap_succ_stores(void) { }
> >>  static inline void inc_frontswap_failed_stores(void) { }
> >>  static inline void inc_frontswap_invalidates(void) { }
> >>  #endif
> >> +
> >> +/*
> >> + * When no backend is registered all calls to init are registered and
> >
> > What is "init"?  Spell it out fully, please.
> >
> 
> I think it's frontswap_init().
> swapon will call frontswap_init() and in it we need to call init
> function of backends with some parameters
> like swap_type.

Well, let's improve that comment please.

> >> + * remembered but fail to create tmem_pools. When a backend registers with
> >> + * frontswap the previous calls to init are executed to create tmem_pools
> >> + * and set the respective poolids.
> >
> > Again, seems really hacky.  Why can't we just change callers so they
> > call things in the correct order?
> >
> 
> I don't think so, because it asynchronous.
> 
> The original idea was to make backends like zcache/tmem modularization.
> So that it's more convenient and flexible to use and testing.
> 
> But currently callers like swapon only invoke frontswap_init() once,
> it fail if backend not registered.
> We have no way to notify swap to call frontswap_init() again when
> backend registered in some random time
>  in future.

We could add such a way?

