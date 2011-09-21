Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003Ab1IUQWf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 12:22:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18426 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926Ab1IUQWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 12:22:33 -0400
Date: Wed, 21 Sep 2011 12:13:52 -0400
From: Don Zickus <dzickus@redhat.com>
To: Robert Richter <robert.richter@amd.com>
Cc: "x86@kernel.org" <x86@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "avi@redhat.com" <avi@redhat.com>, "jeremy@goop.org" <jeremy@goop.org>
Subject: Re: [V5][PATCH 4/6] x86, nmi:  add in logic to handle multiple
 events and unknown NMIs
Message-ID: <20110921161352.GU5795@redhat.com>
References: <1316529792-6560-1-git-send-email-dzickus@redhat.com>
 <1316529792-6560-5-git-send-email-dzickus@redhat.com>
 <20110921100842.GA6063@erda.amd.com>
 <20110921140432.GP5795@redhat.com>
 <20110921151829.GC6063@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110921151829.GC6063@erda.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 05:18:30PM +0200, Robert Richter wrote:
> On 21.09.11 10:04:32, Don Zickus wrote:
> > On Wed, Sep 21, 2011 at 12:08:42PM +0200, Robert Richter wrote:
> > > On 20.09.11 10:43:10, Don Zickus wrote:
> > > > @@ -87,6 +87,16 @@ static int notrace __kprobes nmi_handle(unsigned int type, struct pt_regs *regs)
> > > >  
> > > >  		handled += a->handler(type, regs);
> > > >  
> > > > +		/*
> > > > + 		 * Optimization: only loop once if this is not a 
> > > > + 		 * back-to-back NMI.  The idea is nothing is dropped
> > > > + 		 * on the first NMI, only on the second of a back-to-back
> > > > + 		 * NMI.  No need to waste cycles going through all the
> > > > + 		 * handlers.
> > > > + 		 */
> > > > +		if (!b2b && handled)
> > > > +			break;
> > > 
> > > In rare cases we will lose nmis here.
> > > 
> > > We see a back-to-back nmi in the case if a 2 nmi source triggers
> > > *after* the nmi handler is entered. Depending on the internal cpu
> > > timing influenced by microcode and SMM code execution, the nmi may not
> > > entered immediately. So all sources that trigger *before* the nmi
> > > handler is entered raise only one nmi with no subsequent nmi.
> > 
> > Right, but that can only happen with the second NMI in the back-to-back
> > NMI case.  Here the optimization is only for the first NMI, with the
> > assumption that you will always have a second NMI if multiple sources
> > trigger, so you can process those in the second iteration (assuming we
> > correctly detect the back-to-back NMI condition).  Then when the second
> > NMI comes in, we have no idea how many we dropped to get here so we
> > process all the handlers based on the assumption we might not have another
> > NMI behind us to make up for the dropped NMIs.
> > 
> > Unless I misunderstood your point above?
> 
> No, my point was that a second NMI might not be latched even if there
> are two nmi sources pending.
> 
> Your logic is correct but assumes you will always receive a second
> nmi. This is not always the case depending on the cpu's internal
> timing. Usually there is the following sequence for back-to-back nmis:
> 
> 1. HW triggers first NMI, an NMI is pending.
> 2. NMI handler is called, no NMI pending anymore.
> 3. HW triggers a second NMI, an NMI is pending.
> 4. Return from NMI handler.
> 5. NMI handler is called again to serve the 2nd, no NMI pending anymore.
> 6. Return from NMI handler.
> 
> The above is what your algorithm covers.
> 
> But in rare cases there is the following:
> 
> 1. The cpu executes some microcode or SMM code.
> 2. HW triggers the first NMI, an NMI is pending.
> 3. HW triggers a second NMI, the NMI is still pending.
> 4. The cpu finished microcode or SMM code.
> 5. NMI handler is called, no NMI pending anymore.
> 6. Return from NMI handler.
> 
> In this case the handler is called only once and the second nmi
> remains unhandled with you implementation.
> 
> I don't see a way how this could be catched without serving all
> handlers the first time. But as said, in favor of the optimization I
> think we can live with losing some NMIs.

Ah, I get it know.  Crap.  Well I think Avi was pushing it to make those
ticket_spin_locks work in virt land.  It seems like we should lean towards
removing the optimization.  Avi?

Cheers,
Don
