Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920Ab1IPKbs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 06:31:48 -0400
Received: from mtagate3.uk.ibm.com ([194.196.100.163]:42673 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab1IPKbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 06:31:47 -0400
In-Reply-To: <20110902174812.GD6619@n2100.arm.linux.org.uk>
References: <20110823220056.GK3895@n2100.arm.linux.org.uk> <20110825130907.GO3286@htj.dyndns.org> <20110825145558.GF8883@n2100.arm.linux.org.uk> <201108261644.26329.arnd@arndb.de> <OF2C5ADB6A.65B1BE36-ONC12578FE.00493A67-C12578FE.004B3315@de.ibm.com> <20110901140000.GF29729@n2100.arm.linux.org.uk> <OF69A57AB0.CF22689A-ONC12578FF.004EDD71-C12578FF.005142FF@de.ibm.com> <20110902172259.GA6619@n2100.arm.linux.org.uk> <OFA88E54BC.55310B1A-ONC12578FF.00607E64-C12578FF.00611957@de.ibm.com> <20110902174812.GD6619@n2100.arm.linux.org.uk>
Subject: Re: try_to_freeze() called with IRQs disabled on ARM
X-KeepSent: FC3A1FCC:E1167E09-C125790D:0038D75B;
 type=4; name=$KeepSent
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linaro-toolchain@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>
X-Mailer: Lotus Notes Release 8.5.2 August 10, 2010
Message-ID: <OFFC3A1FCC.E1167E09-ONC125790D.0038D75B-C125790D.0039D4E1@de.ibm.com>
From: Martin Schwidefsky <martin.schwidefsky@de.ibm.com>
Date: Fri, 16 Sep 2011 12:31:40 +0200
X-MIMETrack: Serialize by Router on D06ML032/06/M/IBM(Release 8.5.2FP1 ZX852FP1HF11|June
 14, 2011) at 16/09/2011 12:31:06
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

Russell King - ARM Linux <linux@arm.linux.org.uk> wrote on 09/02/2011
07:48:12 PM:

> On Fri, Sep 02, 2011 at 07:40:34PM +0200, Ulrich Weigand wrote:
> > Russell King - ARM Linux <linux@arm.linux.org.uk> wrote on 09/02/2011
> > 07:22:59 PM:
> > > On Fri, Sep 02, 2011 at 04:47:35PM +0200, Ulrich Weigand wrote:
> > > > Assume the scenario you initally describe, where a first signal is
> > > > ignored and leads to system call restart.  With your latest patch,
> > > > you call into syscall_restart which sets everything up to restart
> > > > the call (with interrupts disabled).
> > >
> > > I don't think SIG_IGN signals even set the TIF work flag, so they
> > > never even cause a call into do_signal().  Therefore, as far as
> > > syscalls go, attempting to send a process (eg) a SIGINT which its
> > > handler is set to SIG_IGN results in the process not even being
> > > notified about the attempt - we won't even wake up while the
> > > syscall is sleeping.
> >
> > I don't see why SIG_IGN signals shouldn't set the TIF work flag;
> > the decision whether to ignore a signal is only made once we've
> > got to get_signal_to_deliver.
>
> Yes, having looked deeper, you seem to be right - but only if the thread
> is being ptraced.  If it's not being ptraced, ignored signals don't
> make it that far.
>
> And yes, we can end up processing the interrupt before the SVC is
> executed, which is still a hole.  So we need to avoid doing the
> restart in userspace - which might actually make things easier.
> I'll take a look into that over the weekend.

After some more discussions with Uli I've now created a patch that
hopefully will address the issue on s390. The new code always uses
the TIF_RESTART_SVC work flag to restart the system call if there
is no signal to deliver. Only if there is a signal to deliver the
traditional rewind of the instruction pointer is used to restart
the system call (for -ERESTARTNOINTR and -ERESTARTSYS with a
SA_RESTART signal handler).

In case you are interested in the code is available at
git://git390.marist.edu/pub/scm/linux-2.6.git features
in particular git commit 4a6a001c39ac196530d8378408b61d6d2fee70d9.

blue skies,
   Martin

