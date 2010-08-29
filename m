Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430Ab0H2Hee (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 03:34:34 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53657 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016Ab0H2Hed convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 03:34:33 -0400
MIME-Version: 1.0
In-Reply-To: <20100828.160357.102557054.davem@davemloft.net>
References: <1282938138-17844-1-git-send-email-Kyle.D.Moffett@boeing.com>
 <1282938138-17844-2-git-send-email-Kyle.D.Moffett@boeing.com> <20100828.160357.102557054.davem@davemloft.net>
From: Kyle Moffett <kyle@moffetthome.net>
Date: Sun, 29 Aug 2010 03:34:11 -0400
Message-ID: <AANLkTi=CT8jVpn0UJ7SLYHCXvqZJ3yWMbqRJ+XPUTZSB@mail.gmail.com>
Subject: Re: [PATCH 1/2] ethtool.h: Add #defines for unidirectional ethernet duplex
To: David Miller <davem@davemloft.net>
Cc: Kyle.D.Moffett@boeing.com, linux-kernel@vger.kernel.org,
        shemminger@linux-foundation.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 28, 2010 at 19:03, David Miller <davem@davemloft.net> wrote:
> From: Kyle Moffett <Kyle.D.Moffett@boeing.com>
> Date: Fri, 27 Aug 2010 15:42:17 -0400
>> In order to configure those kinds of forced modes from userspace, we
>> need to add additional options to the "ethtool" interface.  As such
>> "unidirectional" ethernet modes most closely resemble ethernet "duplex",
>> we add two additional DUPLEX_* defines to the ethtool interface:
>>
>>   #define DUPLEX_TXONLY 0x02
>>   #define DUPLEX_RXONLY 0x03
>
> A fine idea, but you're really going to have to audit all of the networking
> drivers to clean up the existing uses that assume this thing is a bitmap
> and that there are only essentially two values ('0' and '1').  For example:

Well... basically every driver would require specific tweaks to enable
unidirectional link support even in the best case *anyways*.

For example, several SOC chipsets have errata which require a receive
clock in order to reset the chip.  When they are in the "link down"
state, they provide their own fake PHY receive clock copied from an
onboard fixed clock, and when they are in the "link up" state they use
the incoming clock.  Furthermore, they require the RX and TX clocks to
be running at the same frequency (if the RX clock is available)
because of a PLL linking them, so in order to make them work with
unidirectional links, you have to significantly fudge with the fake RX
clock in order to keep the chip operational.

> Finally, phy_ethtool_sset() does this too, so with your patch applied even
> phylib would reject the new settings:
>
>        if (cmd->autoneg == AUTONEG_DISABLE &&
>            ((cmd->speed != SPEED_1000 &&
>              cmd->speed != SPEED_100 &&
>              cmd->speed != SPEED_10) ||
>             (cmd->duplex != DUPLEX_HALF &&
>              cmd->duplex != DUPLEX_FULL)))
>                return -EINVAL;
>
> making it impossible to add support for TX-only or RX-only in a phylib
> using driver.

As you noted, phylib does not have support for the txonly/rxonly
duplex, so drivers using that will automatically return EINVAL as they
would for any other unsupported ethtool options.  I have a very
involved patch series for phylib that reworks some of the ethtool
operations to be more easily customized by individual PHYs but it's
not quite done yet, let alone tested.

Due to the complexity of the phylib patches and because sky2 does not
use phylib yet, I'd like to start with just the simplistic tested sky2
patch.  Since all other drivers would just return -EINVAL, there is no
possibility for ABI/API breakage outside of the sky2 driver.


> There are probably other similar dragons hiding in various drivers, you'll
> really have to do a full audit of how every driver stores and makes use of
> duplex settings before we can seriously apply this patch.

If everyone thinks this particular choice of interface is appropriate
for configuring unidirectional links then I think these two patches
should be mergeable.  I'd especially like to get the first one (which
defines the constants) merged, as that reasonably defines the ABI and
provides a reference for the minor patches to the "ethtool" program.
If you really want I can try to post some of the sample phylib patches
but as I said they're still in very rough shape, as I wanted to get
the ABI extension reviewed and committed before I invested too much
time in them.

In general, my plan for phylib drivers is to change ethtool_sset() and
ethtool_gset() to be phy_driver function pointers.  When the ethernet
driver's mydriver_ethtool_sset() function is called, it will perform
any of its own validation on the settings first, then call static
inline phy_ethtool_sset(), which will look up the function pointer and
call that (by default genphy_ethtool_sset(), based on the current
global version).  Any PHY which has appropriate bits to support
unidirectional operation would customize that function to allow
additional modes and program the PHY regs accordingly.  Please let me
know if this makes sense to you or if you have any other questions.

Thanks again for your comments!

Cheers,
Kyle Moffett
