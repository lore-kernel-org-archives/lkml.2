Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934143Ab1CYKTR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 06:19:17 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33652 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755680Ab1CYKTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 06:19:15 -0400
Subject: Re: [PATCH RFC] x86: avoid atomic operation in
 test_and_set_bit_lock if possible
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, Jack Steiner <steiner@sgi.com>,
        Jan Beulich <JBeulich@novell.com>, Borislav Petkov <bp@amd64.org>,
        Nick Piggin <npiggin@kernel.dk>, "x86@kernel.org" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, tee@sgi.com,
        Nikanth Karthikesan <knikanth@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20110325092227.GA13640@elte.hu>
References: <20110324145221.GC31194@aftab>
	 <4D8B83DA02000078000381DE@vpn.id2.novell.com>
	 <20110324173020.GA26761@sgi.com> <20110324200010.GB7957@elte.hu>
	 <1300999682.2714.23.camel@edumazet-laptop> <20110324205422.GB2393@elte.hu>
	 <1301000557.2714.33.camel@edumazet-laptop> <m2oc50kxg0.fsf@firstfloor.org>
	 <AANLkTimib3TqemF9L=VNkcXT3uFam1gYmVtuA3wrAv1j@mail.gmail.com>
	 <20110324235654.GM21838@one.firstfloor.org>
	 <20110325092227.GA13640@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Mar 2011 11:21:16 +0100
Message-ID: <1301048476.2250.181.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-25 at 10:22 +0100, Ingo Molnar wrote:
> * Andi Kleen <andi@firstfloor.org> wrote:
> 
> > > never EVER seen any good explanation of why that particular sh*t
> > > argument would b true. It seems to be purely about politics, where
> > > some idiotic vendor (namely HP) has convinced Intel that they really
> > > need it. To the point where some engineers seem to have bought into
> > > the whole thing and actually believe that fairy tale ("firmware can do
> > > better" - hah! They must be feeding people some bad drugs at the
> > > cafeteria)
> > 
> > For the record I don't think it's a good idea for the BIOS to do 
> > this (and I'm not aware of any engineer who does),  
> 
> There's really just two sane options:
> 
>  - complain about the BIOS corrupting CPU state and refusing to use the PMU
>  - complain about the BIOS corrupting CPU state and using the PMU against the BIOS
> 
> We went for the first one but i'll be more than glad to implement Linus's much 
> more aggressive second option.
> 
> Btw., for the record, the thing you have been advocating in the past was a 
> third option: for the kernel to step aside quietly and to let the BIOS corrupt 
> a counter or two. You even sent us some sort of BIOS specification about how to 
> implement that. That's pretty much the worst solution imaginable.

Also seriously complicated by the kexec case where the previous kernel
didn't clean up PMU state. There is simply no sane way to detect if its
actually used and by whoem.

The whole PMU 'sharing' concept championed by Andi is utter crap.

As for simply using it despite the BIOS corrupting it, that might not
always work, the BIOS might simply over-write your state because it
one-sidedly declares to own the MSRs (observed behaviour).

Its all a big clusterfuck and really the best way (IMO) is what we have
now to put pressure on and force the BIOS vendors to play nice.

I assume both HP and DELL will be seriously unhappy with the kernel
spewing FIRMWARE BUG messages on boot on their boxen, the question is,
will they be unhappy enough to fix it..

Now Ingo's patch keeps the warning and lets you take the PMU back and
live with whatever consequences that brings (incorrect counts etc), that
might also work but puts less pressure on the vendors because things
appear to work.

