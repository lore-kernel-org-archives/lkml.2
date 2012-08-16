Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990Ab2HPOPb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 10:15:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:56195 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016Ab2HPOP3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 10:15:29 -0400
Message-ID: <1345126502.29668.36.camel@twins>
Subject: Re: powerpc/perf: hw breakpoints return ENOSPC
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: Michael Neuling <mikey@neuling.org>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        K Prasad <prasad@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org
Date: Thu, 16 Aug 2012 16:15:02 +0200
In-Reply-To: <1345125747.20062.12.camel@concordia>
References: <28857.1345091034@neuling.org>
	 <1345102812.31459.114.camel@twins> <20344.1345115849@neuling.org>
	 <1345117498.29668.23.camel@twins> <1345125747.20062.12.camel@concordia>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-08-17 at 00:02 +1000, Michael Ellerman wrote:
> You do want to guarantee that the task will always be subject to the
> breakpoint, even if it moves cpus. So is there any way to guarantee that
> other than reserving a breakpoint slot on every cpu ahead of time? 

That's not how regular perf works.. regular perf can overload hw
resources at will and stuff is strictly per-cpu.

So the regular perf record has perf_event_attr::inherit enabled by
default, this will result in it creating a per-task-per-cpu event for
each cpu and this will succeed because there's no strict reservation to
avoid/detect starvation against perf_event_attr::pinned events.

For regular (!pinned) events, we'll RR the created events on the
available hardware resources.

HWBP does things completely different and reserves a slot over all CPUs
for everything, thus stuff completely falls apart.


