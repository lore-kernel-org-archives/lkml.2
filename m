Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347Ab1EPTDk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 15:03:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59958 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013Ab1EPTDj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 15:03:39 -0400
Date: Mon, 16 May 2011 15:03:10 -0400
From: Don Zickus <dzickus@redhat.com>
To: Huang Ying <ying.huang@intel.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
        huang ying <huang.ying.caritas@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [RFC] x86, NMI, Treat unknown NMI as hardware error
Message-ID: <20110516190310.GH31888@redhat.com>
References: <1305275018-20596-1-git-send-email-ying.huang@intel.com>
 <4DCD4B85.3040702@gmail.com>
 <BANLkTin7LNo0dDLs-Rz6WqCQ9RvS=MLXcw@mail.gmail.com>
 <4DCE3493.4090404@gmail.com>
 <BANLkTin1pvdnXtw53MhwfCsEQpsu0TUUmg@mail.gmail.com>
 <4DCF7413.4070704@gmail.com>
 <4DD07959.4030608@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DD07959.4030608@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 16, 2011 at 09:09:45AM +0800, Huang Ying wrote:
> >   Ying, the concern is rather related to the code scheme in general. Since
> > we have notifiers I think the better way to be consistent here and use
> > hwerr notifier too. But it's IMHO ;)
> 
> As for go notifiers or not.  IMHO, a rule can be:
> 
> - If it is something like a driver, than it should go notifier
> - If it is architectural/PC defacto standard, it can sit outside of
> notifier.

Hmm, then what do you do about perf?  That is architectural and a defacto
standard, but I am not sure hardcoding that would be appropriate.

> 
> I think that seeing unknown NMI as hardware error should be part of PC
> defacto standard.  Do you think so?

Well after thinking about it, I would say no.  And my reason is, if
vendors are really serious about using NMIs as an indicator for hardware
errors, shouldn't they be setting a bit in the memory controller/north
bridge or south bridge/IOHC for an NMI handler to read?  I mean hardware
devices don't just get wired directly to the NMI pin on the cpu, right?
They generally have to go through some hub that acts as a multiplexer.

In those cases, why can't those hubs set a bit saying it detected an error
(don't PCIe bridges already do that?) and let the NMI handler read it to
confirm.  This way we can leave 'unknown NMIs' as a way to say an
unclaimed NMI entered the system and we can have users set policy about
what to do, panic, printk, whatever.

But for the HEST stuff, it should be smart enough by now to trap any
hardware error, no?  How does a machine that supports HEST let a hardware
error get through without detecting it?  Isn't that the point?  Detect a
hardware error, grab as much info about it as possible, save the error
record and then panic?

Otherwise if you just panic, then you have no idea why the machine errored
in the first place.  It might be the safe thing to do in some
circumstances, but then you have to wonder why the fancy HEST enabled
server didn't catch it.  Isn't that what people are spending extra money
for those Intel servers with RAS features?

Cheers,
Don
