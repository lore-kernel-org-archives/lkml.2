Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760965Ab2C3O3r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 10:29:47 -0400
Received: from www.linutronix.de ([62.245.132.108]:38602 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760807Ab2C3O3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 10:29:40 -0400
Date: Fri, 30 Mar 2012 16:29:38 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: David Henningsson <david.henningsson@canonical.com>
cc: Arun Raghavan <arun.raghavan@collabora.co.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] [RESEND] rlimits: Print more information when limits
 are exceeded
In-Reply-To: <4F75BF5B.7000306@canonical.com>
Message-ID: <alpine.LFD.2.02.1203301614310.2542@ionos>
References: <1330025378-26075-1-git-send-email-arun.raghavan@collabora.co.uk> <alpine.LFD.2.02.1203301455360.2542@ionos> <4F75BF5B.7000306@canonical.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Mar 2012, David Henningsson wrote:
> On 03/30/2012 03:39 PM, Thomas Gleixner wrote:
> > On Fri, 24 Feb 2012, Arun Raghavan wrote:
> > 
> > > This dumps some information in logs when a process exceeds its CPU or RT
> > > limits (soft and hard). Makes debugging easier when userspace triggers
> > > these limits.
> > 
> > Why do we need to spam the logs with such information?
> > 
> > SIGXCPU is only ever sent by this code. If there is a signal handler
> > in the application it's easy to debug. If not it's even easier, the
> > thing will simply be killed and you get the reason printed.
> 
> I'm not totally sure, but don't we log SIGSEGVs? If so, the same reasoning
> would apply to SIGSEGV.

I think so. Dunno why this was added in the first place. core dumps or
proper signal handlers are telling you usually more than that single
line in dmesg.
 
> > For the SIGKILL case there only a limited number of reasons why a
> > SIGKILL is sent. So no, I rather commit a patch which removes that
> > ugly printk which is already there instead of adding more of them.
> 
> The reason I proposed some kind of printk for SIGKILL, was to get some
> diagnostic information out of the SIGKILL. E g, if you have two threads both
> running on rtprio rlimits in the same process, it would be very interesting to
> know which one of them was causing the kernel to send SIGKILL.

Usually the one which ignored SIGXCPU for quite a while. There is a
reason why SIGXCPU can be handled by the application.

> Also, it could be useful to know whether the SIGKILL was actually sent by the
> kernel, or by some other process feeling evil (e g "kill -9").

Agreed, but instead of adding that printk to the rlimit code I prefer
a generic infrastructure which can be used by all call sites which
issue SIGKILL. Something like: [__]kill_it(flags, task, "Reason");

Thanks,

	tglx

