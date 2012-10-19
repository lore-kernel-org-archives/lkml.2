Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984Ab2JSSsi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 14:48:38 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:55087 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384Ab2JSSsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 14:48:36 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1210181132430.22996@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1210151716310.10685@file.rdu.redhat.com>
 <Pine.LNX.4.64.1210161924350.20581@file.rdu.redhat.com> <CA+55aFyZ9uq_yfHn9PwpmM77X3xVd+xseEbjJmeCCqbFddtjWA@mail.gmail.com>
 <Pine.LNX.4.64.1210181132430.22996@file.rdu.redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 19 Oct 2012 11:48:13 -0700
X-Google-Sender-Auth: rcbzTYjikuKG6tT2YtHC74r2Ozc
Message-ID: <CA+55aFzyP8OFJGWB5nZduzqMMwuAwy+1Ed5TBCpdBSOpC1ketw@mail.gmail.com>
Subject: Re: [PATCH] percpu-rwsem: use barrier in unlock path
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 9:00 AM, Mikulas Patocka <mpatocka@redhat.com> wrote:
>
> What is the procedure for making changes that require support of
> architectures? It is trivial to make a patch that moves this into
> arch-specific includes, the problem is that the patch break all the
> architectures - I wrote support for x86, sparc, parisc, alpha (I can test
> those) but not the others.

We'd need to add it to everybody.

It shouldn't need per-architecture testing - since "smp_mb()" is
always safe. So we could just make all architectures default to that,
and then for x86 (and potentially others that have cheaper models for
release-consistency) just do the optimized one.

We *could* also simply do something like

   #ifndef smp_release_before_store
     #define smp_release_before_store() smp_mb()
   #endif

and basically make the rule be that only architectures that have a
cheaper one need to define it at all. That may be the correct
short-term fix, since there initially would be only a single user.

                  Linus
