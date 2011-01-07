Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327Ab1AGSmF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 13:42:05 -0500
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:32315 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755279Ab1AGSmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 13:42:01 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: V6ZkNrIVM1kiq66coEA_DA2tDASe6dUSPyx8KdhF02.0geO
 Ky4cJfKKayC02S8irXcOiRVO.40pbvxuTDpRqHxyfsd77p1ZyWQwOyGev0AV
 _Xdlx4bI.EZBVUgUYu6ezsqpOyymorCnNUWk5xmFEhIj1edBPPtKNfkPOCkZ
 bMJpO3JwuUJwqtQpc8ryONpslvnrPWC.mos87nOecFpjEGu0sqa_2bEHFF.R
 RRcCXhCHWhnLT5LS7a.c604mKNQ44z7hhnmsgxzNOQd7.tslFGm1X6uEzquO
 5Ro9KjYA0W6XfJpq1qGRgDmqn.d.X0KhTbek0SyA8_Ch4GgE-
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 7 Jan 2011 12:41:58 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
cc: "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>,
        akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [cpuops cmpxchg double V2 1/4] Generic support for
 this_cpu_cmpxchg_double
In-Reply-To: <20110107180419.GB23082@Krystal>
Message-ID: <alpine.DEB.2.00.1101071227450.3014@router.home>
References: <20110106204513.669098445@linux.com> <20110106204525.222395863@linux.com> <4D263C91.30709@zytor.com> <alpine.DEB.2.00.1101070907060.3014@router.home> <20110107180419.GB23082@Krystal>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Jan 2011, Mathieu Desnoyers wrote:

> I have to admit that I also hate the current interface for two reasons:
>
> a) the way it splits the target address in two.

We are handling two different entities that are placed next to each other.

> b) the loss of the value read (the fact that the only current user of this API
>    does not need the value returned seems like a very weak argument to define an
>    API).

The other user of cmpxchg_double that I have in my tree also does not have
the need. Repeatability is not as simple to implement as with a single
word cmpxchg.

> I'm probably missing important compiler trickiness here, but why are we not
> rather relying on forced compiler alignment to declare the target address type ?
> e.g.:
>
> typedef struct {
>         unsigned long v[2];
> } __attribute__((aligned(2 * sizeof(long)))) cmpxchg_double_t;
>
> For the usage you are doing within the allocator code, you can use an union (the
> bitfield sizes are completely arbitrary).
>
> union alloc_cd {
>         cmpxchg_double_t cd;
>         struct {
>                 void *ptr;
>                 unsigned long seq:48;
>                 unsigned long cpu:16;
>         } v;
> };
>
> So this_cpu_cmpxchg_double would expect the type "cmpxchg_double_t *" as its
> first argument.

That requires conversions back and forth between words and this
type. We only need the bonding between the two per cpu variables for the
single cmpxchg_double operation. There is no need to do this for the two
old values or the two new values.

> One way to manage to return the value read would be to pass a pointer to
> "old_word1-2" as argument rather than the value itself, and return the value
> read in these locations. Anyway, we won't need the old words for comparison with
> the return value, because the returned "bool" takes care of telling us if they
> differ.

That would require allocating storage for the two word variable required,
passing an address etc. All not necessary right now. Would increase the
latency of the inner loop. Saving the returned values also would increase
the code uselessly.

> Adding the types just for clarity sake (should be handled differently in your
> macro scheme of course), this_cpu_cmpxchg_double would look like:
>
> typedef struct {
>         unsigned long v[2];
> } __attribute__((aligned(2 * sizeof(long)))) cmpxchg_double_t;
>
> bool this_cpu_cmpxchg_double(cmpxchg_double_t *pcp,
>                              unsigned long *old_ret_word1,
>                              unsigned long *old_ret_word2,
>                              unsigned long new_word1,
>                              unsigned long new_word2)
>
> Thoughts ?

Looks not symmetric. The proposed approach in the patch has a clear
association of the first and second percpu variable with the first and
second old and new values.

Also cmpxchg_double may be used with different types and different object
sizes. Are we going to define cmpxchg_double_t for all types supported
and maybe created by the user? this_cpu_cmpxchg_double also supports two 4
byte fields.

Plus you can have mixed types. In the current use case you have one
integer and one pointer. So the cmpxchg_double_t would not fit in cleanly.
We would have to define custom types. And with that we will then have
difficulties codeing methods to check the compatibility of types.

I tried something like this before I came up with the current
solution. It was significantly more code and the code was difficult
to understand. Never was as clean and this one.
