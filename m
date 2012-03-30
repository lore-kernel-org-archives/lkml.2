Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761226Ab2C3RTN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 13:19:13 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:55885 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459Ab2C3RTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 13:19:02 -0400
Message-ID: <1333127955.31910.11.camel@localhost>
Subject: Re: [PATCH] [RESEND] rlimits: Print more information when limits
 are exceeded
From: Arun Raghavan <arun.raghavan@collabora.co.uk>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: David Henningsson <david.henningsson@canonical.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Date: Fri, 30 Mar 2012 22:49:15 +0530
In-Reply-To: <alpine.LFD.2.02.1203301614310.2542@ionos>
References: <1330025378-26075-1-git-send-email-arun.raghavan@collabora.co.uk>
	 <alpine.LFD.2.02.1203301455360.2542@ionos> <4F75BF5B.7000306@canonical.com>
	 <alpine.LFD.2.02.1203301614310.2542@ionos>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-30 at 16:29 +0200, Thomas Gleixner wrote:
> On Fri, 30 Mar 2012, David Henningsson wrote:
> > On 03/30/2012 03:39 PM, Thomas Gleixner wrote:
> > > On Fri, 24 Feb 2012, Arun Raghavan wrote:
> > > 
> > > > This dumps some information in logs when a process exceeds its CPU or RT
> > > > limits (soft and hard). Makes debugging easier when userspace triggers
> > > > these limits.
> > > 
> > > Why do we need to spam the logs with such information?
> > > 
> > > SIGXCPU is only ever sent by this code. If there is a signal handler
> > > in the application it's easy to debug. If not it's even easier, the
> > > thing will simply be killed and you get the reason printed.
> > 
> > I'm not totally sure, but don't we log SIGSEGVs? If so, the same reasoning
> > would apply to SIGSEGV.
> 
> I think so. Dunno why this was added in the first place. core dumps or
> proper signal handlers are telling you usually more than that single
> line in dmesg.
>  
> > > For the SIGKILL case there only a limited number of reasons why a
> > > SIGKILL is sent. So no, I rather commit a patch which removes that
> > > ugly printk which is already there instead of adding more of them.
> > 
> > The reason I proposed some kind of printk for SIGKILL, was to get some
> > diagnostic information out of the SIGKILL. E g, if you have two threads both
> > running on rtprio rlimits in the same process, it would be very interesting to
> > know which one of them was causing the kernel to send SIGKILL.
> 
> Usually the one which ignored SIGXCPU for quite a while. There is a
> reason why SIGXCPU can be handled by the application.

In general I agree -- I'm happy to rewrite the patch to drop the printk
in the SIGXCPU case.

In the current situation that I'm debugging, there appears to be a
kernel fragment that's busy waiting and eventually gets killed (I'll be
taking up a fix for this separately). In this case, by the time we get
back control, the hard limit seems to be already hit. Knowing the
culprit thread in this case does make things simpler for us.

> > Also, it could be useful to know whether the SIGKILL was actually sent by the
> > kernel, or by some other process feeling evil (e g "kill -9").
> 
> Agreed, but instead of adding that printk to the rlimit code I prefer
> a generic infrastructure which can be used by all call sites which
> issue SIGKILL. Something like: [__]kill_it(flags, task, "Reason");

The other paths that call SIGKILL seem to be slightly different (going
eventually via do_send_sig_info()). Is this actually functionally the
same? If yes, I'll try to rewrite the patch to consolidate some of these
paths as you suggest.

-- Arun

