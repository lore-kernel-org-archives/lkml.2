Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759108Ab0FJNjP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 09:39:15 -0400
Received: from cantor.suse.de ([195.135.220.2]:53483 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759091Ab0FJNjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 09:39:13 -0400
Subject: Re: [linux-pm] [PATCH v4] pm_qos: make update_request non blocking
From: James Bottomley <James.Bottomley@suse.de>
To: Florian Mickler <florian@mickler.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Frederic Weisbecker <fweisbec@gmail.com>,
       markgross@thegnar.org, linville@tuxdriver.com,
       linux-kernel@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20100610094525.0449d797@schatten.dmk.lab>
References: <1276097381-3982-1-git-send-email-florian@mickler.org>
	 <1276097832.4343.223.camel@mulgrave.site>
	 <20100609180033.39d5b499@schatten.dmk.lab>
	 <1276099645.4343.257.camel@mulgrave.site>
	 <20100609183204.1eeca494@schatten.dmk.lab>
	 <1276103149.4343.350.camel@mulgrave.site>
	 <20100610094525.0449d797@schatten.dmk.lab>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Jun 2010 08:39:04 -0500
Message-ID: <1276177144.27283.37.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-10 at 09:45 +0200, Florian Mickler wrote:
> On Wed, 09 Jun 2010 13:05:49 -0400
> James Bottomley <James.Bottomley@suse.de> wrote:
> > On Wed, 2010-06-09 at 18:32 +0200, Florian Mickler wrote:
> > > On Wed, 09 Jun 2010 12:07:25 -0400
> > > James Bottomley <James.Bottomley@suse.de> wrote:
> > > > OK, so the expression of the race is that the latest notification gets
> > > > lost.  If something is tracking values, you'd really like to lose the
> > > > previous one (which is now irrelevant) not the latest one.  The point is
> > > > there's still a race.
> > > > 
> > > > James
> > > > 
> > > 
> > > Yeah, but for blocking notification it is not that bad. 
> > 
> > The network latency notifier uses the value to recalculate something.
> > Losing the last value will mean it's using stale data.
> 
> Actually after pondering a bit, it is not stale data that gets
> delivered: (Correct me if I'm wrong)
> 
> The update_notify() function determines the extreme value and then
> calls the blocking_notifier_chain. 
> 
> But just before the update_notify() function get's called, the
> work-structure is reset and re-queue-able. So it is possible to queue it
> already even before the extreme_value in update_notify get's
> determined. 
> 
> So the notified value is always the latest or there is another
> notification underway.

Well, no ... it's a race, and like all good races the winner is non
deterministic.

If the update comes in before the work queue is run, then everyone
eventually sees the new value.  If it comes in as the chain is running,
some notifiers see the old value and some the new.  If it comes in
during back end processing, no-one sees the new value.

James


