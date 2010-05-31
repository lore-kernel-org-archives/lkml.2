Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab0EaF4p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 01:56:45 -0400
Received: from cantor.suse.de ([195.135.220.2]:59734 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752778Ab0EaF4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 01:56:44 -0400
Date: Mon, 31 May 2010 15:56:25 +1000
From: Neil Brown <neilb@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Arve =?UTF-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
       Alan Stern <stern@rowland.harvard.edu>
Cc: markgross@thegnar.org, Matthew Garrett <mjg59@srcf.ucam.org>,
       Greg KH <gregkh@suse.de>, linux-doc@vger.kernel.org,
       Peter Zijlstra <peterz@infradead.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andi Kleen <ak@linux.intel.com>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Len Brown <len.brown@intel.com>,
       James Bottomley <James.Bottomley@suse.de>, tytso@mit.edu,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [linux-pm] [PATCH 1/8] PM: Opportunistic suspend support.
Message-ID: <20100531155625.65fd094d@notabene.brown>
In-Reply-To: <20100531090329.786fce79@notabene.brown>
References: <Pine.LNX.4.44L0.1005251647530.1634-100000@iolanthe.rowland.org>
	<AANLkTimVhC3X68uN3krrkkAAAK4a4D5yTK1V8i_x_Vfy@mail.gmail.com>
	<20100530180846.408e50be@notabene.brown>
	<201005302152.14166.rjw@sisk.pl>
	<20100531090329.786fce79@notabene.brown>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 May 2010 09:03:29 +1000
Neil Brown <neilb@suse.de> wrote:

> > Well, please have a look at the Alan Stern's proposal here:
> > http://lkml.org/lkml/2010/5/29/77
> >
> 
> Thanks for the reference.
> Some of the details are different, but the idea seems almost exactly the same
> as mine.
> The apparent dependence on signals makes me feel a little uncomfortable
> (interfaces that depend on using signals seem to be easy to use wrongly), but
> I don't think that is a serious flaw.
> 
> Maybe the biggest difference is philosophical.  Alan's proposal appears to be
> adding a new feature.  Mine presents as trying to fix an existing feature so
> that it can be used reliably.
> It is easier to argue against a feature than against a bug-fix (??).

Addendum...

The use of signals by Alan here got me thinking.. and combining it which what 
Alan Cox and Thomas Gleixner (and others?) have been saying about detecting
idleness led me down an interesting path that I thought I would share.

An absolutely minimal change to allow a user-space initiated auto-suspend to
be race-free would be achieved by placing an interruptible wait between
       pm_notifier_call_chain(PM_SUSPEND_PREPARE);
and 
       suspend_freeze_processes();

which waits for all kernel threads to have passed through an 'idle' state.

Then any wake event that happened after the PM_SUSPEND_PREPARE would
presumably either abort the suspend later, or would cause an immediate
wake-up.
Any event that happened before the PM_SUSPEND_PREPARE would have been fully
processed by any kernel thread and so would be queued for user-space (or have
been discarded).

If we then require any process that handles wakeup events to use the
equivalent of fcntl(F_SETOWN) to direct a SIGIO (or other signal) at the
process which requests the suspend, then wakeup events won't be lost.
They will either send a signal to the suspend-daemon in time to abort the
suspend, or will be late enough to either abort the suspend in-kernel, or
trigger an immediate wakeup.

Yes: this would require quite a large change of the android code, and the
F_SETOWN usage is fairly ugly, but balanced against it actually working and
it being minimal, that might be OK.

The hardest part would be waiting for all kernel-threads to pass through idle
(or all threads to pass through idle or user-space).  We'd need help to make
that work, but at least it would be a fairly localised change.

Maybe it is something to keep in mind when other possibilities have proven
intractable.

NeilBrown
