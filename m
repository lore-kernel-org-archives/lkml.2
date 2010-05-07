Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758141Ab0EGT4K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 15:56:10 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:63971 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756954Ab0EGT4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 15:56:09 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 69.181.193.102
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+k8gX5krtEQ5vTY3+CV1ht
Date: Fri, 7 May 2010 12:55:48 -0700
From: Tony Lindgren <tony@atomide.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: Daniel Walker <dwalker@fifo99.com>, Brian Swetland <swetland@google.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       mark gross <mgross@linux.intel.com>, markgross@thegnar.org,
       Len Brown <len.brown@intel.com>, linux-doc@vger.kernel.org,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 1/8] PM: Add suspend block api.
Message-ID: <20100507195548.GN387@atomide.com>
References: <20100507171218.GA23142@srcf.ucam.org>
 <20100507173549.GF387@atomide.com>
 <20100507175025.GA23952@srcf.ucam.org>
 <20100507180152.GH387@atomide.com>
 <20100507182824.GA25198@srcf.ucam.org>
 <20100507184333.GL387@atomide.com>
 <20100507184621.GA25978@srcf.ucam.org>
 <1273259186.3542.93.camel@c-dwalke-linux.qualcomm.com>
 <20100507192837.GM387@atomide.com>
 <20100507193353.GA27175@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100507193353.GA27175@srcf.ucam.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Matthew Garrett <mjg@redhat.com> [100507 12:29]:
> On Fri, May 07, 2010 at 12:28:37PM -0700, Tony Lindgren wrote:
> > * Daniel Walker <dwalker@fifo99.com> [100507 12:01]:
> > > On Fri, 2010-05-07 at 19:46 +0100, Matthew Garrett wrote:
> > > > Freezer cgroups would work better, but it doesn't really change the 
> > > > point - if that application has an open network socket, how do you know 
> > > > to resume that application when a packet comes in?
> > 
> > No idea, but that still sounds a better situation to me than
> > trying to deal with that for a suspended system! :)
> 
> Suspend blocks deal with that problem. Nobody has yet demonstrated a 
> workable alternative solution.

Well there are obviously two paths to take, I think both of
them should work. The alternative to suspend blockers is:

- Implement a decent kernel idle function for the hardware and
  use cpuidle to change the c states. The dyntick stuff should
  already work for most hardware.

- Fix the core userspace apps to minimize timers.

- Deal with broken apps whichever way you want in the userspace.

- Optionally, do echo mem > /sys/power/state based on some
  product specific logic in the userspace.

The advantage of this is that no kernel changes are needed,
except for implementing the custom idle function for the
hardware. And this kind of setup has been in use for about
five years.

And, you can keep the system running constantly if you have
hardware that supports good idle modes, then you don't even
need to suspend at all.

The core problems I see with suspend blockers are following,
please correct me if I'm wrong:

- It is caching the value of echo mem > /sys/power/state and
  misusing it for runtime power management as the system still
  keeps running after trying to suspend. Instead, the kernel
  idle function and cpuidle should be used if the kernel keeps
  running.

- They require patching all over the drivers and userspace.

- Once the system is suspended, it does not run. And the apps
  don't behave in a standard way because the system does not
  wake to timer interrupts.

I agree that we need to be able to echo mem > /sys/power/state
in an atomic way. So if there are problems with that, those
issues should be fixed.

Cheers,

Tony
