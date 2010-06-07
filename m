Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab0FGXQH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 19:16:07 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:48961 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905Ab0FGXQD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 19:16:03 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1006052233100.22666-100000@netrider.rowland.org>
References: <AANLkTikXUTZE1vesD-Ccn8VhPjhBYYS0Tw_Pq9u5nnq7@mail.gmail.com>
	<Pine.LNX.4.44L0.1006052233100.22666-100000@netrider.rowland.org>
Date: Mon, 7 Jun 2010 16:16:03 -0700
Message-ID: <AANLkTik5gOt0OMY_-BK5Y2FiPvTSc97KeM-W8tVpVVkN@mail.gmail.com>
Subject: Re: suspend blockers & Android integration
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Matt Helsley <matthltc@us.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       tytso@mit.edu, Brian Swetland <swetland@google.com>,
       Neil Brown <neilb@suse.de>, Felipe Balbi <felipe.balbi@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/6/5 Alan Stern <stern@rowland.harvard.edu>:
> On Sat, 5 Jun 2010, Arve Hjønnevåg wrote:
>
>> Yes, we can keep all our user space suspend blockers and thaw the
>> frozen cgroup when any suspend blocker is held, but this would
>> eliminate any power advantage that freezing a cgroup has over using
>> suspend to freeze all processes. Without annotating the drivers to
>> block the cgroup freezing in the same places as we now block suspend,
>> it also prevents processes in the cgroup that we freeze from directly
>> consuming wakup events.
>
> The driver annotations don't need to block the cgroup freezing.  They
> just need to keep the system running long enough to awaken a thread
> that will handle the wakeup event.  (See below.)  A pm-qos constraint
> is good enough for this.
>

I'm not sure what you mean by this, either you need to annotate the
drivers or you don't.

>> If you are referring to the approach that we don't use suspend but
>> freeze a cgroup instead, this only solves the problem of bad apps. It
>> does not help pause timers in trusted user space code and in the
>> kernel, so it does not lower our average power consumption.
>
> You can solve this problem if you restructure your "trusted" apps in
> the right way.  Require a trusted app to guarantee that whenever it
> doesn't hold any suspend blockers, it will do nothing but wait (in a
> poll() system call for example) for a wakeup event.  When the event
> occurs, it must then activate a suspend blocker.
>

This breaks existing apps. It effectively requires that a process that
use suspend blocker do no work that does not block suspend.

> Better yet, make it more fine-grained.  Instead of trusted apps, have
> trusted threads.  Freeze the untrusted threads along with everything
> else, and require the trusted threads to satisfy this guarantee.
>

This would create a minefield of possible deadlocks. You now have to
make sure that your trusted threads do not share any locks with your
untrusted threads. For instance you cannot safely call into the heap
while any threads in your process are frozen.

> In this way, while the system is idle no user timers will get renewed.
> Kernel timers are another matter, but we should be able to handle them.
> There's nothing Android-specific about wanting to reduce kernel timer
> wakeups while in a low-power mode.
>
>> And, it
>> does not solve the problem for systems that enters lower power states
>> from suspend than it can from idle. The last point my not be relevant
>> to android anymore, but desktop systems already have auto suspend and
>> it would be preferable to have a race free kernel api for this.
>
> This is an entirely different matter from the rest of the discussion.
> It would be better to consider this separately after Android's current
> problems have been addressed.
>

Yes there has not been much discussion about this, but I don't
understand why not. Automatic suspend is used outside Android, and it
has the same race conditions that suspend blockers fix.

-- 
Arve Hjønnevåg
