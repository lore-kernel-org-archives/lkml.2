Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964942Ab2FAPm6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 11:42:58 -0400
Received: from mga14.intel.com ([143.182.124.37]:23600 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964838Ab2FAPm5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 11:42:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="150444522"
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@amd64.org>
CC: Steven Rostedt <rostedt@goodmis.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, "Chen, Gong" <gong.chen@intel.com>
Subject: RE: [PATCH] RAS: Add a tracepoint for reporting memory controller
 events
Thread-Topic: [PATCH] RAS: Add a tracepoint for reporting memory controller
 events
Thread-Index: AQHNOZYGtI1DcNZxtEGCK0mbRpqc+pbZOc0AgABYoYCAAAkdAIAAFPOAgAd2gYCAACJ1AIAADiKAgAAIj4CAAZ5vgIABK+aAgAAJUICAAB0igIAAG5oAgAAHRYCAAAZIAIAAApkAgAAB+ICAAAOVAIAAENkAgAAQiYCAACboAIAAApWAgAAIOQCAAAHrAP//kZqggAFGGgD//+9NkA==
Date: Fri, 1 Jun 2012 15:42:54 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F192F71DB@ORSMSX104.amr.corp.intel.com>
References: <20120531145416.GI14515@aftab.osrc.amd.com>
 <4FC787BF.3020006@redhat.com> <20120531151408.GJ14515@aftab.osrc.amd.com>
 <4FC798E2.4000402@redhat.com> <20120531171337.GN14515@aftab.osrc.amd.com>
 <1338492772.13348.388.camel@gandalf.stny.rr.com>
 <20120531194207.GC16998@aftab.osrc.amd.com>
 <1338495092.13348.419.camel@gandalf.stny.rr.com>
 <20120531201824.GD16998@aftab.osrc.amd.com>
 <3908561D78D1C84285E8C5FCA982C28F192F6DE2@ORSMSX104.amr.corp.intel.com>
 <20120601091026.GC20959@aftab.osrc.amd.com>
In-Reply-To: <20120601091026.GC20959@aftab.osrc.amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yeah, about that. What are you guys doing about losing CECCs when
> throttling is on, I'm assuming there's no way around it?

Yes, when throttling is on, we will lose errors, but I don't think
this is too big of a deal - see below.

>> Will EDAC drivers loop over some chipset registers blasting
>> out huge numbers of trace records ... that seems just as bad
>> for system throughput as a CMCI storm. And just as useless.
>
> Why useless?

"Useless" was hyperbole - but "overkill" will convey my meaning better.

Consider the case when we are seeing a storm of errors reported. How
many such error reports do you need to adequately diagnose the problem?

If you have a stuck bit in a hot memory location, all the reports will
be at the same address. After 10 repeats you'll be pretty sure that
you have just one problem address. After 100 identical reports you
should be convinced ... no need to log another million.

If there is a path failure that results in a whole range of addresses
reporting bad, then 10 may not be enough to identify the pattern, but
100 should get you close, and 1000 ought to be close enough to certainty
that dropping records 1001 ... 1000000 won't adversely affect your
diagnosis.

[Gong: after thinking about this to write the above - I think that the
 CMCI storm detector should trigger at a higher number than "5" that
 we picked. That works well for the single stuck bit, but perhaps doesn't
 give us enough samples for the case where the error affects a range of
 addresses. We should consider going to 50, or perhaps even 500 ... but
 we'll need some measurements to determine the impact on the system from
 taking that many CMCI interrupts and logging the larger number of errors.]

The problem case is if you are unlucky enough to have two different
failures at the same time. One with storm like properties, the other
with some very modest rate of reporting. This is where early filtering
might hurt you ... diagnosis might miss the trickle of errors hidden by
the noise of the storm. So in this case we might throttle the errors,
deal with the source of the storm, and then die because we missed the
early warning signs from the trickle.  But this scenario requires a lot
of rare things to happen all at the same time:
- Two unrelated errors, with specific characteristics
- The quieter error to be completely swamped by the storm
- The quieter error to escalate to fatal in a really short period (before
  we can turn off filtering after silencing the source of the storm).

I think this is at least as good as trying to capture every error. Doing
this means that we are so swamped by the logging that we also might not
get around to solving the storm problem before our quiet killer escalates.

Do you have other scenarios where you think we can do better if we log
tens of thousands or hundreds of thousands of errors in order to diagnose
the source(s) of the problem(s)?

-Tony
