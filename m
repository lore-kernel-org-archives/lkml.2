Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092Ab0I1Urk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 16:47:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43429 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751361Ab0I1Uri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 16:47:38 -0400
Date: Tue, 28 Sep 2010 13:47:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Julia Lawall <julia@diku.dk>,
        "David S. Miller" <davem@davemloft.net>,
        uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: {painfully BISECTED} Please revert f25c80a4b2: arch/um/drivers:
 remove duplicate structure field initialization
Message-Id: <20100928134721.f79a5955.akpm@linux-foundation.org>
In-Reply-To: <AANLkTim85sH_2o=xCiDuoQrHq_7ZL96Y91xQMGxUP5Fy@mail.gmail.com>
References: <4CA09977.80506@panasas.com>
	<AANLkTim85sH_2o=xCiDuoQrHq_7ZL96Y91xQMGxUP5Fy@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Sep 2010 13:24:40 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Ping, no comments?
> 
> On Mon, Sep 27, 2010 at 6:17 AM, Boaz Harrosh <bharrosh@panasas.com> wrote:
> >
> > [bharrosh@fs2 ~/dev/git/pub/scsi-misc] 1115$ git bisect good
> > f25c80a4b2bf93c99820f470573626557db35202 is the first bad commit
> > commit f25c80a4b2bf93c99820f470573626557db35202
> 
> It looks like that commit is indeed very misleading. The commit message says:
> 
>   "arch/um/drivers: remove duplicate structure field initialization"
> 
> but it is in fact not duplicate: there's two field initializations,
> but they are _different_. Looking at the patch, it has:
> 
>         .ndo_set_mac_address    = uml_net_set_mac,
> -       .ndo_set_mac_address    = eth_mac_addr,
> 
> so it removes the later one, but it is not at all clear which one the
> compiler actually used. My guess is that it used to use the later one
> (the standard eth_mac_addr function), and the patch made it suddenly
> use the uml_net_set_mac function.
> 
> I didn't check what gcc used to do, but this:
> 
> > The patch Reverts cleanly on top of 2.6.36-rc5 and after Revert works perfectly as
> > before.
> 
> makes me suspect that nobody else checked it either.

I checked! gcc uses the second initialiser.

uml_net_set_mac() is:

static int uml_net_set_mac(struct net_device *dev, void *addr)
{
	struct uml_net_private *lp = netdev_priv(dev);
	struct sockaddr *hwaddr = addr;

	spin_lock_irq(&lp->lock);
	eth_mac_addr(dev, hwaddr->sa_data);
	spin_unlock_irq(&lp->lock);

	return 0;
}

And I misread that, assuming that it's just a wrapper around
eth_mac_addr().  Only it isn't, because it passes eth_mac_addr() the
MAC address's address directly (with ->sa_data).  But eth_mac_addr()
expects a `struct sockaddr *'.

And for some wtf reason, eth_mac_addr() passes that `struct
sockaddr *' in a `void *', thus cunningly hiding the bug.

Yeah, please revert it.

