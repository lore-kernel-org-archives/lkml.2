Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760810Ab2EWUxw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 16:53:52 -0400
Received: from mga01.intel.com ([192.55.52.88]:24661 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758942Ab2EWUxu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 16:53:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="170544304"
From: "Luck, Tony" <tony.luck@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: Chen Gong <gong.chen@linux.intel.com>, "bp@amd64.org" <bp@amd64.org>,
        "x86@kernel.org" <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: RE: [PATCH] x86: auto poll/interrupt mode switch for CMC to stop
 CMC storm
Thread-Topic: [PATCH] x86: auto poll/interrupt mode switch for CMC to stop
 CMC storm
Thread-Index: AQHNOIwYcjpXeEEfSUqwVYn22Q7zo5bXnJGA///5EsCAAJq/AP//onrQ
Date: Wed, 23 May 2012 20:53:49 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F192F30C0@ORSMSX104.amr.corp.intel.com>
References: <1337740341-26711-1-git-send-email-gong.chen@linux.intel.com>
 <alpine.LFD.2.02.1205230859190.3231@ionos>
 <3908561D78D1C84285E8C5FCA982C28F192F2DD6@ORSMSX104.amr.corp.intel.com>
 <alpine.LFD.2.02.1205232044150.3231@ionos>
In-Reply-To: <alpine.LFD.2.02.1205232044150.3231@ionos>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If that's the case, then I really can't understand the 5 CMCIs per
> second threshold for defining the storm and switching to poll mode.
> I'd rather expect 5 of them in a row.

We don't have a lot of science to back up the "5" number (and
can change it to conform to any better numbers if someone has
some real data).

My general approximation for DRAM corrected error rates is
"one per gigabyte per month, plus or minus two orders of
 magnitude". So if I saw 1600 errors per month on a 16GB
workstation, I'd think that was a high rate - but still
plausible from natural causes (especially if the machine
was some place 5000 feet above sea level with a lot less
atmosphere to block neutrons). That only amounts to a couple
of errors per hour. So five in a second is certainly a storm!

Looking at this from another perspective ... how many
CMCIs can we take per second before we start having a
noticeable impact on system performance. RT answer may
be quite a small number, generic throughput computing
answer might be several hundred per second.

The situation we are trying to avoid is a stuck bit on
some very frequently accessed piece of memory generating
a solid stream of CMCI that make the system unusable. In
this case the question is for how long do we let the storm
rage before we turn of CMCI to get some real work done.

Once we are in polling mode, we do lose data on the location
of some corrected errors. But I don't think that this is
too serious. If there are few errors, we want to know about
them all. If there are so many that we have difficulty
counting them all - then sampling from a subset will
give us reasonable data most of the time (the exception
being the case where we have one error source that is
100,000 times as noisy as some other sources that we'd
still like to keep tabs on ... we'll need a *lot* of samples
to see the quieter error sources amongst the noise).

So I think there are justifications for numbers in the
2..1000 range. We could punt it to the user by making
it configurable/tunable ... but I think we already have
too many tunables that end-users don't have enough information
to really set in meaningful ways to meet their actual
needs - so I'd prefer to see some "good enough" number
that meets the needs, rather than yet another /sys/...
file that people can tweak.

-Tony
