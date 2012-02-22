Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab2BVGud (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 01:50:33 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40691 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753109Ab2BVGub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 01:50:31 -0500
Date: Wed, 22 Feb 2012 07:50:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jason Baron <jbaron@redhat.com>, a.p.zijlstra@chello.nl,
        rostedt@goodmis.org, mathieu.desnoyers@efficios.com,
        davem@davemloft.net, ddaney.cavm@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 00/10] jump label: introduce very_[un]likely + cleanups +
 docs
Message-ID: <20120222065016.GA16923@elte.hu>
References: <cover.1329851692.git.jbaron@redhat.com>
 <4F43F9F0.4000605@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F43F9F0.4000605@zytor.com>
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

> On 02/21/2012 12:02 PM, Jason Baron wrote:
> > Hi,
> > 
> > Renames 'static_branch()' -> very_unlikely(), hopefully, to be more intuitive
> > as to what jump labels is about. I'm also introducing 'very_likely()', as
> > the analogue to very_unlikely(). Patch is against the -tip perf branch.
> > 
> 
> Erk... I'm not happy about this.  very_unlikely() makes it 
> sound like it operates like unlikely(), which really is not 
> the case.  There is a huge difference in mechanism here as 
> well as usage.

There are three issues why I insisted for Jason to rename these 
nonsensically 'jump_label' patterned methods before I send any 
more jump label commits to Linus:

The pattern has spread beyond the niche of tracing internals and 
nobody seemed to have any second thoughts about the actual 
readability of these names. That is a major FAIL and it was my 
primary concern.

For those *reading* the code, the similarity of 
very_likely()/very_unlikely() to the likely()/unlikely() 
patterns is *INTENTIONAL*, as functionally the branch site 
itself is very similar to a real branch!

Secondly, for those *writing* such code, you cannot just 
'accidentally' change a unlikely() to a very_unlikely() and get 
something you didn't ask for ...

It is the modification site that is dissimilar (and which is 
slow in the jump label case) - and that is very apparently 
dissimilar that it takes some effort to change these flags. If 
you write such code you have to add the whole jump label 
mechanism to it, which makes it very apparent what is happening 
and makes the costs very apparent as well.

Thirdly, the fact that it's a 'jump label' is an 
*implementational* detail. On some architectures very_unlikely() 
indeed maps to unlikely(), because jump labels have not been 
implemented yet. On some architectures very_unlikely() is 
implemented via jump labels. On some future architectures it 
might be implemented via JIT-ing the target function. (I made 
the last one up)

So it makes sense to decouple 'jump labels' from the actual high 
level naming of this API.

Anyway, I've Cc:-ed Linus and Andrew, I plan to take the renames 
but they can NAK me if doing that is stupid.

Thanks,

	Ingo
