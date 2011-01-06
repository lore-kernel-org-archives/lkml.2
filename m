Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053Ab1AFSRX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 13:17:23 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33393 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751362Ab1AFSRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 13:17:22 -0500
MIME-Version: 1.0
In-Reply-To: <20110106090808.GA15170@elte.hu>
References: <20110106090808.GA15170@elte.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 6 Jan 2011 10:16:34 -0800
Message-ID: <AANLkTikocAcVEAHXi3g7z2s+4y3mh5m0bs17iJnUWPhz@mail.gmail.com>
Subject: Re: [GIT PULL] RCU changes for v2.6.38
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 6, 2011 at 1:08 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> Please pull the latest core-rcu-for-linus git tree from:

So I pulled, but I'm not convinced about the crazy busy-looping
SRCU_SYNCHRONIZE_DELAY thing.

Why does it do a silly udelay(), instead of just looping over the
srcu_readers_active_idx() for a few times? You're wasting CPU time
anyway, why ask the user how many usecs to waste?

IOW, why isn't that "wait for no active readers" a nice helper
function, and why doesn't it do

   for (i = 0; i < CONFIG_SRCU_SYNCHRONIZE_DELAY; i++) {
      if (!srcu_readers_active_idx(sp, idx))
         return;
      udelay(1);
   }
   while (srcu_readers_active_idx(sp, idx))
      schedule_timeout_interruptible(1);

instead? And is it really sane to ask the kernel configurator to come
up with a random value (ie that "CONFIG_SRCU_SYNCHRONIZE_DELAY" is
just stupid and wrong)?

Please fix this. And don't make people answer unanswerable questions.
If YOU and Paul don't know the answer, why the hell do you expect
somebody who does a "make config" to know the answer?

Either pick a number, or pick an algorithm that self-tunes.

Don't use the Kconfig system as a way to tell people that it's their
fault when you made a bad decision. Really.

                           Linus
