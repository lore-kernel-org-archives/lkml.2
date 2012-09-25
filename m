Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537Ab2IYEQV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 00:16:21 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:51313 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750774Ab2IYEQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 00:16:20 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/SHzhfmVzSUyzA+69xJXwHc7rsxGN6EfZJ+eQ0dG
	rsw2WSBt/xFfsW
Message-ID: <1348546575.7100.68.camel@marge.simpson.net>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
From: Mike Galbraith <efault@gmx.de>
To: Mel Gorman <mgorman@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Nikolay Ulyanitsky <lystor@gmail.com>,
        linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Date: Tue, 25 Sep 2012 06:16:15 +0200
In-Reply-To: <20120924150048.GB11266@suse.de>
References: <CA+Medix98MHYzpKSDKKWf7Wew0H4zDFsUS74LrhsP2Lxemd3Mw@mail.gmail.com>
	 <20120914212717.GA29307@liondog.tnic>
	 <CA+55aFwn3UhTDDch4+-=9=T3rHpDvqphY+NLtf2Ljq-7eG+gYw@mail.gmail.com>
	 <20120924150048.GB11266@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-09-24 at 16:00 +0100, Mel Gorman wrote: 
> On Fri, Sep 14, 2012 at 02:42:44PM -0700, Linus Torvalds wrote:
> > On Fri, Sep 14, 2012 at 2:27 PM, Borislav Petkov <bp@alien8.de> wrote:
> > >
> > > as Nikolay says below, we have a regression in 3.6 with pgbench's
> > > benchmark in postgresql.
> > >
> > > I was able to reproduce it on another box here and did a bisection run.
> > > It pointed to the commit below.
> > 
> > Ok. I guess we should just revert it. However, before we do that,
> > maybe Mike can make it just use the exact old semantics of
> > select_idle_sibling() in the update_top_cache_domain() logic.
> > 
> 
> The patch that you being reverted was meant to fix problems with
> commit 4dcfe102 (sched: Avoid SMT siblings in select_idle_sibling() if
> possible). That patch made select_idle_sibling() quite fat and I know it
> is responsible for a 2% regression in a kernel compile benchmark between
> kernel 3.1 and 3.2 on an old AMD Phenom II X4 940. Reverting Mike's patch
> might fix this Postgres regression but it reintroduces the overhead caused
> by commit 4dcfe102 for other cases.  I do not have a suggestion on how to
> make this better, I'm just pointing out that the revert has some downsides.

Yeah.  The very good thing about this is that Linus becoming interested
in a problem like two faced little (naughty word) select_idle_sibling()
brings more minds to bear, so we'll end up in better shape.  Right now,
we're in not so wonderful shape with or without my patch, depending very
much on which processor you're running which load on.  That needs to get
better.  AMD is being hurt _bad_ on fast movers, but just kill the damn
thing on AMD processors, and pgbench will fall through the floor.

Aiming darts would be lots easier if the bullseye would stop moving ;-) 

-Mike

