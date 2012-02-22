Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002Ab2BVHsu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 02:48:50 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51877 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752225Ab2BVHst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 02:48:49 -0500
Date: Wed, 22 Feb 2012 08:48:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jason Baron <jbaron@redhat.com>, a.p.zijlstra@chello.nl,
        rostedt@goodmis.org, mathieu.desnoyers@efficios.com,
        davem@davemloft.net, ddaney.cavm@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 00/10] jump label: introduce very_[un]likely + cleanups +
 docs
Message-ID: <20120222074839.GA24890@elte.hu>
References: <cover.1329851692.git.jbaron@redhat.com>
 <4F43F9F0.4000605@zytor.com>
 <20120222065016.GA16923@elte.hu>
 <4F44934B.2000808@zytor.com>
 <20120222072538.GA17291@elte.hu>
 <4F449ACF.3040807@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F449ACF.3040807@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 02/21/2012 11:25 PM, Ingo Molnar wrote:
> > 
> > There is a fundamental assymetry, and intentionally so. You 
> > *really* have to think what the common case is, and make 
> > sure the build defaults to that. It's not the end of the 
> > world to have it flipped over, but there's costs and those 
> > costs are higher even in the branch path than a regular 
> > likely()/unlikely().
> 
> No, not really -- it's still an unconditional branch, which 
> means you will not tax the branch predictor in any way and 
> which can be followed by the front end without taking a 
> speculation hit. [...]

You are talking about CPU level costs, I am also talking about 
costs introduced at build time.

Fact is, jump-label unlikely branches are moved *out of line*: 
they are often in unlikely portions of the function (near other 
unlikely branches), with instruction cache granularity costs and 
potentially higher instruction-cache miss costs attached, etc.

You are missing three important aspects:

Firstly, instead of:

  ins1
  ins2
  ins3
  ins4
  ins5
  ins-compare
  ins-branch
  ins6
  ins7
  ins8
  ins9
  ins10

We have:

  ins1
  ins2
  ins3
  ins4
  ins5
  ins-jump

  [ hole ]

  ins6
  ins7
  ins8
  ins9
  ins10
  ins-jump back

Where the 'hole' fragments the instruction cache layout. Given 
that most of kernel execution is instruction-cache-cold, the 
'straightness' of kernel code matters quite a bit.

Secondly, there's build time instruction scheduling costs as 
well: GCC will prefer the likely branch over the unlikely one, 
so we might see extra instructions in the out-of-line code:


  ins1
  ins2
  ins3
  ins4
  ins5
  ins-jump

  [ hole ]

  ins-extra-1
  ins-extra-2
  ins6
  ins7
  ins8
  ins9
  ins10
  ins-jump back

In that sense jump labels are unlikely() branches combined with 
a patching mechanism.

Thus *both* aspects are important: if a branch is *truly* 50/50 
then it's quite possibly *NOT* a correct optimization to use 
jump-labels as the 'uncommon' code goes through extra hoops and 
fragments out of the fastpath, which in quite many real life 
cases can outstrip the advantage of the avoidance of a single 
branch ...

Thirdly,

even if it's a correct optimization and both branches happen to 
outperform the pre-jump-label version, regardless of the 
direction of the jump label flag, it's *STILL* fundamentally 
assymetric: due to the hole and due to the possible extra 
instructions the out of line code will be slower by a few 
instruction and the NOP fall-through will be faster.

This is fundamentally so, and any naming that tries to *hide* 
that assymetry and the associated micro-costs is confused.

Thanks,

	Ingo
