Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072Ab0FKUI3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 16:08:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35115 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755134Ab0FKUI2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 16:08:28 -0400
MIME-Version: 1.0
In-Reply-To: <20100611194016.GA5213@Krystal>
References: <20100611194016.GA5213@Krystal>
Date: Fri, 11 Jun 2010 13:07:55 -0700
Message-ID: <AANLkTil84IIgzlPcycNWJFRpZIGRqTFL6FGffzqOaSEx@mail.gmail.com>
Subject: Re: sequence lock in Linux
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 11, 2010 at 12:40 PM, Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
>
> Is it just me, or the following code:
>
> static __always_inline unsigned read_seqbegin(const seqlock_t *sl)
> {
>        unsigned ret;
>
> repeat:
>        ret = sl->sequence;
>        smp_rmb();
>        if (unlikely(ret & 1)) {
>                cpu_relax();
>                goto repeat;
>        }
>
>        return ret;
> }
>
> could use a ACCESS_ONCE() around the sl->sequence read ? I'm concerned about the
> compiler generating code that reads the sequence number chunkwise.

What compiler would do that? That would seem to be a compiler bug, or
a compiler that is just completely crazy.

But it wouldn't be _wrong_ to make it do ACCESS_ONCE(). I just suspect
that any compiler that cares is not a compiler worth worrying about,
and the compiler should be shot in the head rather than us necessarily
worrying about it.

There is no way a sane compiler can do anything but one read anyway.
We do end up using all the bits (for the "return ret") part, so a
compiler that reads the low bit separately is just being a totally
moronic one - we wouldn't want to touch such a stupid compiler with a
ten-foot pole.

But at the same time, ACCESS_ONCE() ends up being a reasonable hint to
programmers, so I wouldn't object to it. I just don't think we should
pander to "compilers can be crazy". If compilers are crazy, we
shouldn't use them.

                 Linus
