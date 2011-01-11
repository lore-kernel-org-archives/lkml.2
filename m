Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077Ab1AKMov (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 07:44:51 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:54802 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756059Ab1AKMos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 07:44:48 -0500
X-IronPort-AV: E=Sophos;i="4.60,307,1291593600"; 
   d="scan'208";a="3701365"
Date: Tue, 11 Jan 2011 12:44:39 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Subject: Re: [PATCH 05/12] xen: add m2p override mechanism
In-Reply-To: <20110110231121.GB16550@dumpdata.com>
Message-ID: <alpine.DEB.2.00.1101111202020.7277@kaball-desktop>
References: <alpine.DEB.2.00.1101101012190.2390@kaball-desktop> <1294655801-16230-5-git-send-email-stefano.stabellini@eu.citrix.com> <20110110231121.GB16550@dumpdata.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Jan 2011, Konrad Rzeszutek Wilk wrote:
> > @@ -83,6 +85,14 @@ static inline unsigned long mfn_to_pfn(unsigned long mfn)
> >  	 */
> >  	__get_user(pfn, &machine_to_phys_mapping[mfn]);
> >  
> > +	/*
> > +	 * If this appears to be a foreign mfn (because the pfn
> > +	 * doesn't map back to the mfn), then check the local override
> > +	 * table to see if there's a better pfn to use.
> > +	 */
> > +	if (get_phys_to_machine(pfn) != mfn)
> 
> Any reason to not use 'pfn_to_mfn' call instead? If we do want
> to use the get_hhys_to_machine wouldn't be easier to just
> check for 'FOREIGN_FRAME_BIT' set? Or is just mostly a copy-n-paste
> of mfn_to_local_pfn?


pfn in this case is the return value of m2p(mfn); there are 3 possible
cases:

1) the mfn was a regular ram page belonging to the domain so
get_phys_to_machine(pfn) == mfn. Nothing to see here.

2) the mfn was a granted page so pfn is actually the pfn in the source
domain and doesn't mean anything in our domain. 
In this case get_phys_to_machine(pfn) is always different from mfn,
either because the mapping in our domain is just different or because
the FOREIGN_FRAME_BIT is set.

3) the pfn belongs to a 1:1 region. In this case
get_phys_to_machine(pfn) != mfn because of the IDENTITY_FRAME_BIT but we
don't actually want to look in the m2p_override because we are not going
to find anything useful there.


Considering all this, I propose this change:

if (get_phys_to_machine(pfn) != mfn)

into

if (pfn_to_mfn(pfn) != mfn)

because:

- it won't make any differences in case 1);

- it will avoid false potives in case 3);

- in case 2) if p2m(pfn) => mfn in both the source and the destination
domain then we might skip the check in the m2p_override but we don't
care because by luck we got the correct value anyway (m2p(mfn) ==
m2p_override(mfn)).



However I understand that it might be subtle and needs a very long
comment so a simpler alternative would be to explicitly remove the
IDENTITY_FRAME_BIT from the check:

if ((get_phys_to_machine(pfn) & ~IDENTITY_FRAME_BIT) != mfn)

