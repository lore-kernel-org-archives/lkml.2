Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461Ab1GMNU5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 09:20:57 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:64558 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114Ab1GMNU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 09:20:56 -0400
Date: Wed, 13 Jul 2011 09:20:38 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: Keir Fraser <keir@xen.org>, Jan Beulich <jbeulich@novell.com>,
        Olaf Hering <olaf@aepfle.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [Xen-devel] [PATCH] xen: update machine_to_phys_order on resume
Message-ID: <20110713132037.GC7618@dumpdata.com>
References: <20110701104148.GA32729@aepfle.de>
 <20110712164342.GA12867@aepfle.de>
 <20110712181118.GA18662@dumpdata.com>
 <1310548364.634.355.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310548364.634.355.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090208.4E1D9BB1.00C5:SCFSTAT5015188,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 13, 2011 at 10:12:44AM +0100, Ian Campbell wrote:
> On Tue, 2011-07-12 at 19:11 +0100, Konrad Rzeszutek Wilk wrote:
> > On Tue, Jul 12, 2011 at 06:43:42PM +0200, Olaf Hering wrote:
> > > 
> > > Migration of pv guests fails, the guest crashes on the target host once the
> > > guest is unpaused after transit. It happens when the guest is started on a
> > > small systen, then migrated from that small system to a large system.
> > > If the guest is started on a large system, then migrated to a small system and
> > > back to the large system, the migration will be successful.
> > > 
> > > The issue is that mfn_to_pfn() makes use of machine_to_phys_order, which
> > > is only configured once early in the boot process. After migration to a
> > > large host the mfns will exceed the order from the small system and a
> > > wrong code path is taken.
> > > 
> > > Calling xen_setup_machphys_mapping() again in the resume path will avoid
> > > the crash.
> > 
> > Oh, duh!
> > 
> > Let me queue that up for 3.0-rc7 unless there are objections?
> 
> It's not so much an objection to this patch but this issue seems to have
> been caused by Xen cset 20892:d311d1efc25e which looks to me like a
> subtle ABI breakage for guests. Perhaps we should introduce a feature
> flag to indicate that a guest can cope with the m2p changing size over
> migration like this?

Sounds reasonable to me.. I will wait (I can always submit it during 3.1 cycle
and CC stable@kernel.org to backport it to 3.0.1).

Jan, you are the one who came up with the c/s - what's your thought?
How does your kernel handle the changing size of the M2P - like the patch below?
> 
> Ian.
> 
> > 
> > > 
> > > Signed-off-by: Olaf Hering <olaf@aepfle.de>
> > > 
> > > ---
> > >  arch/x86/xen/mmu.c     |    2 +-
> > >  arch/x86/xen/suspend.c |    2 ++
> > >  2 files changed, 3 insertions(+), 1 deletion(-)
> > > 
> > > Index: linux-3.0-rc7/arch/x86/xen/mmu.c
> > > ===================================================================
> > > --- linux-3.0-rc7.orig/arch/x86/xen/mmu.c
> > > +++ linux-3.0-rc7/arch/x86/xen/mmu.c
> > > @@ -1623,7 +1623,7 @@ static void __init xen_map_identity_earl
> > >  	set_page_prot(pmd, PAGE_KERNEL_RO);
> > >  }
> > >  
> > > -void __init xen_setup_machphys_mapping(void)
> > > +void xen_setup_machphys_mapping(void)
> > >  {
> > >  	struct xen_machphys_mapping mapping;
> > >  	unsigned long machine_to_phys_nr_ents;
> > > Index: linux-3.0-rc7/arch/x86/xen/suspend.c
> > > ===================================================================
> > > --- linux-3.0-rc7.orig/arch/x86/xen/suspend.c
> > > +++ linux-3.0-rc7/arch/x86/xen/suspend.c
> > > @@ -43,6 +43,8 @@ void xen_arch_hvm_post_suspend(int suspe
> > >  
> > >  void xen_arch_post_suspend(int suspend_cancelled)
> > >  {
> > > +	xen_setup_machphys_mapping();
> > > +
> > >  	xen_build_mfn_list_list();
> > >  
> > >  	xen_setup_shared_info();
> > > 
> > > _______________________________________________
> > > Xen-devel mailing list
> > > Xen-devel@lists.xensource.com
> > > http://lists.xensource.com/xen-devel
> > 
> > _______________________________________________
> > Xen-devel mailing list
> > Xen-devel@lists.xensource.com
> > http://lists.xensource.com/xen-devel
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
