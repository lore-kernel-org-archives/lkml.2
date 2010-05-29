Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511Ab0E2PD0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 11:03:26 -0400
Received: from netrider.rowland.org ([192.131.102.5]:56148 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757442Ab0E2PDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 11:03:24 -0400
Date: Sat, 29 May 2010 11:03:24 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Brian Swetland <swetland@google.com>
cc: Florian Mickler <florian@mickler.org>,
       Peter Zijlstra <peterz@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
In-Reply-To: <AANLkTimyLsldXoZ_egjybwS9kE_OcxsOuZwC0F-C2HjY@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1005291056490.31946-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 May 2010, Brian Swetland wrote:

> On Sat, May 29, 2010 at 7:10 AM, Alan Stern <stern@rowland.harvard.edu> wrote:

> > If no such constraints are active, the QoS-based suspend blocks in an
> > interruptible wait until the number of active QOS_EVENTUALLY
> > constraints drops to 0.  When that happens, it carries out a normal
> > suspend-to-RAM -- except that it checks along the way to make sure that
> > no new QoS constraints are activated while the suspend is in progress.
> > If they are, the PM core backs out and fails the QoS-based suspend.
> >
> > Userspace suspend blockers don't exist at all, as far as the kernel is
> > concerned.  In their place, the Android runs a power-manager program
> > that receives IPC requests from other processes when they need to
> > prevent the system from suspending or allow it to suspend.  The power
> > manager's main loop looks like this:
> >
> >        for (;;) {
> >                while (any IPC requests remain)
> >                        handle them;
> >                if (any processes need to prevent suspend)
> >                        sleep;
> >                else
> >                        write "qos" to /sys/power/state;
> >        }
> 
> The issue with this approach is that if userspace wants to suspend
> while a driver is holding a QOS_EVENTUALLY constraint, it's basically
> going to spin constantly writing "qos" and failing.

No, no.  If userspace wants to suspend while a driver is holding a 
QOS_EVENTUALLY constraint, the user process blocks in an interruptible 
wait state as described in the first paragraph above.

> Could we have write(powerstate_fd, "qos",3) block until all
> QOS_EVENTUALLY constraints are lifted or the system successfully
> suspends and resumes or a signal arrives?

That is basically what I originally wrote.

> > The idea is that receipt of a new IPC request will cause a signal to be
> > sent, interrupting the sleep or the "qos" write.
> 
> Alternatively (to ipc), we could have a driver provide the same
> suspendblock style interface to userspace and maps it to qos
> constraints.  If it's something we maintain out-of-tree, no worries.
> The kernel side api is the bit that's the headache to maintain
> multiple versions of drivers with and without, after all.

Yep.  The idea is that all this userspace-oriented part should be
invisible to the vanilla kernel.

> I'm sure Arve will weigh in on this later, but from what I can see it
> certainly seems like this model provides us with the functionality
> we're looking for, provided the issue with
> spinning-while-waiting-for-drivers-to-release-constraints is sorted
> out.

I'm more concerned about how the other kernel developers will react.

Alan Stern

