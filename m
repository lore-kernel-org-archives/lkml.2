Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758710Ab1DYRfY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 13:35:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60591 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758666Ab1DYRfX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 13:35:23 -0400
MIME-Version: 1.0
In-Reply-To: <20110425172644.GA20689@redhat.com>
References: <20110418134421.GA15951@redhat.com> <BANLkTimO2FL3548rxa9NEoVLFbZU7mzG7g@mail.gmail.com>
 <20110418173224.GA27918@redhat.com> <BANLkTikkYapz+qiJ0skx9ykz7TT9vmTVQw@mail.gmail.com>
 <20110423175901.GA484@redhat.com> <20110423175922.GB484@redhat.com>
 <20110425113746.GM17734@mtj.dyndns.org> <20110425172644.GA20689@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 25 Apr 2011 10:34:30 -0700
Message-ID: <BANLkTinrC1+5CVgnBCxrt895TAnLCKjTRg@mail.gmail.com>
Subject: Re: [PATCH 1/3] signal: sys_rt_sigtimedwait: simplify the timeout logic
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 25, 2011 at 10:26 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> If only I knew what this comment could say except
>
>        /* Why do we add (tv_sec || tv_nsec) ?  */
>
> I'd better send 4/3 which simply removes this (I hope) unneeded code.

It's to guarantee that timeout is at least one tick more than asked
for, because the rule is that you really have to wait for AT LEAST the
time asked for. With the "zero timeout" being special, since that is
"immediate".

Imagine that you ask for one timer tick - but that you're in the
_middle_ of the current one. Waiting for the next timer is going to be
too short - you'll only get half a timer tick. So we need to ask for
"ceiling(nanoseconds / nanosecondspertick) + 1" to make sure that we
really wait _longer_ than asked for.

So "+ (tv_sec || tv_nsec)" is just the "+1" for the "not zero timeout" case.

                     Linus
