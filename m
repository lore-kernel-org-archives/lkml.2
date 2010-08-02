Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280Ab0HBJRc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 05:17:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41067 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753072Ab0HBJR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 05:17:29 -0400
Date: Mon, 2 Aug 2010 11:17:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <npiggin@suse.de>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 11/19] perf record: Release resources at exit
Message-ID: <20100802091714.GA6781@elte.hu>
References: <1280711334-30000-1-git-send-email-acme@infradead.org>
 <1280711334-30000-12-git-send-email-acme@infradead.org>
 <20100802073009.GB7841@amd>
 <20100802075422.GA24085@elte.hu>
 <20100802080353.GA8713@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100802080353.GA8713@amd>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.2.5
	-1.0 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1199]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Nick Piggin <npiggin@suse.de> wrote:

> On Mon, Aug 02, 2010 at 09:54:22AM +0200, Ingo Molnar wrote:
> > 
> > * Nick Piggin <npiggin@suse.de> wrote:
> > 
> > > On Sun, Aug 01, 2010 at 10:08:46PM -0300, Arnaldo Carvalho de Melo wrote:
> > > > From: Arnaldo Carvalho de Melo <acme@redhat.com>
> > > > 
> > > > So that we can reduce the noise on valgrind when looking for memory
> > > > leaks.
> > > 
> > > Really? That's rather crappy of valgrind. exit is well defined to release 
> > > resources and that's often a more efficient way to do it It finds and 
> > > batches things a lot better, eg. it can avoid all TLB flushing of freeing 
> > > memory that munmap requires.
> > 
> > That's certainly true but there's no valgrind crappiness here: valgrind simply 
> > can do a better job of finding leaks if there's a well defined "all resources 
> > the app still knows about are freed now" point.
> 
> "noise" sounds like false positives though. [...]

Every predictive bug detection scheme is open to the potential of false 
positives. I've yet to see a complex one that is 100% false positive free.

> [...] Certainly if this is instead allows valgrind to run in a particular 
> mode that assumes no application resources consumed at exit(2) time, I 
> wouldn't call it crappy :)

Most apps free their stuff before they exit - i do it in all my own C apps.

That is generally useful: for example it makes it easier to thread a program 
later on - when exit() becomes pthread_exit() and a silent leak turns into a 
real leak.

Hence Valgrind checking for exit() by default looks useful to me.

> But you could equally sprinkle in other valgrind specific annotations or 
> semantics at various points in the code to improve its coverage, no?

Yeah, and exit() sounds like a pretty convenient point, right? That's the 
point where all resources are inactive hence a scan for leaks is expected to 
be the most efficient in finding real leaks.

Thanks,

	Ingo
