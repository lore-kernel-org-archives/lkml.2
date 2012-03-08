Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964887Ab2CIP7a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 10:59:30 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:36740 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964854Ab2CIP72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 10:59:28 -0500
Date: Thu, 8 Mar 2012 13:18:32 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.3-rc6
Message-ID: <20120308211832.GU2348@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CA+55aFxHj-7fQ0+yJv4WaeKCGha5+a+J=gtHi6m6EWg58q7Ljw@mail.gmail.com>
 <20120307103227.GA5237@x1.osrc.amd.com>
 <20120307121138.GB5237@x1.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120307121138.GB5237@x1.osrc.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12030915-9360-0000-0000-000004642D83
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2012 at 01:11:38PM +0100, Borislav Petkov wrote:
> On Wed, Mar 07, 2012 at 11:32:27AM +0100, Borislav Petkov wrote:
> > On Sat, Mar 03, 2012 at 06:57:31PM -0800, Linus Torvalds wrote:
> > > Hmm. Nothing much to say about this -rc: it really is all small fixes
> > > and cleanups.
> > > 
> > > In fact, it's been calm enough that this *might* be the last -rc, but
> > > we'll see how the upcoming week goes. If it stays calm (and hopefully
> > > even calms down some more), there doesn't seem to be any major reason
> > > to drag out the release cycle any more.
> > > 
> > > But hey, that does imply that people who have seen regressions should
> > > re-check them and holler loudly if they are still seeing problems.
> > 
> > Just a couple of warnings, just saw them when booted
> > 3.3.0-rc6-00104-gf3969bf78f14 yesterday on this box. I'm ccing Paul for
> > the first two,
> 
> Ok, looks like Paul knows about those already:
> http://marc.info/?l=linux-kernel&m=132744022215850 and further.
> 
> @Paul: which patch is the latest adding rcu_idle_enter/_exit() calls to pm_idle
> assignees, which you'd like me to test?

This one, which defines RCU_NONIDLE(): https://lkml.org/lkml/2012/2/3/498

And then the following patch on top of that.

							Thanx, Paul

------------------------------------------------------------------------

x86: Protect printk() in amd_e400_idle() with RCU_NONIDLE()

Because printk() uses RCU, it cannot be used in the idle loop unless
enclosed by RCU_NONIDLE().  This commit makes the required adjustment.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 15763af..b185a32 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -552,7 +552,9 @@ static void amd_e400_idle(void)
 			amd_e400_c1e_detected = true;
 			if (!boot_cpu_has(X86_FEATURE_NONSTOP_TSC))
 				mark_tsc_unstable("TSC halt in AMD C1E");
-			printk(KERN_INFO "System has AMD C1E enabled\n");
+			RCU_NONIDLE(
+				printk(KERN_INFO "System has AMD C1E enabled\n");
+			);
 		}
 	}
 

