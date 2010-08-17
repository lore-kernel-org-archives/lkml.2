Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932239Ab0HQIv6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 04:51:58 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:32797 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932194Ab0HQIv4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 04:51:56 -0400
Subject: Re: [patch 1/3] sched: init rt_avg stat whenever rq comes online
From: Peter Zijlstra <peterz@infradead.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
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
In-Reply-To: <1281986708.1926.1877.camel@laptop>
References: <20100813190539.410550989@sbsiddha-MOBL3.sc.intel.com>
	 <20100813193911.827207098@sbsiddha-MOBL3.sc.intel.com>
	 <1281944854.1926.948.camel@laptop>
	 <1281980179.2676.22.camel@sbsiddha-MOBL3.sc.intel.com>
	 <1281986708.1926.1877.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 17 Aug 2010 10:51:25 +0200
Message-ID: <1282035085.1926.2164.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-16 at 21:25 +0200, Peter Zijlstra wrote:
> You can use something like:
> 
> suspend:
>  __get_cpu_var(cyc2ns_suspend) = sched_clock();
> 
> resume:
>  for_each_possible_cpu(i)
>    per_cpu(cyc2ns_offset, i) += per_cpu(cyc2ns_suspend);
> 
> or something like that to keep sched_clock() stable, which is exactly
> what most (all?) its users expect when we report the TSC is usable. 

That's actually broken, you only want a single offset, otherwise we
de-sync the TSC, which is bad.

So simply store the sched_clock() value at suspend time on the single
CPU that is still running, then on resume make sure sched_clock()
continues there by adding that stamp to all CPU offsets.


