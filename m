Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757440Ab2FDUbf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 16:31:35 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37682 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753768Ab2FDUbc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 16:31:32 -0400
Message-ID: <1338841878.28282.133.camel@twins>
Subject: Re: [PATCH] cpuidle: menu: use nr_running instead of cpuload for
 calculating perf mult
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Vladimir Davydov <vdavydov@parallels.com>, Ingo Molnar <mingo@elte.hu>,
        Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Date: Mon, 04 Jun 2012 22:31:18 +0200
In-Reply-To: <4FCCEF94.6010805@linux.intel.com>
References: <1338805485-10874-1-git-send-email-vdavydov@parallels.com>
	      <1338805967.28282.12.camel@twins> <4FCCB486.4040905@linux.intel.com>
	     <1338817519.28282.54.camel@twins> <4FCCBC97.8060101@linux.intel.com>
	    <1338822509.28282.65.camel@twins> <4FCCD0CD.8080700@linux.intel.com>
	   <1338823568.28282.79.camel@twins> <4FCCD6B7.4030703@linux.intel.com>
	  <1338827607.28282.99.camel@twins> <4FCCE823.8090700@linux.intel.com>
	 <1338830167.28282.115.camel@twins> <4FCCEF94.6010805@linux.intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-04 at 10:25 -0700, Arjan van de Ven wrote:
> 
> for the sake of argument, lets call it the amount of work the system can
> get done. (where 'work' is obviously still vague, but the software
> running on the system will know what it is).

Screw the software, explain it to me.

> can you afford to do no work for those 20 msec every second ?
> the answer to that will be "it depends", and estimating that "depends"
> is what the load average value is used for. 

See this just doesn't make any sense..

If there's work, we're not idle. If there's more work we're idle less.
We're just not going to be idle 20 msec every second if there's more to
do.

And like I said many times now, if you inflate some of the idle periods,
the work shifts (it doesn't become less) and a next idle period will be
smaller -- since we'll only become idle again once all work is done.

( and since its smaller you decrease your idle guestimate, and lower you
C state level )

The absolute only thing any of this makes any difference to is
synchronous stuff, like round-trip latencies. If you have a workload
that doesn't do anything until something else happens and so on. Then,
if you delay each signal a bit the total time will increase and the
amount of stuff done in a given time decreases.

However, if you stuff enough work down that pipe, the total throughput
should still be good -- esp. if you can saturate the thing and all idle
time goes away.

You said that accrued latency per time unit was an approximate measure,
but afaict that's related to what you want, whereas the unix
load-average is completely unrelated to any of this.

Anyway, as it stands you're better off ripping the entire thing out,
since I don't see how it could have worked, given that you're using an
entirely random measure of something.

Also, I'm still not understanding why decreasing your idle-period
guestimation when you're woken up early isn't catching any of this.
