Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab2BTPOw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 10:14:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16227 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753215Ab2BTPOu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 10:14:50 -0500
Date: Mon, 20 Feb 2012 10:14:19 -0500
From: Don Zickus <dzickus@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org,
        mingo@redhat.com, hpa@zytor.com, torvalds@linux-foundation.org,
        kexec@lists.infradead.org, vgoyal@redhat.com,
        akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/debug] x86/kdump: No need to disable ioapic/ lapic in
 crash path
Message-ID: <20120220151419.GU9751@redhat.com>
References: <m1zkcmyjyd.fsf@fess.ebiederm.org>
 <CAE9FiQVj12UCGbOe4wZfx-L8tdab-1si-RA=vBnNeZ7cUNqyyg@mail.gmail.com>
 <CAE9FiQVPnO8-tuPoio0Wxv=8rjdm2tJbBk3+3ystueyYtZn9BA@mail.gmail.com>
 <20120216172735.GX9751@redhat.com>
 <CAE9FiQVhbAM9vjx-uFcuc0ndsUp0aez9_TsQHStje5G5iwYbag@mail.gmail.com>
 <20120216215603.GH9751@redhat.com>
 <m1y5s2ku36.fsf@fess.ebiederm.org>
 <m1fwe9bpk2.fsf@fess.ebiederm.org>
 <20120217195430.GO9751@redhat.com>
 <m1y5s07rn3.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1y5s07rn3.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 17, 2012 at 07:21:52PM -0800, Eric W. Biederman wrote:
> Don Zickus <dzickus@redhat.com> writes:
> 
> > On Fri, Feb 17, 2012 at 04:41:01AM -0800, Eric W. Biederman wrote:
> >> 
> >> The fix with a guarantee of no more scope creep is to just disable the
> >> nmi watchdog on the kexec on panic path.
> >> 
> >> Don if you have time please figure out is needed to ignore nmi's and
> >> possible record and/or report them while we boot, otherwise please cook
> >> up a patch that just disables the nmi watchdog wherever we are sending
> >> it from (the local apic or the ioapic).
> >
> > Can I keep things even simpler?  The original problem was the deadlock
> > with the ioapic lock.  We fixed that by removing the call to
> > disable_IO_APIC().  Can we just leave the disable_local_APIC calls in
> > there for now?  Is there any real harm?
> 
> > All this rewrite is going to take time which will delay fixing a current
> > problem with kexec on panic, the ioapic deadlock.
> 
> Hmm.
> 
> My apologies I just realized that we can not disable the nmi watchdog
> safely in all cases.  To avoid the deadlock we fundamentally can not
> write to the io_apic, because the locks are the io_apic write path.
> The nmi watchdog can be sourced from either the local apics or the
> io_apics.  To disable the nmi_watchdog we need at least potentially
> to write io_apic.

I am curious where you see the nmi watchdog being sourced from the ioapic?
I thought I removed that code 3 or 4 releases ago.

> 
> So it appears to me that the only reasonable and robust thing we can
> do is to ignore nmis in the kexec on panic path.
> 
> So it looks to me that the only path forward at this point is to fix
> the other bug where an unexpected nmi will kill the kexec on panic boot.
> 
> I just took a look at the code in /sbin/kexec and that code does not in
> fact change the idt except when we switch to 16bit mode, which we
> definitely do not do in the kexec on panic case.  So it appears that we
> don't need to coordinate an /sbin/kexec release with a kernel release to
> ignore nmis.
> 
> In fact it looks like we only need to fix the interrupt descriptors
> loaded in machine_kexec_64.c and head64.c to ignore nmis.
> 
> At which point we will have fixed two bugs and have a much more reliable
> kexec on panic implementation.

Ok.  I'll talk with Vivek about how the can be implemented.

Cheers.
Don
