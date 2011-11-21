Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111Ab1KURzX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 12:55:23 -0500
Received: from 184-106-247-128.static.cloud-ips.com ([184.106.247.128]:42670
	"EHLO cloud01.chad-versace.us" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751178Ab1KURzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 12:55:22 -0500
X-Spam-Flag: NO
X-Spam-Score: -1
Date: Mon, 21 Nov 2011 09:55:07 -0800
From: Ben Widawsky <ben@bwidawsk.net>
To: intel-gfx <intel-gfx@lists.freedesktop.org>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 02/13] drm/i915: rewrite shmem_pwrite_slow to
 use copy_from_user
Message-ID: <20111121175503.GA18843@bolo_yeung.jf.intel.com>
References: <1320606840-21132-1-git-send-email-daniel.vetter@ffwll.ch>
 <1320606840-21132-3-git-send-email-daniel.vetter@ffwll.ch>
 <20111120215632.6982c55c@bwidawsk.net>
 <20111121160244.GA3807@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111121160244.GA3807@phenom.ffwll.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 05:02:44PM +0100, Daniel Vetter wrote:
> On Sun, Nov 20, 2011 at 09:56:32PM -0800, Ben Widawsky wrote:
> [snip the patch]
> > Bikeshed, but I would much prefer a #define for the swizzle
> > bit/cacheline size.
> 
> I've looked at this stuff way too long, so I'm biased, but 64 = cacheline
> = dram fetch size = 1 << 64 feels about as natural for me as 4096 =
> PAGE_SIZE ...
> 
> [snip the patch]
> 
> > I must be missing something obvious here...
> > Can you explain how this can possibly be considered safe without holding
> > struct_mutex?
> 
> That's the reason why the commit msg goes through every case and explains
> why I think it's safe. The large thing here is that we need to drop the
> mutex when calling copy_*_user (at least in the non-atomic slow-paths)
> because otherwise we might deadlock with our own pagefault handler.
> -Daniel

The part about dropping struct_mutex is clear to me.

The bit that I'm missing, I just don't see how you guarantee the page
you're reading from (assuming it's a GTT mmapped page) doesn't get moved
from out under you. For instance if the page isn't there when you do the
initial __copy_from_user, it will get faulted in... cool - but what if
somewhere in that loop the object gets swapped out and something else is
put in it's place? How is that prevented?

Sorry if it's a stupid question, I just don't get it.
Ben
