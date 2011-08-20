Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861Ab1HTIgw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 04:36:52 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:58907 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751685Ab1HTIgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 04:36:47 -0400
Subject: Re: [PATCH v2 07/43] blackfin: Use set_current_blocked() and
 block_sigmask()
From: Matt Fleming <matt@console-pimps.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <CAMjpGUcwkLkHo33WY1vJr4pWPz9wgVcwti5nuqLM2FQYWn6O=A@mail.gmail.com>
References: <1313772419-21951-1-git-send-email-matt@console-pimps.org>
	 <1313772419-21951-8-git-send-email-matt@console-pimps.org>
	 <CAMjpGUcwkLkHo33WY1vJr4pWPz9wgVcwti5nuqLM2FQYWn6O=A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 20 Aug 2011 09:36:43 +0100
Message-ID: <1313829403.19751.14.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-08-20 at 00:00 -0400, Mike Frysinger wrote:
> On Fri, Aug 19, 2011 at 12:46, Matt Fleming wrote:
> > --- a/arch/blackfin/kernel/signal.c
> > +++ b/arch/blackfin/kernel/signal.c
> > -       if (ret == 0) {
> > -               spin_lock_irq(&current->sighand->siglock);
> > -               sigorsets(&current->blocked, &current->blocked,
> > -                         &ka->sa.sa_mask);
> > -               if (!(ka->sa.sa_flags & SA_NODEFER))
> > -                       sigaddset(&current->blocked, sig);
> > -               recalc_sigpending();
> > -               spin_unlock_irq(&current->sighand->siglock);
> > -       }
> > +       if (ret == 0)
> > +               block_sigmask(ka, sig);
> 
> the Blackfin version holds siglock and calls recalc_sigpending() while
> block_sigmask() does neither.  i'm guessing that is expected behavior
> now ?

Yah, set_current_blocked() inside of block_sigmask() still grabs siglock
and calls recalc_sigpending() for you. Reading current->blocked inside
of block_sigmask() is fine and the sigorsets() is OK because we're
modifying a stack variable, so only grabbing the lock inside of
set_current_blocked() is safe.

-- 
Matt Fleming, Intel Open Source Technology Center

