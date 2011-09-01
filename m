Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579Ab1IAOMe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 10:12:34 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:24376 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757420Ab1IAOMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 10:12:31 -0400
X-SpamScore: -11
X-BigFish: VPS-11(zz936eK1432N98dKzz1202hzz8275dhz32i668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-FB-SS: 13,
X-WSS-ID: 0LQUKSQ-01-5NN-02
X-M-MSG: 
Date: Thu, 1 Sep 2011 16:12:19 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] perf, x86: Fix event scheduler for constraints with
 overlapping counters
Message-ID: <20110901141219.GA13447@erda.amd.com>
References: <1302913676-14352-1-git-send-email-robert.richter@amd.com>
 <1302913676-14352-5-git-send-email-robert.richter@amd.com>
 <20110419102600.GU31407@erda.amd.com>
 <1305753398.2466.7180.camel@twins>
 <20110518212054.GC28476@elte.hu>
 <1305754613.2466.7190.camel@twins>
 <20110519180650.GC6139@elte.hu>
 <20110520031855.GA17196@erda.amd.com>
 <1314881807.11566.23.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1314881807.11566.23.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01.09.11 08:56:46, Peter Zijlstra wrote:
> On Fri, 2011-05-20 at 05:18 +0200, Robert Richter wrote:
> > On 19.05.11 14:06:50, Ingo Molnar wrote:
> > > * Peter Zijlstra <peterz@infradead.org> wrote:
> > > 
> > > > On Wed, 2011-05-18 at 23:20 +0200, Ingo Molnar wrote:
> > > > > * Peter Zijlstra <peterz@infradead.org> wrote:
> > > > > 
> > > > > > >                         if (c->weight != w)
> > > > > > >                                 continue;
> > > > > > >  
> > > > > > > -                       for_each_set_bit(j, c->idxmsk, X86_PMC_IDX_MAX) {
> > > > > > > -                               if (!test_bit(j, used_mask))
> > > > > > > +                       /* for each bit in idxmsk starting from idx */
> > > > > > > +                       while (idx < X86_PMC_IDX_MAX) {
> > > > > > > +                               idx = find_next_bit(c->idxmsk, X86_PMC_IDX_MAX,
> > > > > > > +                                                   idx);
> > > > > > 
> > > > > > I'd be mighty tempted to ignore that 80 column rule here ;-)
> > > > > 
> > > > > Please put the body of the loop into a helper function, the function is large 
> > > > > and there are countless col80 uglinesses in it!
> > > > 
> > > > I just tried that, its real ugly due to the amount of state you need to
> > > > pass around.
> > > 
> > > Does it help if you put that state into a helper structure?
> > 
> > Yes, this is what I have in mind too. We could iterate on such a state
> > stucture instead of a couple of single variables. Storing and
> > restoring the state will then just copying the structure.
> 
> Any word on this work? I just noticed we actually need this for Intel
> too, the fixed purpose events have overlapping but non-identical
> constraint masks.
> 
> Now we could optimize the Intel case by always iterating from the top
> down, but it won't cure all cases. For example, suppose one counter
> (that could be on a FP reg) previously got scheduled on a GP register
> and we take the fast-path, in that case we would still end up
> under-utilized.

Yes, I had this patch in mind too. Will try to post an updated version
next week. Ok?

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

