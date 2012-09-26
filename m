Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888Ab2IZQJa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 12:09:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29867 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622Ab2IZQJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 12:09:29 -0400
X-Authority-Analysis: v=2.0 cv=C49rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=LrhBLfKaQO8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=SlKO6I3lSDoA:10 a=pGLkceISAAAA:8 a=iHofi1NxwjVZEAXMnK8A:9 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=gSs6whNv60aspNq8:21 a=YznaSpM5TN1d1NXe:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1348675764.22822.56.camel@gandalf.local.home>
Subject: Re: [PATCH v6] hashtable: introduce a small and naive hashtable
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        David Laight <David.Laight@ACULAB.COM>, torvalds@linux-foundation.org,
        tj@kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, neilb@suse.de, bfields@fieldses.org,
        ejt@redhat.com, snitzer@redhat.com, edumazet@google.com,
        josh@joshtriplett.org, rmallon@gmail.com, palves@redhat.com
Date: Wed, 26 Sep 2012 12:09:24 -0400
In-Reply-To: <20120926143905.GB22699@Krystal>
References: <1348663729-2584-1-git-send-email-levinsasha928@gmail.com>
	 <AE90C24D6B3A694183C094C60CF0A2F6026B7008@saturn3.aculab.com>
	 <1348667992.22822.50.camel@gandalf.local.home> <506310AA.2050700@gmail.com>
	 <20120926143905.GB22699@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-26 at 10:39 -0400, Mathieu Desnoyers wrote:
> * Sasha Levin (levinsasha928@gmail.com) wrote:
> > On 09/26/2012 03:59 PM, Steven Rostedt wrote:
> > > On Wed, 2012-09-26 at 14:45 +0100, David Laight wrote:
> > >> Amazing how something simple gets lots of comments and versions :-)
> > >>
> > >>> ...
> > >>> + * This has to be a macro since HASH_BITS() will not work on pointers since
> > >>> + * it calculates the size during preprocessing.
> > >>> + */
> > >>> +#define hash_empty(hashtable)							\
> > >>> +({										\
> > >>> +	int __i;								\
> > >>> +	bool __ret = true;							\
> > >>> +										\
> > >>> +	for (__i = 0; __i < HASH_SIZE(hashtable); __i++)			\
> > >>> +		if (!hlist_empty(&hashtable[__i]))				\
> > >>> +			__ret = false;						\
> > >>> +										\
> > >>> +	__ret;									\
> > >>> +})
> > >>
> > >> Actually you could have a #define that calls a function
> > >> passing in the address and size.
> > > 
> > > Probably would be cleaner to do so.
> > 
> > I think it's worth it if it was more complex than a simple loop. We
> > were doing a similar thing with the _size() functions (see version 4
> > of this patch), but decided to remove it since it was becoming too
> > complex.
> 
> Defining local variables within statement-expressions can have some
> unexpected side-effects if the "caller" which embeds the macro use the
> same variable name. See rcu_dereference() as an example (Paul uses an
> awefully large number of underscores). It should be avoided whenever
> possible.
> 
> > > 
> > > 
> > >> Also, should the loop have a 'break' in it?
> > > 
> > > Yeah it should, and could do:
> > > 
> > > 	for (i = 0; i < HASH_SIZE(hashtable); i++)
> > > 		if (!hlist_empty(&hashtable[i]))
> > > 			break;
> > > 
> > > 	return i < HASH_SIZE(hashtable);
> 
> 
> Hrm, Steven, did you drink you morning coffee before writing this ? ;-)
> It looks like you did 2 bugs in 4 LOC.

Coffee yes, but head cold as well. :-p

> 
> First, the condition should be reversed, because this function returns
> whether the hash is empty, not the other way around.

Bah, I was looking at the code the code and got the ret confused. I
originally had it the opposite, and then reversed it before sending.

> 
> And even then, if we would do:
> 
>  	for (i = 0; i < HASH_SIZE(hashtable); i++)
>  		if (!hlist_empty(&hashtable[i]))
>  			break;
>  
>  	return i >= HASH_SIZE(hashtable);
> 
> What happens if the last entry of the table is non-empty ?

It still works, as 'i' is not incremented due to the break. And i will
still be less than HASH_SIZE(hashtable). Did you have *your* cup of
coffee today? ;-)


> 
> So I would advise that Sasha keep his original flag-based
> implementation, but add the missing break, and move the init and empty
> define loops into static inlines.
> 

Nah,

-- Steve


