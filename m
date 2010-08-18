Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169Ab0HRJKF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 05:10:05 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:57556 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750964Ab0HRJKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 05:10:03 -0400
Subject: Re: [RFC PATCH 0/0 v3] callchain fixes and cleanups
From: Will Deacon <will.deacon@arm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Paul Mundt <lethal@linux-sh.org>, David Miller <davem@davemloft.net>,
        Borislav Petkov <bp@amd64.org>
In-Reply-To: <20100818035507.GE24748@nowhere>
References: <1281991715-10367-1-git-send-regression-fweisbec@gmail.com>
	 <1282041159.22114.2.camel@e102144-lin.cambridge.arm.com>
	 <20100818035507.GE24748@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Aug 2010 10:08:47 +0100
Message-ID: <1282122527.14913.17.camel@e102144-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Aug 2010 09:08:50.0695 (UTC) FILETIME=[F9400970:01CB3EB4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-18 at 04:55 +0100, Frederic Weisbecker wrote:
> On Tue, Aug 17, 2010 at 11:32:39AM +0100, Will Deacon wrote:
> > I've tested this on an ARM Cortex-A9 board and it all seems fine [plus
> > the code is a lot cleaner!].
> >
> > Tested-by: Will Deacon <will.deacon@arm.com>
> 
> Thanks a lot!

> BTW, out of curiosity, do you have NMIs on ARM and do the hardware events
> make use of them? Or may be you use FIQ to simulate NMIs?
> 

We don't have NMIs on ARM [so obviously we can't use them!] but
you're right to point out the FIQ. I've actually been thinking about
this during the past week, but there are the following problems:

(1) The FIQ isn't always wired up in the hardware, so you can't
    assume that it is available.

(2) The FIQ can only have a single handler at a given time. This
    is because it is a separate exception mode, with its own banked
    registers. Consequently, we might not be able to use it if it's
    being used for something else.

(3) The Trustzone security extensions may reserve the FIQ for secure
    use only or make it available only via the secure monitor [which
    will increase latency].

Of course, the advantage is that we could then use sample-based
profiling techniques in sections of code where the interrupts are
disabled.

The only way I can think of adding this is as a Kconfig option,
which, when selected, tries to use the FIQ and then falls back to
normal IRQs if it fails.

Cheers,

Will

