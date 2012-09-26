Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757026Ab2IZQT7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 12:19:59 -0400
Received: from mail.openrapids.net ([64.15.138.104]:58169 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754333Ab2IZQT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 12:19:58 -0400
Date: Wed, 26 Sep 2012 12:19:56 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        David Laight <David.Laight@ACULAB.COM>, torvalds@linux-foundation.org,
        tj@kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, neilb@suse.de, bfields@fieldses.org,
        ejt@redhat.com, snitzer@redhat.com, edumazet@google.com,
        josh@joshtriplett.org, rmallon@gmail.com, palves@redhat.com
Subject: Re: [PATCH v6] hashtable: introduce a small and naive hashtable
Message-ID: <20120926161956.GB28648@Krystal>
References: <1348663729-2584-1-git-send-email-levinsasha928@gmail.com> <AE90C24D6B3A694183C094C60CF0A2F6026B7008@saturn3.aculab.com> <1348667992.22822.50.camel@gandalf.local.home> <506310AA.2050700@gmail.com> <20120926143905.GB22699@Krystal> <1348675764.22822.56.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348675764.22822.56.camel@gandalf.local.home>
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Wed, 2012-09-26 at 10:39 -0400, Mathieu Desnoyers wrote:
> > * Sasha Levin (levinsasha928@gmail.com) wrote:
> > > On 09/26/2012 03:59 PM, Steven Rostedt wrote:
> > > > On Wed, 2012-09-26 at 14:45 +0100, David Laight wrote:
> > > >> Amazing how something simple gets lots of comments and versions :-)
> > > >>
> > > >>> ...
> > > >>> + * This has to be a macro since HASH_BITS() will not work on pointers since
> > > >>> + * it calculates the size during preprocessing.
> > > >>> + */
> > > >>> +#define hash_empty(hashtable)							\
> > > >>> +({										\
> > > >>> +	int __i;								\
> > > >>> +	bool __ret = true;							\
> > > >>> +										\
> > > >>> +	for (__i = 0; __i < HASH_SIZE(hashtable); __i++)			\
> > > >>> +		if (!hlist_empty(&hashtable[__i]))				\
> > > >>> +			__ret = false;						\
> > > >>> +										\
> > > >>> +	__ret;									\
> > > >>> +})
> > > >>
> > > >> Actually you could have a #define that calls a function
> > > >> passing in the address and size.
> > > > 
> > > > Probably would be cleaner to do so.
> > > 
> > > I think it's worth it if it was more complex than a simple loop. We
> > > were doing a similar thing with the _size() functions (see version 4
> > > of this patch), but decided to remove it since it was becoming too
> > > complex.
> > 
> > Defining local variables within statement-expressions can have some
> > unexpected side-effects if the "caller" which embeds the macro use the
> > same variable name. See rcu_dereference() as an example (Paul uses an
> > awefully large number of underscores). It should be avoided whenever
> > possible.
> > 
> > > > 
> > > > 
> > > >> Also, should the loop have a 'break' in it?
> > > > 
> > > > Yeah it should, and could do:
> > > > 
> > > > 	for (i = 0; i < HASH_SIZE(hashtable); i++)
> > > > 		if (!hlist_empty(&hashtable[i]))
> > > > 			break;
> > > > 
> > > > 	return i < HASH_SIZE(hashtable);
> > 
> > 
> > Hrm, Steven, did you drink you morning coffee before writing this ? ;-)
> > It looks like you did 2 bugs in 4 LOC.
> 
> Coffee yes, but head cold as well. :-p
> 
> > 
> > First, the condition should be reversed, because this function returns
> > whether the hash is empty, not the other way around.
> 
> Bah, I was looking at the code the code and got the ret confused. I
> originally had it the opposite, and then reversed it before sending.
> 
> > 
> > And even then, if we would do:
> > 
> >  	for (i = 0; i < HASH_SIZE(hashtable); i++)
> >  		if (!hlist_empty(&hashtable[i]))
> >  			break;
> >  
> >  	return i >= HASH_SIZE(hashtable);
> > 
> > What happens if the last entry of the table is non-empty ?
> 
> It still works, as 'i' is not incremented due to the break. And i will
> still be less than HASH_SIZE(hashtable). Did you have *your* cup of
> coffee today? ;-)

Ahh, right! Actually I had it already ;-)

> 
> 
> > 
> > So I would advise that Sasha keep his original flag-based
> > implementation, but add the missing break, and move the init and empty
> > define loops into static inlines.
> > 
> 
> Nah,

Agreed that the flags should be removed. Moving to define + static
inline is still important though.

Thanks,

Mathieu


> 
> -- Steve
> 
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
