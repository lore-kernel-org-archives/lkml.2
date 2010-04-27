Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500Ab0D0JZ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 05:25:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49148 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754432Ab0D0JZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 05:25:55 -0400
Date: Tue, 27 Apr 2010 11:25:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@zeniv.linux.org.uk>,
       Jan Blunck <jblunck@suse.de>, John Kacur <jkacur@redhat.com>
Subject: Re: [GIT PULL v2] Preparation for BKL'ed ioctl removal
Message-ID: <20100427092530.GD11348@elte.hu>
References: <1271390201-20431-1-git-send-regression-fweisbec@gmail.com>
 <20100425173912.GA5375@nowhere>
 <20100426072541.GA25961@elte.hu>
 <201004261329.28427.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201004261329.28427.arnd@arndb.de>
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


* Arnd Bergmann <arnd@arndb.de> wrote:

> On Monday 26 April 2010, Ingo Molnar wrote:
> > This could be done all automated for a hundred old drivers if need to be. 
> > There would be no bkl_ioctl's left.
> 
> I don't think it can be fully automated. [...]

Corner cases are not a problem as long as the risk of them going unnoticed is 
lower than the risk of a manual conversion introducing bugs.

> [...] For the majority of the modules, your approach would work fine, but 
> there are still the well-known pitfalls in corner cases:
> 
> - recursive uses in functions outside of ioctl (possibly none left
>   after the TTY layer is done, but who knows)

Not a problem even if there's any such usage left: lockdep will sort those out 
very quickly.

> - lock-order problems with other mutexes (see DRM)

This too will be mapped out very quickly via lockdep.

> - code that depends on autorelease to allow one ioctl while another
>   is sleeping. (a small number of drivers)

This is a real issue, and in fact it's an unknown: there may be an unknown 
number of random sleep points within BKL codepaths that is being relied on in 
creative ways.

Note that by introducing a mutex we (in most cases) make the locking 
_stricter_, so the biggest risk from that is a lockup - which will be 
debuggable via lockdep.

	Ingo
