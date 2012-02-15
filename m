Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348Ab2BOUWG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 15:22:06 -0500
Received: from www.linutronix.de ([62.245.132.108]:54904 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755155Ab2BOUWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 15:22:03 -0500
Date: Wed, 15 Feb 2012 21:22:01 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] hrtimers: Special-case zero length sleeps
In-Reply-To: <20120215145857.GA21755@srcf.ucam.org>
Message-ID: <alpine.LFD.2.02.1202152114510.2794@ionos>
References: <1317308372-6810-1-git-send-email-mjg@redhat.com> <alpine.LFD.2.02.1202151537500.2794@ionos> <1329317650.2293.129.camel@twins> <20120215145857.GA21755@srcf.ucam.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Feb 2012, Matthew Garrett wrote:

> Regardless of whether userspace should be concerning itself about this 
> kind of thing or not, there's plenty of userspace that calls sleep(0) on 
> the assumption that it'll get rescheduled. This makes using whole-system 

Right. And it got always rescheduled because the old pre hrtimer
implementation put it to sleep unconditionally. The hrtimer code
before we introduced the slack stuff returned right away when the
relative delta was 0. Slack changed that back to the pre hrtimer
behaviour. Also if you disable high res timers (compile or runtime)
you go to sleep unconditionally until the next jiffies boundary.

> timer slack difficult, because there are some applications that do this 
> even if they're event-driven and sleeping for significant lengths of 
> time here breaks them. I'd certainly understand the argument for fixing 

What is significant? If the app relies on sleep(0) returning
instantly, then it's going to malfunction on a highres=n kernel with
HZ=100 as well. Also when there are actually other runnable tasks and
it gets scheduled away, then there is no guarantee that it comes back
to the cpu within a defined boundary. 

> userspace instead, but that's a massive task for something that's easily 
> special-cased in the kernel.

So what's the correct special case solution? Return right away, call
schedule() with state RUNNING or some other magic crap?

Again, if a SCHED_OTHER task cannot cope with the fact that it gets
scheduled away for unbound amount of time, then changing the behaviour
of sleep(0) to some magic yield() variant does not help at all. It's
still broken and no special case in the kernel can fix that.

Thanks,

	tglx
