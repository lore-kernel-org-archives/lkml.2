Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab0EVNh2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 09:37:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:44295 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774Ab0EVNhZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 09:37:25 -0400
Subject: Re: [PATCH] Introduce a config option that introduces a bias in
 favour of writers in rwlocks
From: Peter Zijlstra <peterz@infradead.org>
To: Salman <sqazi@google.com>
Cc: akpm@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20100522023744.16767.81170.stgit@bumblebee1.mtv.corp.google.com>
References: <20100522023744.16767.81170.stgit@bumblebee1.mtv.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 22 May 2010 15:36:57 +0200
Message-ID: <1274535417.5605.23306.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-21 at 19:38 -0700, Salman wrote:
> If one or more readers are holding the lock, and one or more writers
> are contending for it, then do not admit any new readers.  However,
> if a writer is holding a lock, then let readers contend for it at
> equal footing with the writers.
> 
> This fixes a pathological case (see the code below), where the
> tasklist_lock is continuously held by the readers, and the writers starve.
> 
> The change does not introduce any unexpected test failures in the locking
> self-test.  Furthermore, it makes the original problem go away.  In
> particular, after the change, the following code can run without
> causing a lockup: 

So how does this work with recursion?

rwlock_t is assumed recursive and quite a lot of code relies on that.

CPU0			CPU1

read_lock(&A)
			write_lock_irq(&A)

<IRQ>
  read_lock(&A) <-- deadlock because there's a pending writer


Also, I really think having config options for lock behaviour is utter
suckage, either a new implementation is better or its not.

If you want your waitpid() case to work better, try converting its
tasklist_lock usage to RCU, or try and break the lock into smaller
locks.

NAK on both your patch and your approach, rwlock_t should be killed off,
not 'improved'.

