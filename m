Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834Ab0IORkS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 13:40:18 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:39474 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753890Ab0IORkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 13:40:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vFbfffM6p4CETS3to8xAwMbZnAWqEUqQkj/Gbur6ROvIdI+2GhaccS2QeO35vLYS0c
         nLuGbYkXpQs6Hi0HsAba2dSbOUoTPkbL4dkwE1XhVAzFi72vIddWbAUowi7gVYHlwuMd
         1znrwId4Z1Nw4Wlm/3IBPUPacvEGd4zot2zcA=
Date: Wed, 15 Sep 2010 21:40:12 +0400
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
Message-ID: <20100915174012.GC5959@lenovo>
References: <20100911114404.GE13563@erda.amd.com> <20100911124537.GA22850@elte.hu> <20100912095202.GF13563@erda.amd.com> <20100913143713.GK13563@erda.amd.com> <20100914174132.GN13563@erda.amd.com> <20100915162034.GO13563@erda.amd.com> <20100915164610.GA5959@lenovo> <AANLkTim5knbg8GdUAYyx_i5WQUwnez8tHkU1SfiJJ+L7@mail.gmail.com> <20100915170222.GB5959@lenovo> <20100915172805.GR13563@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100915172805.GR13563@erda.amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 15, 2010 at 07:28:05PM +0200, Robert Richter wrote:
> On 15.09.10 13:02:22, Cyrill Gorcunov wrote:
> > > what's for sure, is that you can have an interrupt in flight by the time
> > > you disable.
> > > 
> > 
> > I fear you can x86_pmu_stop()
> > 
> > 	if (__test_and_clear_bit(hwc->idx, cpuc->active_mask)) {
> > 
> > --->		active_mask will be cleared here for sure
> > --->		but counter still ticks, say nmi happens active_mask
> > --->		is cleared, but NMI can still happen and gets buffered
> > --->		before you disable counter in real
> > 
> > 		x86_pmu.disable(event);
> > 		cpuc->events[hwc->idx] = NULL;
> > 		WARN_ON_ONCE(hwc->state & PERF_HES_STOPPED);
> > 		hwc->state |= PERF_HES_STOPPED;
> > 	}
> > 
> > No?
> 
> I tried reordering this too, but it didn't fix it.
> 
> -Robert
>

Yeah, already noted from your previous email. Perhaps we might
do a bit simplier approach then -- in nmi handler were we mark
"next nmi" we could take into account not "one next" nmi but
sum of handled counters minus one being just handled (of course
cleaning this counter if new "non spurious" nmi came in), can't
say I like this approach but just a thought.

	-- Cyrill
