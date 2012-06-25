Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068Ab2FYNOk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 09:14:40 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38247 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936Ab2FYNOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 09:14:39 -0400
Subject: Re: [PATCH v7 2/2] x86 mce: use new printk recursion disabling
 interface
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@kernel.org>
Cc: ShuoX Liu <shuox.liu@intel.com>, Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20120625091734.GA25839@gmail.com>
References: <20120605081448.GA7097@liondog.tnic>
	 <4FCDD72A.9030701@intel.com> <4FCDD78A.3070106@intel.com>
	 <20120605151542.GA10669@x1.osrc.amd.com>
	 <1338942965.14538.233.camel@ymzhang.sh.intel.com>
	 <4FCF155B.3090705@intel.com> <4FCF160D.8010404@intel.com>
	 <20120606152238.GA3874@x1.osrc.amd.com> <4FD01896.1010506@intel.com>
	 <4FD01933.7070000@intel.com>  <20120625091734.GA25839@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Jun 2012 15:14:21 +0200
Message-ID: <1340630061.2507.61.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-25 at 11:17 +0200, Ingo Molnar wrote:
> * ShuoX Liu <shuox.liu@intel.com> wrote:
> 
> > From: ShuoX Liu <shuox.liu@intel.com>
> > 
> > On x86 machines, some times MCE happens just when kernel calls printk
> > to output some log info to serial console, while usually MCE module in
> > kernel is used to print out some hardware error information, such like
> > bad cache or bad memory bank. That causes printk recursion and printk
> > would omit MCE printk output.
> > 
> > We hit it when running MTBF testing on Android ATOM mobiles.
> > 
> > Here in print_mce, we choose to disable printk recursion to make sure
> > MCE logs printed out.
> > 
> > Signed-off-by: Yanmin Zhang <yanmin_zhang@linux.intel.com>
> > Signed-off-by: ShuoX Liu <shuox.liu@intel.com>
> > ---
> >  arch/x86/kernel/cpu/mcheck/mce.c |    6 +++++-
> >  1 files changed, 5 insertions(+), 1 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> > index 2afcbd2..6056e94 100644
> > --- a/arch/x86/kernel/cpu/mcheck/mce.c
> > +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> > @@ -242,6 +242,7 @@ static void print_mce(struct mce *m)
> >  {
> >  	int ret = 0;
> >  
> > +	printk_recursion_check_disable();
> >  	pr_emerg(HW_ERR "CPU %d: Machine Check Exception: %Lx Bank %d: %016Lx\n",
> >  	       m->extcpu, m->mcgstatus, m->bank, m->status);
> >  
> > @@ -275,10 +276,13 @@ static void print_mce(struct mce *m)
> >  	 * (if the CPU has an implementation for that)
> >  	 */
> >  	ret = atomic_notifier_call_chain(&x86_mce_decoder_chain, 0, m);
> > -	if (ret == NOTIFY_STOP)
> > +	if (ret == NOTIFY_STOP) {
> > +		printk_recursion_check_enable();
> >  		return;
> > +	}
> >  
> >  	pr_emerg_ratelimited(HW_ERR "Run the above through 'mcelog --ascii'\n");
> > +	printk_recursion_check_enable();
> 
> Ok, this looks useful and it solves a real problem, but I'd 
> prefer a better interface: instead of exposing the guts of 
> printk to drivers in an unsafe manner (and allowing them to keep 
> printk in an unsafe state indefinitely), shouldn't we instead 
> introduce printk_emergency() (and variants) that just disable 
> the recursion check, do the printk and then enable them?

I really don't see why you'd do anything like the above. For one the
oops_in_progress thing is exported, so you could simply use that, you're
going to panic the machine here anyway, right?

Furthermore the whole recursion stuff is broken anyway, see:
  http://marc.info/?l=linux-kernel&m=132446646923333

That also introduces recursive_printk() which you could (ab)use if
needed.

That said, its not entirely clear to me what context you're in when
you're calling this print_mce(), it looks like its only used from
mce_panic().

That already does bust_spinlocks() which already increments the
oops_in_progress thing, so WTF are you doing anyway?

