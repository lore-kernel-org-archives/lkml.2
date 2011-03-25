Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934486Ab1CYKx5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 06:53:57 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53726 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934405Ab1CYKx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 06:53:56 -0400
Subject: Re: Deadlock scenario in regulator core
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: David Collins <collinsd@codeaurora.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1300838856.14261.35.camel@gandalf.stny.rr.com>
References: <4D891C59.1030009@codeaurora.org>
	 <20110322223702.GO14675@home.goodmis.org> <4D892C0A.1090606@codeaurora.org>
	 <1300835998.14261.13.camel@gandalf.stny.rr.com>
	 <4D8933A8.8080607@codeaurora.org>
	 <1300838856.14261.35.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Mar 2011 11:55:58 +0100
Message-ID: <1301050558.2250.187.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-22 at 20:07 -0400, Steven Rostedt wrote:
> On Tue, 2011-03-22 at 16:41 -0700, David Collins wrote:
> 
> > There seem to be very few uses of mutex_lock_nested() in the kernel.  Most
> > of them use subclass = SINGLE_DEPTH_NESTING.  Would this be sufficient for
> > usage in the regulator core in _notifier_call_chain (and perhaps other
> > places) or should some other subclass be used?
> 
> Note, I do not know this code well enough to say. I'm assuming that an
> rdevA on a rdevB->supply_list never has rdevB on its own
> rdevA->supply_list.
> 
> If this is the case, and that you only ever have a lock nesting of one,
> then sure, use the SINGLE_DEPTH_NESTING.
> 
> Peter or Ingo could correct me if I'm wrong.

Right, so be aware that you can annotate an actual deadlock away with
mutex_lock_nested(), so use with care. The thing to avoid is something
like:

  mutex_lock(instance1);
  mutex_lock_nested(instance2, SINGLE_DEPTH_NESTING);

vs

  mutex_lock(instance2);
  mutex_lock_nested(instance1, SINGLE_DEPTH_NESTING);

Lockdep will not complain anymore but it will cause deadlocks.

