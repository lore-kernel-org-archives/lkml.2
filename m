Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932222Ab0FIKm2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 06:42:28 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:45317 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080Ab0FIKm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 06:42:26 -0400
Subject: Re: [RFC PATCH 1/2] mac80211: make max_network_latency notifier
 atomic safe
From: Johannes Berg <johannes@sipsolutions.net>
To: Florian Mickler <florian@mickler.org>
Cc: pm list <linux-pm@lists.linux-foundation.org>, james.bottomley@suse.de,
       markgross@thegnar.org, mgross@linux.intel.com,
       "John W. Linville" <linville@tuxdriver.com>,
       "David S. Miller" <davem@davemloft.net>,
       Javier Cardona <javier@cozybit.com>, Jouni Malinen <j@w1.fi>,
       Rui Paulo <rpaulo@gmail.com>, Kalle Valo <kalle.valo@nokia.com>,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20100609122050.1dd18132@schatten.dmk.lab>
References: <1276074915-26879-1-git-send-email-florian@mickler.org>
	 <1276076287.3727.15.camel@jlt3.sipsolutions.net>
	 <20100609122050.1dd18132@schatten.dmk.lab>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Jun 2010 12:42:08 +0200
Message-ID: <1276080128.14580.5.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-09 at 12:20 +0200, Florian Mickler wrote:
> On Wed, 09 Jun 2010 11:38:07 +0200
> Johannes Berg <johannes@sipsolutions.net> wrote:
> 
> > On Wed, 2010-06-09 at 11:15 +0200, florian@mickler.org wrote:
> > > In order to have the pm_qos framework be callable from interrupt
> > > context, all listeners have to also be callable in that context.
> > 
> > That makes no sense at all. Why add work structs _everywhere_ in the
> > callees and make the API harder to use and easy to get wrong completely,
> > instead of just adding a single work struct that will be queued from the
> > caller and dealing with the locking complexity etc. just once.


> There are only two listeners at the moment. I suspect that most future
> uses of the framework need to be atomic, as the driver that
> requests a specific quality of service probably doesn't want to get into
> races with the provider of that service(listener). So i suspected the
> network listener to be the special case.  

Well even if it doesn't _want_ to race with it, a lot of drivers like
USB drivers etc. can't really do anything without deferring to a
workqueue.

And what's the race anyway? You get one update, defer the work, and if
another update happens inbetween you just read the new value when the
work finally runs -- and you end up doing it only once instead of twice.
That doesn't seem like a problem.

> The race between service-provider and qos-requester for non-atomic
> contextes is already there, isn't it? so, locking complexity shouldn't
> be worse than before.

I have no idea how it works now? I thought you can't request an update
from an atomic context.

However, if you request a QoS value, it is fundamentally that -- a
request. There's no guarantee as to when or how it will be honoured.

> But my first approach to this is seen here:
> https://lists.linux-foundation.org/pipermail/linux-pm/2010-June/026902.html

Icky too.

> A third possibility would be to make it dependent on the
> type of the constraint, if blocking notifiers are allowed or not. 
> But that would sacrifice API consistency (update_request for one
> constraint is allowed to be called in interrupt context and
> update_request for another would be not).

I don't see what's wrong with the fourth possibility: Allow calling
pm_qos_update_request() from atomic context, but change _it_ to schedule
off a work that calls the blocking notifier chain. That avoids the
complexity in notify-API users since they have process context, and also
in request-API users since they can call it from any context.

johannes

