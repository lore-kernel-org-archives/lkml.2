Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751311Ab0ELCIE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 22:08:04 -0400
Received: from mailgw.tensilica.com ([65.119.96.134]:59682 "EHLO
	mailgw.tensilica.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704Ab0ELCIB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 22:08:01 -0400
From: Marc Gauthier <marc@tensilica.com>
To: Mike Frysinger <vapier.adi@gmail.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Johannes Weiner <jw@emlix.com>, Christoph Lameter <cl@linux.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oskar Schirmer <os@emlix.com>,
       Michael Hennerich <Michael.Hennerich@analog.com>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       =?iso-8859-1?Q?Daniel_Gl=F6ckner?= <dg@emlix.com>,
       Oliver Schneidewind <osw@emlix.com>, Nick Piggin <npiggin@suse.de>,
       David Rientjes <rientjes@google.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Grant Likely <grant.likely@secretlab.ca>,
       Chris Zankel <chris@zankel.net>,
       Piet Delaney <Piet.Delaney@tensilica.com>
Date: Tue, 11 May 2010 19:07:35 -0700
Subject: RE: [LKML] Re: [PATCH v3] ad7877: keep dma rx buffers in seperate
 cache lines
Thread-Topic: [LKML] Re: [PATCH v3] ad7877: keep dma rx buffers in seperate
 cache lines
Thread-Index: AcrxXBPdnAql3IckSl+n+z/qA4UMSAAGj5zw
Message-ID: <522C1DF17AF50042AD8AE87F7887BD3D0163549554@exch.hq.tensilica.com>
References: <20100511063309.GC9644@core.coreip.homeip.net>
 	<AANLkTinV79HZqS1cktHDsTsHDel-0Nti_Uk4i7mGaRiK@mail.gmail.com>
 	<1273608441.15067.1002.camel@calx>
 <AANLkTimt-eRCt_HTq7OUwzG1dgRuzJHk1tlgOcq4ocL7@mail.gmail.com>
 	<alpine.DEB.2.00.1005111520260.1500@router.home>
 <AANLkTilEfZLWYxPmCQ1KHIvUGIF_8Qchali66wHNf2gB@mail.gmail.com>
 	<alpine.DEB.2.00.1005111544330.8388@router.home>
 <AANLkTimzxrZyQAfocTwIt5zCVyXP7bReKOvP4K7m8epO@mail.gmail.com>
 	<20100511214836.GH1726@emlix.com>
 <20100511215359.GF7396@core.coreip.homeip.net>
 <AANLkTimm7bOmIz2sdODgHwtCk26kdHgZt7PvceM6gjS3@mail.gmail.com>
In-Reply-To: <AANLkTimm7bOmIz2sdODgHwtCk26kdHgZt7PvceM6gjS3@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger wrote:
> lets look at the cacheline sizes for arches that dont set
> ARCH_KMALLOC_MINALIGN to L1_CACHE_BYTES:
>  - alplha - 32 or 64
>  - frv - 32 or 64
>  - blackfin - 32
>  - parisc - 32 or 64
>  - mn10300 - 16
>  - s390 - 256
>  - score - 16
>  - sparc - 32
>  - xtensa - 16 or 32
>
> assuming alpha and s390 handle cache coherency in hardware, it looks
> to me like the proposed assumption (kmalloc returns cachealigned
> pointers when cache management is in software) does not hold true.
>
> so should these other arches also be setting ARCH_KMALLOC_MINALIGN to
> L1_CACHE_BYTES ?

IMHO, yes.  It just makes sense to avoid false-sharing issues, not to
allocate unrelated blocks in the same cache line.

Also as it turns out (hope he doesn't me telling), Christian Zankel
recently found a bug that was fixed exactly that way, by setting
ARCH_KMALLOC_MINALIGN to L1_CACHE_BYTES for the Xtensa architecture.
(Too recent to have percolated to mainline.)

A lot of the above might be cache line aligned (?).

-Marc
