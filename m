Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971Ab1EPL3v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 07:29:51 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36940 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984Ab1EPL3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 07:29:50 -0400
Date: Mon, 16 May 2011 13:29:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Don Zickus <dzickus@redhat.com>
Cc: huang ying <huang.ying.caritas@gmail.com>,
        Huang Ying <ying.huang@intel.com>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>,
        Andi Kleen <ak@linux.intel.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: [RFC] x86, NMI, Treat unknown NMI as hardware error
Message-ID: <20110516112934.GE19837@elte.hu>
References: <1305275018-20596-1-git-send-email-ying.huang@intel.com>
 <20110513124523.GM13984@redhat.com>
 <20110513130011.GA6474@elte.hu>
 <BANLkTi=Z_3MZVs2CQyk82NfvZj-KdSw5kw@mail.gmail.com>
 <20110513152033.GB3854@elte.hu>
 <20110513160029.GD31888@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110513160029.GD31888@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Don Zickus <dzickus@redhat.com> wrote:

> On Fri, May 13, 2011 at 05:20:33PM +0200, Ingo Molnar wrote:
> > 
> > * huang ying <huang.ying.caritas@gmail.com> wrote:
> > 
> > > > What should be done instead is to add an event for unknown NMIs, which can 
> > > > then be processed by the RAS daemon to implement policy.
> > > >
> > > > By using 'active' event filters it could even be set on a system to panic 
> > > > the box by default.
> > > 
> > > If there is real fatal hardware error, maybe we have no luxury to go from NMI 
> > > handler to user space RAS daemon to determine what to do. System may explode, 
> > > bad data may go to disk before that.
> > 
> > That is why i suggested:
> > 
> >   > > By using 'active' event filters it could even be set on a system to panic 
> >   > > the box by default.
> > 
> > event filters are evaluated in the kernel, so the panic could be instantaneous, 
> > without the event having to reach user-space.
> 
> Interesting.  Question though, what do you mean by 'event filtering'.  Is 
> that different then setting 'unknown_nmi_panic' panic on the commandline or 
> procfs?
> 
> Or are you suggesting something like registering another callback on the 
> die_chain that looks for DIE_NMIUNKNOWN as the event, swallows them and 
> implements the policy?  That way only on HEST related platforms would 
> register them while others would keep the default of 'Dazed and confused' 
> messages?

The idea is that "event filters", which are an existing upstream feature and 
which can be used in rather flexible ways:

  http://lkml.org/lkml/2011/4/27/660

Could be used to trigger non-standard policy action as well - such as to panic 
the box.

This would replace various very limited /debugfs and /sys event filtering hacks 
(and hardcoded policies) such as arch/x86/kernel/cpu/mcheck/mce-severity.c, and 
it would allow nonstandard behavior like 'panic the box on unknown NMIs' as 
well.

This could be set by the RAS daemon, and it could be propagated to the kernel 
boot line as well, where event filter syntax would look like this:

  events=nmi::unknown"if (reason == 0) panic();"

(Where the 'reason' field of the NMI event is the current legacy 'reason' value 
there.)

The filter code would have to be modified to be able to recognize the panic() 
bit, but that's desirable anyway and it is a one-time effort.

This:

  events=nmi::unknown:"if (reason == 0) ignore();"

would be a possible outcome as well, on certain boxes - to skip certain events.

Thanks,

	Ingo
