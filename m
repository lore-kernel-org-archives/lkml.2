Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738Ab2IZOjJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 10:39:09 -0400
Received: from mail.openrapids.net ([64.15.138.104]:58071 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755945Ab2IZOjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 10:39:07 -0400
Date: Wed, 26 Sep 2012 10:39:05 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        David Laight <David.Laight@ACULAB.COM>, torvalds@linux-foundation.org,
        tj@kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, neilb@suse.de, bfields@fieldses.org,
        ejt@redhat.com, snitzer@redhat.com, edumazet@google.com,
        josh@joshtriplett.org, rmallon@gmail.com, palves@redhat.com
Subject: Re: [PATCH v6] hashtable: introduce a small and naive hashtable
Message-ID: <20120926143905.GB22699@Krystal>
References: <1348663729-2584-1-git-send-email-levinsasha928@gmail.com> <AE90C24D6B3A694183C094C60CF0A2F6026B7008@saturn3.aculab.com> <1348667992.22822.50.camel@gandalf.local.home> <506310AA.2050700@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <506310AA.2050700@gmail.com>
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sasha Levin (levinsasha928@gmail.com) wrote:
> On 09/26/2012 03:59 PM, Steven Rostedt wrote:
> > On Wed, 2012-09-26 at 14:45 +0100, David Laight wrote:
> >> Amazing how something simple gets lots of comments and versions :-)
> >>
> >>> ...
> >>> + * This has to be a macro since HASH_BITS() will not work on pointers since
> >>> + * it calculates the size during preprocessing.
> >>> + */
> >>> +#define hash_empty(hashtable)							\
> >>> +({										\
> >>> +	int __i;								\
> >>> +	bool __ret = true;							\
> >>> +										\
> >>> +	for (__i = 0; __i < HASH_SIZE(hashtable); __i++)			\
> >>> +		if (!hlist_empty(&hashtable[__i]))				\
> >>> +			__ret = false;						\
> >>> +										\
> >>> +	__ret;									\
> >>> +})
> >>
> >> Actually you could have a #define that calls a function
> >> passing in the address and size.
> > 
> > Probably would be cleaner to do so.
> 
> I think it's worth it if it was more complex than a simple loop. We
> were doing a similar thing with the _size() functions (see version 4
> of this patch), but decided to remove it since it was becoming too
> complex.

Defining local variables within statement-expressions can have some
unexpected side-effects if the "caller" which embeds the macro use the
same variable name. See rcu_dereference() as an example (Paul uses an
awefully large number of underscores). It should be avoided whenever
possible.

> > 
> > 
> >> Also, should the loop have a 'break' in it?
> > 
> > Yeah it should, and could do:
> > 
> > 	for (i = 0; i < HASH_SIZE(hashtable); i++)
> > 		if (!hlist_empty(&hashtable[i]))
> > 			break;
> > 
> > 	return i < HASH_SIZE(hashtable);


Hrm, Steven, did you drink you morning coffee before writing this ? ;-)
It looks like you did 2 bugs in 4 LOC.

First, the condition should be reversed, because this function returns
whether the hash is empty, not the other way around.

And even then, if we would do:

 	for (i = 0; i < HASH_SIZE(hashtable); i++)
 		if (!hlist_empty(&hashtable[i]))
 			break;
 
 	return i >= HASH_SIZE(hashtable);

What happens if the last entry of the table is non-empty ?

So I would advise that Sasha keep his original flag-based
implementation, but add the missing break, and move the init and empty
define loops into static inlines.

Thanks,

Mathieu

> 
> Right.
> 
> 
> Thanks,
> Sasha

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
