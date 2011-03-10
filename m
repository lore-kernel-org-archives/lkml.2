Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243Ab1CJOTr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 09:19:47 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:52161 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931Ab1CJOTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 09:19:46 -0500
Date: Thu, 10 Mar 2011 16:19:43 +0200
From: Alexander Shishkin <virtuoso@slind.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Ken MacLeod <ken@bitsko.slc.ut.us>,
        Shaun Reich <predator106@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
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
Message-ID: <20110310141943.GF11410@shisha.kicks-ass.net>
References: <1299681411-9227-1-git-send-email-virtuoso@slind.org>
 <201103100948.03628.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103100948.03628.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 09:48:03AM +0100, Arnd Bergmann wrote:
> On Wednesday 09 March 2011 15:36:51 Alexander Shishkin wrote:
> > This is another attempt to approach notifying userspace about system
> > clock changes. The other one is using an eventfd and a syscall [1]. In
> > the course of discussing the necessity of a syscall for this kind of
> > notifications, it was suggested that this functionality can be achieved
> > via timers [2] (and timerfd in particular [3]). This idea got quite
> > some support [4], [5], [6] and some vague criticism [7], so I decided
> > to try and go a bit further with it.
> 
> I don't understand from your description or from the patch how user
> space gets notified. From your description, I would have expected
> to see a change to the timerfd_poll() function to check if the
> clock has changed, possibly returning POLLPRI, but the only such
> change I can see is in the timerfd_read() function. Don't you need
> to change poll() so that a task knows when to call read()?

Luckily, no changes for the _poll function were required, because the
notification code reuses the ctx->ticks counter of timerfds. IOW, poll
wakes up in the same way as before.

> > +/* TFD_NOTIFY_CLOCK_SET timers go here */
> > +static DEFINE_SPINLOCK(notifiers_lock);
> > +static LIST_HEAD(notifiers_list);
> 
> Maybe I was the only one to be confused by this, but I think t
> he naming is slightly misleading, because it's easy to confuse
> with a struct notifier_block. You could of course use the
> notifier API instead of building your own, but if you don't,
> I'd recommend coming up with a different name.

Point taken.

> I also think that a mutex would be better here than a spinlock.
> It's unlikely to be under heavy contention, but if you have
> a lot of threads, it could be held for a significant amount
> of time.

Indeed, thanks!

Regards,
--
Alex
