Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157Ab1AGSEZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 13:04:25 -0500
Received: from mail.openrapids.net ([64.15.138.104]:53791 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755092Ab1AGSEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 13:04:24 -0500
Date: Fri, 7 Jan 2011 13:04:19 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Christoph Lameter <cl@linux.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>,
        akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [cpuops cmpxchg double V2 1/4] Generic support for
	this_cpu_cmpxchg_double
Message-ID: <20110107180419.GB23082@Krystal>
References: <20110106204513.669098445@linux.com> <20110106204525.222395863@linux.com> <4D263C91.30709@zytor.com> <alpine.DEB.2.00.1101070907060.3014@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1101070907060.3014@router.home>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 12:41:44 up 44 days, 22:44,  6 users,  load average: 0.00, 0.00,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (cl@linux.com) wrote:
> On Thu, 6 Jan 2011, H. Peter Anvin wrote:
> 
> > On 01/06/2011 12:45 PM, Christoph Lameter wrote:
> > > Introduce this_cpu_cmpxchg_double. this_cpu_cmpxchg_double() allows the
> > > comparision between two consecutive words and replaces them if there is
> > > a match.
> > >
> > > 	bool this_cpu_cmpxchg_double(pcp1, pcp2,
> > > 		old_word1, old_word2, new_word1, new_word2)
> > >
> > > this_cpu_cmpxchg_double does not return the old value (difficult since
> > > there are two words) but a boolean indicating if the operation was
> > > successful.
> > >
> > > The first percpu variable must be double word aligned!
> >
> > I really truly hate this interface.  The whole notion of passing two
> > pointers where only one is really used, is just painful.
> 
> Well the second cpu variable is just there for correctness checking. That
> way we can verify that the types are compatible for the second word and
> that the second word was properly placed relative to the first one. It
> also helps the reader in the source because it shows explicitly which two
> words are modified by the operation.
> 
> If you look at the prior patch series at the use case you will see that
> s->cpu_slab->tid was not referred to in the cmpxchg operation but
> implicitly modified. That is bad and was the initial motivation to require
> both to be specified.
> 
> During debugging I had a couple of problems with the way the compiler
> placed those two fields that only became evident after painful debugging
> sessions. With the checks possible only because both are specifiec there
> is an explicit failure if either of the two cpu variables is specified in
> such a way that the cmpxchg32b cannot work.

I have to admit that I also hate the current interface for two reasons:

a) the way it splits the target address in two.

b) the loss of the value read (the fact that the only current user of this API
   does not need the value returned seems like a very weak argument to define an
   API).

I'm probably missing important compiler trickiness here, but why are we not
rather relying on forced compiler alignment to declare the target address type ?
e.g.:

typedef struct {
        unsigned long v[2];
} __attribute__((aligned(2 * sizeof(long)))) cmpxchg_double_t;

For the usage you are doing within the allocator code, you can use an union (the
bitfield sizes are completely arbitrary).

union alloc_cd {
        cmpxchg_double_t cd;
        struct {
                void *ptr;
                unsigned long seq:48;
                unsigned long cpu:16;
        } v;
};

So this_cpu_cmpxchg_double would expect the type "cmpxchg_double_t *" as its
first argument.

One way to manage to return the value read would be to pass a pointer to
"old_word1-2" as argument rather than the value itself, and return the value
read in these locations. Anyway, we won't need the old words for comparison with
the return value, because the returned "bool" takes care of telling us if they
differ.

Adding the types just for clarity sake (should be handled differently in your
macro scheme of course), this_cpu_cmpxchg_double would look like:

typedef struct {
        unsigned long v[2];
} __attribute__((aligned(2 * sizeof(long)))) cmpxchg_double_t;

bool this_cpu_cmpxchg_double(cmpxchg_double_t *pcp,
                             unsigned long *old_ret_word1,
                             unsigned long *old_ret_word2,
                             unsigned long new_word1,
                             unsigned long new_word2)

Thoughts ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
