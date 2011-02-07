Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371Ab1BGK37 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 05:29:59 -0500
Received: from ozlabs.org ([203.10.76.45]:40557 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752057Ab1BGK35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 05:29:57 -0500
Date: Mon, 7 Feb 2011 21:29:50 +1100
From: Paul Mackerras <paulus@samba.org>
To: David Miller <davem@davemloft.net>
Cc: Knut_Petersen@t-online.de, linux-kernel@vger.kernel.org,
        mostrows@earthlink.net, linux-ppp@vger.kernel.org
Subject: Re: [BUG] 2.6.38-rc2: Circular Locking Dependency
Message-ID: <20110207102950.GA17044@brick.ozlabs.ibm.com>
References: <4D3D45A3.7040809@t-online.de>
 <20110206.232856.246531984.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110206.232856.246531984.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 06, 2011 at 11:28:56PM -0800, David Miller wrote:
> From: Knut Petersen <Knut_Petersen@t-online.de>
> Date: Mon, 24 Jan 2011 10:25:55 +0100
> 
> > As I was hunting something different I found the following (potential)
> > problem on an openSuSE 11.3 system with kernel 2.6.38-rc2.
> > The message is triggerd by smpppd starting a dsl connection.
> > 
> > Knut
> > 
> > 
> >  NET: Registered protocol family 24
> > 
> >  =======================================================
> >  [ INFO: possible circular locking dependency detected ]
> >  2.6.38-rc2-kape #7
> >  -------------------------------------------------------
> >  pppd/2529 is trying to acquire lock:
> >   (&(&pch->downl)->rlock){+.....}, at: [<f814a634>] ppp_push+0x59/0x4a8
> > [ppp_generic]
> > 
> >  but task is already holding lock:
> >   (&(&ppp->wlock)->rlock){+.-...}, at: [<f814ae1b>]
> > ppp_xmit_process+0x19/0x451 [ppp_generic]
> > 
> >  which lock already depends on the new lock.
> 
> I've stared over this trace several times and can't figure out what
> the problem is.
> 
> Paul, any idea?

We seem to have recursed in the ppp code because of (apparently)
handling a softirq inside a spin_lock_bh region. :(  If I understand
the original report correctly, the stack trace looks like this in part:

        [<c04153eb>] net_rx_action+0x3f/0xfe
        [<c0128563>] __do_softirq+0x76/0xfd
 -> #1 (_xmit_NETROM){+.-...}:
        [<c01462b2>] lock_acquire+0x47/0x5e
        [<c0471c9c>] _raw_spin_lock_irqsave+0x2e/0x3e
        [<c040ed60>] skb_dequeue+0x12/0x4a
        [<f814c237>] ppp_channel_push+0x2e/0x94 [ppp_generic]

So we were in ppp_channel_push, and the first thing it does is
spin_lock_bh(&pch->downl), and then it calls skb_dequeue, which did a
spin_lock_irqsave, and then somehow we get into __do_softirq.  I
thought spin_lock_bh should have stopped softirqs from running?

Paul.
