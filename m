Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965146Ab1GMJMr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 05:12:47 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:32232 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965124Ab1GMJMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 05:12:46 -0400
X-IronPort-AV: E=Sophos;i="4.65,524,1304294400"; 
   d="scan'208";a="6757848"
Subject: Re: [Xen-devel] [PATCH] xen: update machine_to_phys_order on resume
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Keir Fraser <keir@xen.org>,
        Jan Beulich <jbeulich@novell.com>
CC: Olaf Hering <olaf@aepfle.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
In-Reply-To: <20110712181118.GA18662@dumpdata.com>
References: <20110701104148.GA32729@aepfle.de>
	 <20110712164342.GA12867@aepfle.de>  <20110712181118.GA18662@dumpdata.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Wed, 13 Jul 2011 10:12:44 +0100
Message-ID: <1310548364.634.355.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-12 at 19:11 +0100, Konrad Rzeszutek Wilk wrote:
> On Tue, Jul 12, 2011 at 06:43:42PM +0200, Olaf Hering wrote:
> > 
> > Migration of pv guests fails, the guest crashes on the target host once the
> > guest is unpaused after transit. It happens when the guest is started on a
> > small systen, then migrated from that small system to a large system.
> > If the guest is started on a large system, then migrated to a small system and
> > back to the large system, the migration will be successful.
> > 
> > The issue is that mfn_to_pfn() makes use of machine_to_phys_order, which
> > is only configured once early in the boot process. After migration to a
> > large host the mfns will exceed the order from the small system and a
> > wrong code path is taken.
> > 
> > Calling xen_setup_machphys_mapping() again in the resume path will avoid
> > the crash.
> 
> Oh, duh!
> 
> Let me queue that up for 3.0-rc7 unless there are objections?

It's not so much an objection to this patch but this issue seems to have
been caused by Xen cset 20892:d311d1efc25e which looks to me like a
subtle ABI breakage for guests. Perhaps we should introduce a feature
flag to indicate that a guest can cope with the m2p changing size over
migration like this?

Ian.

> 
> > 
> > Signed-off-by: Olaf Hering <olaf@aepfle.de>
> > 
> > ---
> >  arch/x86/xen/mmu.c     |    2 +-
> >  arch/x86/xen/suspend.c |    2 ++
> >  2 files changed, 3 insertions(+), 1 deletion(-)
> > 
> > Index: linux-3.0-rc7/arch/x86/xen/mmu.c
> > ===================================================================
> > --- linux-3.0-rc7.orig/arch/x86/xen/mmu.c
> > +++ linux-3.0-rc7/arch/x86/xen/mmu.c
> > @@ -1623,7 +1623,7 @@ static void __init xen_map_identity_earl
> >  	set_page_prot(pmd, PAGE_KERNEL_RO);
> >  }
> >  
> > -void __init xen_setup_machphys_mapping(void)
> > +void xen_setup_machphys_mapping(void)
> >  {
> >  	struct xen_machphys_mapping mapping;
> >  	unsigned long machine_to_phys_nr_ents;
> > Index: linux-3.0-rc7/arch/x86/xen/suspend.c
> > ===================================================================
> > --- linux-3.0-rc7.orig/arch/x86/xen/suspend.c
> > +++ linux-3.0-rc7/arch/x86/xen/suspend.c
> > @@ -43,6 +43,8 @@ void xen_arch_hvm_post_suspend(int suspe
> >  
> >  void xen_arch_post_suspend(int suspend_cancelled)
> >  {
> > +	xen_setup_machphys_mapping();
> > +
> >  	xen_build_mfn_list_list();
> >  
> >  	xen_setup_shared_info();
> > 
> > _______________________________________________
> > Xen-devel mailing list
> > Xen-devel@lists.xensource.com
> > http://lists.xensource.com/xen-devel
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xensource.com
> http://lists.xensource.com/xen-devel


