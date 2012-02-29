Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593Ab2B2MGs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 07:06:48 -0500
Received: from merlin.infradead.org ([205.233.59.134]:35923 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296Ab2B2MGq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 07:06:46 -0500
Message-ID: <1330517195.11248.148.camel@twins>
Subject: Re: Inconsistent load average on tickless kernels
From: Peter Zijlstra <peterz@infradead.org>
To: =?UTF-8?Q?Les=C5=82aw_Kope=C4=87?= <leslaw.kopec@nasza-klasa.pl>
Cc: Aman Gupta <aman@tmm1.net>, linux-kernel@vger.kernel.org,
        Chase Douglas <chase.douglas@canonical.com>,
        Damien Wyart <damien.wyart@free.fr>, Kyle McMartin <kyle@redhat.com>,
        Venkatesh Pallipadi <venki@google.com>,
        Jonathan Nieder <jrnieder@gmail.com>
Date: Wed, 29 Feb 2012 13:06:35 +0100
In-Reply-To: <4F465F6E.9070605@nasza-klasa.pl>
References: <CAK=uwuy80LaNdQ4P49i+bGUXFvxf1zB=oKqNBTdAyvFc+mOTyw@mail.gmail.com>
	 <4F465F6E.9070605@nasza-klasa.pl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-23 at 16:46 +0100, Lesław Kopeć wrote:

> Each kernel was compiled with CONFIG_NO_HZ enabled (no-hz variant) and
> disabled (hz variant). Here's a snapshot of load 15 on each kernel:

> 				no-hz	hz
> 2.6.32.55-*			0.59	0.57
> 2.6.32.55-*-74f5187ac8		3.56	11.79
> 2.6.32.55-*-0f004f5a69		0.61	11.76
> 2.6.37-rc5-*-0f004f5a69		0.67	11.65
> 2.6.37-rc5-*-pre-0f004f5a69	3.97	12.05

Missing here is a kernel build with CONFIG_NO_HZ but booted with
nohz=off; this would be an interesting data point because it includes
all the funny code but still ticks are the right frequency.

> My observations are:
> 
> 1. On tickless kernels load is very low where no or both patches
> (74f5187ac8 and 0f004f5a69) are applied.
> 
> 2. Kernels that have only patch 74f5187ac8 applied have the smallest
> difference between hz and no-hz variants. Still no-hz kernels are
> returning values lower than their hz siblings.
> 
> 3. Non-tickless kernels seem to be reporting correct load values.
> Overall trend and values are matching CPU utilization. Only exception is
> 2.6.32.55-hz which reports the same values as 2.6.32.55-no-hz.
> 
> 4. If x processes are using all available cycles load is correctly
> incremented by x. This behavior is consistent on all kernels.

Yay! at least we get something right.. Also, I think we actually will go
down to load 0 if the machine is idle, we used to get that wrong for
nohz too.

> Steps to reproduce: run a bunch of CPU bound processes that will not use
> all available cycles. The biggest difference between expected and
> measured load is around 30% CPU utilization in my case.

Hrmm, this suggests we age too hard with nohz code.. in your test case
is there significant idle time? That is, suppose you run each cpu at 30%
what is the period of you load? Running 3s out of 10s is significantly
different from running .3ms out of 1ms.

> Has there been any other patches that correct load calculation? Maybe
> I'm testing it in a wrong way? I'd appreciate any suggestions. I'd be
> happy to test new patches. Sadly, I cannot propose any fixes as kernel
> sources are still a mystery to me.

Darned load-tracking stuff.. I went over it again but couldn't spot
anything obviously broken. I suspect the tail magic of
calc_global_nohz() is busted, just not seeing it atm.

Will go brew myself a fresh pot of tea and stare more.


