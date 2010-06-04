Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872Ab0FDAkI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 20:40:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36384 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753403Ab0FDAkG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 20:40:06 -0400
Date: Fri, 4 Jun 2010 02:39:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: tytso@mit.edu
Cc: Brian Swetland <swetland@google.com>, Neil Brown <neilb@suse.de>,
       Arve Hj?nnev?g <arve@android.com>, Thomas Gleixner <tglx@linutronix.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend blockers & Android integration
Message-ID: <20100604003934.GA5221@elte.hu>
References: <20100603193045.GA7188@elte.hu>
 <20100603231153.GA11302@elte.hu>
 <20100603232302.GA16184@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100603232302.GA16184@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

>  - Create a 'deep idle' mode that suspends. This, if all constraints
>    are met, is triggered by the scheduler automatically: just like the other
>    idle modes are triggered currently. This approach fixes the wakeup
>    races because an incoming wakeup event will set need_resched() and
>    abort the suspend.
> 
>    ( This mode can even use the existing suspend code to bring stuff down,
>      therefore it also solves the pending timer problem and works even on
>      PC style x86. )

Note that this does not necessarily have to be implemented as 'execute suspend 
from the idle task' code: scheduling from the idle task, while can certainly 
be made to work, is a somewhat recursive concept that we might want to avoid 
for robustness reasons.

Instead, the 'deepest idle' (suspend) method could consist of a wakeup of a 
kernel thread (or of any of the existing kernel threads such as the migration 
thread) - which kernel thread then does a race-free suspend: it offlines all 
but one CPU [on platforms that need that] and then initiates the suspend - but 
aborts the attempt if there's any sign of wakeup activity.

Thanks,

	Ingo
