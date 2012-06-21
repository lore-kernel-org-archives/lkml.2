Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364Ab2FUIFP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 04:05:15 -0400
Received: from rudy.puc.rediris.es ([130.206.18.132]:52206 "EHLO
	rudy.puc.rediris.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540Ab2FUIFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 04:05:06 -0400
X-Greylist: delayed 2117 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Jun 2012 04:05:06 EDT
X-Envelope-From: paubert@iram.es
Date: Thu, 21 Jun 2012 09:29:28 +0200
From: Gabriel Paubert <paubert@iram.es>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-kernel@vger.kernel.org,
        Alan Modra <amodra@bigpond.net.au>
Subject: Re: linux-next: build failure after merge of the final tree
 (powerpc related)
Message-ID: <20120621072928.GA13998@visitor2.iram.es>
References: <20120620175014.a822a766e0f91f7b44f48fa0@canb.auug.org.au>
 <1340256961.1998.11.camel@concordia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340256961.1998.11.camel@concordia>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SPF-Received: 2
X-Spamina-Bogosity: Unsure
X-Spam-Score: -4.4 (----)
X-Spam-Report: Content analysis details:   (-4.4 points)
	pts rule name              description
	---- ---------------------- --------------------------------------------------
	-1.8 ALL_TRUSTED            Passed through trusted hosts only via SMTP
	-2.6 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2012 at 03:36:01PM +1000, Michael Ellerman wrote:
> On Wed, 2012-06-20 at 17:50 +1000, Stephen Rothwell wrote:
> > Hi all,
> > 
> > After merging the final tree, today's linux-next build (powerpc
> > allyesconfig) failed like this:
> > 
> > powerpc64-linux-ld: arch/powerpc/net/built-in.o: In function `bpf_slow_path_word':
> > (.text+0x90): sibling call optimization to `skb_copy_bits' does not allow automatic multiple TOCs; recompile with -mminimal-toc or -fno-optimize-sibling-calls, or make `skb_copy_bits' extern
> 
> 
> Those seem to be caused because we don't have a nop after the call,
> meaning we can't patch the TOC pointer on the way back. Adding a nop
> fixes those.
> 
> But, then I get 32,410 variants of this:
> 
> powerpc64-linux-ld: /src/next/net/openvswitch/vport-netdev.c:189:(.text+0x89b990): 
> 	sibling call optimization to `_restgpr0_28' does not allow automatic multiple TOCs;
> 	recompile with -mminimal-toc or -fno-optimize-sibling-calls, or make `_restgpr0_28' extern
> 
> 

These functions should not need a TOC in the first place. There is
code in the linker (for 64 bit only: bfd/elf64-ppc.c) to automatically 
generate them whenever they are needed.

I suspect you compile with -Os. But I don't think you can use
these functions when doing a sibling call since restgpr0_nn
implies a return to the caller. restgpr1_nn would be different...

> And those are generated calls so I don't see how we can fix them.
> 
> > I started building with gcc 4.6.3/binutils 2.22 today.  gcc
> > 4.6.0/binutils 2.21 do not produce this error, it produces this instead
> > (which has been happening for a long time):
> > 
> > powerpc64-linux-ld: TOC section size exceeds 64k
> 
> 
> So presumably there's some new error checking that we're hitting, I
> imagine it was always broken, but now it's being more explicit.

I'm not so sure. I suspect gcc, but upgrading gcc and binutils at the
same time may not be the wisest...

	Gabriel
