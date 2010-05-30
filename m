Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361Ab0E3Apz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 20:45:55 -0400
Received: from netrider.rowland.org ([192.131.102.5]:54828 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757016Ab0E3Apy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 20:45:54 -0400
Date: Sat, 29 May 2010 20:45:53 -0400 (EDT)
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
In-Reply-To: <AANLkTik_4ezDAQoAQjkpEgwD9SLKeOjDzy2H7T2v6uCP@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1005292026080.6300-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 May 2010, Arve Hjønnevåg wrote:

> > In place of in-kernel suspend blockers, there will be a new type of QoS
> > constraint -- call it QOS_EVENTUALLY.  It's a very weak constraint,
> > compatible with all cpuidle modes in which runnable threads are allowed
> > to run (which is all of them), but not compatible with suspend.
> >
> This sound just like another API rename. It will work, but given that
> suspend blockers was the name least objectionable last time around,
> I'm not sure what this would solve.

It's not just a rename.  By changing this into a QoS constraint, we 
make it more generally useful.  Instead of standing on its own, it 
becomes part of the PM-QOS framework.

> > There is no /sys/power/policy file.  In place of opportunistic suspend,
> > we have "QoS-based suspend".  This is initiated by userspace writing
> > "qos" to /sys/power/state, and it is very much like suspend-to-RAM.
> 
> Why do you want to tie it to a specific state?

I don't.  I suggested making it a veriant of suspend-to-RAM merely
because that's what you were using.  But Nigel's suggestion of having
"qos" variants of all the different suspend states makes sense.

> > However a QoS-based suspend fails immediately if there are any active
> 
> Fail or block? Your next paragraph said that it blocks for
> QOS_EVENTUALLY, but if normal constraints fail, you are still stuck in
> a retry loop.

Normal (i.e., non QOS_EVENTUALLY) constraints aren't part of the
Android use case, so it wasn't clear how they should be treated.  On
further thought, it probably makes more sense to block for them too
instead of failing immediately.

> > normal QoS constraints incompatible with system suspend, in other
> > words, any constraints requiring a throughput > 0 or an interrupt
> > latency shorter than the time required for a suspend-to-RAM/resume
> > cycle.
> >
> > If no such constraints are active, the QoS-based suspend blocks in an
> > interruptible wait until the number of active QOS_EVENTUALLY
> 
> How do you implement this?

I'm not sure what you mean.  The same way you implement any 
interruptible wait.

> >        for (;;) {
> >                while (any IPC requests remain)
> >                        handle them;
> >                if (any processes need to prevent suspend)
> >                        sleep;
> >                else
> >                        write "qos" to /sys/power/state;
> >        }
> >
> > The idea is that receipt of a new IPC request will cause a signal to be
> > sent, interrupting the sleep or the "qos" write.
> 
> What happen if the signal is right before (or even right after)
> calling write "qos". How does the signal handler stop the write?

You're right, this is a serious problem.  The process would have to
give the kernel a signal mask to be used during the wait, as in ppoll
or pselect.  There ought to be a way to do this or something
equivalent.

Alan Stern

