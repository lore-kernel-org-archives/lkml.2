Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758207Ab1DASOS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 14:14:18 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:5990 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756921Ab1DASOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 14:14:17 -0400
X-IronPort-AV: E=Sophos;i="4.63,283,1299456000"; 
   d="scan'208";a="5102030"
Date: Fri, 1 Apr 2011 19:14:55 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Yinghai Lu <yinghai@kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Ingo Molnar <mingo@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Michael Leun <lkml20101129@newton.leun.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Mike Pagano <mpagano@gentoo.org>
Subject: Re: 2.6.38.2 breaks suspend to disk
In-Reply-To: <4D95FBDD.9050901@zytor.com>
Message-ID: <alpine.DEB.2.00.1104011729000.16492@kaball-desktop>
References: <20110330203215.0a1a41a7@xenia.leun.net> <20110331090524.07ad0069@xenia.leun.net> <alpine.DEB.2.00.1103311546480.16492@kaball-desktop> <201103312348.53678.rjw@sisk.pl> <4D94FE37.8070109@kernel.org> <alpine.DEB.2.00.1104011230550.16492@kaball-desktop>
 <4D95F80D.7070201@kernel.org> <4D95FBDD.9050901@zytor.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Apr 2011, H. Peter Anvin wrote:
> On 04/01/2011 09:06 AM, Yinghai Lu wrote:
> > Index: linux-2.6/arch/x86/kernel/setup.c
> > ===================================================================
> > --- linux-2.6.orig/arch/x86/kernel/setup.c
> > +++ linux-2.6/arch/x86/kernel/setup.c
> > @@ -294,10 +294,17 @@ static void __init init_gbpages(void)
> >      else
> >          direct_gbpages = 0;
> >  }
> > +static void __init store_mmu_cr4(void)
> > +{
> > +    mmu_cr4_features = read_cr4();
> > +}
> >  #else
> >  static inline void init_gbpages(void)
> >  {
> >  }
> > +static void __init store_mmu_cr4(void)
> > +{
> > +}
> >  static void __init cleanup_highmap(void)
> >  {
> >  }
> > @@ -929,6 +936,8 @@ void __init setup_arch(char **cmdline_p)
> >      /* max_pfn_mapped is updated here */
> >      max_low_pfn_mapped = init_memory_mapping(0, max_low_pfn<<PAGE_SHIFT);
> >      max_pfn_mapped = max_low_pfn_mapped;
> > +    /* after init_memory_mapping updating cr4*/
> > +    store_mmu_cr4();
> >  
> >  #ifdef CONFIG_X86_64
> >      if (max_pfn > max_low_pfn) {
> 
> This looks really, really, really wrong.
> 
> Why the heck should we save and restore CR4 only for x86-64?

AFAICT it has always been the case since the beginning of time (Initial
git repository build).
