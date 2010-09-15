Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738Ab0IORC1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 13:02:27 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59460 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009Ab0IORC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 13:02:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XaJsIisIVuKDnxhnm2n2s28hixeehsSoWkaaFpfOr4+daiPQFeA6nKdaXr+Anzo4ne
         vOB9DNqOdwUvUDhFR8RyKefoq/PwtCJvw7vUn+2f1KHlnAhfYW1bWZU6lCvWmahD0EmM
         Npqg3ReZW1wkhwq+uSyrpkghPjh6N9HL4D/MU=
Date: Wed, 15 Sep 2010 21:02:22 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Stephane Eranian <eranian@google.com>
Cc: Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, Don Zickus <dzickus@redhat.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>
Subject: Re: [PATCH] perf, x86: catch spurious interrupts after disabling
	counters
Message-ID: <20100915170222.GB5959@lenovo>
References: <20100910155659.GD13563@erda.amd.com> <20100911094157.GA11521@elte.hu> <20100911114404.GE13563@erda.amd.com> <20100911124537.GA22850@elte.hu> <20100912095202.GF13563@erda.amd.com> <20100913143713.GK13563@erda.amd.com> <20100914174132.GN13563@erda.amd.com> <20100915162034.GO13563@erda.amd.com> <20100915164610.GA5959@lenovo> <AANLkTim5knbg8GdUAYyx_i5WQUwnez8tHkU1SfiJJ+L7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim5knbg8GdUAYyx_i5WQUwnez8tHkU1SfiJJ+L7@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 15, 2010 at 06:47:51PM +0200, Stephane Eranian wrote:
> On Wed, Sep 15, 2010 at 6:46 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> > On Wed, Sep 15, 2010 at 06:20:34PM +0200, Robert Richter wrote:
> >> On 14.09.10 19:41:32, Robert Richter wrote:
> >> > I found the reason why we get the unknown nmi. For some reason
> >> > cpuc->active_mask in x86_pmu_handle_irq() is zero. Thus, no counters
> >> > are handled when we get an nmi. It seems there is somewhere a race
> >> > accessing the active_mask. So far I don't have a fix available.
> >> > Changing x86_pmu_stop() did not help:
> >>
> >> The patch below for tip/perf/urgent fixes this.
> >>
> >> -Robert
> >>
> >> From 4206a086f5b37efc1b4d94f1d90b55802b299ca0 Mon Sep 17 00:00:00 2001
> >> From: Robert Richter <robert.richter@amd.com>
> >> Date: Wed, 15 Sep 2010 16:12:59 +0200
> >> Subject: [PATCH] perf, x86: catch spurious interrupts after disabling counters
> >>
> >> Some cpus still deliver spurious interrupts after disabling a counter.
> >> This caused 'undelivered NMI' messages. This patch fixes this.
> >>
> >> Signed-off-by: Robert Richter <robert.richter@amd.com>
> >> ---
> > ...
> >
> > Hi Robert, thanks a lot for tracking this issue! I might be missing
> > something but why don't you clean this ->running mask bits on pmu-stop?
> > What if counter gets disabled/freed or whatever before issue any nmis?
> > Another question I have still -- is this an hardware issue in general?
> >
> what's for sure, is that you can have an interrupt in flight by the time
> you disable.
> 

I fear you can x86_pmu_stop()

	if (__test_and_clear_bit(hwc->idx, cpuc->active_mask)) {

--->		active_mask will be cleared here for sure
--->		but counter still ticks, say nmi happens active_mask
--->		is cleared, but NMI can still happen and gets buffered
--->		before you disable counter in real

		x86_pmu.disable(event);
		cpuc->events[hwc->idx] = NULL;
		WARN_ON_ONCE(hwc->state & PERF_HES_STOPPED);
		hwc->state |= PERF_HES_STOPPED;
	}

No?

	-- Cyrill
