Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933159Ab2HXUKX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 16:10:23 -0400
Received: from www.linutronix.de ([62.245.132.108]:35387 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932890Ab2HXUKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 16:10:18 -0400
Date: Fri, 24 Aug 2012 22:10:01 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Borislav Petkov <bp@alien8.de>, Attilio Rao <attilio.rao@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v4 1/2] XEN/X86: Improve semantic support for
 x86_init.mapping.pagetable_reserve
In-Reply-To: <alpine.DEB.2.02.1208241653550.15568@kaball.uk.xensource.com>
Message-ID: <alpine.LFD.2.02.1208242137260.2856@ionos>
References: <1345648122-11935-1-git-send-email-attilio.rao@citrix.com> <1345648122-11935-2-git-send-email-attilio.rao@citrix.com> <alpine.LFD.2.02.1208231722040.2856@ionos> <50364FE5.1070608@citrix.com> <alpine.LFD.2.02.1208231800530.2856@ionos>
 <503664C3.7010301@citrix.com> <20120824100309.GG3019@liondog.tnic> <20120824113644.GE11007@konrad-lan.dumpdata.com> <alpine.LFD.2.02.1208241446090.2856@ionos> <alpine.DEB.2.02.1208241412040.15568@kaball.uk.xensource.com> <alpine.LFD.2.02.1208241719030.2856@ionos>
 <alpine.DEB.2.02.1208241653550.15568@kaball.uk.xensource.com>
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
> > And how exactly are they allocated between from pgt_buf w/o increasing
> > pgt_buf_end ?
> 
> So let's suppose that we change the check in mask_rw_pte to be:
> 
> pfn >= pgt_buf_start && pfn < pgt_buf_end
> 
> as it was originally. This is what could happen:
> 
> 1) pgt_buf_start - pgt_buf_end gets mapped RO;
> 2) pgt_buf_end - pgt_buf_top gets mapped RW;
> 3) a new pagetable page is allocated, pgt_buf_end is increased;
> 4) this new pagetable page is hooked into the pagetable;
> 5) since a mapping of this page already exists (it was done in
>    point 2), and this mapping is RW, Linux crashes.
> 
> 
> Thanks for taking the time to look into this issue. I know it is
> difficult and not very pleasant.

Indeed, it's a nightmare.

Now all of this is only relevant up to the point where paging_init()
has been done. After that xen_pagetable_setup_done() switches the
set_pte function pointer and the nastyness gets replaced.

Now the functions called up to that point which are relevant to page
table setups are quite limited and we know exactly that we are setting
up an early page table pte. So why don't we use a different
indirection for that? Even if there are functions which are used later
on as well it's not a problem to switch the pointer as you do already
for set_pte.

No weird boundary checks, just a plain native_set_pte for !XEN and a
special case for XEN.

Yes, it's some work to analyse all the relevant code pathes and make
the necessary changes, but that's the only sensible thing to do.

The current magic is doomed for failure and completely
unmaintainable. It's really time to find a proper solution for this
early mapping stuff instead of bandaiding it over and over.

Thanks,

	tglx
