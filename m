Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758618Ab0EEVdu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 17:33:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38601 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752752Ab0EEVds (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 17:33:48 -0400
Date: Wed, 5 May 2010 23:33:45 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: Greg KH <gregkh@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>,
       "stable-review@kernel.org" <stable-review@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Renninger <trenn@suse.de>,
       Jiri Benc <jbenc@suse.cz>,
       "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
       "Ostrovsky, Boris" <Boris.Ostrovsky@amd.com>
Subject: Re: [113/197] x86, cacheinfo: Calculate L3 indices
In-Reply-To: <20100505180228.GC15804@aftab>
Message-ID: <alpine.LNX.2.00.1005052328000.9849@pobox.suse.cz>
References: <20100422190917.467545308@kvm.kroah.org> <alpine.LNX.2.00.1005051736080.9849@pobox.suse.cz> <20100505180228.GC15804@aftab>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 May 2010, Borislav Petkov wrote:

> > From: Jiri Kosina <jkosina@suse.cz>
> > Subject: [PATCH] x86, cacheinfo: fix oops in amd_calc_l3_indices()
> > 
> > Commit 048a8774ca4348 ("x86, cacheinfo: Calculate L3 indices") introduced
> > amd_calc_l3_indices(), but this function doesn't properly handle case
> > when node_to_k8_nb_misc() returns NULL, causing immediate oops due to
> > NULL pointer dereference in pci_read_config_dword().
> > 
> > Make amd_calc_l3_indices() return -1 in such cases. This is correct
> > lower bound, as it will make store_cache_disable() return EINVAL in
> > all such cases.
> > 
> > Cc: stable@kernel.org
> > Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> > ---
> >  arch/x86/kernel/cpu/intel_cacheinfo.c |    3 +++
> >  1 files changed, 3 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
> > index b3eeb66..b9f8dca 100644
> > --- a/arch/x86/kernel/cpu/intel_cacheinfo.c
> > +++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
> > @@ -314,6 +314,9 @@ static unsigned int __cpuinit amd_calc_l3_indices(void)
> >  	unsigned int sc0, sc1, sc2, sc3;
> >  	u32 val = 0;
> >  
> > +	if (!dev)
> > +		return -1;
> > +
> 
> This won't fly since the function returns an unsigned value and the L3
> code would still be entered, which is what you don't want actually when
> k8_northbridges initialization has somehow failed.

Yeah, you are right, returning -1 is bogus as well.

The point is though, that we really should be checking for return value of 
node_to_k8_nb_misc() as it can legitimately return NULL, can't it? (and 
other places, such as show_cache_disable() and store_cache_disable(), are 
checking for this being NULL properly).

> Rather, we have a fix already which should take care of your issue too,
> see http://git.kernel.org/tip/f2b20e41407fccfcfacf927ff91ec888832a37af
> 
> I was waiting for it to hit mainline before I backport it to stable and
> it would be helpful if you could verify that it works for you along with
> 0e152cd7c16832bd5cadee0c2e41d9959bc9b6f9 you sent earlier.

Will let you know.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
