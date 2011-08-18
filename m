Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333Ab1HRRIj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 13:08:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44594 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752115Ab1HRRIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 13:08:38 -0400
Date: Thu, 18 Aug 2011 19:05:38 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Petr Vandrovec <petr@vandrovec.name>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Matt Fleming <matt@console-pimps.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 40/41] ncpfs: Use set_current_blocked()
Message-ID: <20110818170538.GA6910@redhat.com>
References: <1313071035-12047-1-git-send-email-matt@console-pimps.org> <1313071035-12047-41-git-send-email-matt@console-pimps.org> <20110816175643.GI29190@redhat.com> <1313528170.3436.200.camel@mfleming-mobl1.ger.corp.intel.com> <20110817120405.GA10709@redhat.com> <1313589483.2311.24.camel@mfleming-mobl1.ger.corp.intel.com> <20110817144139.GA17271@redhat.com> <CA+i2_De=mKMHj++b5=ZPdXxp7pm2KzY+PzCaG++GWSud20a_qQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+i2_De=mKMHj++b5=ZPdXxp7pm2KzY+PzCaG++GWSud20a_qQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17, Petr Vandrovec wrote:
>
> I do not care about 'intr' support, but regular code path blocking all
> signals has to stay.

I do not care about SIGINT/SIGQUIT check, just I simply can't understand
the logic.

But PF_EXITING/SIGKILL code looks absolutely strange.

> PF_EXITING code is there because in the past something was BUG_ON-ing that
> nobody should touch signals while exiting,

Not sure I understand... do you mean we have a kernel bug? it should be
fixed then.

> and same code made sure you
> cannot send signals to exiting process.

Again, can't understand.

A PF_EXITING doesn't need to block the signals at all. See wants_siganl().

But, otoh, even sigblock(SIGKILL) can't protect from SIGKILL or another
fatal signal if this thread has a live subthread.

However, blocking SIGKILL makes the difference if it exits with the pending
SIGKILL. In this case recalc_sigpending() clears TIF_SIGPENDING, this "helps"
to actually sleep in TASK_INTERRUPTIBLE.

At the same time, ncp_do_request() can unblock, say, SIGINT. And this
means that if this task exits because it was killed by SIGINT it won't
block anyway.

And I can't understand why it if fine to kill the live task, but not fine
to interrupt the exiting task. If this was intended. And if you want to
block all signals, why can't you do wait_event_uninterruptible() instead?
Or interruptible/uninterruptible depending on PF_EXITING.


Now suppose it is not PF_EXITING. In this case it is pointless to block
any fatal signal unless this task is single-threaded.


So far I think this code does not understand what it does ;)


OK. I guess nobody cares. Matt, could you redo your original patch?
just remove ->siglock and convert it to use set_current_blocked()
leaving this logic alone.

Oleg.

