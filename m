Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab1IUNdS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 09:33:18 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:44507 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052Ab1IUNdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 09:33:15 -0400
Date: Wed, 21 Sep 2011 14:33:07 +0100
From: Dave Martin <dave.martin@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Laura Abbott <lauraa@codeaurora.org>, Nicolas Pitre <nico@fluxnic.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm: Add unwinding annotations for 64bit division
 functions
Message-ID: <20110921133307.GD2872@arm.com>
References: <1316470297-5063-1-git-send-email-lauraa@codeaurora.org>
 <alpine.LFD.2.00.1109191913210.12663@xanadu.home>
 <2285dff3fee56758b6279062a5a30dc7.squirrel@www.codeaurora.org>
 <20110921113906.GB2872@arm.com>
 <20110921115553.GF17169@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110921115553.GF17169@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 12:55:53PM +0100, Russell King - ARM Linux wrote:
> On Wed, Sep 21, 2011 at 12:39:09PM +0100, Dave Martin wrote:
> > Talking to Catalin a bit more, it sounds like prefetch aborts should not
> > happen in kernel code, and data aborts should not happen when accessing
> > the kernel stack.
> 
> No faults should happen in kernel code, except for:
> 
> 1. instructions specifically marked in the exception table, which are used
>    to access user memory.
> 2. instructions causing an 'undefined instruction' exception.
> 
> Standard ARM instructions like 'add', 'mov' etc should _never_ fault,
> and if they do that means your core isn't executing ARM instructions
> correctly (eg, the hardware design is faulty.)
> 
> Instructions such as VFP, kprobes tracing, etc are expected fault
> locations, and those are fairly well controlled where they can be placed.
> With things like ftrace, it certainly is the case that the unwinder can
> theoretically be called from almost anywhere in a function.
> 
> So I suggest that this does need to be fixed, and you can't rely on
> "prefetch aborts should not happen".  That's true of prefetch aborts
> but not of other aborts.

The important thing for the unwinder is that it can't cope well with faults
happening in the save/restore sequences at function entry and exit, and
we may not cope well with functions which don't have a simple SAVE,
EXECUTE, RESTORE, RETURN structure.

My gut feeling is that neither (1) or (2) should happen in those sequences,
and VFP faults should not happen in these sequences because the kernel
should not contain VFP code except in particular controlled locations.

For things like kprobes which allow a trap to be set at a function's entry
point we do have a problem: if we try to backtrace from this point, the
backtracer will see we are in that function and will assume that the
function's state saving code has already executed.  It might be simple
to work around this particular case by making the unwinder intelligent
enough to realise that if backtracing from the first instruction of a
function, none of the function's state save code can have executed yet.
>From any other location though, it's not so simple.  It may also do the
wrong thing for functions where the entry point is not at the start of
the function body (or where there are loops or multiple entry points)
-- I expect such instances to be pretty rare though, and this should
never happen for C.

Tricks like this are no good for reconstructing what happened on the
path up to an unexpected event like an exception, though.  This is
possible only when certain assumptions are made and the faulting 
function has a sufficiently simple structure.  This can work most of
the time, but it's hard to make it watertight -- this is one reason why
backtracing in gdb is still far from foolproof.

Alternatively, we would need to use some other frame description format
such as DWARF, which would involve building everything with debug, and
keeping the .debug_frame content (possibly with some filtering/post-
processing).  Unwind annotations in .S files would presumably need to be
rewritten to use the .cfi_ dierctives instead of the ARM-specific
directives in order for this to work everywhere.  Apparently there were
some patches around for using DWARF for backtracing in the kernel some
years ago, but they didn't get merged.



...all of which means that making unwinding work _perfectly_ probably
involves significant pain, at least for Thumb-2.

I guess the question would be: how many failed backtraces are we getting
right now?  Is the current unwinder behaviour "good enough"?

Cheers
---Dave
