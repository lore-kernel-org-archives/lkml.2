Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252Ab1BCLXi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 06:23:38 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:46527 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756213Ab1BCLXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 06:23:37 -0500
X-IronPort-AV: E=Sophos;i="4.60,418,1291593600"; 
   d="scan'208";a="4129596"
Date: Thu, 3 Feb 2011 11:25:19 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        Jan Beulich <JBeulich@novell.com>
Subject: Re: [PATCH] x86/mm/init: respect memblock reserved regions when
 destroying mappings
In-Reply-To: <4D4A3782.3050702@zytor.com>
Message-ID: <alpine.DEB.2.00.1102031114030.7277@kaball-desktop>
References: <alpine.DEB.2.00.1101311514580.7277@kaball-desktop> <4D4A3782.3050702@zytor.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Feb 2011, H. Peter Anvin wrote:
> On 01/31/2011 07:18 AM, Stefano Stabellini wrote:
> > x86/mm/init: respect memblock reserved regions when destroying mappings
> > 
> > In init_memory_mapping we are destroying all the mappings between
> > _brk_end and _end, no matter if some memory areas in that range have
> > been reserved using memblock_x86_reserve_range.
> > Besides if _end is not pmd aligned we might destroy the
> > mappings for valid memory between _end and the following pmd.
> > 
> > In order to avoid this problem, before clearing any pmds we check if the
> > corresponding memory area has been reserved and we only destroy the
> > mapping if it hasn't.
> > 
> > We found this problem because under Xen we have a valid mapping at _end,
> > and if _end is not pmd aligned the current code destroys the initial
> > part of it.
> > 
> > In practice this fix does not have any impact on native.
> > 
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> 
> How on Earth would you end up with a reserved region *inside the BRK*?

I think in practice you cannot, but you can have reserved regions at
_end, that is the main problem I am trying to solve.
If we have a reserved region at _end and _end is not PMD aligned, then
we have a problem.

I thought that checking for reserved regions before destroying the
mapping would be a decent solution (because it wouldn't affect the
normal case); so I ended up checking between _brk_end and _end too.

Other alternative solutions I thought about but that I discarded because
they also affect the normal case are:

- never destroy mappings that could go over _end;
- always PMD align _end.

If none of the above are acceptable, I welcome other suggestions :-)

