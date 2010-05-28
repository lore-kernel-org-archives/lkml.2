Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757385Ab0E1OH3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 10:07:29 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58622 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754995Ab0E1OH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 10:07:28 -0400
Date: Fri, 28 May 2010 10:07:26 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Arve =?ISO-8859-14?B?SGr4bm5lduVn?= <arve@android.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>, <felipe.balbi@nokia.com>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
In-Reply-To: <20100528101755.7b5f6b8a@lxorguk.ukuu.org.uk>
Message-ID: <Pine.LNX.4.44L0.1005281006410.1939-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 May 2010, Alan Cox wrote:

> > Since I think we've now rejected the feature, do we have a clear picture about
> > what the Android people should do _instead_ and yet keep the battery life they
> > want?  Because I don't think telling "let them do what they want, who cares"
> > is right.
> 
> Today "idle" means "no task running"
> 
> If you are prepared to rephrase that as "no task that matters is running"
> what would need to answer ?
> 
> - How do we define who matters: QoS ?

Here are the deficiencies in the current PM-QOS implementation which 
would need to be solved for Android's purposes:

	The system includes parameters for latency and throughput.
	It does not include a parameter to describe whether timers
	are enabled.  The presumption is that timers are always
	enabled.

For example, the low-power state used by Android would be described as
one in which the CPU does not run and timers are disabled, with some
appropriate latencies and zero throughput.  On some platforms even some
interrupt sources are disabled (those not marked as wakeup-enabled).

	There's no way to indicate minimum system operating 
	requirements.

For example, we may know that work needs to be done without knowing 
specifically which processes are going to carry out that work.  In such 
cases we would like to require that the CPU continues to run at a 
certain minimum speed so long as _any_ threads are runnable, even if 
those threads don't have any QOS requirements of their own.

Similarly, the requirement that timers be enabled is a system-wide sort 
of thing, not necessarily applying to a particular thread (and in fact, 
not all timers are associated with a thread anyway).

	There's no way to boost the minimum system operating
	requirements upon the arrival of an event.

For example, when an input event enters the queue, it should be
possible to prevent the system from entering its lowest power state
until the event can be consumed by userspace.  Simply boosting the QOS
requirements of the threads waiting on the input queue isn't good
enough, because there may not be any such threads when the event occurs 
(they may be busy doing something else).

The matter of _which_ events should boost the system operating
requirements is debatable.  In the Android proposal it is a fixed set:
those events which enable a suspend blocker.  In theory it could
instead be determined by requests from userspace, although I don't know
how such requests would be expressed.


Until these weaknesses are rectified, Android cannot use the PM-QOS 
system or idle-time power management to satisfy its needs.  That's why 
they have to resort to forced suspends.

Can the PM-QOS framework be enhanced to include these considerations?  
I don't see why not (but on the other hand, I know nothing about its
internal workings).

Alan Stern

