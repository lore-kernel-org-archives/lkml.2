Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171Ab0IXH34 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 03:29:56 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40596 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968Ab0IXH3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 03:29:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GZmeAnX6LBU5eI0gqfUMvFHLLUry2tqDwkA8TYM9Ths4tAdh3msBgmZFFF6gbnZ84d
         kF4MLd8TPPYlQAzs3J5bVsQVQsSATDWChh7k/n4991XJ/NddrvC4tY1xuL/tRsQpeqOm
         A14wmou3DA0iIb21MjobMXtVYQTnGZiKbmndg=
Date: Fri, 24 Sep 2010 09:29:46 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: john stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Christoph Lameter <cl@linux.com>,
        David Miller <davem@davemloft.net>, Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/8] posix clocks: introduce a syscall for clock tuning.
Message-ID: <20100924072946.GA5043@riccoc20.at.omicron.at>
References: <cover.1285261533.git.richard.cochran@omicron.at>
 <b94ef1cd9c04ef3ad5964408bd0af7251add78de.1285261534.git.richard.cochran@omicron.at>
 <1285271331.2587.56.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285271331.2587.56.camel@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 23, 2010 at 12:48:51PM -0700, john stultz wrote:
> On Thu, 2010-09-23 at 19:31 +0200, Richard Cochran wrote:
> > A new syscall is introduced that allows tuning of a POSIX clock. The
> > syscall is implemented for four architectures: arm, blackfin, powerpc,
> > and x86.
> > 
> > The new syscall, clock_adjtime, takes two parameters, the clock ID,
> > and a pointer to a struct timex. The semantics of the timex struct
> > have been expanded by one additional mode flag, which allows an
> > absolute offset correction. When specificied, the clock offset is
> > immediately corrected by adding the given time value to the current
> > time value.
> 
> 
> So I'd still split this patch up a little bit more.
> 
> 1) Patch that implements the ADJ_SETOFFSET  (*and its implementation*)
> in do_adjtimex.
> 
> 2) Patch that adds the new syscall and clock_id multiplexing.
> 
> 3) Patches that wire it up to the rest of the architectures (there's
> still a bunch missing here).

I was not sure what the policy is about adding syscalls. Is it the
syscall author's responsibility to add it into every arch?

The last time (see a2e2725541fad7) the commit only added half of some
archs, and ignored others. In my patch, the syscall *really* works on
the archs that are present in the patch.

(Actually, I did not test blackfin, since I don't have one, but I
included it since I know they have a PTP hardware clock.)

> > +static inline int common_clock_adj(const clockid_t which_clock, struct timex *t)
> > +{
> > +	if (CLOCK_REALTIME == which_clock)
> > +		return do_adjtimex(t);
> > +	else
> > +		return -EOPNOTSUPP;
> > +}
> 
> 
> Would it make sense to point to the do_adjtimex() in the k_clock
> definition for CLOCK_REALTIME rather then conditionalizing it here?

But what about CLOCK_MONOTONIC_RAW, for example?

Does it make sense to allow it to be adjusted?

Thanks,
Richard
