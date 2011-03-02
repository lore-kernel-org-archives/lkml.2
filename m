Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab1CBQDn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 11:03:43 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:52571 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752002Ab1CBQDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 11:03:42 -0500
Date: Wed, 2 Mar 2011 17:03:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Don Zickus <dzickus@redhat.com>, "Huang, Ying" <ying.huang@intel.com>,
        "Maciej W. Rozycki" <macro@linux-mips.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip 2/2 resend] x86, traps: Drop nmi_reason_lock until
 it is really needed
Message-ID: <20110302160315.GA12620@elte.hu>
References: <4D6E631B.6040701@openvz.org>
 <20110302154645.GA11827@elte.hu>
 <4D6E6886.2060707@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D6E6886.2060707@openvz.org>
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


* Cyrill Gorcunov <gorcunov@openvz.org> wrote:

> On 03/02/2011 06:46 PM, Ingo Molnar wrote:
> > 
> > * Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> > 
> >> At moment we have only BSP apic configured to listen
> >> for external NMIs. So there is no reason for additional
> >> spinlock since only BSP will receive them.
> >>
> >> Though we still have UV chips which do enable external NMIs
> >> on all cpus, but since an approach to allow retrieving
> >> NMI reason on BSP only was working pretty fine before --
> >> I assume it still remains valid.
> > 
> > I'm not sure I get the point here: we might get NMIs on non-BSP on UV
> > systems ... so we want to remove the spinlock?
> > 
> > If UV systems can get NMIs on any CPU then the lock is needed.
> > 
> > It might have worked before - but UV systems are rare and relatively
> > new - plus the race window is small, so it might not have been triggered
> > in practice.
> 
> Well, it is incomplete anyway. As far as I can tell even ordering such
> NMIs with spinlock would not make situation better 'cause other cpu might
> obtain unknown nmi (ie two or more cpu's gets NMI then handing started on
> first found that it was say MCE error, handle it, unlock spinlock and then
> the second cpu gets this nmi (the reason for which was already handled by
> first cpu) and sees unknown NMI. So this lock might simply hiding a bug.

Well, the lock serializes the read-out of the 'NMI reason' port, the handling of 
whatever known reason and then the reassertion of the NMI (on 32-bit). 

EDAC has a callback in pci_serr_error() - and this lock serializes that. So we 
cannot just remove a lock like that, if there's any chance of parallel execution on 
multiple CPUs.

Thanks,

	Ingo
