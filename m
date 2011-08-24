Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862Ab1HXRpP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 13:45:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46969 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752116Ab1HXRpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 13:45:12 -0400
Date: Wed, 24 Aug 2011 13:44:56 -0400
From: Don Zickus <dzickus@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: x86@kernel.org, Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>,
        Peter Zijlstra <peterz@infradead.org>, ying.huang@intel.com,
        LKML <linux-kernel@vger.kernel.org>, jason.wessel@windriver.com
Subject: Re: [RFC][PATCH 2/6] x86, nmi: create new NMI handler routines
Message-ID: <20110824174456.GN2067@redhat.com>
References: <1313786266-9585-1-git-send-email-dzickus@redhat.com>
 <1313786266-9585-3-git-send-email-dzickus@redhat.com>
 <20110824170411.GI2417@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110824170411.GI2417@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 10:04:11AM -0700, Paul E. McKenney wrote:
> On Fri, Aug 19, 2011 at 04:37:42PM -0400, Don Zickus wrote:
> > The NMI handlers used to rely on the notifier infrastructure.  This worked
> > great until we wanted to support handling multiple events better.
> > 
> > One of the key ideas to the nmi handling is to process _all_ the handlers for
> > each NMI.  The reason behind this switch is because NMIs are edge triggered.
> > If enough NMIs are triggered, then they could be lost because the cpu can
> > only latch at most one NMI (besides the one currently being processed).
> > 
> > In order to deal with this we have decided to process all the NMI handlers
> > for each NMI.  This allows the handlers to determine if they recieved an
> > event or not (the ones that can not determine this will be left to fend
> > for themselves on the unknown NMI list).
> > 
> > As a result of this change it is now possible to have an extra NMI that
> > was destined to be received for an already processed event.  Because the
> > event was processed in the previous NMI, this NMI gets dropped and becomes
> > an 'unknown' NMI.  This of course will cause printks that scare people.
> > 
> > However, we prefer to have extra NMIs as opposed to losing NMIs and as such
> > are have developed a basic mechanism to catch most of them.  That will be
> > a later patch.
> > 
> > To accomplish this idea, I unhooked the nmi handlers from the notifier
> > routines and created a new mechanism loosely based on doIRQ.  The reason
> > for this is the notifier routines have a couple of shortcomings.  One we
> > could't guarantee all future NMI handlers used NOTIFY_OK instead of
> > NOTIFY_STOP.  Second, we couldn't keep track of the number of events being
> > handled in each routine (most only handle one, perf can handle more than one).
> > Third, I wanted to eventually display which nmi handlers are registered in
> > the system in /proc/interrupts to help see who is generating NMIs.
> > 
> > The patch below just implements the new infrastructure but doesn't wire it up
> > yet (that is the next patch).  Its design is based on doIRQ structs and the
> > atomic notifier routines.  So the rcu stuff in the patch isn't entirely untested
> > (as the notifier routines have soaked it) but it should be double checked in
> > case I copied the code wrong.
> 
> One comment below.
> 
> 							Thanx, Paul
> 
> > Signed-off-by: Don Zickus <dzickus@redhat.com>
> > ---
> >  arch/x86/include/asm/nmi.h |   19 ++++++
> >  arch/x86/kernel/nmi.c      |  139 ++++++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 158 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/nmi.h b/arch/x86/include/asm/nmi.h
> > index 4886a68..6d04b28 100644
> > --- a/arch/x86/include/asm/nmi.h
> > +++ b/arch/x86/include/asm/nmi.h
> > @@ -42,6 +42,25 @@ void arch_trigger_all_cpu_backtrace(void);
> >  #define NMI_LOCAL_NORMAL_PRIOR	(NMI_LOCAL_BIT | NMI_NORMAL_PRIOR)
> >  #define NMI_LOCAL_LOW_PRIOR	(NMI_LOCAL_BIT | NMI_LOW_PRIOR)
> > 
> > +#define NMI_FLAG_FIRST	1
> > +
> > +enum {
> > +	NMI_LOCAL=0,
> > +	NMI_UNKNOWN,
> > +	NMI_EXTERNAL,
> > +	NMI_MAX
> > +};
> > +
> > +#define NMI_DONE	0
> > +#define NMI_HANDLED	1
> > +
> > +typedef int (*nmi_handler_t)(unsigned int, struct pt_regs *);
> > +
> > +int register_nmi_handler(unsigned int, nmi_handler_t, unsigned long,
> > +			 const char *);
> > +
> > +void unregister_nmi_handler(unsigned int, const char *);
> > +
> >  void stop_nmi(void);
> >  void restart_nmi(void);
> > 
> > diff --git a/arch/x86/kernel/nmi.c b/arch/x86/kernel/nmi.c
> > index 68d758a..dfc46a8 100644
> > --- a/arch/x86/kernel/nmi.c
> > +++ b/arch/x86/kernel/nmi.c
> > @@ -13,6 +13,9 @@
> >  #include <linux/kprobes.h>
> >  #include <linux/kdebug.h>
> >  #include <linux/nmi.h>
> > +#include <linux/delay.h>
> > +#include <linux/hardirq.h>
> > +#include <linux/slab.h>
> > 
> >  #if defined(CONFIG_EDAC)
> >  #include <linux/edac.h>
> > @@ -21,6 +24,27 @@
> >  #include <linux/atomic.h>
> >  #include <asm/traps.h>
> >  #include <asm/mach_traps.h>
> > +#include <asm/nmi.h>
> > +
> > +struct nmiaction {
> > +	struct nmiaction __rcu *next;
> > +	nmi_handler_t handler;
> > +	unsigned int flags;
> > +	const char *name;
> > +};
> > +
> > +struct nmi_desc {
> > +	spinlock_t lock;
> > +	struct nmiaction __rcu *head;
> > +};
> > +
> > +static struct nmi_desc nmi_desc[NMI_MAX] = 
> > +{
> > +	{	.lock = __SPIN_LOCK_UNLOCKED(&nmi_desc[0].lock), },
> > +	{	.lock = __SPIN_LOCK_UNLOCKED(&nmi_desc[1].lock), },
> > +	{	.lock = __SPIN_LOCK_UNLOCKED(&nmi_desc[2].lock), },
> > +
> > +};
> > 
> >  static int ignore_nmis;
> > 
> > @@ -38,6 +62,121 @@ static int __init setup_unknown_nmi_panic(char *str)
> >  }
> >  __setup("unknown_nmi_panic", setup_unknown_nmi_panic);
> > 
> > +#define nmi_to_desc(type) (&nmi_desc[type])
> > +
> > +static int notrace __kprobes nmi_handle(unsigned int type, struct pt_regs *regs)
> > +{
> > +	struct nmi_desc *desc = nmi_to_desc(type);
> > +	struct nmiaction *next_a, *a, **ap = &desc->head;
> > +	int handled=0;
> > +
> > +	rcu_read_lock();
> > +	a = rcu_dereference_raw(*ap);
> 
> The reason for rcu_dereference_raw() is to prevent lockdep from choking
> due to being called from an NMI handler, correct?  If so, please add a
> comment to this effect on this and similar uses.

That sounds right.  But honestly, I just copied what notifier_call_chain
had.  Regardless, I will make sure to document that in my next version.
Thanks!

Cheers,
Don
