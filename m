Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757010Ab0HCPla (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 11:41:30 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:52618 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755546Ab0HCPl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 11:41:28 -0400
Date: Tue, 3 Aug 2010 08:41:12 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        mjg59@srcf.ucam.org, pavel@ucw.cz, florian@mickler.org, rjw@sisk.pl,
        stern@rowland.harvard.edu, swetland@google.com, peterz@infradead.org,
        tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
Message-ID: <20100803154112.GE2407@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100731175841.GA9367@linux.vnet.ibm.com>
 <AANLkTi=hoGF7egpyB9sLKJoXv5aiGrxfa9_5iH-96SA=@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=hoGF7egpyB9sLKJoXv5aiGrxfa9_5iH-96SA=@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 02, 2010 at 09:18:27PM -0700, Arve Hjønnevåg wrote:
> On Sat, Jul 31, 2010 at 10:58 AM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> ...

First, thank you very much for your review and feedback!

> > REQUIREMENTS
> >
> > o       Reduce the system's power consumption in order to (1) extend
> >        battery life and (2) preserve state until AC power can be obtained.
> >
> > o       It is necessary to be able to use power-naive applications.
> >        Many of these applications were designed for use in PC platforms
> >        where power consumption has historically not been of great
> >        concern, due to either (1) the availability of AC power or (2)
> >        relatively undemanding laptop battery-lifetime expectations.  The
> >        system must be capable of running these power-naive applications
> >        without requiring that these applications be modified, and must
> >        be capable of reasonable power efficiency even when power-naive
> >        applications are available.
> >
> > o       If the display is powered off, there is no need to run any
> >        application whose only effect is to update the display.
> >
> >        Although one could simply block such an application when it next
> >        tries to access the display, it appears that it is highly
> >        desirable that the application also be prevented from
> >        consuming power computing anything that will not be displayed.
> >        Furthermore, whatever mechanism is used must operate on
> >        power-naive applications that do not use blocking system calls.
> >
> > o       In order to avoid overrunning hardware and/or kernel buffers,
> >        input events must be delivered to the corresponding application
> >        in a timely fashion.  The application might or might not be
> >        required to actually process the events in a timely fashion,
> >        depending on the specific application.
> >
> >        In particular, if user input that would prevent the system
> >        from entering a low-power state is received while the system is
> >        transitioning into a low-power state, the system must transition
> >        back out of the low-power state so that it can hand the user
> >        input off to the corresponding application.
> >
> > o       If a power-aware application receives user input, then that
> >        application must be given the opportunity to process that
> >        input.
> >
> > o       A power-aware application must be able to efficiently communicate
> >        its needs to the system, so that such communication can be
> >        performed on hot code paths.  Communication via open() and
> >        close() is considered too slow, but communication via ioctl()
> >        is acceptable.
> 
> The problem with using open and close to prevent an allow suspend is
> not that it is too slow but that it interferes with collecting stats.
> The wakelock code has a sysfs interface that allow you to use a
> open/write/close sequence to block or unblock suspend. There is no
> limit to the amount of kernel memory that a process can consume with
> this interface, so the suspend blocker patchset uses a /dev interface
> with ioctls to block or unblock suspend and it destroys the kernel
> object when the file descriptor is closed.

Ah, I missed this point.  What I am doing to adjust is to strike the
above requirement, and to add verbiage to the "statistics" requirement
about using ioctl() to implement suspend-blocker operations, so that the
statistics can be tracked based on the device being open throughout the
application's lifetime.

> > o       Power-naive applications must be prohibited from controlling
> >        the system power state.  One acceptable approach is through
> >        use of group permissions on a special power-control device.
> >
> > o       Statistics of the power-control actions taken by power-aware
> >        applications must be provided, and must be keyed off of program
> >        name.
> 
> We don't key the stats off the program name, but having useful
> statistics is critical too us. The current code in linux-next does not
> appear to allow this (I'm referring to pm_stay_awake here, etc not
> pm-qos.)

OK, maybe I was confused earlier.  So you do not track statistics via
the device being open throughout the application's lifetime?

I am not familiar with pm_stay_awake(), but will take a look at it.

> > o       Power-aware applications can make use of power-naive infrastructure.
> >        This means that a power-aware application must have some way,
> >        whether explicit or implicit, to ensure that any power-naive
> >        infrastructure is permitted to run when a power-aware application
> >        needs it to run.
> >
> > o       When a power-aware application is preventing the system from
> >        shutting down, and is also waiting on a power-naive application,
> >        the power-aware application must set a timeout to handle
> >        the possibility that the power-naive application might halt
> >        or otherwise fail.  (Such timeouts are also used to limit the
> >        number of kernel modifications required.)
> 
> wake-lock/suspend-blocker timeouts have nothing to do with the timeout
> used by applications when waiting for a response from a less trusted
> application.

OK, I moved this to a new "SUGGESTED USAGE" section and removed the
last (parenthesized) sentence.

> > o       If no power-aware or power-optimized application are indicating
> >        a need for the system to remain operating, the system is permitted
> >        (even encouraged!) to suspend all execution, even if power-naive
> >        applications are runnable.  (This requirement did appear to be
> >        somewhat controversial.)
> 
> I would say it should suspend even if power aware applications are
> runnable. Most applications do not exclusively perform critical work.

The point being that a power-aware application does not block suspend
-unless- it holds a suspend blocker, correct?

Or am I missing some other subtlety?

> > o       Transition to low-power state must be efficient.  In particular,
> >        methods based on repeated attempts to suspend are considered to
> >        be too inefficient to be useful.
> 
> It must be power-efficient. Repeated attempts to suspend will kill the
> idle battery life.

Good point!  I changed "Transition to low-power state must be efficient"
to instead read "Transition to low-power state must be power-efficient."

> > o       Individual peripherals and CPUs must still use standard
> >        power-conservation measures, for example, transitioning CPUs into
> >        low-power states on idle and powering down peripheral devices
> >        and hardware accelerators that have not been recently used.
> >
> > o       The API that controls the system power state must be
> >        accessible both from Android's Java replacement, from
> >        userland C code, and from kernel C code (both process
> >        level and irq code, but not NMI handlers).
> >
> > o       Any initialization of the API that controls the system power
> >        state must be unconditional, so as to be free from failure.
> >        (I don't currently understand how this relates, probably due to
> >        my current insufficient understanding of the proposed patch set.)
> 
> Unconditional initialization makes it easier to add suspend blockers
> to existing kernel code since you don't have to add new failure exit
> paths. It is not a strong requirement.

Ah, that makes more sense!  I moved this to a new "NICE-TO-HAVES"
section.  I also changed the last parenthesized sentence to read
"Such unconditional initialization reduces the intrusiveness of the
the Android patchset."  Does that work?

> > o       The API that controls the system power state must operate
> >        correctly on SMP systems of modest size.  (My guess is that
> >        "modest" means up to four CPUs, maybe up to eight CPUs.)
> >
> > o       Any QoS-based solution must take display and user-input
> >        state into account.  In other words, the QoS must be
> >        expressed as a function of the display and the user-input
> >        states.
> >
> > o       Transitioning to extremely low power states requires saving
> >        and restoring DRAM and/or cache SRAM state, which in itself
> >        consumes significant energy.  The power savings must therefore
> >        be balanced against the energy consumed in the state
> >        transitions.
> >
> > o       The current Android userspace API must be supported in order
> >        to support existing device software.

Thank you again for looking this over and for your comments!!!

							Thanx, Paul
