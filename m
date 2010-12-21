Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933358Ab0LUACK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 19:02:10 -0500
Received: from mail-bw0-f66.google.com ([209.85.214.66]:45986 "EHLO
	mail-bw0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932472Ab0LUACI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 19:02:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FxmkbA377teQhgHtyClJngL6/VD4kklGECUmLldXfKDMGhL1n8M0ZnWkSkqrrtoA34
         cfdx7lMT1s+hfBrV0ZFQFa5/cnrBLlDjiJeohUvXG9QHm5RgLhU4yYzonEtCv/vxLeUs
         QsfDU05ptodZinWHYwH/ooalCOob6bBmfrMpk=
Date: Tue, 21 Dec 2010 01:02:03 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 08/15] smp: Don't warn if irq are disabled but we
 don't wait for the ipi
Message-ID: <20101221000201.GF1715@nowhere>
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
 <1292858662-5650-9-git-send-email-fweisbec@gmail.com>
 <1292861039.5021.18.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292861039.5021.18.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 05:03:59PM +0100, Peter Zijlstra wrote:
> On Mon, 2010-12-20 at 16:24 +0100, Frederic Weisbecker wrote:
> > The comment in smp_call_function_single() says it wants the irqs
> > to be enabled otherwise it may deadlock.
> > 
> > I can't find the reason for that though, except if we had to wait
> > for a self triggered IPI but we execute the local IPI by just
> > calling the function in place.
> > 
> > In doubt, only suppress the warning if we are not waiting for the
> > IPI to complete as it should really not raise any deadlock.
> > 
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Anton Blanchard <anton@au1.ibm.com>
> > Cc: Tim Pepper <lnxninja@linux.vnet.ibm.com>
> > ---
> >  kernel/smp.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/kernel/smp.c b/kernel/smp.c
> > index 12ed8b0..886a406 100644
> > --- a/kernel/smp.c
> > +++ b/kernel/smp.c
> > @@ -289,7 +289,7 @@ int smp_call_function_single(int cpu, smp_call_func_t func, void *info,
> >  	 * send smp call function interrupt to this cpu and as such deadlocks
> >  	 * can't happen.
> >  	 */
> > -	WARN_ON_ONCE(cpu_online(this_cpu) && irqs_disabled()
> > +	WARN_ON_ONCE(cpu_online(this_cpu) && wait && irqs_disabled()
> >  		     && !oops_in_progress);
> >  
> >  	if (cpu == this_cpu) {
> 
> You just deadlocked the machine.. note how you can still wait on the
> previous csd in csd_lock().

Ah right.

I should then use __smp_call_function_single().
