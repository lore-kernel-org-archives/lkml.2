Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892Ab2LMHsm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 02:48:42 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38823 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab2LMHsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 02:48:41 -0500
Date: Thu, 13 Dec 2012 08:48:34 +0100
From: Ingo Molnar <mingo@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Revert "perf: Require exclude_guest to use PEBS - kernel
 side enforcement"
Message-ID: <20121213074834.GB13446@gmail.com>
References: <20121211090910.GA22985@gmail.com>
 <CA+55aFw=sifEKVJwDvmfV317+RNrf9Z88xZ5pu0SwggrQrubTw@mail.gmail.com>
 <50C94A9C.2050900@gmail.com>
 <CA+55aFxpLJ=gVUSiu04sTzDDrR75B89pzE35MyEyj3pVi5UbiQ@mail.gmail.com>
 <50C94ECD.6020504@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50C94ECD.6020504@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> On 12/12/12 8:34 PM, Linus Torvalds wrote:
> >On Wed, Dec 12, 2012 at 7:25 PM, David Ahern <dsahern@gmail.com> wrote:
> >>
> >>Are you running an older perf binary on the 3.8 kernel?
> >
> >I am.. I don't tend to rebuild 'perf'..
> >
> >>Does this work: perf record -e cycles:ppH  ...
> >
> >Yes it does. What is 'H' and why should anybody care? Especially since
> >I'm not running virtualized.
> >
> > That whole "exclude_guest" test is insane when there isn't 
> > any virtualization going on. Very annoying.
> 
> you know what's worse? [...]

No, nothing can be worse than breaking 99% of our installed 
base...

I'm wondering where this broke - is it:

  20b279ddb38c perf: Require exclude_guest to use PEBS - kernel side enforcement

Linus, does the straight revert below fix everything for you - 
or do we need to do more?

( The VM problem needs a different fix: a new include_guest bit 
  should be introduced, which would naturally default to 'off' 
  on older binaries, and the old bit should be phased out. Then 
  new perf binaries can turn on that bit safely. Or PEBS should 
  be fixed for guests. Or something along these lines - but 
  it should *not* by fixed by regressing existing binaries ... )

Thanks,

	Ingo

----------------->
>From 581ba4671bf1d1095e9ecf843be61904e4c97e91 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@kernel.org>
Date: Thu, 13 Dec 2012 08:41:40 +0100
Subject: [PATCH] Revert "perf: Require exclude_guest to use PEBS - kernel
 side enforcement"

This reverts commit 20b279ddb38ca42f8863cec07b4d45ec24589f13.

Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 4428fd1..6774c17 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -340,9 +340,6 @@ int x86_setup_perfctr(struct perf_event *event)
 		/* BTS is currently only allowed for user-mode. */
 		if (!attr->exclude_kernel)
 			return -EOPNOTSUPP;
-
-		if (!attr->exclude_guest)
-			return -EOPNOTSUPP;
 	}
 
 	hwc->config |= config;
@@ -385,9 +382,6 @@ int x86_pmu_hw_config(struct perf_event *event)
 	if (event->attr.precise_ip) {
 		int precise = 0;
 
-		if (!event->attr.exclude_guest)
-			return -EOPNOTSUPP;
-
 		/* Support for constant skid */
 		if (x86_pmu.pebs_active && !x86_pmu.pebs_broken) {
 			precise++;
