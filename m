Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467Ab1EPNpQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 09:45:16 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60831 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755227Ab1EPNpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 09:45:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qJGBt/KtsWhYxLxKxDR/udyAQtUuj77Ov1VsF3wlaOgATR+X922SW6CivwQmdugYgy
         klZJr+HJk42hHvbKGrbXpHwLzvDnbOcbUsI9+2pZFQ+mA+Is3usikmpOoM7VB8mbXY7Y
         rWu+QW5FEykMMO1XUXb8Kecs1Ns4+I6PxRvzM=
Date: Mon, 16 May 2011 15:45:10 +0200
From: Tejun Heo <tj@kernel.org>
To: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: oleg@redhat.com, vda.linux@googlemail.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, indan@nul.nu
Subject: Re: PTRACE_SEIZE should not stop  [Re: [PATCH 02/11] ptrace:
 implement PTRACE_SEIZE]
Message-ID: <20110516134510.GA23665@htj.dyndns.org>
References: <1304869745-1073-1-git-send-email-tj@kernel.org>
 <1304869745-1073-3-git-send-email-tj@kernel.org>
 <20110515155602.GD31855@host1.jankratochvil.net>
 <20110515162630.GG23665@htj.dyndns.org>
 <20110515171512.GA24047@host1.jankratochvil.net>
 <20110515172505.GL23665@htj.dyndns.org>
 <20110515194829.GA27023@host1.jankratochvil.net>
 <20110516083113.GN23665@htj.dyndns.org>
 <20110516132123.GA13544@host1.jankratochvil.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110516132123.GA13544@host1.jankratochvil.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jan.

On Mon, May 16, 2011 at 03:21:23PM +0200, Jan Kratochvil wrote:
> Currently that waitpid will report SIGUSR1 first and then the INTERRUPT trap.

Yes, it would.

> I suggest - if possible - that tracer will get that INTERRUPT trap first.
> 
> But you made the optimization that the INTERRUPT gets suppressed in such case.
> Which improves performance for the cost of more complicated debuggers.

INTERRUPT is suppressed if group stop is pending not signal.  That was
more about duplicity between INTERRUPT trap and group stop, which made
the whole thing uglier.  I merged the two together so there's no such
distinction anymore.

> I guess after PTRACE_SEIZE if the first signal/event is not INTERRUPT there
> will not be any INTERRUPT later, as you said.

I replied in another message too but now SEIZE and INTERRUPT behave
identically.  Any trap clears the condition.

I don't think INTERRUPT can be prioritized like that above existing
trap conditions.  Traps are taken sometimes deep in the kernel
(e.g. fork/exec) and often after modifying states irrevocably
(e.g. signal is already dequeued on signal trap).  I don't think how
it would be possible to rewind the state changes and replay it later.

FWIW, if INTERRUPT exists while signal is pending, INTERRUPT will be
taken first but that doesn't mean all that much as we can't roll back
from traps which already have happened and tracee might be in any trap
by the time PTRACE_INTERRUPT is issued.

Thank you.

-- 
tejun
