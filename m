Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214Ab0FJHpr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 03:45:47 -0400
Received: from ist.d-labs.de ([213.239.218.44]:35577 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755099Ab0FJHpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 03:45:45 -0400
Date: Thu, 10 Jun 2010 09:45:25 +0200
From: Florian Mickler <florian@mickler.org>
To: James Bottomley <James.Bottomley@suse.de>
Cc: pm list <linux-pm@lists.linux-foundation.org>, markgross@thegnar.org,
       mgross@linux.intel.com, linville@tuxdriver.com,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] pm_qos: make update_request non blocking
Message-ID: <20100610094525.0449d797@schatten.dmk.lab>
In-Reply-To: <1276103149.4343.350.camel@mulgrave.site>
References: <1276097381-3982-1-git-send-email-florian@mickler.org>
	<1276097832.4343.223.camel@mulgrave.site>
	<20100609180033.39d5b499@schatten.dmk.lab>
	<1276099645.4343.257.camel@mulgrave.site>
	<20100609183204.1eeca494@schatten.dmk.lab>
	<1276103149.4343.350.camel@mulgrave.site>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 Jun 2010 13:05:49 -0400
James Bottomley <James.Bottomley@suse.de> wrote:
> On Wed, 2010-06-09 at 18:32 +0200, Florian Mickler wrote:
> > On Wed, 09 Jun 2010 12:07:25 -0400
> > James Bottomley <James.Bottomley@suse.de> wrote:
> > > OK, so the expression of the race is that the latest notification gets
> > > lost.  If something is tracking values, you'd really like to lose the
> > > previous one (which is now irrelevant) not the latest one.  The point is
> > > there's still a race.
> > > 
> > > James
> > > 
> > 
> > Yeah, but for blocking notification it is not that bad. 
> 
> The network latency notifier uses the value to recalculate something.
> Losing the last value will mean it's using stale data.

Actually after pondering a bit, it is not stale data that gets
delivered: (Correct me if I'm wrong)

The update_notify() function determines the extreme value and then
calls the blocking_notifier_chain. 

But just before the update_notify() function get's called, the
work-structure is reset and re-queue-able. So it is possible to queue it
already even before the extreme_value in update_notify get's
determined. 

So the notified value is always the latest or there is another
notification underway.

> 
> > Doesn't using blocking notifiers mean that you need to always check
> > via pm_qos_request() to get the latest value anyways? I.e. the
> > notification is just a hint, that something changed so you can act on
> > it. But if you act (may it because of notification or because of
> > something other) then you have to get the current value anyways.
> 
> Well, the network notifier assumes the notifier value is the latest ... 
> 
> > I think there are 2 schemes of operation. The one which needs
> > atomic notifiers and where it would be bad if we lost any notification
> > and the other where it is just a way of doing some work in a timely
> > fashion but it isn't critical that it is done right away.
> > 
> > pm_qos was the second kind of operation up until now, because the
> > notifiers may have got scheduled away while blocked. 
> 
> Actually, no ... the current API preserves ordering semantics.  If a
> notifier sleeps and another change comes along, the update callsite will
> sleep on the notifier's mutex ... so ordering is always preserved.

If my above thinkings are right, then the change in semantics is only,
that now you can not determine by the number of notifications the
number of update_request-calls.

> 
> James
> 

Cheers,
Flo
