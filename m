Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758456Ab1CaPqn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 11:46:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53658 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758253Ab1CaPqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 11:46:42 -0400
MIME-Version: 1.0
In-Reply-To: <20110331150935.GC10163@redhat.com>
References: <20110329040939.GA32764@redhat.com> <AANLkTi=PHtUpb5oJ8_r1K1dvaUunhxv1MS3LLPM8V4Ci@mail.gmail.com>
 <20110331030917.GB26057@redhat.com> <AANLkTikYAAYcYxTdKAxQjDxVQ7qrZGEfXg+gpfwcj1=-@mail.gmail.com>
 <20110331035511.GA1255@redhat.com> <AANLkTikP5edK=YSRx7zuNqyfwez8qEHpFumYun6GOPxu@mail.gmail.com>
 <20110331145850.GA10163@redhat.com> <20110331150344.GB10163@redhat.com> <20110331150935.GC10163@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 31 Mar 2011 08:45:51 -0700
Message-ID: <AANLkTikvXSZ2NSA7Ar+bTA1H+S3HBs9e5NNb71RPTs32@mail.gmail.com>
Subject: Re: excessive kworker activity when idle. (was Re: vma corruption in
 today's -git)
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 8:09 AM, Dave Jones <davej@redhat.com> wrote:
>
> I thought that trace looked familiar.
>
> http://lkml.org/lkml/2010/11/30/592
>
> It's the same thing.

Ok, that's before the "tty: stop using "delayed_work" in the tty
layer" commit I just pointed to.

So apparently you've been able to trigger this even with the old code
too - although maybe the lack of delays anywhere has made it easier,
and has made it use more cpu.

I'll have to think about it, but I wonder if it's the crazy "reflush"
case in flush_to_ldisc. We do

                        if (!tty->receive_room || seen_tail) {
                                schedule_work(&tty->buf.work);
                                break;
                        }

inside the routine that is the work itself - basically we're saying
that "if there's no more room to flip, of we've seen a new buffer,
give up now and reschedule outselves".

Which doesn't really make much sense to me, I have to admit. The code
that actually empties the buffer, or the code that adds one, should
already have scheduled us for a flip _anyway_. So the only thing that
"schedule_work()" is doing is causing infinite work if nothing empties
the buffer, of more likely if we have a flushing bug elsewhere.

So I'm not sure, but my gut feel is that removing that
"schedule_work()" line there is the right thing to do.

At a guess, it was hiding some locking problem - and it's been carried
around even though hopefully we've fixed all the crazy races we used
to have (and it was a mindless "hey, we can retry in one jiffy - it
doesn't really cost us anything")

NOTE! Even if I'm right, and that line is just buggy, the bug may well
have been hiding some other issue - ie just some using not flushing
the tty when it made more room available. So I think the "make tty
flush cause a re-flush when it cannot make progress" is wrong, but
removing the line may well expose some other problem.

                             Linus
