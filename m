Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075Ab0HRB7r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 21:59:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48332 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752915Ab0HRB7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 21:59:43 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTikQ1dGw0aO10_ZwmVEc-JAVhB==3HS7SrWycE49@mail.gmail.com>
References: <20100817.180325.104051399.davem@davemloft.net> <AANLkTikQ1dGw0aO10_ZwmVEc-JAVhB==3HS7SrWycE49@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 17 Aug 2010 18:59:17 -0700
Message-ID: <AANLkTimZ3rhX2AzPExEGfRCXiFNN-BGOWRKqL241-qNa@mail.gmail.com>
Subject: Re: [GIT] Sparc
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oh,
 I noticed another thing:

In commit 86fa04b8742ac681d470786f55e2403ada0075b2 you fix the return
type, but you still have the wrong _argument_ type:

  extern void atomic64_add(int, atomic64_t *);
  extern void atomic64_sub(int, atomic64_t *);
  extern long atomic64_add_ret(int, atomic64_t *);
  extern long atomic64_sub_ret(int, atomic64_t *);

note how if somebody does

   atomic64_add(0x100000000ull, &x)

sparc64 will get it wrong, because it will only take the low 32 bits
of the first argument, and add zero to the 64-bit counter.

Which is definitely not what the code intended, I think.

I merged your pull request, but you've got some fixing up to do,
methinks. I also really think you need to make your rwsem's use 64-bit
values on sparc64, because otherwise you can overflow the mmap_sem by
having more than 65536 threads doing page-faults (on 32-bit, having
more than 2**16 threads in one process is unlikely to work for other
reasons, like just pure stack usage, so we don't really care about the
32-bit case)

                         Linus
