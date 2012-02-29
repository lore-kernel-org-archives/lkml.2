Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030848Ab2B2Hhl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 02:37:41 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:38484 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755793Ab2B2Hhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 02:37:39 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of penberg@gmail.com designates 10.112.54.36 as permitted sender) smtp.mail=penberg@gmail.com; dkim=pass header.i=penberg@gmail.com
Date: Wed, 29 Feb 2012 09:37:23 +0200 (EET)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Rafael Aquini <aquini@redhat.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Christoph Lameter <cl@linux-foundation.org>,
        Matt Mackall <mpm@selenic.com>, Rik van Riel <riel@redhat.com>,
        Josef Bacik <josef@redhat.com>, David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] mm: SLAB Out-of-memory diagnostics
In-Reply-To: <20120229032715.GA23758@t510.redhat.com>
Message-ID: <alpine.LFD.2.02.1202290934020.4850@tux.localdomain>
References: <20120229032715.GA23758@t510.redhat.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Feb 2012, Rafael Aquini wrote:
> Following the example at mm/slub.c, add out-of-memory diagnostics to the SLAB
> allocator to help on debugging OOM conditions. This patch also adds a new
> sysctl, 'oom_dump_slabs_forced', that overrides the effect of __GFP_NOWARN page
> allocation flag and forces the kernel to report every slab allocation failure.
> 
> An example print out looks like this:
> 
>   <snip page allocator out-of-memory message>
>   SLAB: Unable to allocate memory on node 0 (gfp=0x11200)
>      cache: bio-0, object size: 192, order: 0
>      node0: slabs: 3/3, objs: 60/60, free: 0
> 
> Signed-off-by: Rafael Aquini <aquini@redhat.com>
> ---
>  Documentation/sysctl/vm.txt |   23 ++++++++++++++++++
>  include/linux/slab.h        |    2 +
>  kernel/sysctl.c             |    9 +++++++
>  mm/slab.c                   |   55 ++++++++++++++++++++++++++++++++++++++++++-
>  4 files changed, 88 insertions(+), 1 deletions(-)

No SLUB support for this?

> diff --git a/Documentation/sysctl/vm.txt b/Documentation/sysctl/vm.txt
> index 96f0ee8..75bdf91 100644
> --- a/Documentation/sysctl/vm.txt
> +++ b/Documentation/sysctl/vm.txt
> @@ -498,6 +498,29 @@ this is causing problems for your system/application.
>  
>  ==============================================================
>  
> +oom_dump_slabs_forced
> +
> +Overrides the effects of __GFP_NOWARN page allocation flag, thus forcing
> +the system to print warnings about every allocation failure for the
> +slab allocator, and helping on debugging certain OOM conditions.
> +The print out is pretty similar, and complements data that is reported by
> +the page allocator out-of-memory warning:
> +
> +<snip page allocator out-of-memory message>
> +  SLAB: Unable to allocate memory on node 0 (gfp=0x11200)
> +     cache: bio-0, object size: 192, order: 0
> +     node0: slabs: 3/3, objs: 60/60, free: 0
> +
> +If this is set to zero, the default behavior is observed and warnings will only
> +be printed out for allocation requests that didn't set the __GFP_NOWARN flag.
> +
> +When set to non-zero, this information is shown whenever the allocator finds
> +itself failing to grant a request, regardless the __GFP_NOWARN flag status.
> +
> +The default value is 0 (disabled).
> +
> +==============================================================
> +

Why do you want to add a sysctl for this? That'd be an ABI that we need to 
keep around forever.

Is there any reason we shouldn't just enable this unconditionally?

			Pekka
