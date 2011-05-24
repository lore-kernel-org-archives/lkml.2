Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420Ab1EXPFE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 11:05:04 -0400
Received: from jaguar.mail.utk.edu ([160.36.0.84]:43732 "EHLO
	jaguar.mail.utk.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272Ab1EXPFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 11:05:02 -0400
Date: Tue, 24 May 2011 11:04:43 -0400 (EDT)
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: linux-kernel@vger.kernel.org, fbuihuu@gmail.com, mingo@elte.hu,
        paulus@samba.org, acme@redhat.com
Subject: Re: perf: regression with PERF_EVENT_IOC_REFRESH
In-Reply-To: <1306233036.2497.15.camel@laptop>
Message-ID: <alpine.DEB.2.00.1105241041490.10575@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1105231555490.17453@cl320.eecs.utk.edu>  <1306182141.2497.5.camel@laptop>  <alpine.DEB.2.00.1105240212590.28546@cl320.eecs.utk.edu> <1306233036.2497.15.camel@laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 May 2011, Peter Zijlstra wrote:

> > The old behavior might have been unintentional, but PAPI unfortunately 
> > depends on it (not code I originaly wrote, but code I have to maintain).
> 
> Right, so what the code does is create a group of which the leader is
> disabled, which effectively has the whole group disabled. It then abuses
> REFRESH,0 to enable the leader.

yes.  This is currently what PAPI does.

> The code should use ENABLE (surprise, surprise!) to enable the leader
> and get things going.

It was unclear from the documentation that enabling a group leader that 
had siblings with overflow setup would start them triggering
without some sort of REFRESH first.  It does seem to work though.
But then again, so did the original behavior.

> This is very clear abuse of the API and I'm not really inclined to fix
> it, in fact, I'd be tempted to add an additional test to verify the
> argument to REFRESH > 0.

Well, when there's no documentation then people write to the code.
As I said before, I didn't write this code.  I just get to pick up the 
pieces when it breaks.

As an aside, I also wasted 6 hours last night finding out that you don't 
get signaled on overflow if you don't have a ring-buffer mmap()ed, even
if you never read from the buffer and you only are interested in counting
the number of overflows.  I should stop complaining though or you'll
start telling me to fix the documentation.  Which maybe I would do if I 
didn't spend all my time writing code to reproduce problems in the perf 
ABI for bisection purposes.

> Then again, I do appreciate you're having a problem there, how soon can
> you push this trivial fix into all maintained PAPI branches? We could
> revert this for one release and then properly shut this abuse down the
> next release.

well since you apparently aren't going to retroactively revert it for 
2.6.37, 2.6.38, or 2.6.39 then it would be silly to do it just for 2.6.40.

I'll audit the PAPI code to see how widespread it is.

To warn you though, we still have people complain within hours when we 
break support for 2.6.16 kernels, so it's not like the people who use 
PAPI are the kind to run out and install a minor stable release.  They're
going to upgrade their distro or move their binary to a newer machine and 
suddenly start geting EINVAL returns on their previously working code and 
then start noisily complaining.

Vince
