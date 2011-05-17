Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205Ab1EQFkE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 01:40:04 -0400
Received: from mga01.intel.com ([192.55.52.88]:23322 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221Ab1EQFkC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 01:40:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,223,1304319600"; 
   d="scan'208";a="3158629"
Message-ID: <4DD20A2F.604@intel.com>
Date: Tue, 17 May 2011 13:39:59 +0800
From: Huang Ying <ying.huang@intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110402 Iceowl/1.0b2 Icedove/3.1.9
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: Cyrill Gorcunov <gorcunov@gmail.com>,
        huang ying <huang.ying.caritas@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [RFC] x86, NMI, Treat unknown NMI as hardware error
References: <1305275018-20596-1-git-send-email-ying.huang@intel.com> <4DCD4B85.3040702@gmail.com> <BANLkTin7LNo0dDLs-Rz6WqCQ9RvS=MLXcw@mail.gmail.com> <4DCE3493.4090404@gmail.com> <BANLkTin1pvdnXtw53MhwfCsEQpsu0TUUmg@mail.gmail.com> <4DCF7413.4070704@gmail.com> <4DD07959.4030608@intel.com> <20110516190310.GH31888@redhat.com>
In-Reply-To: <20110516190310.GH31888@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2011 03:03 AM, Don Zickus wrote:
> On Mon, May 16, 2011 at 09:09:45AM +0800, Huang Ying wrote:
>>>   Ying, the concern is rather related to the code scheme in general. Since
>>> we have notifiers I think the better way to be consistent here and use
>>> hwerr notifier too. But it's IMHO ;)
>>
>> As for go notifiers or not.  IMHO, a rule can be:
>>
>> - If it is something like a driver, than it should go notifier
>> - If it is architectural/PC defacto standard, it can sit outside of
>> notifier.
> 
> Hmm, then what do you do about perf?  That is architectural and a defacto
> standard, but I am not sure hardcoding that would be appropriate.

Yes.  perf is architectural, so its source is not put into drivers
directory.  And I think it is a good idea to put perf NMI handler call
directly into system NMI handler instead of a notifier chain.  Unknown
NMI as HW error is far more smaller than perf.  So it can be put into
system NMI handler directly.

>> I think that seeing unknown NMI as hardware error should be part of PC
>> defacto standard.  Do you think so?
> 
> Well after thinking about it, I would say no.  And my reason is, if
> vendors are really serious about using NMIs as an indicator for hardware
> errors, shouldn't they be setting a bit in the memory controller/north
> bridge or south bridge/IOHC for an NMI handler to read?  I mean hardware
> devices don't just get wired directly to the NMI pin on the cpu, right?
> They generally have to go through some hub that acts as a multiplexer.
> 
> In those cases, why can't those hubs set a bit saying it detected an error
> (don't PCIe bridges already do that?) and let the NMI handler read it to
> confirm.  This way we can leave 'unknown NMIs' as a way to say an
> unclaimed NMI entered the system and we can have users set policy about
> what to do, panic, printk, whatever.
> 
> But for the HEST stuff, it should be smart enough by now to trap any
> hardware error, no?  How does a machine that supports HEST let a hardware
> error get through without detecting it?  Isn't that the point?  Detect a
> hardware error, grab as much info about it as possible, save the error
> record and then panic?
> 
> Otherwise if you just panic, then you have no idea why the machine errored
> in the first place.  It might be the safe thing to do in some
> circumstances, but then you have to wonder why the fancy HEST enabled
> server didn't catch it.  Isn't that what people are spending extra money
> for those Intel servers with RAS features?

All you said is possible in theory.  But as far as I know, Windows
thinks unknown NMI is for hardware error and displays blue scrren for
it.  So some hardware OEMs use unknown NMI to report hardware error.
Even on machines with HEST, there may be no GHES record (just unknown
NMI) if Windows does not tell BIOS that it has support for GHES.

Best Regards,
Huang Ying
