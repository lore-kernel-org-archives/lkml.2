Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933152Ab1JDRyx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 13:54:53 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37062 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933050Ab1JDRyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 13:54:52 -0400
MIME-Version: 1.0
In-Reply-To: <20111004171437.GA3489@redhat.com>
References: <1317395577-14091-1-git-send-email-matt@console-pimps.org>
 <20110930165206.GA22048@redhat.com> <1317412823.3375.34.camel@mfleming-mobl1.ger.corp.intel.com>
 <20110930235625.GD2658@mtj.dyndns.org> <1317464192.3375.57.camel@mfleming-mobl1.ger.corp.intel.com>
 <1317474209.12973.15.camel@twins> <20111003130701.GB25952@redhat.com>
 <1317655320.20367.25.camel@twins> <20111004171437.GA3489@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 4 Oct 2011 10:54:31 -0700
X-Google-Sender-Auth: g6FFH7F8AkURTAoq7OR8IMY2iYU
Message-ID: <CA+55aFza+fvdC4UY+JAQ61zip3t3Zxm2zUPAzv3Oqux2L66cDQ@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/5] Signal scalability series
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Matt Fleming <matt@console-pimps.org>, Tejun Heo <htejun@gmail.com>,
        linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 4, 2011 at 10:14 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> Whatever we do with the locking, this can't remove O(nr_threads),
> although read_lock() could help to reduce the contention.

Read locks often make things worse.

Yes, they allow "more concurrency" and avoid contention, but when
we're talking spinning read-locks, almost every time we've used them
we've found them to be *worse* than spinlocks in actual practice.

Why? One reason is that they are just fundamentally more expensive - a
spinlock is just simpler. As a practical example, a spinlock can do
the unlock without the locked cycle.

The other reason seems to be that they often cause more cacheline
bouncing on both the lock itself and the data it protects. For a
spinlock, it's often appropriate to just be exclusive so that you
basically "concentrate" the accesses to one CPU.

It's different for the sleeping rw-semaphores of course. There,
read-locks have major advantages, and if you actually end up having
sleeping entities, read-locks can be a huge huge improvement over a
regular mutex, and the "more concurrency" is a big advantage.

But the spinning rwlock should generally be avoided. The only *real*
reason for using it is if you have timers/interrupts that can take
things for reading, and using an rwlock means that most users can then
avoid the irq save/restore. That pattern improvement more than makes
up for the fact that the rwlock itself is more expensive than the
spinlock.

Almost every time you want to use an rwlock and you think you have a
lot of readers, you should start looking at RCU instead. Because
*that* can be a huge improvement over spinlocks.

                      Linus
