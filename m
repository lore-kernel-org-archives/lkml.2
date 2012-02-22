Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612Ab2BVITO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 03:19:14 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35887 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788Ab2BVITN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 03:19:13 -0500
Date: Wed, 22 Feb 2012 09:18:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@redhat.com>,
        a.p.zijlstra@chello.nl, mathieu.desnoyers@efficios.com,
        davem@davemloft.net, ddaney.cavm@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 00/10] jump label: introduce very_[un]likely + cleanups +
 docs
Message-ID: <20120222081855.GB25318@elte.hu>
References: <cover.1329851692.git.jbaron@redhat.com>
 <4F43F9F0.4000605@zytor.com>
 <20120221202019.GB2381@redhat.com>
 <1329856745.25686.72.camel@gandalf.stny.rr.com>
 <20120222073251.GB17291@elte.hu>
 <20120222075334.GA25053@elte.hu>
 <7479958c-1932-4ced-a7a4-53ac6ea3a38e@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7479958c-1932-4ced-a7a4-53ac6ea3a38e@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> Stupid thought... do we have cases that matter where the bias 
> and default don't agree?

Yeah, that was one of my worries about the proposed original 
tongue twisters (see Jason's original series: "jump label: 
introduce default true branch").

For example could you tell *at a glance* what this does:

+       if (!static_branch_def_false(&perf_sched_events.key))

?

I certainly couldn't, I'd have to consider the '!', that it's a 
'static branch' and that it's either 'defined to false' or 
'default to false'.

Linguistic and visual barriers all around, and that's for code 
that I am intimately familar with ...

The problem with static_branch_def_false/def_true was that the 
very intuitively visible bias that we see with 
likely()/unlikely() is confused in jump label constructs through 
two layers of modifiers. And the fix is so easy, a simple rename 
in most cases ;-)

So instead of that, in this series we have:

+       if (very_unlikely(&perf_sched_events.key))

which is a heck of an improvement IMO. I'd still up its 
readability a notch, by also signalling the overhead of the 
update path by making it:

+       if (very_unlikely(&perf_sched_events.slow_flag))

... but I don't want to be that much of a readability nazi ;-)

Thanks,

	Ingo
