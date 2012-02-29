Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272Ab2B2Lsr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 06:48:47 -0500
Received: from merlin.infradead.org ([205.233.59.134]:58175 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab2B2Lsq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 06:48:46 -0500
Message-ID: <1330516117.11248.138.camel@twins>
Subject: Re: RFC [PATCH] SMP: Don't schedule tasks on inactive cpu(s)
From: Peter Zijlstra <peterz@infradead.org>
To: Jonas Aaberg <jonas.aberg@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 29 Feb 2012 12:48:37 +0100
In-Reply-To: <1330513384.11248.129.camel@twins>
References: <1330512150-20727-1-git-send-email-jonas.aberg@stericsson.com>
	 <1330513384.11248.129.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-29 at 12:03 +0100, Peter Zijlstra wrote:
> On Wed, 2012-02-29 at 11:42 +0100, Jonas Aaberg wrote:
> > This patch removes the ability to schedule tasks on cpus that are online,
> > but not active.  The reason for this patch is that during cpu hotplug
> > on ARM (atleast) there is a short window where cpuX (X > 0) is online, but
> > busy-waiting on cpu0 to put it active, meanwhile cpu0 can be interrupted
> > and try to schedule something on the cpu that is busy checking its active bit.
> 
> https://lkml.org/lkml/2011/12/15/255
> 
> that one?
> 
> I _think_ its correct, but it would be so good if someone else could
> verify.

Relevant patches to consider are: e761b772 and 3a101d05.

Having looked at this again, I think we lost something in 3a101d05 since
it moves cpuset_update_active_cpus() from CPU_DEAD to CPU_DOWN_PREPARE
(and DOWN_FAILED) -- not that it matters that much. Also this patch does
leaves me somewhat puzzled as to what cpu_active_mask is for now..

The suggested patch linked above moves setting active to CPU_STARTING
which is _before_ online. It looks like some parts of the scheduler
don't look at online at all anymore so that opens a 'window' where we
could select a cpu that isn't part of the sched_domain nor online
(select_fallback_rq and cpuset_cpus_allowed_fallback).

Now this isn't really a problem because of stop-machine, by the time
anybody gets to run again both online and active are set and we should
be good to go. The bad part is of course us relying on this silly
stop-machine semantic.

Bah, hotplug is such a pain.. 
