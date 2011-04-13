Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933255Ab1DMWEe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 18:04:34 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:53235 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932094Ab1DMWEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 18:04:33 -0400
Date: Wed, 13 Apr 2011 18:04:30 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Mike Frysinger <vapier@gentoo.org>
cc: Pavel Machek <pavel@ucw.cz>, <uclinux-dist-devel@blackfin.uclinux.org>,
        <linux-pm@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] [uclinux-dist-devel] freezer: should barriers be smp
 ?
In-Reply-To: <BANLkTinj3y+-VhzFAPz8Gzb5vAbtUFU6Aw@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1104131757430.2005-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Apr 2011, Mike Frysinger wrote:

> On Wed, Apr 13, 2011 at 17:05, Pavel Machek wrote:
> > On Wed 2011-04-13 17:02:45, Mike Frysinger wrote:
> 
> >> then what's the diff between smp_rmb() and rmb() ?
> >>
> >> this is what i'm proposing:
> >> --- a/kernel/freezer.c
> >> +++ b/kernel/freezer.c
> >> @@ -17,7 +17,7 @@ static inline void frozen_process(void)
> >>  {
> >>     if (!unlikely(current->flags & PF_NOFREEZE)) {
> >>         current->flags |= PF_FROZEN;
> >> -       wmb();
> >> +       smp_wmb();
> >>     }
> >>     clear_freeze_flag(current);
> >>  }
> >> @@ -93,7 +93,7 @@ bool freeze_task(struct task_struct *p, bool sig_only)
> >>      * the task as frozen and next clears its TIF_FREEZE.
> >>      */
> >>     if (!freezing(p)) {
> >> -       rmb();
> >> +       smp_rmb();
> >>         if (frozen(p))
> >>             return false;
> >
> > smp_rmb() is NOP on uniprocessor.
> >
> > I believe the code is correct as is.
> 
> that isnt what the code / documentation says.  unless i'm reading them
> wrong, both seem to indicate that the proposed patch is what we
> actually want.

The existing code is correct but it isn't optimal.

wmb() and rmb() are heavy-duty operations, and you don't want to call
them when they aren't needed.  That's exactly what smp_wmb() and
smp_rmb() are for -- they call wmb() and rmb(), but only in SMP 
kernels.

Unless you need to synchronize with another processor (not necessarily 
a CPU, it could be something embedded within a device), you should 
always use smp_wmb() and smp_rmb() rather than wmb() and rmb().

Alan Stern

