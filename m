Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab2FOBHS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 21:07:18 -0400
Received: from mga11.intel.com ([192.55.52.93]:34516 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752157Ab2FOBHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 21:07:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="165880697"
Subject: Re: [RFC] x86, fpu: unify signal handling code paths for x86 and
 x86_64 kernels
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Hans Rosenfeld <hans.rosenfeld@amd.com>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, tglx@linutronix.de,
        robert.richter@amd.com, andreas.herrmann3@amd.com
Date: Thu, 14 Jun 2012 18:07:15 -0700
In-Reply-To: <4FDA7EDE.3070408@zytor.com>
References: <1339545814.28766.148.camel@sbsiddha-desk.sc.intel.com>
	  <20120614143727.GF7922@escobedo.osrc.amd.com>
	 <1339719035.3475.52.camel@sbsiddha-desk.sc.intel.com>
	 <4FDA7EDE.3070408@zytor.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1339722435.3475.57.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-14 at 17:16 -0700, H. Peter Anvin wrote:
> On 06/14/2012 05:10 PM, Suresh Siddha wrote:
> > 
> > My personal preference is to use TIF_IA32 check and avoid  the usage of
> > is_ia32_task() in the signal delivery paths.
> 
> That is the quick fix, but...
> 
> > Signal return goes through a system call which already sets the
> > TS_COMPAT. It is the signal delivery that is causing the asymmetry.
> 
> Yes, and I think you missed some aspects of my statement: the notion
> would be that TS_COMPAT would be set from the TIF_IA32 flag at the time
> we decide to deliver a signal, the signal being a pseudo-system-call.
> However, the more I wonder about if that will confuse the crap out of
> ptrace, so using TIF_IA32 might just be the best thing anyway.
> 

Ok. Fix for the existing mainline code appended. Can you queue this
separately?
---
From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: x86, compat: use test_thread_flag(TIF_IA32) in compat signal delivery

Signal delivery compat path may not have the 'TS_COMPAT' flag set. So use
test_thread_flag(TIF_IA32) instead of is_ia32_task().

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: stable@kernel.org	# v3.4
---
 arch/x86/ia32/ia32_signal.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index daeca56..673ac9b 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -38,7 +38,7 @@
 int copy_siginfo_to_user32(compat_siginfo_t __user *to, siginfo_t *from)
 {
 	int err = 0;
-	bool ia32 = is_ia32_task();
+	bool ia32 = test_thread_flag(TIF_IA32);
 
 	if (!access_ok(VERIFY_WRITE, to, sizeof(compat_siginfo_t)))
 		return -EFAULT;


