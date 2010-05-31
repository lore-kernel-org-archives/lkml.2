Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243Ab0EaPNq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 11:13:46 -0400
Received: from netrider.rowland.org ([192.131.102.5]:34045 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755477Ab0EaPNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 11:13:45 -0400
Date: Mon, 31 May 2010 11:13:43 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
cc: Florian Mickler <florian@mickler.org>,
       Peter Zijlstra <peterz@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Brian Swetland <swetland@google.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
In-Reply-To: <AANLkTikxws5kmFhnBO1MLzE65ETka3Jy0R5ayAKTS1Lc@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1005311053270.853-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 May 2010, Arve Hjønnevåg wrote:

> >> This sound just like another API rename. It will work, but given that
> >> suspend blockers was the name least objectionable last time around,
> >> I'm not sure what this would solve.
> >
> > It's not just a rename.  By changing this into a QoS constraint, we
> > make it more generally useful.  Instead of standing on its own, it
> > becomes part of the PM-QOS framework.
> >
> 
> We cannot use the existing pm-qos framework. It is not safe to call
> from atomic context. Also, it does not have any state constraints, so
> it iterates over every registered constraint each time one of them
> changes. Nor does is currently provide any stats for debugging.
> 
> The original wakelock patchset supported a wakelock type so it could
> be used to block more then suspend, but I had to remove this because
> it "overlapped" with pm-qos. So, yes I do consider this just another
> rename.

You're missing the point.  The fact that wakelocks "overlapped" with 
pm-qos is _good_.  It means that you can implement what you need within 
the pm-qos framework, if you expand the framework's capabilities (add 
the ability to do things in atomic context, add the ability to collect 
stats for debugging, etc.).

Maybe this would require redesigning a large part of pm-qos.  I'm not
very familiar with it, so I don't know what would be involved.  Still,
it seems like a reasonable approach, given what you need to accomplish.

> >> > If no such constraints are active, the QoS-based suspend blocks in an
> >> > interruptible wait until the number of active QOS_EVENTUALLY
> >>
> >> How do you implement this?
> >
> > I'm not sure what you mean.  The same way you implement any
> > interruptible wait.
> >
> 
> I mean what should it wait on so that it gets interrupted by a
> userspace ipc call. I guess you want to send a signal in addition to
> the ipc.

If the IPC is carried out over a Unix socket, you can get SIGIO 
signals for free.  But yes, if necessary the client could send a signal 
along with its request.

> I still don't know why you want to do it this way though. It
> seems much simpler to just return immedeately and allow the same
> thread to cancel the request with another write.

I suggested doing it this way because it is as close as possible to the 
existing API.  A two-step submit/cancel approach would be a larger 
change -- but it certainly would work.  I have no objection to it.

The main idea behind this part of the proposal was to get rid of the
new userspace-suspend-blocker API (along with /sys/power/policy, which
Pavel objects to).  Equivalent functionality can be achieved by making
only small changes to the existing /sys/power/state interface (and
perhaps somewhat larger changes to the userspace daemon); the exact 
details of the changes aren't critical.

Alan Stern


