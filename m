Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618Ab1CVJpZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 05:45:25 -0400
Received: from smtp.nokia.com ([147.243.1.47]:41866 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753492Ab1CVJpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 05:45:22 -0400
Date: Tue, 22 Mar 2011 11:41:10 +0200
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: ext Stephen Boyd <sboyd@codeaurora.org>
Cc: akpm@linux-foundation.org, gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 0/4] Improve fallback LPJ calculation
Message-ID: <20110322094110.GA30552@esdhcp04044.research.nokia.com>
References: <1299768487-13200-1-git-send-email-ext-phil.2.carmody@nokia.com> <4D83DF5B.1000006@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D83DF5B.1000006@codeaurora.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/03/11 15:40 -0700, ext Stephen Boyd wrote:
> On 03/10/2011 06:48 AM, Phil Carmody wrote:
> > Apologies for picking on you, Andrew, and sending this out of the blue,
> > but I didn't have much luck with my previous attempt, and I quite like
> > this patchset, so thought it was worth trying again.
> > (http://lkml.org/lkml/2010/9/28/121)
> >
> > The guts of this patchset are in patch 2/4. The motivation for that patch
> > is that currently our OMAP calibrates itself using the trial-and-error 
> > binary chop fallback that some other architectures no longer need to 
> > perform. This is a lengthy process, taking 0.2s in an environment where 
> > boot time is of great interest.
> >
> >
> [snip]
> > 1/4 is simply cosmetic to prepare for 2/4. 
> > 4/4 is simply to assist testing and not intended for integration.
> 
> I tried this patch set out on an MSM7630.
> 
> Before:
> 
> Calibrating delay loop... 681.57 BogoMIPS (lpj=3407872)
> 
> After:
> 
> Calibrating delay loop... 680.75 BogoMIPS (lpj=3403776)
> 
> But the really good news is calibration time dropped from ~247ms to
> ~56ms. Sadly we won't be able to benefit from this should my udelay
> patches make it into ARM because we would be using
> calibrate_delay_direct() instead (at least on machines who choose to).
> Can we somehow reapply the logic behind this to
> calibrate_delay_direct()? That would be even better, but this is
> definitely a boot time improvement.

Such logic is unnecessary in the direct calibration, as it doesn't go 
through the same excessively slow iterative process. This was definitely 
a low-hanging-fruit optimisation.

> Or maybe we could just replace calibrate_delay_direct() with this
> fallback calculation? 

One of our engineers looked into solution almost identical to yours, and
ended up with the same view. Curiously, I preferred his (and therefore
your) solution. The baseline we're based on makes mine more suitable,
and there are some rumours of additional issues with some ARM-based SoCs
that might have been a problem for the more advanced direct technique.
When Nokia lets me go, and I'm less constrained which baseline to work 
with, I may revisit this area in my free time.

> If __delay() is a thin wrapper around
> read_current_timer() it should work just as well (plus patch 3 makes it
> handle SMIs). I'll try that out.

It will be ~2.5x slower though, if the mental model I've built in my head 
is correct.

> You can add a
> 
> Tested-by: Stephen Boyd <sboyd@codeaurora.org>
> 
> to the first 3 patches.

Thanks for testing it, I'm glad I Cc:d you!

Phil
