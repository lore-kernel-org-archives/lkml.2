Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937463Ab0CPGyV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 02:54:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:42220 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937150Ab0CPGyQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 02:54:16 -0400
Message-ID: <4B9F2B0A.70507@kernel.org>
Date: Tue, 16 Mar 2010 15:54:02 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [RFC] remove implicit slab.h inclusion from percpu.h
References: <4B990496.4020002@kernel.org> <4B9F08AC.9030904@kernel.org> <20100316061718.GA22651@elte.hu>
In-Reply-To: <20100316061718.GA22651@elte.hu>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 16 Mar 2010 06:54:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo.

On 03/16/2010 03:17 PM, Ingo Molnar wrote:
> ( /me mumbles something about not having a patch in the email to review and
>   pulling the tree. 200k patch is just fine for lkml - i've attached it below
>   for easier review. percpu.h and percpu.c has the meat of the changes. )

I wanted to keep the discussion high level while giving a general idea
about the extent of necessary changes.  I'll include the patch from
now on.

> i like the dependency reduction. Noticed one small detail:
> 
> this new 2000-lines #ifdef block percpu.c:
> 
>  +#ifdef CONFIG_SMP
>  +#else  /* CONFIG_SMP */
>  +#endif /* CONFIG_SMP */
> 
> feels a bit lame. A separate percpu_up.c file would be nicer i suppose?

Sure.

> Also, why should we make this opt-in and expose a wide range of configs to 
> build breakages? A more gradual approach would be to write a simple script 
> that adds a slab.h include to all .c's that include percpu.h, directly or 
> indirectly.
>
> You can map the pattern experimentally: the insertion pattern could be built 
> from the x86 allmodconfig build you did [i.e. extend the pattern until you 
> make it build on allmodconfig] - that would cover most cases in practice (not 
> just allmodconfig) - and would cover most architectures as well.

I don't really get the 'experimental' part but if I count all the
files which ends up including percpu.h directly or indirectly on
allmodconfig it ends up including much more .c files than necessasry -
11203 to be exact, ~20 times more than necessary.  Inclusions from .c
files definitely are much less troublesome so the situation would be
better than now but we'll still end up with a LOT of bogus inclusions
without any good way to eventually remove them.

Maybe a better way is to grab for slab API usages in .c files which
don't have slab.h inclusion.  If breaking the dependency is the way to
go, I can definitely write up some scripts and do test builds on some
archs.  There sure will be some fallouts but I think it won't be too
bad.

Thanks.

-- 
tejun
