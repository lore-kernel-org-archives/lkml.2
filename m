Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756389Ab0HPWJU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 18:09:20 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:57961 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756103Ab0HPWJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 18:09:19 -0400
Subject: Re: lockdep false positive? -- firewire-core transaction timer vs.
 scsi-core host lock
From: Johannes Berg <johannes@sipsolutions.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <1281994939.1926.2075.camel@laptop>
References: <tkrat.1e48e021935dc8b7@s5r6.in-berlin.de>
	 <1281994939.1926.2075.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Aug 2010 00:09:10 +0200
Message-ID: <1281996550.3683.43.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-16 at 23:42 +0200, Peter Zijlstra wrote:

> Which means that it now worries the following can happen:
> 
> softirq:
>   spin_lock(&t->split_timeout_timer);
> 
> IRQ:
>   spin_lock(&(shost->host_lock)->rlock);
>    spin_lock(&t->split_timeout_timer);
> 
> Now, the thing is that split_timeout_timer is a fake lock used to
> annotate timers, its use is to connect lock chains from within the timer
> callback to del_timer_sync() callers, to detect deadlocks.
> 
> Now, I can't seem to remember why del_timer_sync() explicitly disables
> IRQs but call_timer_fn() does not, Johill, happen to remember?

Err, sorry, no. I do remember that we had long discussions and initially
I had wanted to disable the context checking for these fake locks
completely. I think it was just the minimal thing needed not to make it
warn always. Also, we can't do the same thing in call_timer_fn() since
we need to hold it across fn()? Wouldn't it complain if we held that
lock then while enabling IRQs again? Not sure.

I don't fully understand the scenario above yet though. Why does it
think we could ever take the fake lock in an IRQ to start with? That
must not happen. Or is that just preemptive worrying?

johannes

