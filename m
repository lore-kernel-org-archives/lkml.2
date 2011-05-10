Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932793Ab1EJI6I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 04:58:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51109 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932131Ab1EJI6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 04:58:07 -0400
Date: Tue, 10 May 2011 10:57:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Valdis.Kletnieks@vt.edu, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: 2.6.39-rc6-mmotm0506 - lockdep splat in RCU code on page fault
Message-ID: <20110510085746.GG27426@elte.hu>
References: <6921.1304989476@localhost>
 <20110510082029.GF2258@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110510082029.GF2258@linux.vnet.ibm.com>
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


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> -	raw_spin_lock_irqsave(&rnp->lock, flags);
> -	rnp->wakemask |= rdp->grpmask;
> -	raw_spin_unlock_irqrestore(&rnp->lock, flags);
> +	do {
> +		old = rnp->wakemask;
> +		new = old | rdp->grpmask;
> +	} while (cmpxchg(&rnp->wakemask, old, new) != old);

Hm, isnt this an inferior version of atomic_or_long() in essence?

Note that atomic_or_long() is x86 only, so a generic one would have to be 
offered too i suspect, atomic_cmpxchg() driven or so - which would look like 
the above loop.

Most architectures could offer atomic_or_long() i suspect.

Thanks,

	Ingo
