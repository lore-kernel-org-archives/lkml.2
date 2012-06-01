Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965176Ab2FAQA0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 12:00:26 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:49854 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965159Ab2FAQAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 12:00:24 -0400
Date: Fri, 1 Jun 2012 18:00:50 +0200
From: Borislav Petkov <bp@amd64.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Borislav Petkov <bp@amd64.org>, Steven Rostedt <rostedt@goodmis.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, "Chen, Gong" <gong.chen@intel.com>
Subject: Re: [PATCH] RAS: Add a tracepoint for reporting memory controller
 events
Message-ID: <20120601160050.GE28216@aftab.osrc.amd.com>
References: <20120531151408.GJ14515@aftab.osrc.amd.com>
 <4FC798E2.4000402@redhat.com>
 <20120531171337.GN14515@aftab.osrc.amd.com>
 <1338492772.13348.388.camel@gandalf.stny.rr.com>
 <20120531194207.GC16998@aftab.osrc.amd.com>
 <1338495092.13348.419.camel@gandalf.stny.rr.com>
 <20120531201824.GD16998@aftab.osrc.amd.com>
 <3908561D78D1C84285E8C5FCA982C28F192F6DE2@ORSMSX104.amr.corp.intel.com>
 <20120601091026.GC20959@aftab.osrc.amd.com>
 <3908561D78D1C84285E8C5FCA982C28F192F71DB@ORSMSX104.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F192F71DB@ORSMSX104.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2012 at 03:42:54PM +0000, Luck, Tony wrote:
> > Yeah, about that. What are you guys doing about losing CECCs when
> > throttling is on, I'm assuming there's no way around it?
> 
> Yes, when throttling is on, we will lose errors, but I don't think
> this is too big of a deal - see below.
> 
> >> Will EDAC drivers loop over some chipset registers blasting
> >> out huge numbers of trace records ... that seems just as bad
> >> for system throughput as a CMCI storm. And just as useless.
> >
> > Why useless?
> 
> "Useless" was hyperbole - but "overkill" will convey my meaning better.
> 
> Consider the case when we are seeing a storm of errors reported. How
> many such error reports do you need to adequately diagnose the problem?
> 
> If you have a stuck bit in a hot memory location, all the reports will
> be at the same address. After 10 repeats you'll be pretty sure that
> you have just one problem address. After 100 identical reports you
> should be convinced ... no need to log another million.

Yeah, we want to have sensible thresholds for this, after which the
(n+1)-st error reported at the same address offlines the page.

> If there is a path failure that results in a whole range of addresses
> reporting bad, then 10 may not be enough to identify the pattern,
> but 100 should get you close, and 1000 ought to be close enough to
> certainty that dropping records 1001 ... 1000000 won't adversely
> affect your diagnosis.

Right, so I've been thinking about collecting error addresses in
userspace (ras daemon or whatever) with a leaky bucket counter which,
when reaching a previously programmed threshold, offlines the page.

This should hopefully mitigate the error burst faster and bring back
CMCI from polling to normal interrupts.

> [Gong: after thinking about this to write the above - I think that the
> CMCI storm detector should trigger at a higher number than "5" that we
> picked. That works well for the single stuck bit, but perhaps doesn't
> give us enough samples for the case where the error affects a range
> of addresses. We should consider going to 50, or perhaps even 500 ...
> but we'll need some measurements to determine the impact on the system
> from taking that many CMCI interrupts and logging the larger number of
> errors.]

And I'm thinking that with proper, proactive page offlining triggered
from userspace you probably might need the throttling in the kernel on
only very rare, bursting occasions ...

> The problem case is if you are unlucky enough to have two different
> failures at the same time. One with storm like properties, the other
> with some very modest rate of reporting. This is where early filtering
> might hurt you ... diagnosis might miss the trickle of errors hidden by
> the noise of the storm. So in this case we might throttle the errors,
> deal with the source of the storm, and then die because we missed the
> early warning signs from the trickle.  But this scenario requires a lot
> of rare things to happen all at the same time:
> - Two unrelated errors, with specific characteristics
> - The quieter error to be completely swamped by the storm
> - The quieter error to escalate to fatal in a really short period (before
>   we can turn off filtering after silencing the source of the storm).

Yeah, that's nasty. I don't think you can catch a case like that where
an error turns into UC under the threshold value...

If you consume it, you kill the process, if it is in kernel space, you
really have to pack your bags and hang on to your hat.

> I think this is at least as good as trying to capture every error.
> Doing this means that we are so swamped by the logging that we also
> might not get around to solving the storm problem before our quiet
> killer escalates.

Yessir.

> Do you have other scenarios where you think we can do better if we
> log tens of thousands or hundreds of thousands of errors in order to
> diagnose the source(s) of the problem(s)?

My only example is by counting the errors in userspace and using a leaky
bucket algo to decide when to act by offlining pages or disabling hw
components.

This is why I'm advocating the userspace - you can implement almost
anything there - we only need the kernel to be as thin and as fast when
reporting those errors so that we can have the most reliable and full
info as possible. The kernel's job is only to report as many errors
as it possibly can so that userspace can create a good picture of the
situation.

Then, it should act swiftly when disabling those pages so that the
kernel can get back to normal operation as fast as possible.

If we decide - for whatever reason - that we need a different policy, we
can always hack it up quickly in the ras daemon.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
