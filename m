Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750Ab2A0TYW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 14:24:22 -0500
Received: from mail.windriver.com ([147.11.1.11]:43035 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067Ab2A0TYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 14:24:20 -0500
Date: Fri, 27 Jan 2012 14:23:55 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <gregkh@suse.de>, <rmk+kernel@arm.linux.org.uk>,
        <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC - PATCH 0/7] consolidation of BUG support code.
Message-ID: <20120127192354.GA7150@windriver.com>
References: <1327632272-12928-1-git-send-email-paul.gortmaker@windriver.com>
 <20120127165245.263bd8f7259ea629d8f7df31@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120127165245.263bd8f7259ea629d8f7df31@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Re: [RFC - PATCH 0/7] consolidation of BUG support code.] On 27/01/2012 (Fri 16:52) Stephen Rothwell wrote:

> Hi Paul,
> 
> On Thu, 26 Jan 2012 21:44:25 -0500 Paul Gortmaker <paul.gortmaker@windriver.com> wrote:
> >
> > The changes shown here are to unify linux's BUG support under
> > the one <linux/bug.h> file.  Due to historical reasons, we have
> > some BUG code in bug.h and some in kernel.h -- i.e. the support for
> > BUILD_BUG in linux/kernel.h predates the addition of linux/bug.h,
> > but old code in kernel.h wasn't moved to bug.h at that time.  As
> > a band-aid, kernel.h was including <asm/bug.h> to pseudo link them.
> > With the above in mind, the goals of this changeset are:
> > 
> > 1) find and fix any include/*.h files that were relying on the
> >    implicit presence of BUG code.
> > 2) find and fix any C files that were consuming kernel.h and
> >    hence relying on implicitly getting some/all BUG code.
> > 3) Move the BUG related code living in kernel.h to <linux/bug.h>
> > 4) remove the asm/bug.h from kernel.h to finally break the chain.
> > 
> > During development, the order was more like 3-4, build-test, 1-2.
> > But to ensure that git history for bisect doesn't get needless
> > build failures introduced, the commits have been reorderd to fix
> > the problem areas in advance.
> 
> I have expressed reservations with these tree wide include file cleanups
> in the past (there was going pain for me and others during the module.h

Well, I thought module.h went reasonably OK for something that touched
close to 2500 files.  I don't recall getting a lot of scorn and flame.
In any case, this is nowhere near that size or scope of the module.h
work, so I'll go out on a limb and say it should be nearly "pain free".

> split up for example).  So, have you considered the following alternate

> method of achieving most (if not all) of the gains:
> 
> First a patch that moves the BUG related stuff from kernel.h to
> linux/bug.h and replacing the include of asm/bug.h with linux/bug.h in
> kernel.h.  This should essentially be a noop (bar some strange
> interesting bugs).

You don't even really need the above as a prerequisite in order to start
adding bug.h to all the places that are using it.  As I noted in one of
the commit logs, things are compiling today, so files using BUG are
already getting it one way or another -- just implicitly.

> 
> The trick is to convince Linus that this patch is OK for the current RC series ...
> 
> Then you can (at your leisure) fix all the files that need linux/bug.h
> included - farming them out as required.  And we could add a check in
> checkpatch.pl.

I originally had the module.h stuff broken across maintainer lines, as
I was assuming they would need to be farmed out as chunks, when Ingo
suggested to just lump it all into one pull request and have it go at
once (and I was fine with that).  So this time I didn't bother making
things like the one include/* commit into 60-odd separate commits.

I'm not really inclined to greatly favour one way over the other.
Tracking all the one line commits to make sure they make it through
the various sub-maintainers will take a bit more effort, but if that
is what folks *really* want me to do, I'm OK with that.  It is just
that your feedback here is the 1st I've heard favouring that method
so far.

Thanks,
Paul.

> 
> Then (either after 3.4-rc1 or in the 3.5 merge window) we can remove the
> include of linux/bug.h from linux/kernel.h and fix any left over build
> problems.
> 
> I have not thought about this too hard, so there may be large holes in
> this plan.
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au


