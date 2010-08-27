Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab0H0VpK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 17:45:10 -0400
Received: from smtp.outflux.net ([198.145.64.163]:51423 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752580Ab0H0VpH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 17:45:07 -0400
Date: Fri, 27 Aug 2010 14:43:57 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Jean Tourrilhes <jt@hpl.hp.com>
Cc: linux-kernel@vger.kernel.org, "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Joe Perches <joe@perches.com>, Tejun Heo <tj@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] wireless: fix 64K kernel heap content leak via ioctl
Message-ID: <20100827214357.GE4703@outflux.net>
References: <20100827210240.GC4703@outflux.net>
 <20100827212254.GB32275@bougret.hpl.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100827212254.GB32275@bougret.hpl.hp.com>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

On Fri, Aug 27, 2010 at 02:22:54PM -0700, Jean Tourrilhes wrote:
> On Fri, Aug 27, 2010 at 02:02:41PM -0700, Kees Cook wrote:
> > This problem was originally tracked down by Brad Spengler.
> > 
> > When calling wireless ioctls, if a driver does not correctly
> > validate/shrink iwp->length, the resulting copy_to_user can leak up to
> > 64K of kernel heap contents.
> > 
> > It seems that this is triggerable[1] in 2.6.32 at least on ath5k, but
> > I was not able to track down how. The twisty maze of ioctl handlers
> > stumped me. :)
> 
> 	You can always ask.
> 
> > Other drivers I checked did not appear to have any problems,
> > but the potential remains. I'm not sure if this patch is the right approach;
> > it was fixed differently[2] in grsecurity.
> 
> 	Did you tried your patch for real ? With large scan request ?
> 	I ask because at first glance, it looks incorrect, asI believe
> it kills large request. But someone would need to test, for sure.

I did not, no. Since I couldn't reproduce the original problem (I lacked
the hardware to test ath5k, and all the other drivers correctly managed
iwp->length).

> > [1] http://forums.grsecurity.net/viewtopic.php?f=3&t=2290&start=0
> > [2] http://grsecurity.net/~spender/wireless-infoleak-fix2.patch
> 
> 	I believe this patch would make the situation worse.
> 
> 	Would you mind validating the following patch ? I've just
> verified that it compiles and I believe it does what you are asking in
> a much more predictable way.

> -               if (copy_to_user(iwp->pointer, extra,
> -                                iwp->length *
> -                                descr->token_size)) {
> +               /* Verify how much we should return. Some driver
> +                * may abuse iwp->length... */
> +               if((iwp->length * descr->token_size) < extra_size)
> +                       extra_size = iwp->length * descr->token_size;
> +
> +               if (copy_to_user(iwp->pointer, extra, extra_size)) {

The comment should probably be clarified -- it's the caller's iwp->length
that may be causing problems (when combined with a driver that forgets to
adjusted iwp->length downward). Regardless, the above patch would appear to
limit the copy_to_user to only the kzalloced region.

Thanks!

-Kees

-- 
Kees Cook
Ubuntu Security Team
