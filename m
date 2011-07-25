Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912Ab1GYKFd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 06:05:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:47399 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359Ab1GYKF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 06:05:26 -0400
Subject: Re: [GIT PULL] core/locking changes for v3.1
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <CACqU3MUW81UmBK7qBQCZRqzfosrukYM9=o0EZP_DvSjgywfK8g@mail.gmail.com>
References: <20110722125236.GA24832@elte.hu>
	 <CACqU3MUW81UmBK7qBQCZRqzfosrukYM9=o0EZP_DvSjgywfK8g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Jul 2011 12:09:59 +0200
Message-ID: <1311588599.2617.56.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-07-24 at 21:06 -0400, Arnaud Lacombe wrote:
> > Peter Zijlstra (1):
> >      lockdep: Fix lockdep_no_validate against IRQ states
> >
> from today's master, this last commit triggers:
> 
> /src/linux/linux/kernel/lockdep.c: In function 'mark_held_locks':
> /src/linux/linux/kernel/lockdep.c:2471:31: warning: comparison of
> distinct pointer types lacks a cast
> 
> I'm not sure if both struct member and variable's type are correct nor
> the comparability between `struct lockdep_subclass_key *' and `struct
> lock_class_key *'. So I'll let you fix this. 

Argh, I really need -Werror to even see warnings, compiler output just
flies by waaaaaay too fast.

The warning is harmless in this case, but the below makes it go away.

---
 kernel/lockdep.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 3956f51..99906aa 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -2468,7 +2468,7 @@ mark_held_locks(struct task_struct *curr, enum mark_type mark)
 
 		BUG_ON(usage_bit >= LOCK_USAGE_STATES);
 
-		if (hlock_class(hlock)->key == &__lockdep_no_validate__)
+		if (hlock_class(hlock)->key == __lockdep_no_validate__.subkeys)
 			continue;
 
 		if (!mark_lock(curr, hlock, usage_bit))


