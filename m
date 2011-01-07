Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339Ab1AGTHT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 14:07:19 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60592 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755128Ab1AGTHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 14:07:17 -0500
Date: Fri, 7 Jan 2011 19:06:56 +0000
From: Ben Hutchings <benh@debian.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, Hayes Wang <hayeswang@realtek.com>,
        Francois Romieu <romieu@fr.zoreil.com>,
        David Woodhouse <dwmw2@infradead.org>, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT] Networking
Message-ID: <20110107190656.GQ3702@decadent.org.uk>
References: <20110106.122003.233698077.davem@davemloft.net> <AANLkTi=7=_FyVsjA3vKEpg8RwfC=m-8QGfqa6ctxQday@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=7=_FyVsjA3vKEpg8RwfC=m-8QGfqa6ctxQday@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: benh@debian.org
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 07, 2011 at 10:46:48AM -0800, Linus Torvalds wrote:
> On Thu, Jan 6, 2011 at 12:20 PM, David Miller <davem@davemloft.net> wrote:
> >
> > Plus the usual spattering of wireless, bluetooth, and wired driver
> > updates.
> 
> Grr.
> 
> This breaks booting for me.
> 
> [torvalds@i5 linux]$ git bisect good
> bca03d5f32c8ee9b5cfa1d32640a63fded6cb3c0 is the first bad commit
> commit bca03d5f32c8ee9b5cfa1d32640a63fded6cb3c0
> Author: françois romieu <romieu@fr.zoreil.com>
> Date:   Mon Jan 3 15:07:31 2011 +0000
> 
>     r8169: remove the firmware of RTL8111D.
> 
>     The binary file of the firmware is moved to linux-firmware repository.
>     The firmwares are rtl_nic/rtl8168d-1.fw and rtl_nic/rtl8168d-2.fw.
>     The driver goes along if the firmware couldn't be found. However, it
>     is suggested to be done with the suitable firmware.
> 
>     Some wrong PHY parameters are directly corrected in the driver.
> 
>     Simple firmware checking added per Ben Hutchings suggestion.
> 
>     Signed-off-by: Hayes Wang <hayeswang@realtek.com>
>     Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
>     Cc: Ben Hutchings <benh@debian.org>
>     Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> and the behavior is very broken: it just hangs at boot-time. No
> messages from the driver (certainly not any messages about missing
> firmware), no nothing. The thing is just hung.

This is because the driver is requesting firmware during probe, before
there is a firmware agent available (maybe even before / is mounted?)
rather than when the interface is brought up, as many other network
drivers do.

At the very least, we ought to make firmware loading fail fast and
noisily if this happens.

[...]
> Quite frankly, that commit looks broken anyway. It doesn't just switch
> to the firmware loader, it also seems to change other things (ie
> removed some mdio writes, added others).

There were some tables of PHY registers to poke that were a mixture of
control register writes and transfer of firmware to the microcontroller.
Hayes and Francois have separated those out.

[...]
> I bet I can make it work by making it a module, and installing the
> firmware manually. But it's supposed to work even without that.
 
Right.  This is very vaguely based on a patch I applied in Debian
where we build r8169 as a module, and I don't think anyone reported
this behaviour.

Ben.

-- 
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camus
