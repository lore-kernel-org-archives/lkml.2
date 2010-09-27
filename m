Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933273Ab0I0Q0P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 12:26:15 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:47177 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933262Ab0I0Q0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 12:26:13 -0400
Date: Mon, 27 Sep 2010 20:26:10 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, rth@twiddle.net,
        linux-kernel@vger.kernel.org, Matt Turner <mattst88@gmail.com>
Subject: Re: alpha: potential race around hae_cache in RESTORE_ALL
Message-ID: <20100927162610.GA18373@jurassic.park.msu.ru>
References: <20100925181304.GV19804@ZenIV.linux.org.uk> <AANLkTi=XURM0hOiitvNSiacd9+7Vx8s7V0KZ+oZQsDDQ@mail.gmail.com> <20100925191836.GW19804@ZenIV.linux.org.uk> <20100925192509.GX19804@ZenIV.linux.org.uk> <20100927075828.GA15344@jurassic.park.msu.ru> <20100927121227.GB19804@ZenIV.linux.org.uk> <20100927124624.GC19804@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100927124624.GC19804@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 01:46:24PM +0100, Al Viro wrote:
> AFAICS, we have 3 variants:
> 	1) alpha_mv.hae_register == &alpha_mv.hae_cache; all that code
> becomes a no-op.
> 	2) UP boxen with hae_register pointing someplace real; we save
> HAE in SAVE_ALL, restore it in RESTORE_ALL and disable interrupts around
> the updates of hae_cache/*hae_register to keep them in sync.  readl()
> et.al. set HAE, then do memory access and rely on not giving CPU up between
> these moments.  Since alpha doesn't do PREEMPT, we are OK (otherwise we'd
> needed to disable preempt in those places; also not a big deal)
> 	3) SMP t2 boxen; we protect the entire sequence from setting HAE to
> memory access with spinlock and with disabling interrupts.  We don't rely on
> interrupts not modifying the damn thing, but we *do* rely on other CPU not
> messing with HAE on syscall paths outside of spinlock-protected area.  And
> we have RESTORE_ALL hit us on all exits to userland, interrupt, trap and
> syscall alike.
> 
> 	Looks like (3) has always been broken...

Ah, agreed with all of the above.

Looks like we need to drop HAE bits from SAVE_ALL/RESTORE_ALL, which
benefits (1) and automatically fixes (3), and do the entire IO sequences
in (2) with disabled interrupts (if HAE is involved).
The latter includes apecs, lca and jensen.

Ivan.
