Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275Ab1CJLmJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 06:42:09 -0500
Received: from www.tglx.de ([62.245.132.106]:51952 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751421Ab1CJLmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 06:42:07 -0500
Date: Thu, 10 Mar 2011 12:41:27 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jamie Lokier <jamie@shareable.org>
cc: Kay Sievers <kay.sievers@vrfy.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Shishkin <virtuoso@slind.org>, linux-kernel@vger.kernel.org,
        Ken MacLeod <ken@bitsko.slc.ut.us>,
        Shaun Reich <predator106@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@suse.de>, Feng Tang <feng.tang@intel.com>,
        Michael Tokarev <mjt@tls.msk.ru>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        John Stultz <johnstul@us.ibm.com>,
        Chris Friesen <chris.friesen@genband.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Davide Libenzi <davidel@xmailserver.org>,
        linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [RFCv4] timerfd: add TFD_NOTIFY_CLOCK_SET to watch for clock
 changes
In-Reply-To: <20110310111622.GH29234@shareable.org>
Message-ID: <alpine.LFD.2.00.1103101223420.2787@localhost6.localdomain6>
References: <1299681411-9227-1-git-send-email-virtuoso@slind.org> <20110309162513.5058c824.akpm@linux-foundation.org> <AANLkTinZioShsr3O0Z=xaEQ-S=JBCgs_SS_LdsBnNhZ2@mail.gmail.com> <alpine.LFD.2.00.1103101004540.2787@localhost6.localdomain6>
 <20110310111622.GH29234@shareable.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Mar 2011, Jamie Lokier wrote:
> Thomas Gleixner wrote:
> > Note, that we have CLOCK_BOOTTIME pending for .39 which aims at the
> > same problem. It's basically CLOCK_MONOTONIC adjusted by the time we
> > were in suspend. So while CLOCK_MONOTONIC timers are not aware of the
> > time spent in suspend CLOCK_BOOTTIME timers are. The reason for
> > implementing CLOCK_BOOTTIME was basically the same problem.
> 
> I'm afraid for coherent distributed system problems,
> I don't trust CLOCK_BOOTTIME.

That timerfd thing as proposed will not solve that either.

> What happens when the clock battery is flat?  (Some systems have
> separate battery for the clock, and it's never changed or recharged).

Then your timekeeping is hosed anyway, so that's the least of your
worries.

> What about systems that just don't have a hardware clock while
> suspended, or the clock doesn't remember the current year reliably, or
> it's handled by userspace not the kernel?
> 
> (I have a system here where the clock battery will eventually run
> down, and which has a userspace-only hwclock driver)

Ditto. And I really do not care about user space only drivers at all.
 
> What happens if user does suspend to disk and resumes the disk image
> after they used a different OS for a while, which has meanwhile also
> altered the clock?

Again, your timekeeping is busted.

> Or suspend to disk on a VM followed by moving to a different VM host.

If your hosts have a complete different notion of clock realtime or
provide complete different based RTC emulation, then you run into a
whole set of other problems.

> In general I trust CLOCK_BOOTTIME to be a reasonable measure of
> elapsed time most of the time - but not reliable enough for
> distributed systems (such as coherent caches) that need stricter
> guarantees whatever the client hardware, or need to know when those
> guarantees aren't met.
> 
> Whereas I'd trust an "something happened so recalibate" event that is
> always triggered - provided it's not sent too early or too late
> relative to clock measurements and timer queue reads.  I've yet to
> check if these proposed timerfd events meet that criterion.

Not at all. There is no guarantee, that the process waiting for that
timerfd notification will resume before any other process which might
be affected by such an event.

You try to square the circle, but that won't happen before pigs fly.

Thanks,

	tglx
