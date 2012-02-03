Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557Ab2BCOGk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 09:06:40 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59840 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755929Ab2BCOGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 09:06:39 -0500
Date: Fri, 3 Feb 2012 14:06:21 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: Kautuk Consul <consul.kautuk@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "Mohd. Faris" <mohdfarisq2010@gmail.com>
Subject: Re: [PATCH 1/1] arm: vfp: Raising SIGFPE on invalid floating point
	operation
Message-ID: <20120203140621.GK889@n2100.arm.linux.org.uk>
References: <1328258184-23082-1-git-send-email-consul.kautuk@gmail.com> <20267.57822.537801.969721@pilspetsen.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20267.57822.537801.969721@pilspetsen.it.uu.se>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 03, 2012 at 02:32:14PM +0100, Mikael Pettersson wrote:
> No, a SIGFPE delivered at the wrong point in time with the wrong
> context in its sigframe is MUCH worse than not getting a SIGFPE
> at all.  (And likewise for all other trap signals, SEGV, ILL, etc.)

If your FP is pipelined, then you won't get a SIGFPE for a div0 situation
as soon as the instruction appears in the program.  Think about what's
happening.

1. The FP hardware may be occupied with a computation.
2. The program issues the divide instruction, the FP hardware accepts
   this.  Meanwhile, the integer part of the core continues processing
   instructions.
3. The FP hardware completes its computation, and gets to execute the
   divide instruction.
4. The FP hardware discovers a divide-by-zero situation, and flags it
   in its status register.

At this point, there's no way for the FP hardware to flag that situation
to the integer core (there's no interrupt.)  The failure gets flagged
when the program executes the next FP instruction, and is raised by the
FP hardware refusing to accept that instruction with an exception status.

The kernel can't back-track the execution path to find out where the
divide instruction was, and the hardware doesn't tell you what address
the instruction was (the FP hardware effectively just gets to listen to
the integer core's instruction stream when the integer core sees a
'co-processor' instruction.)

The only way FP would be able to abort a divide-by-zero immediately is
if it halted the integer core while it started the divide operation,
preventing it from running integer computations in parallel with the FP
hardware.
