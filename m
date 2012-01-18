Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932155Ab2ARJca (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 04:32:30 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59765 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757028Ab2ARJc0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 04:32:26 -0500
Date: Wed, 18 Jan 2012 10:31:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Greg KH <gregkh@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Sergei Trofimovich <slyich@gmail.com>, linux-kernel@vger.kernel.org,
        Kay Sievers <kay.sievers@vrfy.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@amd64.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>, prasad@linux.vnet.ibm.com,
        Ming Lei <tom.leiming@gmail.com>, Djalal Harouni <tixxdz@opendz.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Andi Kleen <ak@linux.intel.com>,
        gouders@et.bocholt.fh-gelsenkirchen.de,
        Marcos Souza <marcos.mage@gmail.com>, justinmattock@gmail.com,
        Jeff Chua <jeff.chua.linux@gmail.com>
Subject: Re: [PATCH] mce: fix warning messages about static struct mce_device
Message-ID: <20120118093138.GC5842@elte.hu>
References: <20120116224028.GA5072@suse.de>
 <20120117083843.GC13181@elte.hu>
 <20120117155125.GB13778@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120117155125.GB13778@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Greg KH <gregkh@suse.de> wrote:

> On Tue, Jan 17, 2012 at 09:38:43AM +0100, Ingo Molnar wrote:
> > 
> > * Greg KH <gregkh@suse.de> wrote:
> > 
> > > diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
> > > index f35ce43..6aefb14 100644
> > > --- a/arch/x86/include/asm/mce.h
> > > +++ b/arch/x86/include/asm/mce.h
> > > @@ -151,7 +151,7 @@ static inline void enable_p5_mce(void) {}
> > >  
> > >  void mce_setup(struct mce *m);
> > >  void mce_log(struct mce *m);
> > > -DECLARE_PER_CPU(struct device, mce_device);
> > > +extern struct device *mce_device[CONFIG_NR_CPUS];
> > 
> > Minor nit, i don't think we have any other such [CONFIG_NR_CPUS] 
> > pattern in the kernel.
> > 
> > This should be something like:
> > 
> >   DECLARE_PER_CPU(struct device *, mce_device);
> 
> That is what we used to have, but with just a static struct 
> device. [...]

Which was fine in itself for a per CPU data structure - wouldnt 
the warning be fixed by memset()-ing before registering the 
device or such, if device registry absolutely needs a pre-zeroed 
buffer?

I still think there must be some bug/assumption lurking in the 
device layer - do you require all device allocations to be one 
via zalloc()? Seems like a weird and unrobust requirement.

I don't object to the quick fix that gets rid of the warnings, 
but that quick fix came at the price of leaving the real bug 
unfixed and at the price of introducing a new ugliness ;-)

> [...] We really don't need this to be in the per-cpu area, a 
> flat array should be just fine, why can't we use the 
> CONFIG_NR_CPUS value?  Should we use something else?

By that argument we don't really need PER_CPU() areas to begin 
with, a flat [CONFIG_NR_CPUS] array is just fine, right?

Amongst other things we use PER_CPU to have an array of just 2 
elements on a dual core system, even if it boots a 
CONFIG_NR_CPUS=512 distro kernel. That saves RAM, and with 
higher CONFIG_NR_CPUS values it adds up quickly.

> > Or the pointer should be attached to the CPU info structure.
> 
> Ok, I have no objection to that, do you want me to make a 
> patch doing that, now that this is already in Linus's tree?

Would be nice if you could do that or some other equivalent 
solution, i'd really not like to see the [CONFIG_NR_CPUS] 
pattern to spread in the kernel, we spent a lot of time getting 
rid of such uses ;-)

Thanks,

	Ingo
