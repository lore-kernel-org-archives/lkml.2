Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157Ab1DRRdU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 13:33:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54201 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756130Ab1DRRdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 13:33:11 -0400
Date: Mon, 18 Apr 2011 19:32:24 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 0/7] signal: sigprocmask fixes
Message-ID: <20110418173224.GA27918@redhat.com>
References: <20110418134421.GA15951@redhat.com> <BANLkTimO2FL3548rxa9NEoVLFbZU7mzG7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimO2FL3548rxa9NEoVLFbZU7mzG7g@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18, Linus Torvalds wrote:
>
> On Mon, Apr 18, 2011 at 6:44 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > Once again: if we need this, then we need a lot more (trivial) changes
> > like 6/7 and 7/7. Basically every change of ->blocked should be converted
> > to use set_current_blocked(). OTOH, perhaps this makes sense by itself.
>
> Hmm. The more I think about this, the less I like it.
>
> What if the pending thread signal was thread-specific to begin with?

These patches should not change the current behaviour in this case.
We never try to re-target the thread-specific signals. Note that
retarget_shared_pending() checks ->signal->shared_pending only.

> For example, if we have a SIGFPE and a SIGKILL that happen at the same
> time, a dying task may have a SIGFPE pending when it dies, and that
> SIGFPE should _not_ be just distributed out to the other threads in
> the thread group.

Yes, and it won't be.

Btw, we do not need to distribute SIGKILL too, we can change
retarget_shared_pending() to remove SIGKILL from shared_pending.
But this only matters when the caller is exit_signals(), and in
this case it should likely notice signal_group_exit() unless
SIGKILL (in unlikely case) it comes in between.

Or I misunderstood?

Oleg.

