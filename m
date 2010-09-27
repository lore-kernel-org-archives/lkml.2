Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933350Ab0I0TBQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 15:01:16 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58153 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757252Ab0I0TBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 15:01:15 -0400
Date: Mon, 27 Sep 2010 20:01:09 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>, rth@twiddle.net,
        linux-kernel@vger.kernel.org, Matt Turner <mattst88@gmail.com>
Subject: Re: alpha: potential race around hae_cache in RESTORE_ALL
Message-ID: <20100927190109.GD19804@ZenIV.linux.org.uk>
References: <20100925181304.GV19804@ZenIV.linux.org.uk>
 <AANLkTi=XURM0hOiitvNSiacd9+7Vx8s7V0KZ+oZQsDDQ@mail.gmail.com>
 <20100925191836.GW19804@ZenIV.linux.org.uk>
 <20100925192509.GX19804@ZenIV.linux.org.uk>
 <20100927075828.GA15344@jurassic.park.msu.ru>
 <20100927121227.GB19804@ZenIV.linux.org.uk>
 <20100927124624.GC19804@ZenIV.linux.org.uk>
 <20100927162610.GA18373@jurassic.park.msu.ru>
 <AANLkTimjep+H2VDJC1sFvT52XPmiKgMHuRBirzNm6qnL@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimjep+H2VDJC1sFvT52XPmiKgMHuRBirzNm6qnL@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 10:10:40AM -0700, Linus Torvalds wrote:
> On Mon, Sep 27, 2010 at 9:26 AM, Ivan Kokshaysky
> <ink@jurassic.park.msu.ru> wrote:
> >
> > Looks like we need to drop HAE bits from SAVE_ALL/RESTORE_ALL, which
> > benefits (1) and automatically fixes (3), and do the entire IO sequences
> > in (2) with disabled interrupts (if HAE is involved).
> 
> No can do.
> 
> HAE is used in user space too (the X server), and it depends on the
> kernel restoring HAE over interrupts and system calls, afaik.
> 
> I'm also pretty certain that all SMP machines either don't have HAE at
> all, or have a per-CPU HAE in hardware (and then it's possible that we
> screw it up in software, of course). Anything else would be too broken
> for words. Can somebody find documentation saying otherwise?

Besides, I'm not particulary happy to force a couple of swpipl on each
iomem access on old UP alpha boxen.

The only flavours that have HAE at all are APECS, LCA, MCPCIA, JENSEN and
T2.  APECS, LCA and JENSEN are UP-only, MCPCIA we build with
MCPCIA_ONE_HAE_WINDOW which blocks HAE switching AFAICS.  So it's really
about T2 and there we have something interesting:

#define T2_HAE_1                (IDENT_ADDR + GAMMA_BIAS + 0x38e0000e0UL)
#define T2_HAE_2                (IDENT_ADDR + GAMMA_BIAS + 0x38e000100UL)
#define T2_HAE_3                (IDENT_ADDR + GAMMA_BIAS + 0x38e000240UL)
#define T2_HAE_4                (IDENT_ADDR + GAMMA_BIAS + 0x38e000260UL)
#define T2_HAE_ADDRESS          T2_HAE_1

And seeing that it appears to be 4-CPU chipset...
