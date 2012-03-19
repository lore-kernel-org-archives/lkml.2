Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030484Ab2CSKyC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 06:54:02 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52492 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932216Ab2CSKx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 06:53:58 -0400
Date: Mon, 19 Mar 2012 10:53:47 +0000
From: Dave Martin <dave.martin@linaro.org>
To: Laura Abbott <lauraa@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        nicolas.pitre@linaro.org, catalin.marinas@arm.com,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] arm: Add unwinding support for memset and memzero.
Message-ID: <20120319105346.GA2124@linaro.org>
References: <1331574027-28542-1-git-send-email-lauraa@codeaurora.org>
 <20120314111504.GA2033@linaro.org>
 <4F63767E.3020706@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F63767E.3020706@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2012 at 10:21:02AM -0700, Laura Abbott wrote:
> On 3/14/2012 4:15 AM, Dave Martin wrote:
> >
> >For functions like this, the unwinding requirements are different
> >depending on where we are in the function.  But the unwinder annotations
> >don't remember exact instruction locations; only the extent of the
> >whole unwind block is recorded, along with the sequence (but not
> >location) of unwinder directives.
> >
> >As is, the unwinding may be wrong depending on which part of the function
> >is executing when the fault occurs.
> >
> 
> Hmmmm, I thought I could get away with only one annotation based on
> the structure of memset/memzero but looking again you are right, it
> really requires multiple annotations to be correct.
> 
> >It may be possible to split the function into multiple unwind blocks,
> >e.g.:
> >
> >ENTRY(somefunc)
> >UNWIND(.fnstart)
> >
> >UNWIND(.save {r4,lr})
> >	stfmd	sp!, {r4,lr}
> >
> >	/* check something */
> >
> >	blt	_the_other_way
> >	/* maybe carry out our job this way */
> >
> >	ldmfd	sp!, {r4,lr}
> >UNWIND(.fnend)
> >
> >_the_other_way:
> >UNWIND(.fnstart)
> >UNWIND(.save {r4,lr})
> >UNWIND(.save {r5-r8})
> >	stmfd	sp!, {r5-r8}	/* !! */
> >
> >	/* carry out our job the other way */
> >
> >	ldmfd	sp!, {r5-r8}
> >	ldmfd	sp!, {r4,pc}	/* !! */
> >UNWIND(.fnend)
> >
> >
> >This is still not exactly right (it's hard to be exactly right,
> >since the unwind tables are not meant for handling asynchronous
> >unwinding), but unwinding should be correct for the main bits of code
> >where most time is spent and/or faults are most likely (the "carry out
> >our job" comments).
> >
> 
> Would a compiler be able to generate code such as this and still
> generate correct completely unwinding annotations? Or if the
> compiler knows unwinding is necessary, is the only option to
> generate code in 'unwindable blocks'? (alternatively, no compiler is
> smart/stupid enough to generate this code?)

I believe the compiler will typically generate a single unwind block per
function, with single save/restore sequences at the entry and exit
points which save/restore everything the function could possibly
use.  This means that unless a fault occurs in the save/restore
sequences (this would imply a stack overflow etc.) then the resulting
backtrace should be sensible.

In assembly functions, we do sometimes optimise things further, so
that if there is a fast path through the function we don't necessarily
do the full save/restore on that path.  However, deferring state save
like this doesn't fit the "single unwind block per function" model.

The unusual thing about the function being considered here is that
it has two parts where non-stack faults can reasonably occur, with
different save/restore frames in each part.

Cheers
---Dave
