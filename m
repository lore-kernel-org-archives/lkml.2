Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab2ALL65 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 06:58:57 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:60410 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481Ab2ALL64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 06:58:56 -0500
X-Originating-IP: 217.70.178.135
X-Originating-IP: 50.43.15.19
Date: Thu, 12 Jan 2012 03:58:30 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: paulmck@linux.vnet.ibm.com, laijs@cn.fujitsu.com, manfred@colorfullife.com,
        dhowells@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rcu: avoid checking for constant
Message-ID: <20120112115830.GA3436@leaf>
References: <1326345104-6919-1-git-send-email-jengelh@medozas.de>
 <20120112071431.GA1896@leaf>
 <alpine.LNX.2.01.1201121018430.31943@frira.zrqbmnf.qr>
 <20120112095257.GA2441@leaf>
 <alpine.LNX.2.01.1201121106040.17330@frira.zrqbmnf.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1201121106040.17330@frira.zrqbmnf.qr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 11:34:23AM +0100, Jan Engelhardt wrote:
> On Thursday 2012-01-12 10:52, Josh Triplett wrote:
> >> +#define __kfree_rcu(head, offset) \
> >> +	call_rcu(head, (void (*)(struct rcu_head *))(unsigned long)(offset) + \
> >> +		 BUILD_BUG_ON_ZERO((offset) >= 4096))
> >> +
> >
> >I had to stare at this for a while, and look up the definition of
> >BUILD_BUG_ON_ZERO.  Naturally I assumed that BUILD_BUG_ON_ZERO(arg)
> >meant BUILT_BUG_ON((arg) == 0), which would have made the logic
> >backwards here.  However, per the definition it just provides a
> >zero-returning version of BUILD_BUG_ON.  Ow.
> 
> Same impression here. BUILD_BUG_ON_ZERO was introduced by
> 
> commit 4552d5dc08b79868829b4be8951b29b07284753f
> Author: Jan Beulich <jbeulich@novell.com>
> Date:   Mon Jun 26 13:57:28 2006 +0200
> 
> while Rusty's CCAN archive calls it "BUILD_BUG_OR_ZERO" (since either 
> it's a bug, or returning neutral zero).

Sounds like a good target for a fix at some point.

> rcu: avoid checking for constant
> 
> When compiling kernel or module code with -O0, "offset" is no longer
> considered a constant, and therefore always triggers the build error
> that BUILD_BUG_ON is defined to yield.
> 
> Therefore, change the innards of kfree_rcu so that the offset is not
> tunneled through a function argument before checking it.

The commit message looks good now.

> @@ -835,7 +817,20 @@ void __kfree_rcu(struct rcu_head *head, unsigned long offset)
>   *
>   * Note that the allowable offset might decrease in the future, for example,
>   * to allow something like kmem_cache_free_rcu().
> + *
> + * The BUILD_BUG_ON check must not involve any function calls, hence the
> + * checks are done in macros here. __is_kfree_rcu_offset is also used by
> + * kernel/rcu.h.

The first sentence of that paragraph seems like a worthwhile addition.
Please drop the second, though, since it'll inevitably become outdated.

> +#define __is_kfree_rcu_offset(offset) ((offset) < 4096)
> +
> +#define __kfree_rcu(head, offset) \
> +	do { \
> +		typedef void (*rcu_callback)(struct rcu_head *); \
> +		BUILD_BUG_ON(!__is_kfree_rcu_offset(offset)); \
> +		call_rcu(head, (rcu_callback)(unsigned long)(offset)); \
> +	} while (0)

No, you can't define that typedef here with that name.  Unlike in the
inline function, in a macro you could introduce a name conflict.

- Josh Triplett
