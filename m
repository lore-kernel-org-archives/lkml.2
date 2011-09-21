Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750849Ab1IUOFO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 10:05:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55064 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750712Ab1IUOFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 10:05:12 -0400
Date: Wed, 21 Sep 2011 10:04:32 -0400
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
Message-ID: <20110921140432.GP5795@redhat.com>
References: <1316529792-6560-1-git-send-email-dzickus@redhat.com>
 <1316529792-6560-5-git-send-email-dzickus@redhat.com>
 <20110921100842.GA6063@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110921100842.GA6063@erda.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 12:08:42PM +0200, Robert Richter wrote:
> On 20.09.11 10:43:10, Don Zickus wrote:
> > @@ -87,6 +87,16 @@ static int notrace __kprobes nmi_handle(unsigned int type, struct pt_regs *regs)
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
> In rare cases we will lose nmis here.
> 
> We see a back-to-back nmi in the case if a 2 nmi source triggers
> *after* the nmi handler is entered. Depending on the internal cpu
> timing influenced by microcode and SMM code execution, the nmi may not
> entered immediately. So all sources that trigger *before* the nmi
> handler is entered raise only one nmi with no subsequent nmi.

Right, but that can only happen with the second NMI in the back-to-back
NMI case.  Here the optimization is only for the first NMI, with the
assumption that you will always have a second NMI if multiple sources
trigger, so you can process those in the second iteration (assuming we
correctly detect the back-to-back NMI condition).  Then when the second
NMI comes in, we have no idea how many we dropped to get here so we
process all the handlers based on the assumption we might not have another
NMI behind us to make up for the dropped NMIs.

Unless I misunderstood your point above?

> 
> However, as these cases should be very rare, I think we can live with
> it in favor of the optimization to jump out the handler chain and save
> lot of cpu cycles esp. in the case of heavy PMI load.

I think it is covered as described above?

Cheers,
Don
