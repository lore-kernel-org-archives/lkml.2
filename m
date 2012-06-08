Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933570Ab2FHONT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 10:13:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:44931 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932655Ab2FHONS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 10:13:18 -0400
Subject: Re: [PATCH] perf/x86: check ucode before disabling PEBS on
 SandyBridge
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, mingo@elte.hu, ming.m.lin@intel.com,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Dimitri Sivanich <sivanich@sgi.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>
In-Reply-To: <CABPqkBQprykpCH=A4VQhNAc2j8JQm3Z0d_EV=Nb3bV1QZ_++nw@mail.gmail.com>
References: <20120607071531.GA4849@quad> <1339064319.23343.13.camel@twins>
	 <CABPqkBQ+p5rcuxpXCTLMXPM+awAHhQ6mP9-WzVh5GWtn2GyfrA@mail.gmail.com>
	 <1339065932.23343.18.camel@twins>
	 <CABPqkBQ=tLXXsgvzQx+i01Owm4MM8m=6cEVVi4ab64gOiTTBYQ@mail.gmail.com>
	 <1339067757.23343.21.camel@twins> <20120608093513.GA22520@gmail.com>
	 <1339149613.23343.52.camel@twins> <1339161972.2507.13.camel@laptop>
	 <CABPqkBQprykpCH=A4VQhNAc2j8JQm3Z0d_EV=Nb3bV1QZ_++nw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Jun 2012 16:13:05 +0200
Message-ID: <1339164785.2507.23.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-08 at 16:07 +0200, Stephane Eranian wrote:

> > The very worst is that it does per-cpu micro-code updates, not machine
> > wide. This results in it being able to have different revisions on
> > different cpus. This in turn makes the below O(n^2) :/
> >
> But it's not like this is a frequent operation either...

Still Dimitri did a patch 938179b4f8cf8 ("x86: Improve Intel microcode
loader performance") to improve the performance of it, so apparently
they do care some.

> > ---

> > diff --git a/arch/x86/include/asm/microcode.h b/arch/x86/include/asm/microcode.h
> > index 4ebe157..1cd2dc5 100644
> > --- a/arch/x86/include/asm/microcode.h
> > +++ b/arch/x86/include/asm/microcode.h

> > @@ -63,4 +64,15 @@ static inline struct microcode_ops * __init init_amd_microcode(void)
> >  static inline void __exit exit_amd_microcode(void) {}
> >  #endif
> >
> > +extern struct blocking_notifier_head microcode_notifier;
> > +
> That is a problem because microcode can be compiled as a module.
> When I tried compiling your patch I got undefined for this notifier because
> I have microcode update as a module...
> 
> > +#define MICROCODE_CAN_UPDATE   0x01
> > +#define MICROCODE_UPDATED      0x02
> > +
> > +#define microcode_notifier(fn)                                         \
> > +do {                                                                   \
> > +       static struct notifier_block fn##_nb ={ .notifier_call = fn };  \
> > +       blocking_notifier_chain_register(&microcode_notifier, &fn##_nb);\
> > +} while (0)
> > +
> >  #endif /* _ASM_X86_MICROCODE_H */

But that's ourside of CONFIG_MICROCODE and...

> > diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> > index f4b9b80..98b5b5c 100644
> > --- a/arch/x86/kernel/setup.c
> > +++ b/arch/x86/kernel/setup.c
> > @@ -68,6 +68,7 @@
> >  #include <linux/percpu.h>
> >  #include <linux/crash_dump.h>
> >  #include <linux/tboot.h>
> > +#include <linux/notifier.h>
> >
> >  #include <video/edid.h>
> >
> > @@ -205,6 +206,10 @@ struct cpuinfo_x86 boot_cpu_data __read_mostly = {
> >  EXPORT_SYMBOL(boot_cpu_data);
> >  #endif
> >
> > +/*
> > + * Lives here because the microcode stuff is modular.
> > + */
> > +struct atomic_notifier_head microcode_notifier;

s/atomic_/blocking_/ -- forgot a refresh there..

> >  #if !defined(CONFIG_X86_PAE) || defined(CONFIG_X86_64)
> >  unsigned long mmu_cr4_features;


So that all should build.. weird.. I'll give it a go.


