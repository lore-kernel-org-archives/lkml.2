Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113Ab1I1Mh6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 08:37:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12185 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752460Ab1I1Mh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 08:37:57 -0400
Date: Wed, 28 Sep 2011 08:37:20 -0400
From: Don Zickus <dzickus@redhat.com>
To: Robert Richter <robert.richter@amd.com>
Cc: "x86@kernel.org" <x86@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "avi@redhat.com" <avi@redhat.com>, "jeremy@goop.org" <jeremy@goop.org>
Subject: Re: [V6][PATCH 4/6] x86, nmi:  add in logic to handle multiple
 events and unknown NMIs
Message-ID: <20110928123720.GL5795@redhat.com>
References: <1316805435-14832-1-git-send-email-dzickus@redhat.com>
 <1316805435-14832-5-git-send-email-dzickus@redhat.com>
 <20110928103140.GD6063@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110928103140.GD6063@erda.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 28, 2011 at 12:31:40PM +0200, Robert Richter wrote:
> On 23.09.11 15:17:13, Don Zickus wrote:
> > @@ -89,6 +89,15 @@ static int notrace __kprobes nmi_handle(unsigned int type, struct pt_regs *regs)
> >  
> >  		handled += a->handler(type, regs);
> >  
> > +		/*
> > + 		 * Optimization: only loop once if this is not a 
> > + 		 * back-to-back NMI.  The idea is nothing is dropped
> > + 		 * on the first NMI, only on the second of a back-to-back
> > + 		 * NMI.  No need to waste cycles going through all the
> > + 		 * handlers.
> > + 		 */
> > +		if (!b2b && handled)
> > +			break;
> 
> I don't think we can leave this in. As said, there are cases that 2
> nmis trigger but the handler is called only once. Only the first would
> be handled then, and the second get lost cause there is no 2nd nmi
> call.

Right.  Avi, Jeremy what was your objection that needed this optimization
in the first place?

> 
> >  	}
> >  
> >  	rcu_read_unlock();
> > @@ -251,7 +260,13 @@ unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
> >  {
> >  	int handled;
> >  
> > -	handled = nmi_handle(NMI_UNKNOWN, regs);
> > +	/*
> > +	 * Use 'false' as back-to-back NMIs are dealt with one level up.
> > +	 * Of course this makes having multiple 'unknown' handlers useless
> > +	 * as only the first one is ever run (unless it can actually determine
> > +	 * if it caused the NMI)
> > +	 */
> > +	handled = nmi_handle(NMI_UNKNOWN, regs, false);
> >  	if (handled) 
> >  		return;
> >  #ifdef CONFIG_MCA
> > @@ -274,19 +289,49 @@ unknown_nmi_error(unsigned char reason, struct pt_regs *regs)
> >  	pr_emerg("Dazed and confused, but trying to continue\n");
> >  }
> >  
> > +static DEFINE_PER_CPU(bool, swallow_nmi);
> > +static DEFINE_PER_CPU(unsigned long, last_nmi_rip);
> > +
> >  static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
> >  {
> >  	unsigned char reason = 0;
> >  	int handled;
> > +	bool b2b = false;
> >  
> >  	/*
> >  	 * CPU-specific NMI must be processed before non-CPU-specific
> >  	 * NMI, otherwise we may lose it, because the CPU-specific
> >  	 * NMI can not be detected/processed on other CPUs.
> >  	 */
> > -	handled = nmi_handle(NMI_LOCAL, regs);
> > -	if (handled)
> > +
> > +	/*
> > +	 * Back-to-back NMIs are interesting because they can either
> > +	 * be two NMI or more than two NMIs (any thing over two is dropped
> > +	 * due to NMI being edge-triggered).  If this is the second half
> > +	 * of the back-to-back NMI, assume we dropped things and process
> > +	 * more handlers.  Otherwise reset the 'swallow' NMI behaviour
> > +	 */
> > +	if (regs->ip == __this_cpu_read(last_nmi_rip))
> > +		b2b = true;
> > +	else
> > +		__this_cpu_write(swallow_nmi, false);
> > +
> > +	__this_cpu_write(last_nmi_rip, regs->ip);
> 
> Just a minor thing and if you make a new version of this patch: You
> could move the write to the else branch.

Ah, true.  Thanks.

Cheers,
Don
