Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826Ab0K2TGL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 14:06:11 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:40284 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751294Ab0K2TGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 14:06:10 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1931ZIeSml3nTCmNcxwKvqfHTvLeyJLFyXFGtxa6u
	dFp7x6NWfyUufT
Subject: Re: [PATCH v4] sched: automated per session task groups
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, Paul Turner <pjt@google.com>
In-Reply-To: <1291052268.32004.171.camel@laptop>
References: <20101121133744.GA10765@elte.hu>
	 <1290700829.4759.16.camel@maggy.simson.net>
	 <1290954299.30515.15.camel@marge.simson.net>
	 <AANLkTin5Z_WdAPDfcS3V3DCcN40HLDfpzK-o0XeSMiQh@mail.gmail.com>
	 <20101128201851.GA20555@elte.hu> <1291031593.32004.19.camel@laptop>
	 <AANLkTimQ2Kp2=um9ip7J2=-joskmz4P-0b_SrexFbTh0@mail.gmail.com>
	 <1291052268.32004.171.camel@laptop>
Content-Type: text/plain
Date: Mon, 29 Nov 2010 20:06:05 +0100
Message-Id: <1291057565.20709.2.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-29 at 18:37 +0100, Peter Zijlstra wrote:
> On Mon, 2010-11-29 at 08:27 -0800, Linus Torvalds wrote:
> > On Mon, Nov 29, 2010 at 3:53 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > >
> > > Well we totally re-wrote the cgroup load-balancer in -tip. The thing
> > > currently in -linus is a utter crap because its very strongly serialized
> > > across all cores (some people spend like 25% of their time in there).
> > 
> > Well, it seems that the rewrite is more crap than the "utter crap" in
> > current -git. What does that make -tip? Super-utter-crap?
> > 
> > Peter - getting the wrong answer quickly is not any better than strong
> > serialization.
> 
> I know, from the testing so far we _thought_ it was fairly sane.
> Apparently there's still some work to do.

Damn thing bisected to:

commit 92fd4d4d67b945c0766416284d4ab236b31542c4
Merge: fe7de49 e53beac
Author: Ingo Molnar <mingo@elte.hu>
Date:   Thu Nov 18 13:22:14 2010 +0100

    Merge commit 'v2.6.37-rc2' into sched/core

    Merge reason: Move to a .37-rc base.

    Signed-off-by: Ingo Molnar <mingo@elte.hu>

92fd4d4d67b945c0766416284d4ab236b31542c4 is the first bad commit

git bisect start
# good: [f6f94e2ab1b33f0082ac22d71f66385a60d8157f] Linux 2.6.36
git bisect good f6f94e2ab1b33f0082ac22d71f66385a60d8157f
# bad: [3a2b7f908d45fa45670e8ba9e7e24c0409ba43d8] Merge branch 'linus'
git bisect bad 3a2b7f908d45fa45670e8ba9e7e24c0409ba43d8
# good: [520045db940a381d2bee1c1b2179f7921b40fb10] Merge branches 'upstream/xenfs' and 'upstream/core' of git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen
git bisect good 520045db940a381d2bee1c1b2179f7921b40fb10
# good: [520045db940a381d2bee1c1b2179f7921b40fb10] Merge branches 'upstream/xenfs' and 'upstream/core' of git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen
git bisect good 520045db940a381d2bee1c1b2179f7921b40fb10
# good: [120a795da07c9a02221ca23464c28a7c6ad7de1d] audit mmap
git bisect good 120a795da07c9a02221ca23464c28a7c6ad7de1d
# good: [19650e8580987c0ffabc2fe2cbc16b944789df8b] Merge branch 'bugfixes' of git://git.linux-nfs.org/projects/trondmy/nfs-2.6
git bisect good 19650e8580987c0ffabc2fe2cbc16b944789df8b
# good: [11259d65a61b84ad954953a194c41fe84dff889a] Merge branch 'out-of-tree'
git bisect good 11259d65a61b84ad954953a194c41fe84dff889a
# good: [eae0932ceba16e7ee0b5690455a13ef8364845da] Merge branch 'x86/mm'
git bisect good eae0932ceba16e7ee0b5690455a13ef8364845da
# good: [0464a38aaca10e1a8afed003d16d25dca2168d86] Merge branch 'sched/urgent'
git bisect good 0464a38aaca10e1a8afed003d16d25dca2168d86
# good: [22d1b202a8d0e1dedc35086b8f3df0a7b37d1371] Merge branch 'x86/urgent'
git bisect good 22d1b202a8d0e1dedc35086b8f3df0a7b37d1371
# bad: [282810f891cf6587dfc04fc5e26ec7772330c8cb] Merge branch 'sched/core'
git bisect bad 282810f891cf6587dfc04fc5e26ec7772330c8cb
# bad: [2932e532dd8fbd699ce072a4badc7fbe69451be6] Merge branch 'out-of-tree'
git bisect bad 2932e532dd8fbd699ce072a4badc7fbe69451be6
# bad: [d6b5591829bd348a5fbe1c428d28dea00621cdba] sched: Allow update_cfs_load() to update global load
git bisect bad d6b5591829bd348a5fbe1c428d28dea00621cdba
# bad: [f0d7442a5924a802b66eef79b3708f77297bfb35] sched: Fix load corruption from update_cfs_shares()
git bisect bad f0d7442a5924a802b66eef79b3708f77297bfb35
# bad: [2069dd75c7d0f49355939e5586daf5a9ab216db7] sched: Rewrite tg_shares_up)
git bisect bad 2069dd75c7d0f49355939e5586daf5a9ab216db7
# bad: [48c5ccae88dcd989d9de507e8510313c6cbd352b] sched: Simplify cpu-hot-unplug task migration
git bisect bad 48c5ccae88dcd989d9de507e8510313c6cbd352b
# bad: [92fd4d4d67b945c0766416284d4ab236b31542c4] Merge commit 'v2.6.37-rc2' into sched/core
git bisect bad 92fd4d4d67b945c0766416284d4ab236b31542c4


