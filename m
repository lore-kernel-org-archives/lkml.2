Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765Ab1KPTXq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 14:23:46 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:6014 "EHLO
	VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831Ab1KPTXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 14:23:45 -0500
X-SpamScore: -12
X-BigFish: VPS-12(zz936eK1432N98dKzz1202hzzz2dh668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LURPVE-02-42M-02
X-M-MSG: 
Date: Wed, 16 Nov 2011 20:23:31 +0100
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] perf, x86: Implement event scheduler helper
 functions
Message-ID: <20111116192331.GR15738@erda.amd.com>
References: <20111111142935.GI15738@erda.amd.com>
 <1321293071-8636-1-git-send-email-robert.richter@amd.com>
 <1321293071-8636-2-git-send-email-robert.richter@amd.com>
 <1321459336.27735.8.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1321459336.27735.8.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.11.11 17:02:16, Peter Zijlstra wrote:
> On Mon, 2011-11-14 at 18:51 +0100, Robert Richter wrote:
> > @@ -22,8 +22,14 @@ extern unsigned long __sw_hweight64(__u64 w);
> >  #include <asm/bitops.h>
> >  
> >  #define for_each_set_bit(bit, addr, size) \
> > -       for ((bit) = find_first_bit((addr), (size)); \
> > -            (bit) < (size); \
> > +       for ((bit) = find_first_bit((addr), (size));            \
> > +            (bit) < (size);                                    \
> > +            (bit) = find_next_bit((addr), (size), (bit) + 1))
> > +
> > +/* same as for_each_set_bit() but use bit as value to start with */
> > +#define for_each_set_bit_cont(bit, addr, size) \
> > +       for ((bit) = find_next_bit((addr), (size), (bit));      \
> > +            (bit) < (size);                                    \
> >              (bit) = find_next_bit((addr), (size), (bit) + 1)) 
> 
> So my version has the +1 for the first as well, this is from the
> assumption that the bit passed in has been dealt with and should not be
> the first. ie. cont _after_ @bit instead of cont _at_ @bit.
> 
> This seems consistent with the list_*_continue primitives as well, which
> will start with the element after (or before for _reverse) the given
> position.
> 
> Thoughts?

The problem is that you then can't start with bit 0 unless you pass a
-1 which seems unsane.

You hit this actually too in your code with

	for_each_set_bit_cont(j, c->idxmsk, X86_PMC_IDX_MAX)
		...

Your intention was to start with X86_PMC_IDX_MAX, the first fixed
counter. But you always started with X86_PMC_IDX_MAX+1 never getting
the first fixed counter.

With list_*_continue it is slightly different because there is the
list header that *points* to the first element. Thus it can start with
the fist element of the list too by passing the list header.

In the end, passing the first bit to start with seems more logically.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

