Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758807Ab0FJOlk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 10:41:40 -0400
Received: from ist.d-labs.de ([213.239.218.44]:41486 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320Ab0FJOlj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 10:41:39 -0400
Date: Thu, 10 Jun 2010 16:41:18 +0200
From: Florian Mickler <florian@mickler.org>
To: James Bottomley <James.Bottomley@suse.de>
Cc: Jonathan Corbet <corbet@lwn.net>, Frederic Weisbecker <fweisbec@gmail.com>,
       markgross@thegnar.org, linville@tuxdriver.com,
       linux-kernel@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [linux-pm] [PATCH v4] pm_qos: make update_request non blocking
Message-ID: <20100610164118.15ec7a05@schatten.dmk.lab>
In-Reply-To: <1276177144.27283.37.camel@mulgrave.site>
References: <1276097381-3982-1-git-send-email-florian@mickler.org>
	<1276097832.4343.223.camel@mulgrave.site>
	<20100609180033.39d5b499@schatten.dmk.lab>
	<1276099645.4343.257.camel@mulgrave.site>
	<20100609183204.1eeca494@schatten.dmk.lab>
	<1276103149.4343.350.camel@mulgrave.site>
	<20100610094525.0449d797@schatten.dmk.lab>
	<1276177144.27283.37.camel@mulgrave.site>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jun 2010 08:39:04 -0500
James Bottomley <James.Bottomley@suse.de> wrote:

> On Thu, 2010-06-10 at 09:45 +0200, Florian Mickler wrote:
> > On Wed, 09 Jun 2010 13:05:49 -0400
> > James Bottomley <James.Bottomley@suse.de> wrote:
> > > On Wed, 2010-06-09 at 18:32 +0200, Florian Mickler wrote:
> > > > On Wed, 09 Jun 2010 12:07:25 -0400
> > > > James Bottomley <James.Bottomley@suse.de> wrote:
> > > > > OK, so the expression of the race is that the latest notification gets
> > > > > lost.  If something is tracking values, you'd really like to lose the
> > > > > previous one (which is now irrelevant) not the latest one.  The point is
> > > > > there's still a race.
> > > > > 
> > > > > James
> > > > > 
> > > > 
> > > > Yeah, but for blocking notification it is not that bad. 
> > > 
> > > The network latency notifier uses the value to recalculate something.
> > > Losing the last value will mean it's using stale data.
> > 
> > Actually after pondering a bit, it is not stale data that gets
> > delivered: (Correct me if I'm wrong)
> > 
> > The update_notify() function determines the extreme value and then
> > calls the blocking_notifier_chain. 
> > 
> > But just before the update_notify() function get's called, the
> > work-structure is reset and re-queue-able. So it is possible to queue it
> > already even before the extreme_value in update_notify get's
> > determined. 
> > 
> > So the notified value is always the latest or there is another
> > notification underway.
> 
> Well, no ... it's a race, and like all good races the winner is non
> deterministic.

Can you point out where I'm wrong?

U1. update_request gets called
U2. 	new extreme value gets calculated under spinlock
U3.	notify gets queued if its WORK_PENDING_BIT is not set.

run_workqueue() does the following:
R1. clears the WORK_PENDING_BIT
R2. calls update_notify()
R3. 	reads the current extreme value
R4. 	notification gets called with that value		


If another update_request comes to schedule_work before
run_workqueue() has cleared the WORK_PENDING_BIT, the work will not be
requeued, but R3 isn't yet executed. So the notifiers will get the last
value.

If another update_request comes to schedule_work() after
run_workqueue() has cleared the WORK_PENDING_BIT, the work will be
requeued and another update_notify will be executed later.

> 
> If the update comes in before the work queue is run, then everyone
> eventually sees the new value.  If it comes in as the chain is running,
> some notifiers see the old value and some the new.  If it comes in
> during back end processing, no-one sees the new value.
> 
> James
> 

No, I think that is not correct. There will always be another
update_notify()-call after the last update_request-recalculation due to
the fact that run_workqueue() calls work_clear_pending() before calling
the callback function of that work. 

(We could even requeue the work from within that callback function if we
wanted to keep the number of notifications the same. But then we would
need to queue the extreme_values in the framework. I think this
isn't needed.)

Cheers,
Flo
