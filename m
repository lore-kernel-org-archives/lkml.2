Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116Ab1HXN6E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 09:58:04 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:21519 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750767Ab1HXN6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 09:58:00 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Qkj2PmMVM1nYSwfjlJHDqVfC3HiyLzInV6XVtkpGd.jlYtw
 1tmVUTSZ6xKX9ftaLcxpsopjISoWr.bDP8scP0LriWPI6Rr9dbuBh4Namykv
 9c79unD1_isynkNKtrp2bZGrjLdGfYn_du0WEtiiwhAOMeTxqSUCAZ63eyFx
 M01BF.l7v7ZR.H6N.TH2sPePcLT5AirInPUfXXQSPT1Dhl5v9ycdBaY4QXB_
 y55hkHP3A9C4XPwSpZWN6OQWR9QXQGQlqxStYROGlnh0BJINTZNHCgxuPny2
 HFX7VkCHH3a_Yl76vKmU2WP0MZnsm8TqoIvkZ8mW8sRZG76wakH0adr17IFd
 wCtNRwP9hMH7VBiEGRgXee4xT1dlhUayzekx2UG74R2oBGw--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 24 Aug 2011 08:57:55 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Lin Ming <ming.m.lin@intel.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
        David Rientjes <rientjes@google.com>, Andi Kleen <andi@firstfloor.org>,
        tj@kernel.org, Metathronius Galabant <m.galabant@googlemail.com>,
        Matt Mackall <mpm@selenic.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        Adrian Drzewiecki <z@drze.net>, "Li, Shaohua" <shaohua.li@intel.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [slub p4 6/7] slub: per cpu cache for partial pages
In-Reply-To: <1314170783.5245.24.camel@minggr.sh.intel.com>
Message-ID: <alpine.DEB.2.00.1108240856060.24118@router.home>
References: <20110809211221.831975979@linux.com>  <20110809211302.222722588@linux.com>  <CAF1ivSaH9fh6_QvuBkLc5t=zC4mPEAD5ZzsxOuPruDwG9MiZzw@mail.gmail.com> <1314170783.5245.24.camel@minggr.sh.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Aug 2011, Lin Ming wrote:

> > Potential future enhancements:
> >
> > 1. The pickup from the partial list could be perhaps be done without disabling
> >   interrupts with some work. The free path already puts the page into the
> >   per cpu partial list without disabling interrupts.
>
> Nice patches!
>
> Could you share possible ways for this potential enhancement?

In order to avoid disabling interrupts in the allocation paths the state
that has to be kept in kmem_cache_cpu needs to be minimized so that it can
be swapped atomically using a this_cpu_cmpxchg. This means getting rid of
the node and slab fields I guess. Working on some patches to that effect.

Once that is done one can with a this_cpu_cmpxchg_double take over the per
cpu slab and then use that information to update the slab page etc.

