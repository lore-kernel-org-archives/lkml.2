Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756349Ab2BXJIl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 04:08:41 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38857 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755561Ab2BXJIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 04:08:36 -0500
Date: Fri, 24 Feb 2012 10:08:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jason Baron <jbaron@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Steven Rostedt <rostedt@goodmis.org>, a.p.zijlstra@chello.nl,
        davem@davemloft.net, ddaney.cavm@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/10] jump label: introduce very_[un]likely + cleanups +
 docs
Message-ID: <20120224090811.GB814@elte.hu>
References: <20120222075334.GA25053@elte.hu>
 <7479958c-1932-4ced-a7a4-53ac6ea3a38e@email.android.com>
 <20120222081855.GB25318@elte.hu>
 <20120222213343.GA19758@bloggs.ozlabs.ibm.com>
 <20120223100205.GD24310@elte.hu>
 <CA+55aFwwV3GsqHue8oUsx-XbvSQXSawJ0w5z=wL8ue=EH4ifzw@mail.gmail.com>
 <20120223223348.GA25513@elte.hu>
 <20120223223933.GA7942@elte.hu>
 <20120223231842.GA31030@Krystal>
 <20120224022512.GA3777@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120224022512.GA3777@redhat.com>
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


* Jason Baron <jbaron@redhat.com> wrote:

> On Thu, Feb 23, 2012 at 06:18:42PM -0500, Mathieu Desnoyers wrote:
> > * Ingo Molnar (mingo@elte.hu) wrote:
> > > 
> > > * Ingo Molnar <mingo@elte.hu> wrote:
> > > 
> > > > So, a modified scheme would be:
> > > > 
> > > >         #include <linux/static_key.h>
> > > > 
> > > >         struct static_key key = STATIC_KEY_INIT_TRUE;
> > > > 
> > > >         if (static_key_false(&key))
> > > >                 do unlikely code
> > > >         else
> > > >                 do likely code
> > > > 
> > > > Or:
> > > > 
> > > >         if (static_key_true(&key))
> > > >                 do likely code
> > > >         else
> > > >                 do unlikely code
> > > > 
> > > > The static key is modified via:
> > > > 
> > > >         static_key_slow_inc(&key);
> > > >         ...
> > > >         static_key_slow_dec(&key);
> > > > 
> > > > Is that API fine? I'll rework the series to such an effect if 
> > > > everyone agrees.
> > > 
> > > I.e. something like the patch below on top of 
> > > tip:perf/jump-labels.
> > > 
> > > Untested - will test it and will refactor the series if 
> > > everyone's happy.
> > 
> > Hi Ingo,
> > 
> > Reading your documentation updates makes me realise that adding the
> > "inline" keyword in there would make the whole thing even clearer:
> > 
> > struct static_key key = STATIC_KEY_INLINE_TRUE_INIT;
> > struct static_key key = STATIC_KEY_INLINE_FALSE_INIT;
> > 
> > static_key_inline_true() / static_key_inline_false()
> > 
> > to show that the "true/false" in there does not mean that the key will
> > always be true or false (the key value can indeed by changed by calling
> > static_key_slow_inc/dec), but that the inlined path is either the true
> > of false branch.
> > 
> 
> Also, as part of the API, there is a test to check the branch 
> direction - which was 'jump_label_true(key)', but is now also 
> 'static_key_true(key)', [...]

Yeah, there is such an overlap - I've renamed it to 
static_key_enabled(), which makes sense anyway as the original 
was jump_label_enabled()..

Btw., shouldnt it be an inline function? Currently it's:

bool static_key_enabled(struct static_key *key)
{
        return (atomic_read(&key->enabled) > 0);
}

which is the perfect candidate for inlining. The difference to 
static_key_true() is the lack of the jump label patching and the 
lack of an unlikely() hint.

> [...] so we are going to have to change either the branch site 
> or the test for true/false name. The above 
> 'static_key_inline_true/false' solves that.

It's generally good practice to make the mostly commonly used 
method names the simplest/shortest names - i.e. I don't think we 
should make it longer via adding an _inline to every use.

In that sense static_key_true() has pretty optimal length - we'd 
like these tests to also be visually unintrusive.

So in the latest patch (still under testing, will push it out 
soon) we have:

	static_key_true()
	static_key_false()
	static_key_enabled()

> Also, I do like having a consistent 'static_key_*' prefix for 
> the entire API - definitely an improvement for me.

Yeah.

Thanks,

	Ingo
