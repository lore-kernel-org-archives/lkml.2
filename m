Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759192Ab0I0VVS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 17:21:18 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:34493 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755703Ab0I0VVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 17:21:17 -0400
Date: Tue, 28 Sep 2010 01:21:13 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, rth@twiddle.net,
        linux-kernel@vger.kernel.org, Matt Turner <mattst88@gmail.com>
Subject: Re: alpha: potential race around hae_cache in RESTORE_ALL
Message-ID: <20100927212113.GA20167@jurassic.park.msu.ru>
References: <20100925181304.GV19804@ZenIV.linux.org.uk> <AANLkTi=XURM0hOiitvNSiacd9+7Vx8s7V0KZ+oZQsDDQ@mail.gmail.com> <20100925191836.GW19804@ZenIV.linux.org.uk> <20100925192509.GX19804@ZenIV.linux.org.uk> <20100927075828.GA15344@jurassic.park.msu.ru> <20100927121227.GB19804@ZenIV.linux.org.uk> <20100927124624.GC19804@ZenIV.linux.org.uk> <20100927162610.GA18373@jurassic.park.msu.ru> <AANLkTimjep+H2VDJC1sFvT52XPmiKgMHuRBirzNm6qnL@mail.gmail.com> <20100927190109.GD19804@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100927190109.GD19804@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 08:01:09PM +0100, Al Viro wrote:
> The only flavours that have HAE at all are APECS, LCA, MCPCIA, JENSEN and
> T2.  APECS, LCA and JENSEN are UP-only, MCPCIA we build with
> MCPCIA_ONE_HAE_WINDOW which blocks HAE switching AFAICS.  So it's really
> about T2 and there we have something interesting:
> 
> #define T2_HAE_1                (IDENT_ADDR + GAMMA_BIAS + 0x38e0000e0UL)
> #define T2_HAE_2                (IDENT_ADDR + GAMMA_BIAS + 0x38e000100UL)
> #define T2_HAE_3                (IDENT_ADDR + GAMMA_BIAS + 0x38e000240UL)
> #define T2_HAE_4                (IDENT_ADDR + GAMMA_BIAS + 0x38e000260UL)
> #define T2_HAE_ADDRESS          T2_HAE_1
> 
> And seeing that it appears to be 4-CPU chipset...

Yeah, looks like per-cpu stuff, but no... From core_t2.c:

	/* Zero HAE.  */                                                        
	*(vulp)T2_HAE_1 = 0; mb(); /* Sparse MEM HAE */                         
	*(vulp)T2_HAE_2 = 0; mb(); /* Sparse I/O HAE */                         
	*(vulp)T2_HAE_3 = 0; mb(); /* Config Space HAE */                       

        /*                                                                      
	* We also now zero out HAE_4, the dense memory HAE, so that            
...

However, a good thing about T2 is that the Sparse HAE window is reasonably
large - 128 Mb, exactly as on MCPCIA. So we can easily do T2_ONE_HAE_WINDOW
and be done with it.

Ivan.
