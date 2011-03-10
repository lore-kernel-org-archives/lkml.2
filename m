Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683Ab1CJOMs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 09:12:48 -0500
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:58043 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877Ab1CJOMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 09:12:46 -0500
Date: Thu, 10 Mar 2011 16:12:41 +0200
From: Alexander Shishkin <virtuoso@slind.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Ken MacLeod <ken@bitsko.slc.ut.us>,
        Shaun Reich <predator106@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@suse.de>, Feng Tang <feng.tang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michael Tokarev <mjt@tls.msk.ru>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        John Stultz <johnstul@us.ibm.com>,
        Chris Friesen <chris.friesen@genband.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Davide Libenzi <davidel@xmailserver.org>,
        linux-fsdevel@vger.kernel.org, Alexander Shishkin <virtuoso@slind.org>
Subject: Re: [RFCv4] timerfd: add TFD_NOTIFY_CLOCK_SET to watch for clock
 changes
Message-ID: <20110310141241.GE11410@shisha.kicks-ass.net>
References: <1299681411-9227-1-git-send-email-virtuoso@slind.org>
 <alpine.LFD.2.00.1103101014260.2787@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1103101014260.2787@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 10:52:18AM +0100, Thomas Gleixner wrote:
> On Wed, 9 Mar 2011, Alexander Shishkin wrote:
> > The major change since the previous version is the new semantics of
> > timerfd_settime() when it's called on a time change notification
> > descriptor: it will set the system time to utmr.it_value if the time
> > change counter is zero, otherwise it will return EBUSY, this is required
> > to prevent a race between setting the time and reading the counter, when
> > the time controlling procees changes the time immediately after another
> > process in the system did the same (the counter is greater than one),
> > that process' time change will be lost. Thus, the time controlling
> > process should use timerfd_settime() instead of clock_settime() or
> > settimeofday() to ensure that other processes' time changes don't get
> > lost.
> 
> No, we really don't want to go there and invent another mechanism to
> set the time.
> 
> >  	/*
> > +	 * for the notification timerfd, set current time to it_value
> > +	 * if the timer hasn't expired; otherwise someone has changed
> > +	 * the system time to the value that we don't know
> > +	 */
> > +	if (!list_empty(&ctx->notifiers_list) && utmr) {
> > +		if (ctx->ticks) {
> > +			ret = -EBUSY;
> > +			goto out;
> > +		}
> > +
> > +		ret = security_settime(&ktmr.it_value, NULL);
> > +		if (ret)
> > +			goto out;
> > +
> > +		spin_unlock_irq(&ctx->wqh.lock);
> > +		ret = do_settimeofday(&ktmr.it_value);
> > +		goto out1;
> > +	}
> 
> And how does that solve the problem of multiple processes using that
> interface? Not at all. You moved the timer_fd_clock_was_set()
> notification into the syscalls so you do not deadlock on the
> notifier_lock when you call do_settimeofday() here. So if you have
> multiple users of notification fd then they do not notice that you
> changed the time here. That's a half thought hack, really.

Indeed, you're right here.

> And you start to overload timerfd in a way which is really horrible.
> The proposed semantics of timerfd_settime() with utmr == NULL or utmr
> != NULL depending on the notification flag are so non obvious that Joe
> user space programmer is doomed to fail.
> 
> The problem you want to solve is:
> 
>    Wakeup CLOCK_REALTIME timers which are not yet expired, when the
>    time is set backward.

"...when the time is set", yes.

> That's at least what you said you wanted to solve. I regret already
> that I suggested adding that flag to timerfd, as it was only meant to
> provide an interface which wakes a non expired timer whenever clock
> was set.

Yes. Except for in our usecase here and other usecases listed in the patch
description, there doesn't necessarily have to be a timer set to expire in
future. In some cases programs simply want to be notified when the time
changes. However, systemd or crond wouldn't (or shouldn't, in any case)
really care about time changes unless they have scheduled tasks.

I'm not sure it's worth it to always start a timer in order to get these
notifications. On the other hand, it fits much better in the timer/timerfd
interface than what I currently have.

> The patch does something different. How is this related to the problem
> you wanted to solve in the first place?

Well, if you scratch the timerfd_settime() bit, it kind of addresses the
initial problem. The timerfd_settime() was indeed a mistake.

> Can you please explain which problems you identified aside of the
> initial one?

Sure. The time daemon that we have here has to stop automatic time updates
when some other program changes system time *and* keep that setting
effective. Currently, when "the other program" changes the system time
right before time daemon changes it, this time setting will be overwritten
and lost. I'm thinking that it could be solved with something like

  clock_swaptime(clockid, new_timespec, old_timespec);

but something tells me that it will not be welcome either.

Thanks,
--
Alex
