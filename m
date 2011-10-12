Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316Ab1JLHJo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 03:09:44 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34507 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab1JLHJn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 03:09:43 -0400
Subject: Re: [PATCH 2/3] ipc/sem.c: handle spurious wakeups
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Manfred Spraul <manfred@colorfullife.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>
Date: Wed, 12 Oct 2011 09:09:35 +0200
In-Reply-To: <20111011145441.228e4c94.akpm@linux-foundation.org>
References: <1316885831-11996-1-git-send-email-manfred@colorfullife.com>
	 <20111011145441.228e4c94.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1318403375.3968.4.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-11 at 14:54 -0700, Andrew Morton wrote:
> On Sat, 24 Sep 2011 19:37:11 +0200
> Manfred Spraul <manfred@colorfullife.com> wrote:
> 
> > semtimedop() does not handle spurious wakeups, it returns -EINTR to user space.
> > Most other schedule() users would just loop and not return to user space.
> > The patch adds such a loop to semtimedop()
> 
> What is a "spurious wakeup" and how can a process receive one?

Its a wakeup unrelated to the condition its waiting for. They shouldn't
happen (often) but all wait loops should deal with them. Sadly of course
most out of core wait loops don't :-(

> I'm wondering about the userspace-visible effects of this change, and
> any compatibility issues?

For this particular case it would be returning to userspace with -EINTR
without a signal having been raised what so ever. Not a big deal as
userspace it supposed to be able to deal with -EINTR and retry.

Also, these spurious wakeups hardly ever happen in the current kernel, I
only noticed it because I made them slightly more likely with a patch
currently on the back-burner until I figure out a sane way to audit all
1400+ schedule() and co. callsites.
