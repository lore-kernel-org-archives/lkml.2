Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480Ab0HSAUn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 20:20:43 -0400
Received: from mga03.intel.com ([143.182.124.21]:1373 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849Ab0HSAUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 20:20:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,230,1280732400"; 
   d="scan'208";a="314277460"
Subject: Re: [patch 1/3] sched: init rt_avg stat whenever rq comes online
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "mingo@elte.hu" <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "chris@frostnet.net" <chris@frostnet.net>,
        "debian00@aliceadsl.fr" <debian00@aliceadsl.fr>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "jonathan.protzenko@gmail.com" <jonathan.protzenko@gmail.com>,
        "mans@mansr.com" <mans@mansr.com>,
        "psastudio@mail.ru" <psastudio@mail.ru>, "rjw@sisk.pl" <rjw@sisk.pl>,
        "stephan.eicher@web.de" <stephan.eicher@web.de>,
        "sxxe@gmx.de" <sxxe@gmx.de>,
        "thomas@archlinux.org" <thomas@archlinux.org>,
        "venki@google.com" <venki@google.com>,
        "wonghow@gmail.com" <wonghow@gmail.com>,
        "stable@kernel.org" <stable@kernel.org>, tglx <tglx@linutronix.de>
In-Reply-To: <1282035085.1926.2164.camel@laptop>
References: <20100813190539.410550989@sbsiddha-MOBL3.sc.intel.com>
	 <20100813193911.827207098@sbsiddha-MOBL3.sc.intel.com>
	 <1281944854.1926.948.camel@laptop>
	 <1281980179.2676.22.camel@sbsiddha-MOBL3.sc.intel.com>
	 <1281986708.1926.1877.camel@laptop>  <1282035085.1926.2164.camel@laptop>
Content-Type: text/plain
Organization: Intel Corp
Date: Wed, 18 Aug 2010 17:20:13 -0700
Message-Id: <1282177213.7801.17.camel@sbsiddha-MOBL3.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-17 at 01:51 -0700, Peter Zijlstra wrote:
> On Mon, 2010-08-16 at 21:25 +0200, Peter Zijlstra wrote:
> > You can use something like:
> > 
> > suspend:
> >  __get_cpu_var(cyc2ns_suspend) = sched_clock();
> > 
> > resume:
> >  for_each_possible_cpu(i)
> >    per_cpu(cyc2ns_offset, i) += per_cpu(cyc2ns_suspend);
> > 
> > or something like that to keep sched_clock() stable, which is exactly
> > what most (all?) its users expect when we report the TSC is usable. 
> 
> That's actually broken, you only want a single offset, otherwise we
> de-sync the TSC, which is bad.
> 
> So simply store the sched_clock() value at suspend time on the single
> CPU that is still running, then on resume make sure sched_clock()
> continues there by adding that stamp to all CPU offsets.


Peter, That might not be enough. I should add that in my Lenovo T410
(having 2 core wsm cpu), TSC's are somehow set to a strange big value
(for example 0xfffffffebc22f02e) after resume from S3. It looks like
bios might be writing TSC during resume. I am not sure if this is the
case for other OEM laptops aswell. I am checking.

So such large values of TSC (leading to a very big difference between
rq->clock and rq->age_stamp) wont be correctly handled by
scale_rt_power() either.

thanks,
suresh

