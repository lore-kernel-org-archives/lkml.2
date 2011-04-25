Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758777Ab1DYR51 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 13:57:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38206 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757722Ab1DYR50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 13:57:26 -0400
Date: Mon, 25 Apr 2011 19:56:05 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] signal: sys_rt_sigtimedwait: simplify the timeout
	logic
Message-ID: <20110425175605.GA22289@redhat.com>
References: <20110418134421.GA15951@redhat.com> <BANLkTimO2FL3548rxa9NEoVLFbZU7mzG7g@mail.gmail.com> <20110418173224.GA27918@redhat.com> <BANLkTikkYapz+qiJ0skx9ykz7TT9vmTVQw@mail.gmail.com> <20110423175901.GA484@redhat.com> <20110423175922.GB484@redhat.com> <20110425113746.GM17734@mtj.dyndns.org> <20110425172644.GA20689@redhat.com> <BANLkTinrC1+5CVgnBCxrt895TAnLCKjTRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTinrC1+5CVgnBCxrt895TAnLCKjTRg@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25, Linus Torvalds wrote:
>
> On Mon, Apr 25, 2011 at 10:26 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > If only I knew what this comment could say except
> >
> >        /* Why do we add (tv_sec || tv_nsec) ?  */
> >
> > I'd better send 4/3 which simply removes this (I hope) unneeded code.
>
> It's to guarantee that timeout is at least one tick more than asked
> for, because the rule is that you really have to wait for AT LEAST the
> time asked for.

Aah, thanks. This makes sense. I'll add the comment.

> So "+ (tv_sec || tv_nsec)" is just the "+1" for the "not zero timeout" case.

So, we have

	timeout = timespec_to_jiffies(ts) + (tv_sec || tv_nsec);
	...

	if (timeout)
		timeout = schedule_timeout_interruptible(timeout);

Perhaps it makes sense to turn this code into

	timeout = timespec_to_jiffies(ts);

	if (timeout)
		// make sure we sleep at least the time we asked for
		timeout = schedule_timeout_interruptible(timeout + 1);

Assuming that timespec_to_jiffies() always returns nonzero if ts is
"not zero timeout". I think it does.

Oleg.

