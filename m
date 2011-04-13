Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932975Ab1DMVFu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 17:05:50 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:32911 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932879Ab1DMVFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 17:05:49 -0400
Date: Wed, 13 Apr 2011 23:05:46 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Mike Frysinger <vapier@gentoo.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org,
        linux-pm@lists.linux-foundation.org
Subject: Re: freezer: should barriers be smp ?
Message-ID: <20110413210546.GC16830@elf.ucw.cz>
References: <BANLkTi=F-C-vwX4PGGfbkdTBw3OWL-twfg@mail.gmail.com>
 <201104132258.17705.rjw@sisk.pl>
 <BANLkTiknfeTj6GD0t-ekMoaS1QYQBVyBjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTiknfeTj6GD0t-ekMoaS1QYQBVyBjQ@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2011-04-13 17:02:45, Mike Frysinger wrote:
> On Wed, Apr 13, 2011 at 16:58, Rafael J. Wysocki wrote:
> > On Wednesday, April 13, 2011, Mike Frysinger wrote:
> >> when we suspend/resume Blackfin SMP systems, we notice that the
> >> freezer code runs on multiple cores.  this is of course what you want
> >> -- freeze processes in parallel.  however, the code only uses non-smp
> >> based barriers which causes us problems ... our cores need software
> >> support to keep caches in sync, so our smp barriers do just that.  but
> >> the non-smp barriers do not, and so the frozen/thawed processes
> >> randomly get stuck in the wrong task state.
> >>
> >> thinking about it, shouldnt the freezer code be using smp barriers ?
> >
> > Yes, it should, but rmb() and wmb() are supposed to be SMP barriers.
> >
> > Or do you mean something different?
> 
> then what's the diff between smp_rmb() and rmb() ?
> 
> this is what i'm proposing:
> --- a/kernel/freezer.c
> +++ b/kernel/freezer.c
> @@ -17,7 +17,7 @@ static inline void frozen_process(void)
>  {
>     if (!unlikely(current->flags & PF_NOFREEZE)) {
>         current->flags |= PF_FROZEN;
> -       wmb();
> +       smp_wmb();
>     }
>     clear_freeze_flag(current);
>  }
> @@ -93,7 +93,7 @@ bool freeze_task(struct task_struct *p, bool sig_only)
>      * the task as frozen and next clears its TIF_FREEZE.
>      */
>     if (!freezing(p)) {
> -       rmb();
> +       smp_rmb();
>         if (frozen(p))
>             return false;

smp_rmb() is NOP on uniprocessor.

I believe the code is correct as is.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
