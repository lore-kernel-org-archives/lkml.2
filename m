Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592Ab0LMBqI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 20:46:08 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:3306 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752272Ab0LMBqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 20:46:04 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAN/mBE15LdLl/2dsb2JhbACkBHnAZIVKBA
Date: Mon, 13 Dec 2010 12:45:53 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: Nick Piggin <npiggin@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: Big git diff speedup by avoiding x86 "fast string" memcmp
Message-ID: <20101213014553.GA6522@amd>
References: <20101209070938.GA3949@amd>
 <19324.1291990997@jrobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19324.1291990997@jrobl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 10, 2010 at 11:23:17PM +0900, J. R. Okajima wrote:
> 
> Nick Piggin:
> > The standard memcmp function on a Westmere system shows up hot in
> > profiles in the `git diff` workload (both parallel and single threaded),
> > and it is likely due to the costs associated with trapping into
> > microcode, and little opportunity to improve memory access (dentry
> > name is not likely to take up more than a cacheline).
> 
> Let me make sure.
> What you are pointing out is
> - asm("repe; cmpsb") may grab CPU long time, and can be a hazard for
>   scaling.
> - by breaking it into pieces, the chances to scale will increase.
> Right?

It's not scaling but just single threaded performance. gcc turns memcmp
into rep cmp, which has quite a long latency, so it's not appripriate
for short strings.

 
> Anyway this appraoch replacing smallest code by larger but faster code
> is interesting.
> How about mixing 'unsigned char *' and 'unsigned long *' in referencing
> the given strings?
> For example,
> 
> int f(const unsigned char *cs, const unsigned char *ct, size_t count)
> {
> 	int ret;
> 	union {
> 		const unsigned long *l;
> 		const unsigned char *c;
> 	} s, t;
> 
> /* this macro is your dentry_memcmp() actually */
> #define cmp(s, t, c, step)		      \
> 	do {				      \
> 		while ((c) >= (step)) {	      \
> 			ret = (*(s) != *(t)); \
> 			if (ret)	      \
> 				return ret;   \
> 			(s)++;		      \
> 			(t)++;		      \
> 			(c) -= (step);	      \
> 		}			      \
> 	} while (0)
> 
> 	s.c = cs;
> 	t.c = ct;
> 	cmp(s.l, t.l, count, sizeof(*s.l));
> 	cmp(s.c, t.c, count, sizeof(*s.c));
> 	return 0;
> }
> 
> What I am thinking here is,
> - in load and compare, there is no difference between 'char*' and
>   'long*', probably.
> - obviously 'step by sizeof(long)' will reduce the number of repeats.
> - but I am not sure whether the length of string is generally longer
>   than 4 (or 8) or not.

The comparison is no longer an issue, so I think the added complexity
is not going to be worth it -- think about average length of directory
entry name, the average is maybe 12? In the kernel tree it's 11.

If we really wanted to do this, we'd round name lengths up to nearest
sizeof(long) (which should be the case already, but we'd do it
explicitly), zero fill the last bytes, and do a long compare loop. I
doubt it would be noticable though.



