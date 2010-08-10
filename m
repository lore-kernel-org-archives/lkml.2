Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932220Ab0HJPNS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 11:13:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:5404 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932129Ab0HJPNN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 11:13:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,348,1278313200"; 
   d="scan'208";a="543702597"
Date: Tue, 10 Aug 2010 11:13:06 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: David Miller <davem@davemloft.net>
Cc: cmetcalf@tilera.com, willy@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: perf build broke by list_head changes...
Message-ID: <20100810151306.GC6981@wil.cx>
References: <20100809.235746.115919762.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100809.235746.115919762.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 09, 2010 at 11:57:46PM -0700, David Miller wrote:
> Commit:
> 
> commit de5d9bf6541736dc7ad264d2b5cc99bc1b2ad958
> Author: Chris Metcalf <cmetcalf@tilera.com>
> Date:   Fri Jul 2 13:41:14 2010 -0400
> 
>     Move list types from <linux/list.h> to <linux/types.h>.
> 
> broke the build of 'perf'.
> 
> If you move "struct list_head" into types.h, this means perf stops
> building because it depends upon being able to include linux/list.h
> from a userland application and at the same time be able to get the
> basic data types without defining __KERNEL__ or similar.

Sorry about that.  Obviously, I didn't test-build this patch.

> Now that no longer occurs because the bulk of types.h is __KERNEL__
> protected and thus the build breaks since "struct list_head" is
> never defined.

list.h isn't a header-y file, so it's not an interface we expect userspace
to use.  So one reasonable way to fix this is for perf to take its own copy.

Reverting the patch gets us back to the former problem (of not being
able to use list.h in certain cases).

We could do a glibc-like _WANT_LIST_HEAD macro.  I don't think the
resulting uglification is reasonable.

perf could pretend that it's real userspace instead of being part of
the kernel and use a list implementation designed for userspace.  I
don't know of a good one though.

Any preferences which solution we take?
