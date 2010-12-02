Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336Ab0LBCnx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 21:43:53 -0500
Received: from mga11.intel.com ([192.55.52.93]:60579 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754664Ab0LBCnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 21:43:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,285,1288594800"; 
   d="scan'208";a="863382133"
Subject: Re: [patch 1/3]make readmostly section correctly align
From: Shaohua Li <shaohua.li@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "sam@ravnborg.org" <sam@ravnborg.org>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>
In-Reply-To: <20101201182854.dd70bdf2.akpm@linux-foundation.org>
References: <1291255341.12777.115.camel@sli10-conroe>
	 <20101201182854.dd70bdf2.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Dec 2010 10:43:50 +0800
Message-ID: <1291257830.12777.125.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-02 at 10:28 +0800, Andrew Morton wrote:
> On Thu, 02 Dec 2010 10:02:21 +0800 Shaohua Li <shaohua.li@intel.com> wrote:
> 
> > readmostly section should end at cache line aligned address, otherwise the last
> > several data might share cachline with other data and make the readmostly data
> > still have cache bounce.
> > For example, in ia64, secpath_cachep is the last readmostly data, and it shares
> > cacheline with init_uts_ns.
> > a000000100e80480 d secpath_cachep
> > a000000100e80488 D init_uts_ns
> > 
> > Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> > 
> > ---
> >  include/asm-generic/vmlinux.lds.h |    3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > Index: linux/include/asm-generic/vmlinux.lds.h
> > ===================================================================
> > --- linux.orig/include/asm-generic/vmlinux.lds.h	2010-12-01 16:49:48.000000000 +0800
> > +++ linux/include/asm-generic/vmlinux.lds.h	2010-12-02 09:22:32.000000000 +0800
> > @@ -192,7 +192,8 @@
> >  
> >  #define READ_MOSTLY_DATA(align)						\
> >  	. = ALIGN(align);						\
> > -	*(.data..read_mostly)
> > +	*(.data..read_mostly)						\
> > +	. = ALIGN(align);
> >  
> >  #define CACHELINE_ALIGNED_DATA(align)					\
> >  	. = ALIGN(align);						\
> > 
> 
> Surely the sane way to do this is to ensure that each section *starts*
> at an at-least-cacheline aligned address and then not worry about how
> the section ends.  So shouldn't we be fixing DATA_DATA?
Some archs don't use DATA_DATA but directly use READ_MOSTLY_DATA, so I
change READ_MOSTLY_DATA.

> With your approach, .data may end up sharing a cacheline with
> some other section in some undesirable manner on a different arch.
> 
> "fixing" DATA_DATA would involve page-aligning it, which sucks a bit. 
> Things would be better if include/asm-generic/vmlinux.lds.h had access
> to a globally-agreed cacheline-size, as it does the page size.
yes, there isn't a well defined cacheline-size for vmlinux.lds.h.

> otoh, .data.read_mostly is "special", in that it wants the tail end of
> its last cacheline not to share with any other section.  Most other
> sections aren't like that.
yes, other sections don't need to be so.

Thanks,
Shaohua

