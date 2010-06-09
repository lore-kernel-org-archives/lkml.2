Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758040Ab0FIRby (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 13:31:54 -0400
Received: from ist.d-labs.de ([213.239.218.44]:37125 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754147Ab0FIRbw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 13:31:52 -0400
Date: Wed, 9 Jun 2010 19:31:32 +0200
From: Florian Mickler <florian@mickler.org>
To: James Bottomley <James.Bottomley@suse.de>
Cc: pm list <linux-pm@lists.linux-foundation.org>, markgross@thegnar.org,
       mgross@linux.intel.com, linville@tuxdriver.com,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] pm_qos: make update_request non blocking
Message-ID: <20100609193132.2ac313b0@schatten.dmk.lab>
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
> > Yeah, but for blocking notification it is not that bad. 
> 
> The network latency notifier uses the value to recalculate something.
> Losing the last value will mean it's using stale data.

Ah. Indeed. I didn't do my homework there. That sucks. (Btw, I know why
you said "recalculate _something_" :) )

It even fetches via pm_qos_get_request() in the middle. But obviously
if we do not report the last value but the value before that, then this
is bloed. 

We could fix it though for all current (two) in tree users by passing
always a negative value in to the notification. Then the network
notifier fetches the value via pm_qos_get_request(); 
And cpuidle ignores the value anyways. 

> > 
> > pm_qos was the second kind of operation up until now, because the
> > notifiers may have got scheduled away while blocked. 
> 
> Actually, no ... the current API preserves ordering semantics.  If a
> notifier sleeps and another change comes along, the update callsite will
> sleep on the notifier's mutex ... so ordering is always preserved.

Ah! Ordering. Something I didn't thought of. But still no luck for me. 

> 
> > I think we should allow for both kinds of operations simultaneous. But
> > as I got that pushback to the change from John Linville as I touched his
> > code, I got a bit reluctant and just have done the simple variant. :)
> 
> The code I proposed does ... but it relies on the callsite supplying the
> necessary context.
> 

Yes, I know. It's just that if we want to have both kind's of notifiers
we need to use a atomic_notifier chain for that constraint. And then we
have the issue that John objected to, namely pushing all the
schedule_work code to each of the API-Users. 

Anyway, I think your patch is better in that it is correct.

It just doesn't solve the issue for constraints where drivers want to
update from interrupt but notifiers want to be able to work from
process context. 

> James
> 

Cheers,
Flo
