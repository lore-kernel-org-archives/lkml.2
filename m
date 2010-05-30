Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855Ab0E3Pnv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 11:43:51 -0400
Received: from netrider.rowland.org ([192.131.102.5]:55642 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752749Ab0E3Pnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 11:43:50 -0400
Date: Sun, 30 May 2010 11:43:50 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
cc: Peter Zijlstra <peterz@infradead.org>,
       Brian Swetland <swetland@google.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
In-Reply-To: <Pine.LNX.4.44L0.1005292026080.6300-100000@netrider.rowland.org>
Message-ID: <Pine.LNX.4.44L0.1005301134530.19555-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 May 2010, Alan Stern wrote:

> On Sat, 29 May 2010, Arve Hjønnevåg wrote:

> > >        for (;;) {
> > >                while (any IPC requests remain)
> > >                        handle them;
> > >                if (any processes need to prevent suspend)
> > >                        sleep;
> > >                else
> > >                        write "qos" to /sys/power/state;
> > >        }
> > >
> > > The idea is that receipt of a new IPC request will cause a signal to be
> > > sent, interrupting the sleep or the "qos" write.
> > 
> > What happen if the signal is right before (or even right after)
> > calling write "qos". How does the signal handler stop the write?
> 
> You're right, this is a serious problem.  The process would have to
> give the kernel a signal mask to be used during the wait, as in ppoll
> or pselect.  There ought to be a way to do this or something
> equivalent.

Okay, here's a possible solution:

	char arg[20];

	signal_handler()
	{
		arg[0] = 0;
	}


	In the main loop:

	...
	mask signals;
	if (we decide to start a QoS-based suspend) {
		strcpy(arg, "qos");
		unmask signals;
		write arg to /sys/power/state;
	}

It's hacky but I think it will work.

A more straightforward approach is to give processes the ability to 
register their own QoS constraints.  This could be done via a custom 
driver as Brian suggested or by adding a new system call as Alan Cox 
suggested.  Then the power manager could be split into two threads, one 
of which handles IPC requests and manages QoS constraints, while the 
other repeatedly attempts to initiate QoS-based suspends.

Alan Stern

