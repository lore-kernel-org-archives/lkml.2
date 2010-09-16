Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721Ab0IPGxb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 02:53:31 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:60736 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683Ab0IPGx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 02:53:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=aH3jvQ7TWUYHQrF56eZOIogCPEzmEcFkGaO4hDNYvSYcMibBRWHDAB4bp5RR/V2fN5
         FqGvbzUvgNAMfPoCnBY0djv7CGSUGK7M/AO+cytxV8BFASs/Z7ISscuxstwlx7fikgmG
         dpunTggtwMEcahpqbNbX1F8zs1K8vl2DhcZWk=
Date: Thu, 16 Sep 2010 10:53:24 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, Don Zickus <dzickus@redhat.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>
Subject: Re: [PATCH] perf, x86: catch spurious interrupts after disabling
	counters
Message-ID: <20100916065324.GA6470@lenovo>
References: <20100912095202.GF13563@erda.amd.com> <20100913143713.GK13563@erda.amd.com> <20100914174132.GN13563@erda.amd.com> <20100915162034.GO13563@erda.amd.com> <20100915164610.GA5959@lenovo> <AANLkTim5knbg8GdUAYyx_i5WQUwnez8tHkU1SfiJJ+L7@mail.gmail.com> <20100915170222.GB5959@lenovo> <20100915172805.GR13563@erda.amd.com> <20100915174012.GC5959@lenovo> <20100915221041.GT13563@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100915221041.GT13563@erda.amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 16, 2010 at 12:10:41AM +0200, Robert Richter wrote:
> On 15.09.10 13:40:12, Cyrill Gorcunov wrote:
> > Yeah, already noted from your previous email. Perhaps we might
> > do a bit simplier approach then -- in nmi handler were we mark
> > "next nmi" we could take into account not "one next" nmi but
> > sum of handled counters minus one being just handled (of course
> > cleaning this counter if new "non spurious" nmi came in), can't
> > say I like this approach but just a thought.
> 
> If we disable a counter, it might still trigger an interrupt which we
> cannot detect. Thus, if a running counter is deactivated, we must
> count it as handled in the nmi handler.
> 
> Working with a sum is not possible, because a disabled counter may or
> *may not* trigger an interrupt. We cannot predict the number of
> counters that will be handled.
> 
> Dealing with the "next nmi" is also not handy here. Spurious nmis are
> caused then stopping a counter. Since this is done outside the nmi
> handler, we would then start touching the "next nmi" also outside the
> handler. This might be more complex because we then have to deal with
> locking or atomic access. We shouldn't do that.
> 
> -Robert
>

OK, I see what you mean Robert. Btw, when you reorder cpu_active_mask access
and wrmsr did you try also additional read after write of msr? ie like

	wrmsr
	barrier() // just to be sure gcc would not reorder it
	rdmsr
	clear cpu_active_mask

wonders if it did the trick

	-- Cyrill
