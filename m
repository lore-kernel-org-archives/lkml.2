Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759700Ab0FKO0F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 10:26:05 -0400
Received: from cantor.suse.de ([195.135.220.2]:60969 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756376Ab0FKO0C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 10:26:02 -0400
Subject: Re: [linux-pm] [PATCH v4] pm_qos: make update_request non blocking
From: James Bottomley <James.Bottomley@suse.de>
To: Florian Mickler <florian@mickler.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Frederic Weisbecker <fweisbec@gmail.com>,
       markgross@thegnar.org, linville@tuxdriver.com,
       linux-kernel@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20100610164118.15ec7a05@schatten.dmk.lab>
References: <1276097381-3982-1-git-send-email-florian@mickler.org>
	 <1276097832.4343.223.camel@mulgrave.site>
	 <20100609180033.39d5b499@schatten.dmk.lab>
	 <1276099645.4343.257.camel@mulgrave.site>
	 <20100609183204.1eeca494@schatten.dmk.lab>
	 <1276103149.4343.350.camel@mulgrave.site>
	 <20100610094525.0449d797@schatten.dmk.lab>
	 <1276177144.27283.37.camel@mulgrave.site>
	 <20100610164118.15ec7a05@schatten.dmk.lab>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Jun 2010 09:25:52 -0500
Message-ID: <1276266352.2862.70.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-10 at 16:41 +0200, Florian Mickler wrote:
> > > So the notified value is always the latest or there is another
> > > notification underway.
> > 
> > Well, no ... it's a race, and like all good races the winner is non
> > deterministic.
> 
> Can you point out where I'm wrong?
> 
> U1. update_request gets called
> U2. 	new extreme value gets calculated under spinlock
> U3.	notify gets queued if its WORK_PENDING_BIT is not set.
> 
> run_workqueue() does the following:
> R1. clears the WORK_PENDING_BIT
> R2. calls update_notify()
> R3. 	reads the current extreme value
> R4. 	notification gets called with that value		
> 
> 
> If another update_request comes to schedule_work before
> run_workqueue() has cleared the WORK_PENDING_BIT, the work will not be
> requeued, but R3 isn't yet executed. So the notifiers will get the last
> value.

So the race now only causes lost older notifications ... as long as the
consumers are OK with that (it is an API change) then this should work.
You're still not taking advantage of the user context passed in, though,
so this does needlessly delay notifications for that case.

Actually, pm_qos_remove now needs a flush_scheduled work since you don't
want to return until the list is clear (since the next action may be to
free the object).

James


