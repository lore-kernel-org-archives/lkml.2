Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795Ab2JNTY6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 15:24:58 -0400
Received: from www.linutronix.de ([62.245.132.108]:60886 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571Ab2JNTY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 15:24:56 -0400
Date: Sun, 14 Oct 2012 21:24:46 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Ben Hutchings <ben@decadent.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        stable <stable@vger.kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: Re: [STABLE REQUEST] add: e1000: fix lockdep splat in shutdown
 handler
In-Reply-To: <1349993385.24256.79.camel@gandalf.local.home>
Message-ID: <alpine.LFD.2.02.1210142102300.2868@ionos>
References: <1349993385.24256.79.camel@gandalf.local.home>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Oct 2012, Steven Rostedt wrote:
> commit 3a3847e007aae732d64d8fd1374126393e9879a3
> Author: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Date:   Wed Jan 4 20:23:33 2012 +0000
> 
>     e1000: fix lockdep splat in shutdown handler

as I discussed with Jesse on IRC, there is another possible deadlock
lurking in the e1000 code.

static void e1000_reinit_safe(struct e1000_adapter *adapter)
{
	while (test_and_set_bit(__E1000_RESETTING, &adapter->flags))
		msleep(1);
	mutex_lock(&adapter->mutex);
	e1000_down(adapter);

e1000_down() waits on the various work tasks to shut down, but those
work functions might be blocked on the adapter mutex.

I have no idea how I managed to trigger that one, but it's real. The
task dump I got out of the machine shows stuff waiting on each other
forever.

I can't give you a receipe to reprodruce. Looking at the code this is
not very surprising. It takes quite some coincidence of having
e1000_reinit_safe() being invoked and the delayed work timer bringing
the work on right after e1000_reinit_safe() took the adapter mutex.

Thanks,

	tglx
