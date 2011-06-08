Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623Ab1FHTfC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 15:35:02 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54974 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755661Ab1FHTet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 15:34:49 -0400
MIME-Version: 1.0
In-Reply-To: <20110608191758.GA12457@elte.hu>
References: <20110606155236.GA7374@elte.hu> <1307376039.2322.164.camel@twins>
 <20110606160810.GA16636@elte.hu> <1307376771.2322.168.camel@twins>
 <20110606161749.GA22157@elte.hu> <4DED0292.1040605@die-jansens.de>
 <4DED0423.4050904@die-jansens.de> <20110606170725.GD2391@elte.hu>
 <1307380311.2322.223.camel@twins> <1307548218.3941.6.camel@twins> <20110608191758.GA12457@elte.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 8 Jun 2011 12:27:19 -0700
Message-ID: <BANLkTim8LY0ekPQNZasUbinKcvS78y_umw@mail.gmail.com>
Subject: Re: [debug patch] printk: Add a printk killswitch to robustify NMI
 watchdog messages
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>, Arne Jansen <lists@die-jansens.de>,
        mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        efault@gmx.de, npiggin@kernel.dk, akpm@linux-foundation.org,
        frank.rowand@am.sony.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 8, 2011 at 12:17 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> Hm, the no-wakeup aspect seems rather useful.

I like the patch, but I would like to get it much better abstracted
out. Make some kind of

  void atomic_down();
  int atomic_down_trylock();
  void atomic_up();

interfaces that basically get the semaphore in an "atomic" mode that
leaves the semaphore spinlock locked in the locked region.

So they would basically be spinlocks that can then be mixed with
normal sleeping semaphore usage.

> Could we perhaps remove console_sem and replace it with a mutex and
> do something like this with a mutex and its ->wait_lock?

That would be horrible.

The reason it works well for semaphores is that the semaphores have no
architecture-specific fast-path any more, and everything is done
within the spinlock.

With a mutex? Not good. We have several different mutex
implementations, along with fastpaths that never touch the spinlock at
all etc. And that is very much on purpose, because the spinlock
approach is noticeably slower and needs more atomic accesses. In
contrast, the semaphores are "legacy interfaces" and aren't considered
high-performance locking any more.

                      Linus
