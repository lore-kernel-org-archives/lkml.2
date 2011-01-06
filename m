Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751786Ab1AFJIH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 04:08:07 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59430 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214Ab1AFJID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 04:08:03 -0500
Date: Thu, 6 Jan 2011 09:07:41 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm: mm: Poison freed init memory
Message-ID: <20110106090741.GQ8638@n2100.arm.linux.org.uk>
References: <1294256845-29517-1-git-send-email-sboyd@codeaurora.org> <20110105202645.GL8638@n2100.arm.linux.org.uk> <4D255263.7040106@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D255263.7040106@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 05, 2011 at 09:25:55PM -0800, Stephen Boyd wrote:
> On 01/05/2011 12:26 PM, Russell King - ARM Linux wrote:
> > On Wed, Jan 05, 2011 at 11:47:25AM -0800, Stephen Boyd wrote:
> >> Poisoning __init marked memory can be useful when tracking down
> >> obscure memory corruption bugs. When a pointer is 0xCCCCCCCC in an
> >
> > That's a bad idea for a value.  With a 3GB page offset and 256MB or
> > more memory, accesses to such an address will always succeed.
> >
> > There's two things to be considered when selecting a possible poison
> > value:
> >
> > 1. what value is guaranteed to provoke an undefined instruction exception?
> > 2. what value when used as an address and dereferenced is mostly always
> >    going to abort?
> >
> > 1 for ARM mode implies an 0xe7fXXXfX value.  For Thumb mode 0xdeXX.  We
> > use this space for breakpoints.
> >
> > 2 unfortunately depends on the platform. 
> 
> A coworker proposed we use a SWI instruction. We could do that if the
> poison is 0xEF and then do something in the SWI handler where that
> number causes us to blow up?

Doesn't work with EABI - the comment field in the SWI instruction is
ignored on EABI.

> If I'm following correctly, point 1 is about __init functions and point
> 2 is about __initdata. I'm more concerned about __initdata because
> __init functions called from non __init marked functions are usually
> caught with section mismatch checks. Also, if we're jumping to
> 0xCCCCCCCC we're probably not in the text section of the kernel with a

But, as I pointed out, you don't know that 0xCCCCCCCC isn't a valid
address _and_ on modern platforms it won't fault.  So it's pointless
to use it as a poison value.
