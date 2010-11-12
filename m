Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102Ab0KLNWI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 08:22:08 -0500
Received: from casper.infradead.org ([85.118.1.10]:47276 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069Ab0KLNWF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 08:22:05 -0500
Subject: Re: [PATCH 2/3] perf: Add support for extra parameters for raw
 events
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, mingo@elte.hu, acme@redhat.com,
        paulus <paulus@samba.org>, Tony Luck <tony.luck@intel.com>
In-Reply-To: <AANLkTinjzZnv8dzfKPzgGtRnk5C-XsAt=gyf_4G0+gf8@mail.gmail.com>
References: <1289492117-18066-1-git-send-email-andi@firstfloor.org>
	 <1289492117-18066-2-git-send-email-andi@firstfloor.org>
	 <4CDC2DDD.50508@linux.vnet.ibm.com> <4CDC3845.4030104@linux.intel.com>
	 <4CDC4628.8020109@linux.vnet.ibm.com>
	 <20101111194936.GJ18718@basil.fritz.box> <1289505587.2084.193.camel@laptop>
	 <20101111201259.GL18718@basil.fritz.box> <1289507858.2084.195.camel@laptop>
	 <20101112102748.GA8020@basil.fritz.box>
	 <AANLkTi=idvNVyccD53Xwjp5mWfJb=S8UXekhXNqhzRPC@mail.gmail.com>
	 <1289561817.2084.240.camel@laptop>
	 <AANLkTinjzZnv8dzfKPzgGtRnk5C-XsAt=gyf_4G0+gf8@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 12 Nov 2010 14:21:17 +0100
Message-ID: <1289568077.2084.256.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-12 at 14:00 +0100, Stephane Eranian wrote:
> I don't understand what aspect you think is messy. When you are sampling
> cache misses, you expect to get the tuple (instr addr, data addr, latency,
> data source). 

Its the data source thing I have most trouble with -- see below. The
latency isn't immediately clear either, I mean the larger the bubble the
more hits the instruction will get, so there should be a correlation
between samples and latency.

> That is what you get with AMD IBS, Nehalem PEBS-LL and
> also Itanium D-EAR. I am sure IBM Power has something similar as well.
> To collect this, you can either store the info in registers (AMD, Itanium)
> or in a buffer (PEBS). But regardless of that you will always have to expose
> the tuple. We have a solution for two out of 4 fields that reuses the existing
> infrastructure. We need something else for the other two.

Well, if Intel PEBS, IA64 and PPC64 all have a data source thing we can
simply add PERF_SAMPLE_SOURCE or somesuch and use that. 

Do IA64/PPC64 have latency fields as well? PERF_SAMPLE_LATENCY would
seem to be the thing to use in that case.

BTW, what's the status of perf on IA64? And do we really still care
about that platform, its pretty much dead isn't it?

> We should expect that in the future PMUs will collect more than code addresses. 

Sure, but I hate stuff that counts multiple events on a single base like
IBS does, and LL is similar to that, its a fetch retire counter and then
you report where fetch was satisfied from. So in effect you're measuring
l1/l2/l3/dram hit/miss all at the same time but on a fetch basis.

Note that we need proper userspace for such crap as well, and libpfm
doesn't count, we need a full analysis tool in perf itself.
