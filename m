Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233Ab1KUStw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 13:49:52 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:60142 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545Ab1KUStu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 13:49:50 -0500
Date: Mon, 21 Nov 2011 10:49:39 -0800
From: Tejun Heo <tj@kernel.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Dan Williams <dan.j.williams@intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, rjw@sisk.pl,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vinod Koul <vinod.koul@intel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH] dmatest: don't use set_freezable_with_signal()
Message-ID: <20111121184939.GA25776@google.com>
References: <20111121184316.GH15314@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111121184316.GH15314@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 10:43:16AM -0800, Tejun Heo wrote:
> Commit 981ed70d8e (dmatest: make dmatest threads freezable) made
> dmatest kthread use set_freezable_with_signal(); however, the
> interface is scheduled to be removed in the next merge window.
> 
> The problem is that unlike userland tasks there's no default place
> which handles signal pending state and it isn't clear who owns and/or
> is responsible for clearing TIF_SIGPENDING.  For example, in the
> current code, try_to_freeze() clears TIF_SIGPENDING but it isn't sure
> whether it actually owns the TIF_SIGPENDING nor is it race-free -
> ie. the task may continue to run with TIF_SIGPENDING set after the
> freezable section.
> 
> Unfortunately, we don't have wait_for_completion_freezable_timeout().
> This patch open codes it and uses wait_event_freezable_timeout()
> instead and removes timeout reloading - wait_event_freezable_timeout()
> won't return across freezing events (currently racy but fix scheduled)
> and timer doesn't decrement while the task is in freezer.  Although
> this does lose timer-reset-over-freezing, given that timeout is
> supposed to be long enough and failure to finish inside is considered
> irrecoverable, I don't think this is worth the complexity.
> 
> While at it, move completion to outer scope and explain that we're
> ignoring dangling pointer problem after timeout.  This should give
> slightly better chance at avoiding oops after timeout.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
> Guennadi, Dan, how does this look?  If it's okay, do you guys mind
> routing this through pm tree?  I have some patches stacked on top
> removal of freezable_with_signal and it would be much easier to route
> these together.

Ooh, forgot to mention that it's only compile tested.

Thanks.

-- 
tejun
