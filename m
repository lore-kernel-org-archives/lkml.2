Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933330Ab1INUpI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 16:45:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37635 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933306Ab1INUpH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 16:45:07 -0400
Date: Wed, 14 Sep 2011 16:44:46 -0400
From: Don Zickus <dzickus@redhat.com>
To: Robert Richter <robert.richter@amd.com>
Cc: "x86@kernel.org" <x86@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "avi@redhat.com" <avi@redhat.com>, "jeremy@goop.org" <jeremy@goop.org>
Subject: Re: [V4][PATCH 4/6] x86, nmi:  add in logic to handle multiple
 events and unknown NMIs
Message-ID: <20110914204446.GZ5795@redhat.com>
References: <1315947509-6429-1-git-send-email-dzickus@redhat.com>
 <1315947509-6429-5-git-send-email-dzickus@redhat.com>
 <20110914162653.GI6063@erda.amd.com>
 <20110914175809.GY5795@redhat.com>
 <20110914201612.GK6063@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110914201612.GK6063@erda.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 14, 2011 at 10:16:12PM +0200, Robert Richter wrote:
> On 14.09.11 13:58:09, Don Zickus wrote:
> > On Wed, Sep 14, 2011 at 06:26:53PM +0200, Robert Richter wrote:
> > > On 13.09.11 16:58:27, Don Zickus wrote:
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
> > > Don, if I am not missing something, this actually does not work
> > > because perfctr NMIs do not re-trigger. Suppose a handler running
> > > before perfctr. It sets 'handled' and the chain is stopped here. To
> > > run through the perfctr handler the NMI must retrigger which it
> > > doesn't.
> > 
> > Your patch is incorrect.  Your dummy handler does not handle a _real_ NMI.
> > Which means no _real_ NMI was ever generated.  Of course perf won't work.
> > You just swallowed its NMI.
> > 
> > The change I made is for nmi handlers that actually have an NMI associated
> > with them.  The idea is if somebody generated an NMI, it will get handled
> > by a handler.  If perf comes along and generates another NMI, it should
> > get latched.  Upon handling the first NMI, the perf NMI should be sitting
> > queued up and cause the back-to-back NMI. In this case all the handlers
> > will be executed (to handle dropped NMIs).
> 
> Yes, your thought about the latched NMI could work. Though I better

I don't think it is a matter of could as I believe this is how x86 is
designed if I understand correctly. :-)

> test this with some real nmis from different sources.  Unfortunately
> this is much harder to trigger. Will give it a try. It would be a
> pretty nice optimization then.

That is why I was generating NMIs using IPIs

apic->send_IPI_mask(cpumask_of(smp_processor_id()), NMI_VECTOR)

> 
> > My only question to you is the IBS stuff you were working on.  Does that
> > generate a _real_ NMI or does it just piggy back off of the perf NMI?
> 
> Yes, IBS generates real NMIs, there is an own interrupt vector for
> it.

Ok, good.

Cheers,
Don
