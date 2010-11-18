Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757940Ab0KRNjn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 08:39:43 -0500
Received: from one.firstfloor.org ([213.235.205.2]:43278 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757606Ab0KRNjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 08:39:42 -0500
Date: Thu, 18 Nov 2010 14:39:40 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>, a.p.zijlstra@chello.nl,
        eranian@google.com, linux-kernel@vger.kernel.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/4] x86: set cpu masks before calling CPU_STARTING
 notifiers
Message-ID: <20101118133940.GD12667@basil.fritz.box>
References: <1290077254-12165-1-git-send-email-andi@firstfloor.org>
 <1290077254-12165-2-git-send-email-andi@firstfloor.org>
 <alpine.LFD.2.00.1011181251370.2900@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1011181251370.2900@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 12:52:33PM +0100, Thomas Gleixner wrote:
> On Thu, 18 Nov 2010, Andi Kleen wrote:
> 
> > From: Andi Kleen <ak@linux.intel.com>
> > 
> > When booting up a CPU set the various topology masks before
> > calling the CPU_STARTING notifier. This way the notifier
> > can actually use the masks.
> > 
> > This is needed for a perf change.
> > 
> > Signed-off-by: Andi Kleen <ak@linux.intel.com>
> > ---
> >  arch/x86/kernel/smpboot.c |    8 ++++----
> >  1 files changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> > index 083e99d..9d2980e 100644
> > --- a/arch/x86/kernel/smpboot.c
> > +++ b/arch/x86/kernel/smpboot.c
> > @@ -281,6 +281,10 @@ static void __cpuinit smp_callin(void)
> >  	 */
> >  	smp_store_cpu_info(cpuid);
> >  
> > +	/* This must be done before setting cpu_online_mask */
> 
> Can we please fix up that comment to match that change ?

Here's an updated patch.

x86: set cpu masks before calling CPU_STARTING notifiers
    
When booting up a CPU set the various topology masks before
calling the CPU_STARTING notifier. This way the notifier
can actually use the masks.
    
This is needed for a perf change.
    
Signed-off-by: Andi Kleen <ak@linux.intel.com>

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 083e99d..c019c03 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -281,6 +281,13 @@ static void __cpuinit smp_callin(void)
 	 */
 	smp_store_cpu_info(cpuid);
 
+	/* 
+	 * This must be done before setting cpu_online_mask
+	 * or calling notify_cpu_starting.
+	 */
+	set_cpu_sibling_map(raw_smp_processor_id());
+	wmb();
+
 	notify_cpu_starting(cpuid);
 
 	/*
@@ -322,10 +329,6 @@ notrace static void __cpuinit start_secondary(void *unused)
 		legacy_pic->unmask(0);
 	}
 
-	/* This must be done before setting cpu_online_mask */
-	set_cpu_sibling_map(raw_smp_processor_id());
-	wmb();
-
 	/*
 	 * We need to hold call_lock, so there is no inconsistency
 	 * between the time smp_call_function() determines number of
