Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446Ab0FSKyK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 06:54:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47985 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754716Ab0FSKyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 06:54:08 -0400
Date: Sat, 19 Jun 2010 12:53:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       huang ying <huang.ying.caritas@gmail.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Huang Ying <ying.huang@intel.com>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Don Zickus <dzickus@redhat.com>, "H.PeterA" <"nvin hpa"@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/3] Unified NMI delayed call mechanism
Message-ID: <20100619105352.GA10186@elte.hu>
References: <20100612102558.GA4000@elte.hu>
 <4C15A5D1.1040104@jp.fujitsu.com>
 <20100618094838.GD23977@elte.hu>
 <AANLkTimqRwAjrQ_b8BZ28lEn_Gaz5-SpLULWASHD1fVn@mail.gmail.com>
 <20100618124551.GC7612@elte.hu>
 <AANLkTinaPhAcGra6JdmHCVcj9HrNyG2TP91-A8AnQMZE@mail.gmail.com>
 <20100618143532.GA10886@elte.hu>
 <AANLkTimI7efmGNeUkCVT2mUYD8LkYsLAS9chkPhZVA1E@mail.gmail.com>
 <1276875067.1875.133.camel@laptop>
 <20100619080210.GC18946@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100619080210.GC18946@basil.fritz.box>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.5
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0455]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


( Ugh: what's this new fad of you not quoting the name of the person who 
  wrote a mail? It makes multi-level quotes utterly unreadable as it's not
  clear who wrote what. You should also respect others by quoting their names. )

* Andi Kleen <andi@firstfloor.org> wrote:

> > > we can use soft_irq as a backup of self interrupt (for systems without 
> > > APIC and maybe for other architectures).
> > 
> > Whatever would you want to do that for.
> 
> The idea is that the work would be done latest on the next timer interrupt 
> as a fallback if APIC is not available.

Abusing the timer irq for that is an exceedingly ugly and unacceptable design, 
as machine check events have nothing to do with timers. (That approach is also 
buggy because it inserts an arbitrary delay - which could be rather long on 
nohz.)

This kind of messy, ad-hoc piggybacking only creates unmaintainable code in 
the long run.

> That's what mce does already and it's probably approbiate for most other 
> users too.

Hell no, the unfortunate and unclean practices of the MCE code must not be 
propagated elsewhere.

The proper, generic approach would be to enable softirq notifications (on x86) 
from NMI contexts as well (it's actually possible without overhead), and to 
extend user return notifiers with the logical next step: nmi return notifiers. 
If presented in such a form then those could use softirqs for atomic callbacks 
and per cpu kthreads for sleepable callbacks, etc.

	Ingo
