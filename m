Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759576Ab2HXPUX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 11:20:23 -0400
Received: from www.linutronix.de ([62.245.132.108]:33910 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754672Ab2HXPUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 11:20:19 -0400
Date: Fri, 24 Aug 2012 17:20:13 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Borislav Petkov <bp@alien8.de>, Attilio Rao <attilio.rao@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v4 1/2] XEN/X86: Improve semantic support for
 x86_init.mapping.pagetable_reserve
In-Reply-To: <alpine.DEB.2.02.1208241412040.15568@kaball.uk.xensource.com>
Message-ID: <alpine.LFD.2.02.1208241719030.2856@ionos>
References: <1345648122-11935-1-git-send-email-attilio.rao@citrix.com> <1345648122-11935-2-git-send-email-attilio.rao@citrix.com> <alpine.LFD.2.02.1208231722040.2856@ionos> <50364FE5.1070608@citrix.com> <alpine.LFD.2.02.1208231800530.2856@ionos>
 <503664C3.7010301@citrix.com> <20120824100309.GG3019@liondog.tnic> <20120824113644.GE11007@konrad-lan.dumpdata.com> <alpine.LFD.2.02.1208241446090.2856@ionos> <alpine.DEB.2.02.1208241412040.15568@kaball.uk.xensource.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Aug 2012, Stefano Stabellini wrote:
> On Fri, 24 Aug 2012, Thomas Gleixner wrote:
> > I looked at the whole pgt_buf_* mess and it's amazingly stupid. We
> > could avoid all that dance and make all of that pgt_buf_* stuff static
> > and provide proper accessor functions and hand start, end, top to the
> > reserve function instead of fiddling with global variables all over
> > the place. That'd be a real cleanup and progress.
> > 
> > But we can't do that easily. And why? Because XEN is making magic
> > decisions based on those globals in mask_rw_pte().
> > 
> > 	/*
> > 	 * If the new pfn is within the range of the newly allocated
> > 	 * kernel pagetable, and it isn't being mapped into an
> > 	 * early_ioremap fixmap slot as a freshly allocated page, make sure
> > 	 * it is RO.
> > 	 */
> > 	if (((!is_early_ioremap_ptep(ptep) &&
> > 			pfn >= pgt_buf_start && pfn < pgt_buf_top)) ||
> > 			(is_early_ioremap_ptep(ptep) && pfn != (pgt_buf_end - 1)))
> > 
> > This comment along with the implementation is really a master piece of
> > obfuscation. Let's see what this is doing. RO is enforced when:
> > 
> > This is not an early ioreamp AND
> > 
> >       pfn >= pgt_buf_start && pfn < pgt_buf_top
> > 
> > So why is this checking pgt_buf_top? The early stuff is installed
> > within pgt_buf_start and pgt_buf_end. Anything which is >=
> > pgt_buf_end at this point is completely wrong.
> 
> Unfortunately pgt_buf_end only marks the current end of the pagetable
> pages (pgt_buf_end keeps increasing during
> kernel_physical_mapping_init).  However at some point
> kernel_physical_mapping_init is going to start mapping the pagetable
> pages themselves, when that happens some of them are not pagetable pages
> yet (pgt_buf_end <= page < pgt_buf_top) but they are going to be in the
> near future.

And how exactly are they allocated between from pgt_buf w/o increasing
pgt_buf_end ?

Thanks,

	tglx
