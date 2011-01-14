Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757926Ab1ANQwj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 11:52:39 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59448 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757500Ab1ANQwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 11:52:34 -0500
Date: Fri, 14 Jan 2011 16:52:23 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Dave Martin <dave.martin@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Colin Cross <ccross@android.com>
Subject: Re: [PATCH] ARM: vfp: Fix up exception location in Thumb mode
Message-ID: <20110114165222.GI15996@n2100.arm.linux.org.uk>
References: <1294990949-2729-1-git-send-email-ccross@android.com> <AANLkTimqiqABxCejdeOQWZZ62DVUZW2v-yMpdu1aNDQT@mail.gmail.com> <20110114120229.GA15996@n2100.arm.linux.org.uk> <1295014231.7901.41.camel@e102109-lin.cambridge.arm.com> <AANLkTi=4=c0B3Qo+boguUw-DvEihBej5Zz_d2QWmoucm@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=4=c0B3Qo+boguUw-DvEihBej5Zz_d2QWmoucm@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 14, 2011 at 10:24:52AM -0600, Dave Martin wrote:
> Is the comment preceding __und_usr_unknown causing some confusion here?
> 
> /*
>  * The FP module is called with these registers set:
>  *  r0  = instruction
>  *  r2  = PC+4
>  ...
> 
> That reflects the ARM case only: for Thumb, r2 is always PC+2 (?)

Actually, referring to 'PC' here is confusing (and yes, I probably wrote
it) - does 'PC' refer to the address of the faulting instruction or the
current PC value...

Your '(?)' there is exactly the problem I'm referring to - I don't think
there's much of a clear idea really what's going on here...

> The comment at the start of do_undefinstr() (which receives these
> registers) is correct though:
> 
> 	/*
> 	 * According to the ARM ARM, PC is 2 or 4 bytes ahead,
> 	 * depending whether we're in Thumb mode or not.
> 	 * Correct this offset.

The ARM ARM says that in order to return to the instruction which
generated the exception, subtract 2 bytes for thumb or 4 bytes for
ARM.

So, in order to point at the instruction which generated the exception,
we have to subtract this value from the PC value we were passed.  I
suggest changing this comment to:

	/*
	 * According to the ARM ARM, the PC is 2 or 4 bytes ahead
	 * depending on Thumb mode.  Correct this offset so that
	 * regs->ARM_pc points at the faulting instruction.
	 */

